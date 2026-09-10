package com.springboot.meongnyang_Jiphapso.dto;

import java.util.Date;

public class OrderCancelDTO {

	private Long ocOutNo;          // 신청번호 (PK)
	private String ocType;         // 유형 (CANCEL/RETURN/EXCHANGE)
	private String ocStatus;       // 처리상태 (신청/REQUESTED/APPROVED/REFUNDED/REJECTED 등)
	private String ocReason;       // 사유
	private Long ocQuantity;       // 수량
	private Long ocRamount;        // 환불(예정)금액
	private Long ocTurn;           // 반품 배송비
	private Long ocPoint;          // 차감/환급 포인트
	private Long ocCoupon;         // 차감/환급 쿠폰
	private Date ocRe;             // 신청일시
	private Date ocPr;             // 처리완료일시
	private Long odDetailNo;       // 주문상세번호 (FK)

	// 아래 두 개는 테이블 컬럼은 아니고, 목록 조회 시 조인해서 같이 내려주는 표시용 필드
	private String odProductTitle; // 상품명 (dc_order_detail.od_product_name)
	private Long orNo;             // 주문번호 (dc_order.or_no)

	public Long getOcOutNo() {
		return ocOutNo;
	}
	public void setOcOutNo(Long ocOutNo) {
		this.ocOutNo = ocOutNo;
	}

	public String getOcType() {
		return ocType;
	}

	public void setOcType(String ocType) {
		this.ocType = ocType;
	}

	public String getOcStatus() {
		return ocStatus;
	}

	public void setOcStatus(String ocStatus) {
		this.ocStatus = ocStatus;
	}

	public String getOcReason() {
		return ocReason;
	}

	public void setOcReason(String ocReason) {
		this.ocReason = ocReason;
	}

	public Long getOcQuantity() {
		return ocQuantity;
	}

	public void setOcQuantity(Long ocQuantity) {
		this.ocQuantity = ocQuantity;
	}

	public Long getOcRamount() {
		return ocRamount;
	}

	public void setOcRamount(Long ocRamount) {
		this.ocRamount = ocRamount;
	}

	public Long getOcTurn() {
		return ocTurn;
	}

	public void setOcTurn(Long ocTurn) {
		this.ocTurn = ocTurn;
	}

	public Long getOcPoint() {
		return ocPoint;
	}

	public void setOcPoint(Long ocPoint) {
		this.ocPoint = ocPoint;
	}

	public Long getOcCoupon() {
		return ocCoupon;
	}

	public void setOcCoupon(Long ocCoupon) {
		this.ocCoupon = ocCoupon;
	}

	public Date getOcRe() {
		return ocRe;
	}

	public void setOcRe(Date ocRe) {
		this.ocRe = ocRe;
	}

	public Date getOcPr() {
		return ocPr;
	}

	public void setOcPr(Date ocPr) {
		this.ocPr = ocPr;
	}

	public Long getOdDetailNo() {
		return odDetailNo;
	}

	public void setOdDetailNo(Long odDetailNo) {
		this.odDetailNo = odDetailNo;
	}

	public String getOdProductTitle() {
		return odProductTitle;
	}

	public void setOdProductTitle(String odProductTitle) {
		this.odProductTitle = odProductTitle;
	}

	public Long getOrNo() {
		return orNo;
	}

	public void setOrNo(Long orNo) {
		this.orNo = orNo;
	}

}