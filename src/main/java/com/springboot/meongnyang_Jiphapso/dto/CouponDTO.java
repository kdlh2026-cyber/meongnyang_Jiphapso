package com.springboot.meongnyang_Jiphapso.dto;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class CouponDTO {

	private Long coNo;          // 쿠폰번호 (PK)
	private String coName;      // 쿠폰명 (예: MUNGNYANG JIPHAPSO DISCOUNT COUPON)
	private String coType;      // 할인방식 - 현재는 "PERCENT" 고정 사용
	private Integer coVal;      // 할인율(%) - 10/20/30/40/50 만 허용
	private Integer coMaxAmt;   // 최대 할인 금액 (정률 할인 상한 캡, 없으면 null)
	private Integer coMinAmt;   // 최소 주문 금액 (이 금액 이상일 때만 적용, 기본 0)
	private String coScope;     // 적용범위 - "ALL"(전체상품) / "PRODUCT"(특정상품만)
	private String coReason;    // 발급 사유 (신규가입/생일/이벤트 등)
	private Integer coDays;     // 다운로드일로부터 유효기간(일) - 생일쿠폰처럼 무제한이면 null
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date coStart;       // 다운로드 가능 시작일
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date coEnd;         // 다운로드 가능 종료일
	private Date coAt;          // 쿠폰 생성일시

	@JsonProperty("pNo")
	private Long pNo;           // 특정 상품 한정 할인일 때 상품번호 FK (coScope="PRODUCT"일 때만 사용)

	// --화면 표시/조인용 (저장컬럼 X)--
	@JsonProperty("pTitle")
	private String pTitle;        // 대상 상품명 (관리자 목록에서 조인 표시용)
	private String imageName;     // 화면에 뿌릴 쿠폰 디자인 이미지 파일명 (coVal 기준으로 Service에서 세팅, 예: coupon_50.png)
	private Boolean downloaded;   // 로그인한 회원이 이미 다운로드했는지 여부 (다운로드가능목록 조회 시 세팅)
}