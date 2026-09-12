package com.springboot.meongnyang_Jiphapso.common;

/**
 * 포인트 적립/사용 정책 상수 모음.
 * 적립액이나 사유 문구를 바꿔야 할 때 이 파일만 고치면 되도록 한 곳에 모아둠.
 */
public class PointPolicy {

    // ---------- 이력 구분(po_type) ----------
    public static final String TYPE_EARN    = "EARN";    // 적립
    public static final String TYPE_USE     = "USE";     // 사용
    public static final String TYPE_EXPIRE  = "EXPIRE";  // 기간만료 소멸
    public static final String TYPE_RESTORE = "RESTORE"; // 주문취소 등으로 인한 복원

    // ---------- 정액 적립 ----------
    public static final long AMOUNT_SIGNUP       = 1000L; // 최초 회원가입
    public static final long AMOUNT_FIRST_REVIEW = 1000L; // 첫 상품리뷰 작성
    public static final long AMOUNT_HOT_POST     = 1000L; // 라운지 인기글 선정
    public static final long AMOUNT_DAILY_CHECK  = 100L;  // 출석체크
    public static final long AMOUNT_COMMUNITY_POST = 50L; // 커뮤니티 글 작성 1건당

    // ---------- 정률 적립 ----------
    public static final double RATE_PURCHASE_REVIEW = 0.03; // 구매한 상품에 리뷰 작성 시, 그 상품 구매금액의 3%

    // ---------- 기간 ----------
    public static final int VALID_DAYS = 365; // 포인트 유효기간 (적립일 + 1년)
    public static final int EXPIRE_SOON_DAYS = 7; // "소멸예정" 으로 표시할 기준 (7일 이내)

    // ---------- 적립 사유 문구 (중복적립 체크 키로도 사용) ----------
    public static final String REASON_SIGNUP       = "회원가입 축하";
    public static final String REASON_FIRST_REVIEW = "첫 리뷰 작성";
    public static final String REASON_HOT_POST     = "라운지 인기글 선정";
    public static final String REASON_DAILY_CHECK  = "출석체크";
    public static final String REASON_PURCHASE_REVIEW = "구매상품 리뷰 적립";
    public static final String REASON_COMMUNITY_POST = "커뮤니티 글 작성";
    public static final String REASON_ORDER_USE    = "주문 사용";
    public static final String REASON_EXPIRED      = "기간만료 소멸";
    public static final String REASON_CANCEL       = "주문취소 복원";
    public static final String REASON_ADMIN        = "관리자 수동처리";

    /** 정률 적립액 계산 (원 단위 절사) */
    public static long calcRate(long baseAmount, double rate) {
        if (baseAmount <= 0) {
            return 0L;
        }
        return (long) Math.floor(baseAmount * rate);
    }

    private PointPolicy() {} // 상수 전용 클래스라 인스턴스 생성 막음
}
