package com.springboot.meongnyang_Jiphapso.dto;

import java.util.Date;

import lombok.Data;

@Data
public class PointDTO {

    private Long poNo;        // 포인트 이력번호 (PK, IDENTITY)
    private String poType;    // 구분: EARN(적립) / USE(사용) / EXPIRE(소멸) / RESTORE(복원)
    private Long poAmount;    // 증감액 (적립/복원 = +, 사용/소멸 = -)
    private Long poAfter;     // 처리 후 잔액
    private String poReason;  // 발생 사유 (회원가입, 출석체크, 구매적립 등)
    private Date poAt;        // 발생일시
    private Date poEx;        // 소멸예정일 (적립건에만 존재, 적립일 + 1년)
    private Long poOrderNo;   // 관련 주문번호 FK
    private Long mNo;         // 회원번호 FK
    private Long chNo;        // 출석체크 번호 FK
    private Long poRelatedNo; // 이 이력이 다른 이력을 취소한 경우, 그 원본 이력번호(자기참조)

    // ----- 화면 표시/조인용 (저장컬럼 x) -----
    private String mId;             // 회원 아이디 (관리자 목록에서 표시)
    private String mName;           // 회원 이름 (관리자 목록에서 표시)
    private Long remainAmount;      // 해당 적립건의 남은 포인트 (FIFO 계산 결과)
    private Integer expireDday;     // 소멸까지 남은 일수

    public PointDTO() {}

    public PointDTO(Long mNo, String poType, Long poAmount, String poReason) {
        this.mNo = mNo;
        this.poType = poType;
        this.poAmount = poAmount;
        this.poReason = poReason;
    }

    public Long getPoNo() { return poNo; }
    public void setPoNo(Long poNo) { this.poNo = poNo; }

    public String getPoType() { return poType; }
    public void setPoType(String poType) { this.poType = poType; }

    public Long getPoAmount() { return poAmount; }
    public void setPoAmount(Long poAmount) { this.poAmount = poAmount; }

    public Long getPoAfter() { return poAfter; }
    public void setPoAfter(Long poAfter) { this.poAfter = poAfter; }

    public String getPoReason() { return poReason; }
    public void setPoReason(String poReason) { this.poReason = poReason; }

    public Date getPoAt() { return poAt; }
    public void setPoAt(Date poAt) { this.poAt = poAt; }

    public Date getPoEx() { return poEx; }
    public void setPoEx(Date poEx) { this.poEx = poEx; }

    public Long getPoOrderNo() { return poOrderNo; }
    public void setPoOrderNo(Long poOrderNo) { this.poOrderNo = poOrderNo; }

    public Long getMNo() { return mNo; }
    public void setMNo(Long mNo) { this.mNo = mNo; }

    public Long getChNo() { return chNo; }
    public void setChNo(Long chNo) { this.chNo = chNo; }

    public Long getPoRelatedNo() { return poRelatedNo; }
    public void setPoRelatedNo(Long poRelatedNo) { this.poRelatedNo = poRelatedNo; }

    public String getMId() { return mId; }
    public void setMId(String mId) { this.mId = mId; }

    public String getMName() { return mName; }
    public void setMName(String mName) { this.mName = mName; }

    public Long getRemainAmount() { return remainAmount; }
    public void setRemainAmount(Long remainAmount) { this.remainAmount = remainAmount; }

    public Integer getExpireDday() { return expireDday; }
    public void setExpireDday(Integer expireDday) { this.expireDday = expireDday; }

    @Override
    public String toString() {
        return "PointDTO{" +
                "poNo=" + poNo +
                ", poType='" + poType + '\'' +
                ", poAmount=" + poAmount +
                ", poAfter=" + poAfter +
                ", mNo=" + mNo +
                '}';
    }
}
