package com.springboot.meongnyang_Jiphapso.dto;

import java.util.Date;

import lombok.Data;

@Data
public class OrderCancelDTO {
	private Long ocOutNo;        // 주문취소번호
    private String ocType;       // 처리유형
    private String ocStatus;     // 취소상태
    private String ocReason;     // 취소/반품/교환 사유
    private Integer ocQuantity;  // 취소 수량
    private Long ocRamount;      // 환불 결제금액
    private Long ocTurn;         // 반품 배송비
    private Long ocPoint;        // 반환되지 않는 사용포인트
    private Long ocCoupon;       // 반환되지 않는 쿠폰할인액
    private Date ocRe;           // 취소 신청일시
    private Date ocPr;           // 취소 처리완료일시
    private Long odDetailNo;     // 주문상세번호 FK

    // 화면 표시 용 
    private String odProductTitle; // 상품명
    private Long orNo;
    
    public OrderCancelDTO() {}
    
    public Long getOcOutNo() {return ocOutNo;}
    public void setOcOutNo(Long OcOutNo) {this.ocOutNo = ocOutNo;}
    
    public String getOcType() { return ocType; }
    public void setOcType(String ocType) { this.ocType = ocType; }
    
    public String getOcStatus() { return ocStatus; }
    public void setOcStatus(String ocStatus) { this.ocStatus = ocStatus; }

    public String getOcReason() { return ocReason; }
    public void setOcReason(String ocReason) { this.ocReason = ocReason; }

    public Integer getOcQuantity() { return ocQuantity; }
    public void setOcQuantity(Integer ocQuantity) { this.ocQuantity = ocQuantity; }

    public Long getOcRamount() { return ocRamount; }
    public void setOcRamount(Long ocRamount) { this.ocRamount = ocRamount; }

    public Long getOcTurn() { return ocTurn; }
    public void setOcTurn(Long ocTurn) { this.ocTurn = ocTurn; }

    public Long getOcPoint() { return ocPoint; }
    public void setOcPoint(Long ocPoint) { this.ocPoint = ocPoint; }

    public Long getOcCoupon() { return ocCoupon; }
    public void setOcCoupon(Long ocCoupon) { this.ocCoupon = ocCoupon; }

    public Date getOcRe() { return ocRe; }
    public void setOcRe(Date ocRe) { this.ocRe = ocRe; }

    public Date getOcPr() { return ocPr; }
    public void setOcPr(Date ocPr) { this.ocPr = ocPr; }

    public Long getOdDetailNo() { return odDetailNo; }
    public void setOdDetailNo(Long odDetailNo) { this.odDetailNo = odDetailNo; }

    public String getOdProductName() { return odProductTitle; }
    public void setOdProductName(String odProductName) { this.odProductTitle = odProductName; }

    public Long getOrNo() { return orNo; }
    public void setOrNo(Long orNo) { this.orNo = orNo; }

    @Override
    public String toString() {
        return "OrderCancelDTO{" +
                "ocOutNo=" + ocOutNo +
                ", ocType='" + ocType + '\'' +
                ", ocStatus='" + ocStatus + '\'' +
                ", odDetailNo=" + odDetailNo +
                '}';
    }
}
