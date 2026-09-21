package com.springboot.meongnyang_Jiphapso.service;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.springboot.meongnyang_Jiphapso.common.PointPolicy;
import com.springboot.meongnyang_Jiphapso.dao.IMemberDAO;
import com.springboot.meongnyang_Jiphapso.dao.IPointDAO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;
import com.springboot.meongnyang_Jiphapso.dto.PointDTO;

@Service
public class PointService {

	private static final Logger log = LoggerFactory.getLogger(PointService.class);

	@Autowired
	private IPointDAO pointDAO;

	@Autowired
	private IMemberDAO memberDAO; // 회원 아이디 -> 회원번호 변환용 (커뮤니티 글 적립/회수)

	// ================= 조회 =================

	// 회원의 포인트 이력 전체 (마이페이지)
	public List<PointDTO> getPointListByMember(Long mNo) {
		return pointDAO.selectPointListByMember(mNo);
	}

	// 현재 보유 포인트
	public Long getCurrentBalance(Long mNo) {
		Long balance = pointDAO.selectCurrentBalance(mNo);
		return (balance != null) ? balance : 0L;
	}

	// 마이페이지 상단 요약 (전체 보유 포인트 / 소멸예정 포인트 7일이내)
	public Map<String, Object> getPointSummary(Long mNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		Long total = getCurrentBalance(mNo);
		Long expireSoon = pointDAO.selectExpireSoonAmount(mNo, PointPolicy.EXPIRE_SOON_DAYS);
		map.put("totalPoint", total);
		map.put("expireSoonPoint", (expireSoon != null) ? expireSoon : 0L);
		return map;
	}

	// 관리자 - 전체 이력
	public List<PointDTO> getPointListAll() {
		return pointDAO.selectPointListAll();
	}

	// 관리자 - 이력 삭제
	@Transactional
	public int deletePoint(Long poNo) {
		int result = pointDAO.deletePoint(poNo);
		log.info("관리자 - 포인트 이력 삭제 - poNo={}, result={}", poNo, result);
		return result;
	}

	// ================= 내부 공통 처리 =================
	// 포인트 적립 공통 처리 (신규 적립 lot 생성, 만료일 = 오늘 + 1년)
	private Long earn(Long mNo, long amount, String reason, Long orderNo, Long chNo) {
		if (amount <= 0) {
			return null; // 적립할 금액이 없으면 이력 남기지 않음
		}

		long before = getCurrentBalance(mNo);
		long after = before + amount;

		PointDTO dto = new PointDTO();
		dto.setMNo(mNo);
		dto.setPoType(PointPolicy.TYPE_EARN);
		dto.setPoAmount(amount);
		dto.setPoAfter(after);
		dto.setPoReason(reason);
		dto.setPoEx(addDays(new Date(), PointPolicy.VALID_DAYS)); // 적립일 + 1년 소멸예정일
		dto.setPoOrderNo(orderNo);
		dto.setChNo(chNo);

		pointDAO.insertPoint(dto);

		log.info("포인트 적립 - mNo={}, amount={}, reason={}, after={}", mNo, amount, reason, after);

		return dto.getPoNo();
	}

	// 포인트 사용 공통 처리 (음수 이력, 잔액 부족 시 예외)
	@Transactional
	public void usePoint(Long mNo, long amount, Long orderNo) {
		if (amount <= 0) {
			return; // 사용 포인트 0원이면 이력 남기지 않음
		}

		long before = getCurrentBalance(mNo);
		if (before < amount) {
			log.warn("포인트 사용 실패(잔액부족) - mNo={}, 요청={}, 보유={}", mNo, amount, before);
			throw new IllegalStateException("보유 포인트가 부족합니다.");
		}
		long after = before - amount;

		PointDTO dto = new PointDTO();
		dto.setMNo(mNo);
		dto.setPoType(PointPolicy.TYPE_USE);
		dto.setPoAmount(-amount); // 사용은 감소이므로 음수로 저장
		dto.setPoAfter(after);
		dto.setPoReason(PointPolicy.REASON_ORDER_USE);
		dto.setPoEx(null); // 사용 이력은 소멸예정일 없음
		dto.setPoOrderNo(orderNo);

		pointDAO.insertPoint(dto);

		log.info("포인트 사용 - mNo={}, amount={}, orNo={}, after={}", mNo, amount, orderNo, after);
	}

	// 주문취소 시 사용했던 포인트 복원 (새 적립 lot으로 생성, 만료일 오늘+1년)
	@Transactional
	public void restorePoint(Long mNo, long amount, Long orderNo) {
		if (amount <= 0) {
			return;
		}

		long before = getCurrentBalance(mNo);
		long after = before + amount;

		PointDTO dto = new PointDTO();
		dto.setMNo(mNo);
		dto.setPoType(PointPolicy.TYPE_RESTORE);
		dto.setPoAmount(amount);
		dto.setPoAfter(after);
		dto.setPoReason(PointPolicy.REASON_CANCEL);
		dto.setPoEx(addDays(new Date(), PointPolicy.VALID_DAYS));
		dto.setPoOrderNo(orderNo);

		pointDAO.insertPoint(dto);

		log.info("포인트 복원 - mNo={}, amount={}, orNo={}, after={}", mNo, amount, orderNo, after);
	}

	// ================= 이벤트별 적립 트리거 (각 도메인 Service에서 호출) =================

	// 최초 회원가입 (회원가입 완료 직후 1회 호출)
	@Transactional
	public void earnSignupBonus(Long mNo) {
		if (pointDAO.countByMemberAndReason(mNo, PointPolicy.REASON_SIGNUP) > 0) {
			return; // 이미 지급된 경우 중복 지급 방지
		}
		earn(mNo, PointPolicy.AMOUNT_SIGNUP, PointPolicy.REASON_SIGNUP, null, null);
	}

	// 첫 상품리뷰 작성 (리뷰 작성 Service에서 첫 리뷰 여부 확인 후 호출)
	@Transactional
	public void earnFirstReviewBonus(Long mNo) {
		if (pointDAO.countByMemberAndReason(mNo, PointPolicy.REASON_FIRST_REVIEW) > 0) {
			return;
		}
		earn(mNo, PointPolicy.AMOUNT_FIRST_REVIEW, PointPolicy.REASON_FIRST_REVIEW, null, null);
	}

	// 출석체크 적립 (DailyCheck Service에서 출석 처리 후 호출)
	@Transactional
	public Long earnDailyCheckBonus(Long mNo, Long chNo) {
		return earn(mNo, PointPolicy.AMOUNT_DAILY_CHECK, PointPolicy.REASON_DAILY_CHECK, null, chNo);
	}

	// 라운지 인기글 선정 적립 (관리자/배치가 인기글 선정 후 호출)
	@Transactional
	public void earnHotPostBonus(Long mNo) {
		earn(mNo, PointPolicy.AMOUNT_HOT_POST, PointPolicy.REASON_HOT_POST, null, null);
	}
	@Transactional
	public void earnPurchaseReviewBonus(Long mNo, long reviewedProductAmount, Long orderNo) {
		long amount = PointPolicy.calcRate(reviewedProductAmount, PointPolicy.RATE_PURCHASE_REVIEW);
		earn(mNo, amount, PointPolicy.REASON_PURCHASE_REVIEW, orderNo, null);
	}

	// 커뮤니티 글 작성 적립 (글 종류/내용과 무관하게 1건당 고정 50P, 커뮤니티 Service에서 글 insert 성공 후 호출)
	// ※ 글번호를 안 받는 기존 버전 - 이걸로 적립한 글은 삭제해도 포인트 회수가 안 됨 (아래 아이디+글번호 버전 사용 권장)
	@Transactional
	public void earnCommunityPostBonus(Long mNo) {
		earn(mNo, PointPolicy.AMOUNT_COMMUNITY_POST, PointPolicy.REASON_COMMUNITY_POST, null, null);
	}

	// ================= 커뮤니티 글 적립 / 삭제 시 회수 (회원 아이디 기준) =================

	// 회원 아이디로 회원번호 조회 (없으면 null)
	private Long findMemberNoById(String mId) {
		if (mId == null || mId.trim().isEmpty()) {
			return null;
		}
		MemberDTO member = memberDAO.MemberView(mId);
		return (member != null) ? (long) member.getM_no() : null;
	}

	// 글번호를 사유에 넣어서 저장 -> 글 삭제 시 이 사유로 적립 이력을 찾아서 회수함
	private String communityPostReason(Long commNo) {
		return PointPolicy.REASON_COMMUNITY_POST + " (글번호:" + commNo + ")";
	}

	// 커뮤니티 글 작성 적립 (회원 아이디 + 글번호) - 글 insert 성공 후 커뮤니티 Service에서 호출
	@Transactional
	public void earnCommunityPostBonusById(String mId, Long commNo) {
		log.info("적립 시작 - mId={}, commNo={}", mId, commNo);
		Long mNo = findMemberNoById(mId);
		log.info("회원번호 조회 결과 - mNo={}", mNo);
		if (mNo == null) {
			log.warn("글 작성 포인트 적립 실패(존재하지 않는 회원) - mId={}, commNo={}", mId, commNo);
			return;
		}		
		earn(mNo, PointPolicy.AMOUNT_COMMUNITY_POST, communityPostReason(commNo), null, null);

	}

	// 커뮤니티 글 삭제 시 그 글로 받은 포인트 회수 (회원 아이디 + 글번호) - 커뮤니티 Service의 글 삭제 로직에서 호출
	// 잔액이 모자라도 예외를 던지지 않고 가능한 만큼만 회수함 (글 삭제 자체가 막히지 않게)
	@Transactional
	public void revokeCommunityPostBonusById(String mId, Long commNo) {
		Long mNo = findMemberNoById(mId);
		if (mNo == null) {
			log.warn("글 삭제 포인트 회수 실패(존재하지 않는 회원) - mId={}, commNo={}", mId, commNo);
			return;
		}

		PointDTO earnHistory = pointDAO.selectActiveEarnByReason(mNo, communityPostReason(commNo));
		if (earnHistory == null) {
			return; // 적립받은 적이 없거나 이미 회수된 글
		}

		// 소멸기한이 지난 적립분은 만료 배치가 이미 처리하므로 회수하지 않음 (이중 차감 방지)
		if (earnHistory.getPoEx() != null && earnHistory.getPoEx().before(new Date())) {
			return;
		}

		long earned = (earnHistory.getPoAmount() != null) ? earnHistory.getPoAmount() : 0L;
		long before = getCurrentBalance(mNo);
		long revoke = Math.min(earned, before); // 이미 써서 잔액이 모자라면 남은 만큼만 회수
		if (revoke <= 0) {
			log.info("글 삭제 포인트 회수 생략(회수할 잔액 없음) - mId={}, commNo={}", mId, commNo);
			return;
		}

		PointDTO dto = new PointDTO();
		dto.setMNo(mNo);
		dto.setPoType(PointPolicy.TYPE_USE); // 회수는 차감이므로 USE(음수)로 기록 (관리자 취소와 동일)
		dto.setPoAmount(-revoke);
		dto.setPoAfter(before - revoke);
		dto.setPoReason("게시글 삭제로 인한 포인트 회수 (글번호:" + commNo + ")");
		dto.setPoEx(null);
		dto.setPoRelatedNo(earnHistory.getPoNo()); // 원본 적립 이력과 연결 -> 관리자 취소 관리 목록에도 같이 표시됨

		pointDAO.insertPoint(dto);

		log.info("글 삭제 포인트 회수 - mId={}, commNo={}, earned={}, revoke={}", mId, commNo, earned, revoke);
	}

	// 관리자 수동 적립/차감 (관리자 페이지에서 직접 호출, amount는 양수(적립)/음수(차감) 모두 가능)
	@Transactional
	public void adjustPointByAdmin(Long mNo, long amount, String reason) {
		if (amount == 0) {
			return;
		}

		long before = getCurrentBalance(mNo);
		long after = before + amount;
		if (after < 0) {
			log.warn("관리자 포인트 조정 실패(잔액 음수) - mNo={}, amount={}, before={}", mNo, amount, before);
			throw new IllegalStateException("차감 후 포인트가 음수가 될 수 없습니다.");
		}

		PointDTO dto = new PointDTO();
		dto.setMNo(mNo);
		dto.setPoType(amount > 0 ? PointPolicy.TYPE_EARN : PointPolicy.TYPE_USE);
		dto.setPoAmount(amount);
		dto.setPoAfter(after);
		dto.setPoReason((reason != null && !reason.isEmpty()) ? reason : PointPolicy.REASON_ADMIN);
		dto.setPoEx(amount > 0 ? addDays(new Date(), PointPolicy.VALID_DAYS) : null);

		pointDAO.insertPoint(dto);

		log.info("관리자 포인트 수동 조정 - mNo={}, amount={}, reason={}, after={}", mNo, amount, reason, after);
	}

	// 관리자 - 특정 이력을 "취소" 
	@Transactional
	public void cancelPointEntry(Long poNo, String reason) {
		if (reason == null || reason.trim().isEmpty()) {
			throw new IllegalArgumentException("취소 사유를 입력해주세요.");
		}

		PointDTO original = pointDAO.selectPointOne(poNo);
		if (original == null) {
			throw new IllegalArgumentException("존재하지 않는 포인트 이력입니다.");
		}
		if (original.getPoRelatedNo() != null) {
			log.warn("포인트 이력 취소 실패(이미 취소된 이력) - poNo={}", poNo);
			throw new IllegalStateException("이미 다른 이력을 취소한 이력은 다시 취소할 수 없습니다.");
		}
		// 같은 원본을 두 번 취소하면 포인트가 두 번 차감되는 문제 방지
		if (pointDAO.countByRelatedNo(poNo) > 0) {
			log.warn("포인트 이력 취소 실패(이미 취소된 원본) - poNo={}", poNo);
			throw new IllegalStateException("이미 취소 처리된 이력입니다.");
		}

		long originalAmount = (original.getPoAmount() != null) ? original.getPoAmount() : 0L;
		long reverseAmount = -originalAmount;
		if (reverseAmount == 0) {
			return;
		}

		Long mNo = original.getMNo();
		long before = getCurrentBalance(mNo);
		long after = before + reverseAmount;
		if (after < 0) {
			log.warn("포인트 이력 취소 실패(잔액 음수) - poNo={}, mNo={}, reverseAmount={}, before={}", poNo, mNo, reverseAmount, before);
			throw new IllegalStateException("취소하면 포인트가 음수가 되어 처리할 수 없습니다.");
		}

		PointDTO dto = new PointDTO();
		dto.setMNo(mNo);
		dto.setPoType(reverseAmount > 0 ? PointPolicy.TYPE_EARN : PointPolicy.TYPE_USE);
		dto.setPoAmount(reverseAmount);
		dto.setPoAfter(after);
		dto.setPoReason(reason.trim());
		dto.setPoEx(reverseAmount > 0 ? addDays(new Date(), PointPolicy.VALID_DAYS) : null);
		dto.setPoRelatedNo(original.getPoNo());

		pointDAO.insertPoint(dto);

		log.info("관리자 - 포인트 이력 취소 - poNo={}, mNo={}, reverseAmount={}, reason={}", poNo, mNo, reverseAmount, reason);
	}

	// ================= 만료 배치 =================

	// 매일 새벽 4시 - 기한이 지난 포인트를 소멸 처리 (EXPIRE 이력 생성)
	@Scheduled(cron = "0 0 4 * * *")
	@Transactional
	public void processExpiredPoints() {
		List<Long> targetMembers = pointDAO.selectMemberNosWithExpiredEarn();
		if (targetMembers == null) {
			return;
		}

		int processedCount = 0;
		long totalExpired = 0;

		for (Long mNo : targetMembers) {
			Long expiredAmount = pointDAO.selectExpiredAmount(mNo);
			if (expiredAmount == null || expiredAmount <= 0) {
				continue; // 이미 다 사용했거나 소멸 처리된 경우 건너뜀
			}

			long before = getCurrentBalance(mNo);
			long after = before - expiredAmount;

			PointDTO dto = new PointDTO();
			dto.setMNo(mNo);
			dto.setPoType(PointPolicy.TYPE_EXPIRE);
			dto.setPoAmount(-expiredAmount);
			dto.setPoAfter(after);
			dto.setPoReason(PointPolicy.REASON_EXPIRED);
			dto.setPoEx(null);

			pointDAO.insertPoint(dto);

			processedCount++;
			totalExpired += expiredAmount;
		}

		log.info("포인트 일괄 소멸처리 완료 - 대상회원수={}, 처리건수={}, 총소멸포인트={}", targetMembers.size(), processedCount, totalExpired);
	}

	// ================= 유틸 =================

	private Date addDays(Date date, int days) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.add(Calendar.DATE, days);
		return cal.getTime();
	}
}