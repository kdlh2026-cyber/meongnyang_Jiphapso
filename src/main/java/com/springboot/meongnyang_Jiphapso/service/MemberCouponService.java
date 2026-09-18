package com.springboot.meongnyang_Jiphapso.service;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.ICouponDAO;
import com.springboot.meongnyang_Jiphapso.dao.IMemberCouponDAO;
import com.springboot.meongnyang_Jiphapso.dto.CouponDTO;
import com.springboot.meongnyang_Jiphapso.dto.MemberCouponDTO;

@Service
public class MemberCouponService {

	private static final Logger log = LoggerFactory.getLogger(MemberCouponService.class);

	@Autowired
	private IMemberCouponDAO memberCouponDAO;

	@Autowired
	private ICouponDAO couponDAO;

	private void fillImageName(List<MemberCouponDTO> list) {
		for (MemberCouponDTO dto : list) {
			dto.setImageName(CouponService.imageNameFor(dto.getCoVal()));
		}
	}

	// 쿠폰 다운로드 (쿠폰함 -> 보유쿠폰함으로 이동)
	public MemberCouponDTO downloadCoupon(Long mNo, Long coNo) {
		if (mNo == null) {
			throw new IllegalStateException("로그인이 필요합니다");
		}

		CouponDTO coupon = couponDAO.selectCouponOne(coNo);
		if (coupon == null) {
			throw new IllegalArgumentException("존재하지 않는 쿠폰입니다");
		}

		Date now = new Date();
		if (now.before(coupon.getCoStart()) || now.after(coupon.getCoEnd())) {
			throw new IllegalStateException("다운로드 가능한 기간이 아닙니다");
		}

		if (memberCouponDAO.countDownloaded(mNo, coNo) > 0) {
			log.warn("쿠폰 다운로드 실패(중복) - mNo={}, coNo={}", mNo, coNo);
			throw new IllegalStateException("이미 다운로드한 쿠폰입니다");
		}

		MemberCouponDTO dto = new MemberCouponDTO();
		dto.setMNo(mNo);
		dto.setCoNo(coNo);
		dto.setMcExpired(calcExpired(coupon.getCoDays())); // coDays가 null(생일쿠폰 등)이면 만료일도 null(무제한)

		memberCouponDAO.insertMemberCoupon(dto);

		log.info("쿠폰 다운로드 완료 - mNo={}, coNo={}, expired={}", mNo, coNo, dto.getMcExpired());

		return dto;
	}

	private Date calcExpired(Integer coDays) {
		if (coDays == null) {
			return null;
		}
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, coDays);
		return cal.getTime();
	}

	// 회원 - 보유쿠폰함 전체 목록
	public List<MemberCouponDTO> getMyCouponList(Long mNo) {
		if (mNo == null) {
			throw new IllegalStateException("로그인이 필요합니다");
		}
		List<MemberCouponDTO> list = memberCouponDAO.selectMemberCouponListByMember(mNo);
		fillImageName(list);
		return list;
	}

	// 회원 - 결제화면에서 사용 가능한 쿠폰 목록
	public List<MemberCouponDTO> getUsableCouponList(Long mNo) {
		if (mNo == null) {
			throw new IllegalStateException("로그인이 필요합니다");
		}
		List<MemberCouponDTO> list = memberCouponDAO.selectUsableMemberCouponListByMember(mNo);
		fillImageName(list);
		return list;
	}

	// 결제 시 쿠폰 사용 처리 - 취소/반품되어도 되돌리지 않음(정책)
	public void useCoupon(Long mcNo, Long orderNo) {
		MemberCouponDTO mc = memberCouponDAO.selectMemberCouponOne(mcNo);
		if (mc == null) {
			log.warn("쿠폰 사용 실패(보유 안함) - mcNo={}, orNo={}", mcNo, orderNo);
			throw new IllegalArgumentException("보유하지 않은 쿠폰입니다");
		}
		if (!"UNUSED".equals(mc.getMcStatus())) {
			log.warn("쿠폰 사용 실패(이미 사용/만료 상태) - mcNo={}, orNo={}, status={}", mcNo, orderNo, mc.getMcStatus());
			throw new IllegalStateException("이미 사용되었거나 만료된 쿠폰입니다");
		}
		if (mc.getMcExpired() != null && mc.getMcExpired().before(new Date())) {
			log.warn("쿠폰 사용 실패(기간만료) - mcNo={}, orNo={}, expired={}", mcNo, orderNo, mc.getMcExpired());
			throw new IllegalStateException("유효기간이 지난 쿠폰입니다");
		}
		memberCouponDAO.updateUseStatus(mcNo, orderNo);

		log.info("쿠폰 사용 확정 - mcNo={}, orNo={}", mcNo, orderNo);
	}

	public long calcDiscountAmount(Long mcNo, Long mNo, long productAmount) {
		MemberCouponDTO mc = memberCouponDAO.selectMemberCouponOne(mcNo);
		if (mc == null) {
			throw new IllegalArgumentException("존재하지 않는 쿠폰입니다");
		}
		if (mc.getMNo() == null || !mc.getMNo().equals(mNo)) {
			log.warn("쿠폰 검증 실패(소유자 불일치) - mcNo={}, 요청mNo={}, 실제mNo={}", mcNo, mNo, mc.getMNo());
			throw new IllegalStateException("본인 쿠폰만 사용할 수 있습니다");
		}
		if (!"UNUSED".equals(mc.getMcStatus())) {
			log.warn("쿠폰 검증 실패(이미 사용/만료 상태) - mcNo={}, mNo={}, status={}", mcNo, mNo, mc.getMcStatus());
			throw new IllegalStateException("이미 사용되었거나 만료된 쿠폰입니다");
		}
		if (mc.getMcExpired() != null && mc.getMcExpired().before(new Date())) {
			log.warn("쿠폰 검증 실패(기간만료) - mcNo={}, mNo={}, expired={}", mcNo, mNo, mc.getMcExpired());
			throw new IllegalStateException("유효기간이 지난 쿠폰입니다");
		}
		int minAmt = mc.getCoMinAmt() == null ? 0 : mc.getCoMinAmt();
		if (productAmount < minAmt) {
			log.warn("쿠폰 검증 실패(최소주문금액 미달) - mcNo={}, mNo={}, productAmount={}, minAmt={}", mcNo, mNo, productAmount, minAmt);
			throw new IllegalStateException("최소 주문금액 조건을 만족하지 않습니다");
		}

		int coVal = mc.getCoVal() == null ? 0 : mc.getCoVal();
		long raw = (long) Math.floor(productAmount * (coVal / 100.0));
		if (mc.getCoMaxAmt() != null && raw > mc.getCoMaxAmt()) {
			raw = mc.getCoMaxAmt();
		}

		log.info("쿠폰 할인액 계산 - mcNo={}, mNo={}, productAmount={}, coVal={}, discount={}", mcNo, mNo, productAmount, coVal, raw);

		return raw;
	}

	// 관리자 - 전체 회원 보유쿠폰 목록
	public List<MemberCouponDTO> getMemberCouponListAll() {
		List<MemberCouponDTO> list = memberCouponDAO.selectMemberCouponListAll();
		fillImageName(list);
		return list;
	}

	public int deleteMemberCoupon(Long mcNo) {
		int result = memberCouponDAO.deleteMemberCoupon(mcNo);
		log.info("관리자 - 보유쿠폰 강제 삭제 - mcNo={}, result={}", mcNo, result);
		return result;
	}

	public int expireOldCoupons() {
		int result = memberCouponDAO.updateExpiredStatusBatch();
		log.info("쿠폰 일괄 만료처리 - 대상건수={}", result);
		return result;
	}
}