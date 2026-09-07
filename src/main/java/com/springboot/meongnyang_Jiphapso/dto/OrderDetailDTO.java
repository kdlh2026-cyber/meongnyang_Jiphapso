package com.springboot.meongnyang_Jiphapso.dto;

import java.util.Date;

import lombok.Data;

@Data
public class OrderDetailDTO {

    private Long odDetailNo;     // 주문상세번호
    private String odOptionName; // 주문 시점 옵션명 스냅샷
    private String odProductName;// 주문 시점 상품명 스냅샷
    private Long odPrice;        // 주문 시점 단가 스냅샷
    private Integer odQuantity;  // 수량
    private Long odAmount;       // 상품금액 x 수량
    private Date odAt;           // 주문일시
    private Long orNo;           // 주문번호 FK
    private Long pNo;            // 상품번호 FK
    private Long oNo;            // 상품옵션번호 FK

    // ----- 화면 표시용 -----
    private String pMainImg;     // 상품 이미지
    private String orStatus;     // 상위 주문상태 (결제하기/취소 버튼 노출 분기용)
    private Date orAt;           // 상위 주문일시

    public OrderDetailDTO() {}

    public Long getOdDetailNo() { return odDetailNo; }
    public void setOdDetailNo(Long odDetailNo) { this.odDetailNo = odDetailNo; }

    public String getOdOptionName() { return odOptionName; }
    public void setOdOptionName(String odOptionName) { this.odOptionName = odOptionName; }

    public String getOdProductName() { return odProductName; }
    public void setOdProductName(String odProductName) { this.odProductName = odProductName; }

    public Long getOdPrice() { return odPrice; }
    public void setOdPrice(Long odPrice) { this.odPrice = odPrice; }

    public Integer getOdQuantity() { return odQuantity; }
    public void setOdQuantity(Integer odQuantity) { this.odQuantity = odQuantity; }

    public Long getOdAmount() { return odAmount; }
    public void setOdAmount(Long odAmount) { this.odAmount = odAmount; }

    public Date getOdAt() { return odAt; }
    public void setOdAt(Date odAt) { this.odAt = odAt; }

    public Long getOrNo() { return orNo; }
    public void setOrNo(Long orNo) { this.orNo = orNo; }

    public Long getPNo() { return pNo; }
    public void setPNo(Long pNo) { this.pNo = pNo; }

    public Long getONo() { return oNo; }
    public void setONo(Long oNo) { this.oNo = oNo; }

    public String getPMainImg() { return pMainImg; }
    public void setPMainImg(String pMainImg) { this.pMainImg = pMainImg; }

    public String getOrStatus() { return orStatus; }
    public void setOrStatus(String orStatus) { this.orStatus = orStatus; }

    public Date getOrAt() { return orAt; }
    public void setOrAt(Date orAt) { this.orAt = orAt; }

    @Override
    public String toString() {
        return "OrderDetailDTO{" +
                "odDetailNo=" + odDetailNo +
                ", odProductName='" + odProductName + '\'' +
                ", odQuantity=" + odQuantity +
                ", orNo=" + orNo +
                '}';
    }
}
