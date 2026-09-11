package com.springboot.meongnyang_Jiphapso.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

	@Autowired
	private IPaymentDAO paymentDAO;
	
	@Autowired
	private OrderService orderService;

	@Autowired
	private CartService cartService;

	@Autowired
	private OrderDetailService orderDetailService; // 결제 승인 시 주문상세(옵션/수량) 조회용

	@Autowired
	private IProductDao productDao; // 결제 승인 시 옵션 재고(o_quantity) 차감용

	@Autowired
	private PointService pointService; // 결제 승인 시 사용 포인트 실제 차감용

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

	private static final String PORTONE_API_BASE = "https://api.portone.io";

	private final RestTemplate restTemplate = new RestTemplate();

	// ================= 결제창 사전 정보 세팅 =================

	// 결제 페이지 진입 시 결제수단(easyPayProvider)에 맞는 채널키를 골라서 DTO에 채워줌 (JS 결제창 호출용)
	public void bindChannelKey(PaymentDTO dto) {

		String provider = dto.getEasyPayProvider(); // TOSSPAY / PAYCO / KAKAOPAY / SMILEPAY / NAVERPAY

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

	// 주문/결제 페이지에서 결제하기 버튼 클릭 시 - DB에 PENDING 상태로 먼저 적재
	public PaymentDTO requestPayment(PaymentDTO dto) {

		dto.setPayMethod(dto.getEasyPayProvider());

		dto.setPayStatus("PENDING");
		paymentDAO.insertPayment(dto);
		return dto; // payNo 채워져서 리턴 (JS 결제창 호출 시 paymentId 로 조합해서 사용)
	}

	// ================= 결제 승인/검증 =================

	// 프론트에서 결제창(SDK) 완료 콜백을 받은 뒤, 실제로 결제가 됐는지 포트원 서버에 재조회해서 금액 위변조를 검증함
	public boolean confirmPayment(Long payNo, String portonePaymentId) {

		PaymentDTO dto = paymentDAO.selectPaymentOne(payNo);
		if (dto == null) {
			throw new IllegalArgumentException("결제 정보를 찾을 수 없습니다.");
		}

		// 포트원 V2 결제건 단건조회 API 호출 (GET /payments/{paymentId})
		Map<String, Object> portonePayment = fetchPortOnePayment(portonePaymentId);

		if (portonePayment == null) {
			paymentDAO.updatePaymentComplete(payNo, portonePaymentId, "FAILED");
			return false;
		}

		String status = String.valueOf(portonePayment.get("status")); // PAID / FAILED / CANCELLED 등
		Map<String, Object> amountMap = (Map<String, Object>) portonePayment.get("amount");
		Long paidAmount = amountMap != null ? Long.valueOf(String.valueOf(amountMap.get("total"))) : null;

		// 금액 위변조 검증: 우리 쪽에서 결제요청 시 저장한 실결제금액과 포트원에서 실제 승인된 금액이 같아야 함
		boolean amountMatches = paidAmount != null && paidAmount.equals(dto.getPayRealAmt());

		if ("PAID".equals(status) && amountMatches) {
			paymentDAO.updatePaymentComplete(payNo, portonePaymentId, "PAID");

			// 재고 차감 + 포인트 사용은 주문이 아직 PAID가 아닐 때만 (웹훅/컨펌 이중 호출로 인한 중복처리 방지)
			applyPaidSideEffectsIfFirstPaid(dto);

			orderService.updateOrderStatus(dto.getOrNo(), "PAID");
			cartService.deleteCartByOrder(dto.getOrNo());

			return true;
		} else {
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
			// 네트워크 오류/404 등 - 호출부에서 FAILED 처리하도록 null 리턴
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
				// 재고 차감 + 포인트 사용은 주문이 아직 PAID가 아닐 때만 (웹훅/컨펌 이중 호출로 인한 중복처리 방지)
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

	// 주문취소 승인 시 OrderCancelService 에서 호출 (포트원 결제취소 API 호출 후 DB 상태 갱신)
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
			return true;

		} catch (Exception e) {
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
