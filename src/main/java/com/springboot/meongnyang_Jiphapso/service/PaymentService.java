package com.springboot.meongnyang_Jiphapso.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.springboot.meongnyang_Jiphapso.dao.IPaymentDAO;
import com.springboot.meongnyang_Jiphapso.dao.IProductDao;
import com.springboot.meongnyang_Jiphapso.dto.OrderDTO;
import com.springboot.meongnyang_Jiphapso.dto.OrderDetailDTO;
import com.springboot.meongnyang_Jiphapso.dto.PaymentDTO;

@Service
public class PaymentService {

	private static final Logger log = LoggerFactory.getLogger(PaymentService.class);

	@Autowired
	private IPaymentDAO paymentDAO;

	@Autowired
	private OrderService orderService;

	@Autowired
	private CartService cartService;

	@Autowired
	private OrderDetailService orderDetailService; 

	@Autowired
	private IProductDao productDao; 

	@Autowired
	private PointService pointService; 

	@Autowired
	private MemberCouponService memberCouponService; 

	// 포트원 V2 API 시크릿
	@Value("${portone.api-secret}")
	private String portoneApiSecret;

	// 포트원 V2 상점 아이디 (storeId)
	@Value("${portone.store-id}")
	private String portoneStoreId;

	// 채널키 5종 (콘솔 "채널 관리" 화면 값을 그대로 properties 에 등록)
	@Value("${portone.channel-key.tosspay}")
	private String channelKeyTossPay;

	@Value("${portone.channel-key.payco}")
	private String channelKeyPayco;

	@Value("${portone.channel-key.kakaopay}")
	private String channelKeyKakaoPay;

	@Value("${portone.channel-key.smilepay}")
	private String channelKeySmilePay;

	@Value("${portone.channel-key.naverpay}")
	private String channelKeyNaverPay;

	private static final long FREE_SHIPPING_THRESHOLD = 30000L;
	private static final long SHIPPING_FEE = 3000L;
	private static final long BAG_PRICE = 500L; 

	private static final String PORTONE_API_BASE = "https://api.portone.io";

	private final RestTemplate restTemplate = new RestTemplate();

	// ================= 결제창 사전 정보 세팅 =================

	public void bindChannelKey(PaymentDTO dto) {

		String provider = dto.getEasyPayProvider(); 

		if (provider == null) {
			throw new IllegalArgumentException("결제수단을 선택해주세요.");
		}

		switch (provider) {
			case "TOSSPAY":
				dto.setChannelKey(channelKeyTossPay);
				break;
			case "PAYCO":
				dto.setChannelKey(channelKeyPayco);
				break;
			case "KAKAOPAY":
				dto.setChannelKey(channelKeyKakaoPay);
				break;
			case "SMILEPAY":
				dto.setChannelKey(channelKeySmilePay);
				break;
			case "NAVERPAY":
				dto.setChannelKey(channelKeyNaverPay);
				break;
			default:
				throw new IllegalArgumentException("지원하지 않는 결제수단입니다: " + provider);
		}
	}

	// ================= 결제요청 등록 (PENDING) =================
	public PaymentDTO requestPayment(PaymentDTO dto) {

		Long orNo = dto.getOrNo();
		if (orNo == null) {
			throw new IllegalArgumentException("주문 정보가 없습니다.");
		}

		OrderDTO order = orderService.getOrderOne(orNo);
		if (order == null) {
			throw new IllegalArgumentException("존재하지 않는 주문입니다.");
		}
		if (order.getMNo() == null || !order.getMNo().equals(dto.getMNo())) {
			throw new IllegalStateException("본인 주문만 결제할 수 있습니다.");
		}
		if (!"PAYMENT_PENDING".equals(order.getOrStatus())) {
			throw new IllegalStateException("이미 처리되었거나 결제할 수 없는 주문입니다.");
		}
		if (order.getOrderDetailList() == null || order.getOrderDetailList().isEmpty()) {
			throw new IllegalStateException("주문 상품 정보가 없습니다.");
		}

		// 품절(재고 0) 또는 0원(= 품절 처리) 상품이 하나라도 섞여 있으면 결제 자체를 막음
		validateNotSoldOut(order.getOrderDetailList());
		long productAmount = order.getOrderDetailList().stream()
				.mapToLong(OrderDetailDTO::getOdAmount)
				.sum();

		// 배송비 - 정책값 기준 서버 재계산
		long shippingFee = productAmount >= FREE_SHIPPING_THRESHOLD ? 0L : SHIPPING_FEE;

		// 쇼핑백 추가구매 금액 - 주문 생성 시 이미 저장된 or_yn/or_qty 기준 (결제 시점에 클라이언트가 못 바꿈)
		long bagAmount = ("Y".equals(order.getOrYn()) && order.getOrQty() != null)
				? order.getOrQty() * BAG_PRICE
				: 0L;
		long couponDiscount = 0L;
		if (dto.getMcNo() != null) {
			couponDiscount = memberCouponService.calcDiscountAmount(dto.getMcNo(), dto.getMNo(), productAmount);
		}
		long usePoint = dto.getPayUsed() != null ? dto.getPayUsed() : 0L;
		Long balance = pointService.getCurrentBalance(dto.getMNo());
		if (usePoint > (balance == null ? 0L : balance)) {
			throw new IllegalArgumentException("보유 포인트가 부족합니다.");
		}
		if (usePoint > productAmount) {
			usePoint = productAmount;
		}

		long payRealAmt = productAmount + shippingFee + bagAmount - couponDiscount - usePoint;
		if (payRealAmt < 0) {
			payRealAmt = 0L; 
		}

		dto.setPayAmount(productAmount);
		dto.setPayFee(shippingFee + bagAmount); 
		dto.setPayDiscount(couponDiscount);
		dto.setPayUsed(usePoint);
		dto.setPayDis(couponDiscount + usePoint);
		dto.setPayRealAmt(payRealAmt);

		dto.setPayMethod(dto.getEasyPayProvider());
		dto.setPayStatus("PENDING");
		paymentDAO.insertPayment(dto);

		log.info("결제요청 등록 - orNo={}, mNo={}, payRealAmt={}, method={}", orNo, dto.getMNo(), payRealAmt, dto.getPayMethod());

		return dto; 
	}
	private void validateNotSoldOut(List<OrderDetailDTO> detailList) {

		for (OrderDetailDTO detail : detailList) {

			List<Map<String, Object>> options = cartService.getOptionListByProduct(detail.getPNo());

			Map<String, Object> option = options.stream()
					.filter(o -> {
						Object no = o.get("oNo");
						return no != null && detail.getONo() != null
								&& detail.getONo().equals(((Number) no).longValue());
					})
					.findFirst()
					.orElse(null);

			// 옵션 자체가 삭제/단종된 경우도 결제 불가로 처리
			if (option == null) {
				log.warn("품절/단종 상품으로 결제 불가 - 상품={}", detail.getOdProductName());
				throw new IllegalStateException("판매가 종료된 상품이 포함되어 있어 결제할 수 없습니다: " + detail.getOdProductName());
			}

			Object priceObj = option.get("oPrice");
			Object qtyObj = option.get("oQuantity");
			long currentPrice = priceObj != null ? ((Number) priceObj).longValue() : 0L;
			int currentStock = qtyObj != null ? ((Number) qtyObj).intValue() : 0;

			// 0원 = 품절 컨벤션 + 재고 0 모두 품절로 취급
			if (currentPrice <= 0 || currentStock <= 0) {
				log.warn("품절 상품으로 결제 불가 - 상품={}, 재고={}, 가격={}", detail.getOdProductName(), currentStock, currentPrice);
				throw new IllegalStateException("품절된 상품이 포함되어 있어 결제할 수 없습니다: " + detail.getOdProductName());
			}
		}
	}

	// ================= 결제 승인/검증 =================
	public boolean confirmPayment(Long payNo, String portonePaymentId) {

		PaymentDTO dto = paymentDAO.selectPaymentOne(payNo);
		if (dto == null) {
			throw new IllegalArgumentException("결제 정보를 찾을 수 없습니다.");
		}
		Map<String, Object> portonePayment = fetchPortOnePayment(portonePaymentId);

		if (portonePayment == null) {
			log.warn("결제 승인 실패(포트원 조회 불가) - payNo={}, portonePaymentId={}", payNo, portonePaymentId);
			paymentDAO.updatePaymentComplete(payNo, portonePaymentId, "FAILED");
			return false;
		}

		String status = String.valueOf(portonePayment.get("status")); // PAID / FAILED / CANCELLED 등
		Map<String, Object> amountMap = (Map<String, Object>) portonePayment.get("amount");
		Long paidAmount = amountMap != null ? Long.valueOf(String.valueOf(amountMap.get("total"))) : null;
		boolean amountMatches = paidAmount != null && paidAmount.equals(dto.getPayRealAmt());

		if ("PAID".equals(status) && amountMatches) {

			log.info("결제 승인 완료 - payNo={}, orNo={}, amount={}, method={}", payNo, dto.getOrNo(), dto.getPayRealAmt(), dto.getPayMethod());

			paymentDAO.updatePaymentComplete(payNo, portonePaymentId, "PAID");
			applyPaidSideEffectsIfFirstPaid(dto);

			orderService.updateOrderStatus(dto.getOrNo(), "PAID");
			cartService.deleteCartByOrder(dto.getOrNo());

			return true;
		} else {
			log.warn("결제 승인 실패 - payNo={}, portoneStatus={}, expectedAmount={}, paidAmount={}", payNo, status, dto.getPayRealAmt(), paidAmount);
			paymentDAO.updatePaymentComplete(payNo, portonePaymentId, "FAILED");
			return false;
		}
	}

	// 포트원 V2 결제건 단건조회
	private Map<String, Object> fetchPortOnePayment(String portonePaymentId) {

		try {
			HttpHeaders headers = new HttpHeaders();
			headers.set("Authorization", "PortOne " + portoneApiSecret);

			HttpEntity<Void> entity = new HttpEntity<>(headers);

			String url = PORTONE_API_BASE + "/payments/" + portonePaymentId;

			ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.GET, entity, Map.class);

			return response.getBody();

		} catch (Exception e) {
			log.error("포트원 결제조회 API 호출 실패 - portonePaymentId={}", portonePaymentId, e);
			return null;
		}
	}

	// ================= 웹훅 처리 =================
	public void handleWebhook(String portonePaymentId) {

		Map<String, Object> portonePayment = fetchPortOnePayment(portonePaymentId);
		if (portonePayment == null) {
			return;
		}

		String customData = String.valueOf(portonePayment.get("customData")); // 결제요청 시 payNo 를 실어보낸 값
		Long payNo;
		try {
			payNo = Long.valueOf(customData);
		} catch (NumberFormatException e) {
			return; // customData 형식이 안 맞으면 무시
		}

		String status = String.valueOf(portonePayment.get("status"));
		String mappedStatus = "PAID".equals(status) ? "PAID" : "FAILED";

		paymentDAO.updatePaymentComplete(payNo, portonePaymentId, mappedStatus);

		if ("PAID".equals(mappedStatus)) {
			PaymentDTO dto = paymentDAO.selectPaymentOne(payNo);
			if (dto != null) {
				log.info("웹훅으로 결제 승인 완료 - payNo={}, orNo={}", payNo, dto.getOrNo());
				applyPaidSideEffectsIfFirstPaid(dto);

				orderService.updateOrderStatus(dto.getOrNo(), "PAID");
				cartService.deleteCartByOrder(dto.getOrNo());
			}
		}
	}

	private void applyPaidSideEffectsIfFirstPaid(PaymentDTO payment) {

		Long orNo = payment.getOrNo();

		OrderDTO order = orderService.getOrderOne(orNo);
		if (order != null && "PAID".equals(order.getOrStatus())) {
			return; // 이미 결제완료 처리된 주문이면 재처리하지 않음
		}

		// 옵션 재고 차감
		List<OrderDetailDTO> details = orderDetailService.getListByOrder(orNo);
		if (details != null) {
			for (OrderDetailDTO detail : details) {
				if (detail.getONo() != null && detail.getOdQuantity() != null) {
					productDao.decreaseOptionStock(detail.getONo(), detail.getOdQuantity());
				}
			}
		}

		// 사용 포인트 실제 차감 (결제요청 시점에 payUsed로 저장해둔 값)
		if (payment.getPayUsed() != null && payment.getPayUsed() > 0) {
			pointService.usePoint(payment.getMNo(), payment.getPayUsed(), orNo);
		}
	}

	// ================= 결제 취소/환불 =================
	public boolean cancelPayment(Long payNo, String reason) {

		PaymentDTO dto = paymentDAO.selectPaymentOne(payNo);
		if (dto == null || dto.getPayTno() == null) {
			throw new IllegalStateException("취소할 결제 내역이 없습니다.");
		}

		try {
			HttpHeaders headers = new HttpHeaders();
			headers.set("Authorization", "PortOne " + portoneApiSecret);
			headers.setContentType(org.springframework.http.MediaType.APPLICATION_JSON);

			Map<String, Object> body = new HashMap<>();
			body.put("reason", reason);

			HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);

			String url = PORTONE_API_BASE + "/payments/" + dto.getPayTno() + "/cancel";

			restTemplate.postForEntity(url, entity, Map.class);

			paymentDAO.updatePaymentStatus(payNo, "REFUNDED");

			log.info("결제 취소 완료 - payNo={}, reason={}", payNo, reason);

			return true;

		} catch (Exception e) {
			log.error("결제 취소 실패 - payNo={}, reason={}", payNo, reason, e);
			return false;
		}
	}

	// ================= 조회 =================

	public PaymentDTO getPaymentOne(Long payNo) {
		return paymentDAO.selectPaymentOne(payNo);
	}

	public PaymentDTO getPaymentByOrder(Long orNo) {
		return paymentDAO.selectPaymentByOrder(orNo);
	}

	public List<PaymentDTO> getPaymentListByMember(Long mNo) {
		return paymentDAO.selectPaymentListByMember(mNo);
	}

	public List<PaymentDTO> getPaymentListAll() {
		return paymentDAO.selectPaymentListAll();
	}

	// ================= 관리자 =================

	public int updatePaymentStatus(Long payNo, String payStatus) {
		return paymentDAO.updatePaymentStatus(payNo, payStatus);
	}

	public int deletePayment(Long payNo) {
		return paymentDAO.deletePayment(payNo);
	}
}