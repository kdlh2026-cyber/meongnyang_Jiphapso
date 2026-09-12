package com.springboot.meongnyang_Jiphapso.dto;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;
@Data
public class MemberCouponDTO {

	private Long mcNo;            // 회원보유쿠폰번호 (PK)
	private String mcStatus;      // 상태 - "UNUSED"(보유중) / "USED"(사용완료) / "EXPIRED"(기간만료)
	private Date mcIssued;        // 다운로드(발급)일시
	private Date mcExpired;       // 만료일 (mcIssued + coupon.coDays, coDays가 null이면 무제한이라 null)
	private Date mcUsed;          // 사용일시
	private Long usedOrderNo;     // 사용된 주문번호 FK (결제 시 세팅)

	// mNo, mId 는 getter 이름(getMNo/getMId)의 앞 두 글자가 둘 다 대문자라
	// Jackson이 JSON 필드명을 소문자로 안 바꾸고 "MNo"/"MId"로 내보내는 문제가 있어서
	// @JsonProperty 로 실제 JSON 키를 강제로 고정해준다 (그래야 프론트에서 item.mNo / item.mId 로 정상 접근됨)
	@JsonProperty("mNo")
	private Long mNo;             // 회원번호 FK
	private Long coNo;            // 쿠폰번호 FK

	// --화면 표시용 (dc_coupon / dc_member 조인) - 저장컬럼 X--
	@JsonProperty("mId")
	private String mId;           // 회원아이디 (관리자 목록 표시용)
	private String coName;        // 쿠폰명
	private String coType;        // 할인방식
	private Integer coVal;        // 할인율(%)
	private Integer coMaxAmt;     // 최대 할인 금액
	private Integer coMinAmt;     // 최소 주문 금액
	private String coScope;       // 적용범위
	private String coReason;      // 발급 사유
	private String imageName;     // 쿠폰 디자인 이미지 파일명 (coVal 기준, 예: coupon_10.png)
}