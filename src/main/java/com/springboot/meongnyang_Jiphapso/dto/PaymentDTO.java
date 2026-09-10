package com.springboot.meongnyang_Jiphapso.dto;

import java.util.Date;

import lombok.Data;

@Data
public class PaymentDTO {

    private Long payNo;         // 결제 번호
    private String payMethod;   // 결제수단: TOSSPAY / PAYCO / KAKAOPAY / SMILEPAY / NAVERPAY
    private String payTno;      // PG사 거래ID (포트원 paymentId / txId)
    private Long payAmount;     // 상품 총 금액
    private Long payFee;        // 배송비
    private Long payDiscount;   // 쿠폰 사용 금액
    private Long payUsed;       // 포인트 사용 금액
    private Long payDis;        // 총 할인금액 (payDiscount + payUsed)
    private Long payRealAmt;    // 실 결제금액
    private String payStatus;   // 결제상태: PENDING/PAID/FAILED/PARTIAL_REFUNDED/REFUNDED
    private Date payAt;         // 결제완료일시
    private Date payReqAt;      // 결제요청일시
    private Long orNo;          // 주문 FK
    private Long mNo;           // 회원 FK

    // ----- 화면 표시/조인용 (저장컬럼 x) -----
    private String easyPayProvider;  // 간편결제 PG사 코드 (포트원 V2 provider 값과 동일하게 사용)
    private String channelKey;       // 포트원 V2 채널키 (JS 결제창 호출용, DB 저장 안함)
    private String orderName;        // 결제창에 표시할 주문명

    public PaymentDTO() {}

    public Long getPayNo() { return payNo; }
    public void setPayNo(Long payNo) { this.payNo = payNo; }

    public String getPayMethod() { return payMethod; }
    public void setPayMethod(String payMethod) { this.payMethod = payMethod; }

    public String getPayTno() { return payTno; }
    public void setPayTno(String payTno) { this.payTno = payTno; }

    public Long getPayAmount() { return payAmount; }
    public void setPayAmount(Long payAmount) { this.payAmount = payAmount; }

    public Long getPayFee() { return payFee; }
    public void setPayFee(Long payFee) { this.payFee = payFee; }

    public Long getPayDiscount() { return payDiscount; }
    public void setPayDiscount(Long payDiscount) { this.payDiscount = payDiscount; }

    public Long getPayUsed() { return payUsed; }
    public void setPayUsed(Long payUsed) { this.payUsed = payUsed; }

    public Long getPayDis() { return payDis; }
    public void setPayDis(Long payDis) { this.payDis = payDis; }

    public Long getPayRealAmt() { return payRealAmt; }
    public void setPayRealAmt(Long payRealAmt) { this.payRealAmt = payRealAmt; }

    public String getPayStatus() { return payStatus; }
    public void setPayStatus(String payStatus) { this.payStatus = payStatus; }

    public Date getPayAt() { return payAt; }
    public void setPayAt(Date payAt) { this.payAt = payAt; }

    public Date getPayReqAt() { return payReqAt; }
    public void setPayReqAt(Date payReqAt) { this.payReqAt = payReqAt; }

    public Long getOrNo() { return orNo; }
    public void setOrNo(Long orNo) { this.orNo = orNo; }

    public Long getMNo() { return mNo; }
    public void setMNo(Long mNo) { this.mNo = mNo; }

    public String getEasyPayProvider() { return easyPayProvider; }
    public void setEasyPayProvider(String easyPayProvider) { this.easyPayProvider = easyPayProvider; }

    public String getChannelKey() { return channelKey; }
    public void setChannelKey(String channelKey) { this.channelKey = channelKey; }

    public String getOrderName() { return orderName; }
    public void setOrderName(String orderName) { this.orderName = orderName; }

    @Override
    public String toString() {
        return "PaymentDTO{" +
                "payNo=" + payNo +
                ", payStatus='" + payStatus + '\'' +
                ", orNo=" + orNo +
                ", mNo=" + mNo +
                '}';
    }
}
