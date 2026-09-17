package com.springboot.meongnyang_Jiphapso.service;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.ICouponDAO;
import com.springboot.meongnyang_Jiphapso.dao.IMemberCouponDAO;
import com.springboot.meongnyang_Jiphapso.dto.CouponDTO;
import com.springboot.meongnyang_Jiphapso.dto.MemberCouponDTO;

@Service
public class MemberCouponService {

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
			throw new IllegalStateException("이미 다운로드한 쿠폰입니다");
		}

		MemberCouponDTO dto = new MemberCouponDTO();
		dto.setMNo(mNo);
		dto.setCoNo(coNo);
		dto.setMcExpired(calcExpired(coupon.getCoDays())); // coDays가 null(생일쿠폰 등)이면 만료일도 null(무제한)

		memberCouponDAO.insertMemberCoupon(dto);
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
			throw new IllegalArgumentException("보유하지 않은 쿠폰입니다");
		}
		if (!"UNUSED".equals(mc.getMcStatus())) {
			throw new IllegalStateException("이미 사용되었거나 만료된 쿠폰입니다");
		}
		if (mc.getMcExpired() != null && mc.getMcExpired().before(new Date())) {
			throw new IllegalStateException("유효기간이 지난 쿠폰입니다");
		}
		memberCouponDAO.updateUseStatus(mcNo, orderNo);
	}

	// 결제요청 시 쿠폰 할인액 서버 재계산 (PaymentService#requestPayment 에서 호출)
	// 클라이언트가 보낸 payDiscount 값은 절대 믿지 않고, mcNo 기준으로 소유자/상태/만료/최소주문금액을 전부 다시 검증한 뒤 계산함
	public long calcDiscountAmount(Long mcNo, Long mNo, long productAmount) {
		MemberCouponDTO mc = memberCouponDAO.selectMemberCouponOne(mcNo);
		if (mc == null) {
			throw new IllegalArgumentException("존재하지 않는 쿠폰입니다");
		}
		if (mc.getMNo() == null || !mc.getMNo().equals(mNo)) {
			throw new IllegalStateException("본인 쿠폰만 사용할 수 있습니다");
		}
		if (!"UNUSED".equals(mc.getMcStatus())) {
			throw new IllegalStateException("이미 사용되었거나 만료된 쿠폰입니다");
		}
		if (mc.getMcExpired() != null && mc.getMcExpired().before(new Date())) {
			throw new IllegalStateException("유효기간이 지난 쿠폰입니다");
		}
		int minAmt = mc.getCoMinAmt() == null ? 0 : mc.getCoMinAmt();
		if (productAmount < minAmt) {
			throw new IllegalStateException("최소 주문금액 조건을 만족하지 않습니다");
		}

		int coVal = mc.getCoVal() == null ? 0 : mc.getCoVal();
		long raw = (long) Math.floor(productAmount * (coVal / 100.0));
		if (mc.getCoMaxAmt() != null && raw > mc.getCoMaxAmt()) {
			raw = mc.getCoMaxAmt();
		}
		return raw;
	}

	// 관리자 - 전체 회원 보유쿠폰 목록
	public List<MemberCouponDTO> getMemberCouponListAll() {
		List<MemberCouponDTO> list = memberCouponDAO.selectMemberCouponListAll();
		fillImageName(list);
		return list;
	}

	// 관리자 - 보유쿠폰 강제 삭제
	public int deleteMemberCoupon(Long mcNo) {
		return memberCouponDAO.deleteMemberCoupon(mcNo);
	}

	// 배치/스케줄러용 - 기간 지난 미사용 쿠폰 일괄 만료처리
	public int expireOldCoupons() {
		return memberCouponDAO.updateExpiredStatusBatch();
	}
}