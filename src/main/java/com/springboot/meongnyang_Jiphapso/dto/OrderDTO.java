package com.springboot.meongnyang_Jiphapso.dto;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class OrderDTO {
	private Long orNo;  		 // 주문번호
	private String orName; 	 // 받는사람이름
	private String orPhone; 	 // 받는사람 연락처
	private String orAddress;    // 배송주소
	private String orAddrdetail; // 배송상세주소
	private String orMemo; 	 // 배송 요청사항
	private String orYn; 		 // 쇼핑백 구매여부(Y/N)
	private Integer orQty; 	 // 쇼핑백 수량 (주문 상품 개수 아님! 장바구니에 담긴 상품 총 수량이 아니라, 쇼핑백 추가구매 옵션의 수량임)
	private String orMethod; 	 // 결제수단
	private String orStatus; 	 // 주문상태
	private  Date orAt; 		 // 주문일시
	private	 Date orUp; 		 // 수정일시
	private  Long mNo; 		 	 // 회원번호FK


	// --화면 표시/조인용 (저장컬럼x)--
    private String orderNoDisplay;    			  // 주문번호 문자열
    private Long productAmount;    			  	  // 상품 금액 합계
    private Long shippingFee;      			  	  // 배송비
    private Long discountAmount;   			  	  // 쿠폰+포인트 총 할인액
    private Long payAmount;      			  	  	  // 최종 결제금액
    private Integer productQty;                     // 주문에 포함된 상품 총 수량 (dc_order_detail.od_quantity 합계) - or_qty(쇼핑백 수량)랑 다른 값이라 목록화면에서 헷갈리지 않게 별도로 내려줌
    private List<OrderDetailDTO> orderDetailList; // 주문상세 목록

    public OrderDTO() {}

    public Long getOrNo() { return orNo; }
    public void setOrNo(Long orNo) { this.orNo = orNo; }

    public String getOrName() { return orName; }
    public void setOrName(String orName) { this.orName = orName; }

    public String getOrPhone() { return orPhone; }
    public void setOrPhone(String orPhone) { this.orPhone = orPhone; }

    public String getOrAddress() { return orAddress; }
    public void setOrAddress(String orAddress) { this.orAddress = orAddress; }

    public String getOrAddrdetail() { return orAddrdetail; }
    public void setOrAddrdetail(String orAddrdetail) { this.orAddrdetail = orAddrdetail; }

    public String getOrMemo() { return orMemo; }
    public void setOrMemo(String orMemo) { this.orMemo = orMemo; }

    public String getOrYn() { return orYn; }
    public void setOrYn(String orYn) { this.orYn = orYn; }

    public Integer getOrQty() { return orQty; }
    public void setOrQty(Integer orQty) { this.orQty = orQty; }

    public String getOrMethod() { return orMethod; }
    public void setOrMethod(String orMethod) { this.orMethod = orMethod; }

    public String getOrStatus() { return orStatus; }
    public void setOrStatus(String orStatus) { this.orStatus = orStatus; }

    public Date getOrAt() { return orAt; }
    public void setOrAt(Date orAt) { this.orAt = orAt; }

    public Date getOrUp() { return orUp; }
    public void setOrUp(Date orUp) { this.orUp = orUp; }

    public Long getMNo() { return mNo; }
    public void setMNo(Long mNo) { this.mNo = mNo; }

    public String getOrderNoDisplay() { return orderNoDisplay; }
    public void setOrderNoDisplay(String orderNoDisplay) { this.orderNoDisplay = orderNoDisplay; }

    public Long getProductAmount() { return productAmount; }
    public void setProductAmount(Long productAmount) { this.productAmount = productAmount; }

    public Long getShippingFee() { return shippingFee; }
    public void setShippingFee(Long shippingFee) { this.shippingFee = shippingFee; }

    public Long getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(Long discountAmount) { this.discountAmount = discountAmount; }

    public Long getPayAmount() { return payAmount; }
    public void setPayAmount(Long payAmount) { this.payAmount = payAmount; }

    public Integer getProductQty() { return productQty; }
    public void setProductQty(Integer productQty) { this.productQty = productQty; }

    public List<OrderDetailDTO> getOrderDetailList() { return orderDetailList; }
    public void setOrderDetailList(List<OrderDetailDTO> orderDetailList) { this.orderDetailList = orderDetailList; }

    @Override
    public String toString() {
        return "OrderDTO{" +
                "orNo=" + orNo +
                ", orStatus='" + orStatus + '\'' +
                ", mNo=" + mNo +
                '}';
    }
}
