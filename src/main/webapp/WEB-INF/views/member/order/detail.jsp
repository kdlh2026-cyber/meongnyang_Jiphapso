<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주문상세</title>
    <link rel="stylesheet" href="/css/order/detail.css">
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>

<c:set var="editable" value="${order.orStatus == 'PAYMENT_PENDING'}" />

<div class="od-wrap">

    <div class="od-header">
        <button type="button" class="od-back" onclick="history.back()">‹</button>
        <h2 class="od-title">주문상세</h2>
    </div>

    <%-- ================== 주문 정보 ================== --%>
    <div class="od-card">
        <div class="od-card-title">주문 정보</div>
        <div class="od-info-grid">
            <div class="od-info-row"><span class="label">주문번호</span><span>${order.orNo}</span></div>
            <div class="od-info-row"><span class="label">주문일시</span><span><fmt:formatDate value="${order.orAt}" pattern="yyyy.MM.dd HH:mm" /></span></div>
            <div class="od-info-row">
                <span class="label">주문상태</span>
                <span class="status-badge status-${order.orStatus}">
                    <c:choose>
                        <c:when test="${order.orStatus == 'PAYMENT_PENDING'}">결제대기</c:when>
                        <c:when test="${order.orStatus == 'PAID'}">결제완료</c:when>
                        <c:when test="${order.orStatus == 'SHIPPING'}">배송중</c:when>
                        <c:when test="${order.orStatus == 'DELIVERED'}">배송완료</c:when>
                        <c:when test="${order.orStatus == 'CANCELED'}">취소완료</c:when>
                        <c:otherwise>${order.orStatus}</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="od-info-row"><span class="label">결제수단</span><span>${order.orMethod}</span></div>
            <div class="od-info-row"><span class="label">상품 수량</span><span>${order.productQty}개</span></div>
            <c:if test="${order.orYn == 'Y' && order.orQty > 0}">
                <div class="od-info-row"><span class="label">쇼핑백</span><span>${order.orQty}개 추가구매</span></div>
            </c:if>
        </div>
    </div>

    <%-- ================== 배송 정보 ================== --%>
    <div class="od-card">
        <div class="od-card-title">배송 정보</div>

        <div class="od-form-row">
            <label>받는분</label>
            <input type="text" id="orName" value="${order.orName}" ${editable ? '' : 'readonly'}>
        </div>
        <div class="od-form-row">
            <label>연락처</label>
            <input type="text" id="orPhone" value="${order.orPhone}" ${editable ? '' : 'readonly'}>
        </div>
        <div class="od-form-row">
            <label>주소</label>
            <div class="od-form-inline">
                <input type="text" id="orAddress" value="${order.orAddress}" readonly>
                <c:if test="${editable}">
                    <button type="button" class="od-btn" onclick="searchAddress()">주소 검색</button>
                </c:if>
            </div>
        </div>
        <div class="od-form-row">
            <label>상세주소</label>
            <input type="text" id="orAddrdetail" value="${order.orAddrdetail}" ${editable ? '' : 'readonly'}>
        </div>
        <div class="od-form-row">
            <label>주문메모</label>
            <textarea id="orMemo" rows="2" ${editable ? '' : 'readonly'}>${order.orMemo}</textarea>
        </div>

        <c:if test="${editable}">
            <div class="od-form-actions">
                <button type="button" class="od-btn od-btn-primary" onclick="updateOrder()">배송지 수정</button>
            </div>
        </c:if>
    </div>

    <%-- ================== 주문 상품 ================== --%>
    <div class="od-card" id="odProductCard">
        <div class="od-card-title">주문 상품</div>
        <div class="od-table-wrap">
            <table class="od-detail-table">
                <thead>
                    <tr>
                        <th>상품명</th>
                        <th>옵션</th>
                        <th>단가</th>
                        <th>수량</th>
                        <th>금액</th>
                        <th>취소/반품/교환</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="detail" items="${order.orderDetailList}">
                        <tr>
                            <td class="od-pname">${detail.odProductName}</td>                            
                            <td>${empty detail.odOptionName ? '-' : detail.odOptionName}</td>
                            <td><fmt:formatNumber value="${detail.odPrice}" pattern="#,##0" />원</td>
                            <td>${detail.odQuantity}개</td>
                            <td class="od-amount"><fmt:formatNumber value="${detail.odAmount}" pattern="#,##0" />원</td>
                            <td>   
                                <c:choose>
                                    <c:when test="${not empty detail.ocStatus && detail.ocStatus != 'REJECTED'}">
                                        <span class="oc-status-badge oc-status-<c:choose><c:when test="${detail.ocStatus == 'REQUESTED'}">requested</c:when><c:when test="${detail.ocStatus == 'APPROVED'}">approved</c:when><c:when test="${detail.ocStatus == 'REFUNDED'}">refunded</c:when><c:otherwise>etc</c:otherwise></c:choose>">
                                            <c:choose>
                                                <c:when test="${detail.ocStatus == 'REQUESTED'}">취소신청중</c:when>
                                                <c:when test="${detail.ocStatus == 'APPROVED'}">취소승인</c:when>
                                                <c:when test="${detail.ocStatus == 'REFUNDED'}">환불완료</c:when>
                                                <c:otherwise>${detail.ocStatus}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${order.orStatus != 'CANCELED'}">
                                            <button type="button" class="od-btn od-btn-cancel"
                                                    onclick="openCancelModal(${detail.odDetailNo}, '${detail.odProductName}', ${detail.odQuantity})">
                                                <c:choose>
                                                    <c:when test="${detail.ocStatus == 'REJECTED'}">재신청</c:when>
                                                    <c:otherwise>취소/반품/교환</c:otherwise>
                                                </c:choose>
                                            </button>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                                
                                 <!-- 리뷰 대상 상품 찾기: orderWithReview 목록에서 같은 odDetailNo를 가진 항목 매칭 -->
					            <c:set var="reviewDetail" value="${null}" />
					            <c:forEach var="rd" items="${orderWithReview.orderDetailList}">
					                <c:if test="${rd.odDetailNo == detail.odDetailNo}">
					                    <c:set var="reviewDetail" value="${rd}" />
					                </c:if>
					            </c:forEach>
                                
                                <!-- 배송 완료된 상품만 리뷰가능 -->
					            <c:if test="${order.orStatus == 'DELIVERED'}">
					                <button type="button" class="od-btn <c:choose><c:when test="${not empty reviewDetail.review}">od-btn-review-done</c:when><c:otherwise>od-btn-review btn-review-toggle</c:otherwise></c:choose> btn-review-toggle" data-detailno="${detail.odDetailNo}">
					                    <c:choose>
					                        <c:when test="${not empty reviewDetail.review}">리뷰상세</c:when>
					                        <c:otherwise>리뷰작성</c:otherwise>
					                    </c:choose>
					                </button>
					            </c:if>
					        </td>
					    </tr>
					
					    <!-- [추가] 상품별 리뷰 작성 토글 박스 -->
					    <c:if test="${order.orStatus == 'DELIVERED'}">
					        <tr id="review-row-${detail.odDetailNo}" class="review-row-box" style="display: none;">
					            <td colspan="6">
					                <c:choose>
					                    <%-- 이미 리뷰가 작성되어 있는 경우: 작성된 내용 출력 --%>
					                    <c:when test="${not empty reviewDetail.review}">
					                        <div id="review-view-box-${reviewDetail.odDetailNo}" class="review-view-container">
										        <div class="review-view-header" style="font-weight: 700; margin-bottom: 8px; color: #333;">	
										        	<span style="color: #f59e0b; font-size: 15px; letter-spacing: 2px; margin-right: 8px;">
												        <c:choose>
												            <c:when test="${reviewDetail.review.cmt_score == 5}">★★★★★</c:when>
												            <c:when test="${reviewDetail.review.cmt_score == 4}">★★★★☆</c:when>
												            <c:when test="${reviewDetail.review.cmt_score == 3}">★★★☆☆</c:when>
												            <c:when test="${reviewDetail.review.cmt_score == 2}">★★☆☆☆</c:when>
												            <c:otherwise>★☆☆☆☆</c:otherwise>
												        </c:choose>
												    </span>				                            
										            <span style="font-weight: normal; font-size: 11px; color: #888; margin-left: 8px;">
										                <fmt:formatDate value="${reviewDetail.review.cmt_date}" pattern="yyyy.MM.dd HH:mm" />
										            </span>
										        </div>
										        <div class="review-view-content" style="background: #fff; padding: 12px; border: 1px solid #eee; border-radius: 6px; color: #444; font-size: 13px; line-height: 1.5;">
										            ${reviewDetail.review.cmt_content}
										        </div>
										        <div class="review-detail-link-wrap">
												    <a href="/products/ShoppingView?p_no=${detail.PNo}" class="review-detail-link">
												        <span>상품 상세보기</span>
												        <span class="arrow">›</span>
												    </a>
												</div>
										        <div class="review-actions" style="margin-top: 8px; text-align: right;">
										            <!-- 수정 모드로 전환하는 버튼 -->
										            <button type="button" class="od-btn" onclick="toggleEditMode(${reviewDetail.odDetailNo}, true)">수정</button>
										            
										            <!-- 삭제 버튼 (자바스크립트 함수 이용) -->
										            <button type="button" class="od-btn" onclick="deleteReview(${reviewDetail.review.cmt_no}, ${order.orNo})">삭제</button>
										        </div>
										    </div>
					                        
					                        <!-- 2. '수정' 버튼을 누르면 나타나는 리뷰 수정 폼 영역 (기본은 숨김) -->
											<div id="review-edit-box-${reviewDetail.odDetailNo}" class="review-edit-container" style="display: none;">
											    <form action="/review/update" method="post" class="review-form-container">
											        <!-- 시큐리티 CSRF 토큰 -->
											        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
											        
											        <input type="hidden" name="cmt_no" value="${reviewDetail.review.cmt_no}">
											        <input type="hidden" name="orNo" value="${order.orNo}">
											
											        <div class="review-input-area">
											            <!-- ★ [수정 폼] 별점 선택 라디오 UI -->
											            <div class="review-rating-wrap" style="margin-bottom: 8px; display: flex; align-items: center;">
											                <label style="font-size: 13px; font-weight: bold; color: #333; margin-right: 8px;">평점 :</label>
											                <div class="star-rating">
											                    <input type="radio" id="star5-edit-${reviewDetail.odDetailNo}" name="cmt_score" value="5" ${empty reviewDetail.review.cmt_score or reviewDetail.review.cmt_score eq 5 ? 'checked' : ''}><label for="star5-edit-${reviewDetail.odDetailNo}" title="5점">★</label>
											                    <input type="radio" id="star4-edit-${reviewDetail.odDetailNo}" name="cmt_score" value="4" ${reviewDetail.review.cmt_score eq 4 ? 'checked' : ''}><label for="star4-edit-${reviewDetail.odDetailNo}" title="4점">★</label>
											                    <input type="radio" id="star3-edit-${reviewDetail.odDetailNo}" name="cmt_score" value="3" ${reviewDetail.review.cmt_score eq 3 ? 'checked' : ''}><label for="star3-edit-${reviewDetail.odDetailNo}" title="3점">★</label>
											                    <input type="radio" id="star2-edit-${reviewDetail.odDetailNo}" name="cmt_score" value="2" ${reviewDetail.review.cmt_score eq 2 ? 'checked' : ''}><label for="star2-edit-${reviewDetail.odDetailNo}" title="2점">★</label>
											                    <input type="radio" id="star1-edit-${reviewDetail.odDetailNo}" name="cmt_score" value="1" ${reviewDetail.review.cmt_score eq 1 ? 'checked' : ''}><label for="star1-edit-${reviewDetail.odDetailNo}" title="1점">★</label>
											                </div>
											            </div>
											
											            <!-- 기존 작성했던 내용이 기본으로 들어가 있게 설정 -->
											            <textarea name="cmt_content" class="review-textarea" rows="4" required>${reviewDetail.review.cmt_content}</textarea>
											
											            <div class="review-form-actions" style="margin-top: 8px; text-align: right;">
											                <button type="submit" class="od-btn od-btn-primary">수정 완료</button>
											                <button type="button" class="od-btn" onclick="toggleEditMode(${reviewDetail.odDetailNo}, false)">취소</button>
											            </div>
											        </div>
											    </form>
											</div>
											</c:when>
					
					                    <%-- 리뷰가 아직 없는 경우: 작성 폼 출력 --%>
										<c:otherwise>
										    <form action="/review/register" method="post" class="review-form-container">
										        <!-- 시큐리티 CSRF 토큰 (등록 폼에도 필요시 추가) -->
										        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
										        
										        <input type="hidden" name="orNo" value="${order.orNo}">
										        <input type="hidden" name="odDetailNo" value="${detail.odDetailNo}">
										        <input type="hidden" name="p_no" value="${detail.PNo}">
										
										        <div class="review-input-area">
										            <!-- ★ [등록 폼] 별점 선택 라디오 UI -->
										            <div class="review-rating-wrap" style="margin-bottom: 8px; display: flex; align-items: center;">
										                <label style="font-size: 13px; font-weight: bold; color: #333; margin-right: 8px;">평점 :</label>
										                <div class="star-rating">
										                    <input type="radio" id="star5-reg-${detail.odDetailNo}" name="cmt_score" value="5" checked><label for="star5-reg-${detail.odDetailNo}" title="5점">★</label>
										                    <input type="radio" id="star4-reg-${detail.odDetailNo}" name="cmt_score" value="4"><label for="star4-reg-${detail.odDetailNo}" title="4점">★</label>
										                    <input type="radio" id="star3-reg-${detail.odDetailNo}" name="cmt_score" value="3"><label for="star3-reg-${detail.odDetailNo}" title="3점">★</label>
										                    <input type="radio" id="star2-reg-${detail.odDetailNo}" name="cmt_score" value="2"><label for="star2-reg-${detail.odDetailNo}" title="2점">★</label>
										                    <input type="radio" id="star1-reg-${detail.odDetailNo}" name="cmt_score" value="1"><label for="star1-reg-${detail.odDetailNo}" title="1점">★</label>
										                </div>
										            </div>
										
										            <textarea name="cmt_content" class="review-textarea" placeholder="소중한 리뷰를 남겨주세요." rows="4" required></textarea>
										
										            <div class="review-form-actions">
										                <button type="submit" class="od-btn od-btn-primary">리뷰 등록</button>
										            </div>
										        </div>
										    </form>
										</c:otherwise>
					                </c:choose>
					            </td>
					        </tr>
					    </c:if>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <div class="od-btn-group">
        <button type="button" class="od-btn" onclick="history.back()">목록으로</button>
    </div>

</div>

<script>
    const orNo = ${order.orNo};


    const orderDetailItems = [
        <c:forEach var="detail" items="${order.orderDetailList}" varStatus="st">
        { odDetailNo: ${detail.odDetailNo}, odProductName: '${detail.odProductName}', odQuantity: ${detail.odQuantity}, ocStatus: <c:choose><c:when test="${empty detail.ocStatus}">null</c:when><c:otherwise>'${detail.ocStatus}'</c:otherwise></c:choose> }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    function searchAddress() {
        new daum.Postcode({
            oncomplete: function (data) {
                document.getElementById('orAddress').value = data.roadAddress || data.jibunAddress;
                document.getElementById('orAddrdetail').focus();
            }
        }).open();
    }

    // 배송지/메모 수정 - 결제 전(PAYMENT_PENDING) 상태에서만 컨트롤러가 허용
    function updateOrder() {
        const body = {
            orName: document.getElementById('orName').value,
            orPhone: document.getElementById('orPhone').value,
            orAddress: document.getElementById('orAddress').value,
            orAddrdetail: document.getElementById('orAddrdetail').value,
            orMemo: document.getElementById('orMemo').value
        };

        fetch('/member/order/' + orNo, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body)
        })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                alert('배송지 정보가 수정되었어요.');
                location.reload();
            } else {
                alert(result.message || '수정에 실패했어요.');
            }
        })
        .catch(() => alert('처리 중 오류가 발생했어요.'));
    }


    function refreshOrderDetail() {
        location.href = location.pathname;
    }
    
    document.addEventListener('click', function(event) {
        const reviewBtn = event.target.closest('.btn-review-toggle');
        
        if (reviewBtn) {
            const detailNo = reviewBtn.getAttribute('data-detailno');
            const reviewRow = document.getElementById('review-row-' + detailNo);
            
            if (reviewRow) {
                if (reviewRow.style.display === 'none' || reviewRow.style.display === '') {
                    reviewRow.style.display = 'table-row'; // 테이블 내부 행이므로 table-row 사용
                } else {
                    reviewRow.style.display = 'none';
                }
            }
        }
    });
    
    function deleteReview(cmtNo, orNo) {
        if (confirm('정말 리뷰를 삭제하시겠습니까?')) {
            // GET 방식으로 파라미터를 전달하여 컨트롤러 호출
            location.href = '/review/delete?cmt_no=' + cmtNo + '&orNo=' + orNo;
        }
    }
    
    function toggleEditMode(detailNo, isEdit) {
        const viewBox = document.getElementById('review-view-box-' + detailNo);
        const editBox = document.getElementById('review-edit-box-' + detailNo);
        
        if (isEdit) {
            viewBox.style.display = 'none';
            editBox.style.display = 'block';
        } else {
            viewBox.style.display = 'block';
            editBox.style.display = 'none';
        }
    }
</script>

<%-- 취소/반품/교환 신청 모달 (버튼 onclick="openCancelModal(...)" 이 이 안의 함수를 호출함) --%>
<jsp:include page="/WEB-INF/views/member/OrderCancel/cancelForm.jsp" />

<script>

    (function () {
        const params = new URLSearchParams(location.search);
        if (params.get('cancel') !== '1') return;

        // 이미 취소신청이 들어간(REJECTED=거절 제외) 라인은 자동오픈 대상에서 제외 - 아직 신청 안 한 상품만 대상
        const cancellable = orderDetailItems.filter(function (item) {
            return !item.ocStatus || item.ocStatus === 'REJECTED';
        });

        if (cancellable.length === 0) return;

        if (cancellable.length === 1) {
            // 취소 가능한 상품이 1개뿐이면 바로 취소/반품/교환 모달을 열어줌
            const item = cancellable[0];
            openCancelModal(item.odDetailNo, item.odProductName, item.odQuantity);
        } else {

            const card = document.getElementById('odProductCard');
            if (card) {
                card.scrollIntoView({ behavior: 'smooth', block: 'start' });
                card.classList.add('od-card-highlight');
                setTimeout(function () { card.classList.remove('od-card-highlight'); }, 1600);
            }
        }
    })();
</script>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
