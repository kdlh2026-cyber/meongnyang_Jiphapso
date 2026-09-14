<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<style>
.image img {
		width: 80%;
		height: auto;
		max-width: 180px;
	}

.category-btn {
    display: flex;
    gap: 12px;                  /* 버튼 사이의 간격 */
    justify-content: flex-start; /* 좌측 정렬 */
    margin: 20px 0;
    overflow-x: auto;           /* 내용이 넘치면 가로 스크롤 생성 */
    flex-wrap: nowrap;          /* 버튼들이 강제로 줄바꿈되지 않게 함 */
    white-space: nowrap;        /* 텍스트 줄바꿈 방지 */
    -webkit-overflow-scrolling: touch; /* 모바일에서 부드러운 스크롤 */
    padding-bottom: 10px;       /* 스크롤바와 콘텐츠 간격 */
}

/* 스크롤바 디자인 (선택사항 - 크롬, 사파리 등) */
.category-btn::-webkit-scrollbar {
    height: 15px;                /* 스크롤바 두께 */
}
.category-btn::-webkit-scrollbar-thumb {
    background-color: #cbd5e1;  /* 스크롤바 색상 */
    border-radius: 10px;
}
.category-btn::-webkit-scrollbar-track {
    background-color: #f1f3f5;  /* 스크롤바 배경 색상 */
    border-radius: 10px;
}

.category-btn button {
    background-color: #e9ecef; 	
    color: black;           
    border: none;              
    padding: 12px 16px;        /* 패딩을 살짝 조정하여 여백 맞춤 */
    font-size: 14px;          
    font-weight: bold;      
    border-radius: 20px;       
    cursor: pointer;           
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); 
    transition: all 0.3s ease; 
    flex-shrink: 0;             
    
    display: flex;
    flex-direction: column;    /* 이미지는 위, 글씨는 아래로 세로 정렬 */
    align-items: center;       /* 가운데 정렬 */
    justify-content: center;
    gap: 8px;                  /* 이미지와 글씨 사이 간격 */
}

.category-btn button img {
    width: 60px;
    height: 60px;
    object-fit: contain;
}

.type-btn {
    display: inline-flex;
    background-color: #f1f3f5; /* 전체 배경 (연한 회색) */
    padding: 4px;
    border-radius: 30px;
}

.type-btn button {
    display: flex;
    align-items: center;
    gap: 6px;
    background: transparent;
    border: none;
    padding: 8px 16px;
    border-radius: 30px;
    cursor: pointer;
    font-size: 14px;
    color: #495057;
    transition: all 0.2s ease-in-out;
}

.type-btn button img {
    width: 16px;
    height: 16px;
    object-fit: contain;
}

.type-btn button.active {
    background-color: #ffffff;
    color: #000000;
    font-weight: bold;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1); /* 튀어나와 보이는 효과 */
}

/* ===== 상품 카드 - 장바구니/관심상품 UI ===== */
.image-wrap { position: relative; display: block; }

.fav-heart-btn {
    position: absolute;
    top: 6px; right: 6px;
    width: 30px; height: 30px;
    border-radius: 50%;
    border: none;
    background: rgba(255,255,255,0.9);
    box-shadow: 0 1px 4px rgba(0,0,0,0.15);
    display: flex; align-items: center; justify-content: center;
    font-size: 16px; line-height: 1;
    color: #bbb; /* 기본 빈 하트 색 */
    cursor: pointer;
}
.fav-heart-btn.active { color: #e0402e; } /* 담기 완료 시 빨간색으로 채워짐 */

.btn-cart-icon {
    display: inline-flex; align-items: center; justify-content: center;
    width: 32px; height: 32px;
    background: #ffd400; color: #222; border: none;
    border-radius: 50%;
    font-size: 15px; cursor: pointer;
    box-shadow: 0 1px 4px rgba(0,0,0,0.15);
}
.btn-cart-icon:hover { background: #f5c800; }

.price-row { display: flex; align-items: center; justify-content: space-between; margin-top: 6px; }
#globalToast {
    display: none;
    position: fixed;
    left: 50%;
    bottom: 24px;
    transform: translateX(-50%);
    align-items: center;
    gap: 8px;
    background: #222;
    color: #fff;
    border-radius: 30px;
    padding: 10px 8px 10px 16px;
    font-size: 13px;
    box-shadow: 0 6px 18px rgba(0,0,0,0.25);
    z-index: 9999;
    white-space: nowrap;
}
#globalToast .toast-icon { font-size: 15px; }
#globalToast .toast-msg { font-weight: 700; margin-right: 4px; }
#globalToast .toast-link {
    display: none;
    color: #ffe08a;
    font-weight: 700;
    text-decoration: none;
    padding: 8px 14px;
    border-radius: 24px;
    background: rgba(255,255,255,0.08);
    margin-left: 4px;
}
#globalToast .toast-link.show { display: inline-block; }
#globalToast .toast-link:hover { background: rgba(255,255,255,0.18); }
</style>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const urlParams = new URLSearchParams(window.location.search);
        const mode = urlParams.get('mode'); // 현재 선택된 mode 값 (없으면 null)

        const buttons = document.querySelectorAll('.category-btn button');
        buttons.forEach(button => {
            const onclickVal = button.getAttribute('onclick');
            
            if (!mode) {
                // '전체' 버튼인 경우 (mode 파라미터가 없을 때)
                if (onclickVal && !onclickVal.includes('mode=')) {
                    button.classList.add('active');
                }
            } else {
                // 특정 카테고리 버튼인 경우 (mode 파라미터가 일치할 때)
                // 디코딩을 고려하여 포함 여부 확인
                if (onclickVal && onclickVal.includes(mode)) {
                    button.classList.add('active');
                }
            }
        });
    });
</script>
<meta charset="UTF-8">
<title>상품</title>
</head>
<body>
<%@ include file="../hamburger_menu.jsp" %>
	<h3>상품리스트</h3>
	<c:set var="currentType" value="${empty param.p_type ? '강아지' : param.p_type}" />
	<div class="type-btn">
    <button type="button" class="<%= "강아지".equals(request.getParameter("p_type")) ? "active" : "" %>" onclick="location.href='?p_type=강아지'">
        <img src="${pageContext.request.contextPath}/images/products/menu/riri-happy.png" alt="강아지">
        <span>강아지</span>
    </button>
    <button type="button" class="<%= "고양이".equals(request.getParameter("p_type")) ? "active" : "" %>" onclick="location.href='?p_type=고양이'">
        <img src="${pageContext.request.contextPath}/images/products/menu/samsek-smile.png" alt="고양이">
        <span>고양이</span>
    </button>
	</div>
	<c:if test="${currentType eq '강아지'}">
	<div class="category-btn">
		<button onclick="location.href='?p_type=강아지'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/toebeans-all.png"></span>
			<span>전체</span>
		</button>
		<button onclick="location.href='?p_type=강아지&mode=간식'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/61645b0724a2502278d4de906fd617d9.png"></span>
			<span>간식</span>
		</button>
		<button onclick="location.href='?p_type=강아지&mode=매트'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/8c622bfe3a1931692537e4659e191c0b.png"></span>
			<span>매트</span>
		</button>
		<button onclick="location.href='?p_type=강아지&mode=사료'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/b58ee794421ddad8d856fa0806fd251a.png"></span>
			<span>사료</span>
		</button>
		<button onclick="location.href='?p_type=강아지&mode=식기'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/892de792c6a81294f601874899fa0236.png"></span>
			<span>식기</span>
		</button>
		<button onclick="location.href='?p_type=강아지&mode=영양제'">
			<img src="${pageContext.request.contextPath}/images/products/menu/82e61db6782bef62dd6159c9142afa76.png">
			<span>영양제</span>
		</button>
		<button onclick="location.href='?p_type=강아지&mode=위생'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/fbc3aa2a2dc9c0ba4470d79bb85befbc.png"></span>
			<span>위생</span>
		</button>
		<button onclick="location.href='?p_type=강아지&mode=이동장'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/b6a7bb22d7e1713e150c37e7ff3b4163.png"></span>
			<span>이동장</span>
		</button>
		<button onclick="location.href='?p_type=강아지&mode=장난감'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/7ec22f0cbad74019862dfe5ea6b219cb.png"></span>
			<span>장난감</span>
		</button>
		<button onclick="location.href='?p_type=강아지&mode=집/하우스'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/c8f04741cadf02119289a1e69b81c6ca.png"></span>
			<span>집/하우스</span>
		</button>
		<button onclick="location.href='?p_type=강아지&mode=패션'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/9507b81e0f44f948c15b4cbd2b5a7a3b.png"></span>
			<span>패션</span>
		</button>
		<button onclick="location.href='?p_type=강아지&mode=펫가전'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/414e138f4295162de90c455a40930790.png"></span>
			<span>펫가전</span>
		</button>
		<button onclick="location.href='?p_type=강아지&mode=하네스/줄'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/f6b114fff6a770c9460992a6942d9ada.png"></span>
			<span>하네스/줄</span>
		</button>
		<button onclick="location.href='?p_type=강아지&mode=해충방지'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/a5e6d2f2121b1e402be8965e2ac00b34.png"></span>
			<span>해충방지</span>
		</button>
	</div>
	</c:if>
	<c:if test="${currentType eq '고양이'}">
	<div class="category-btn">
		<button onclick="location.href='?p_type=고양이'">
			<span>전체</span>
		</button>
		<button onclick="location.href='?p_type=고양이&mode=간식'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/8bf8e6984da30176a4584b3a7334908b.png"></span>
			<span>간식</span>
		</button>
		<button onclick="location.href='?p_type=고양이&mode=모래'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/ccd3831314e190051266bceedd0eb52f.png"></span>
			<span>모래</span>
		</button>
		<button onclick="location.href='?p_type=고양이&mode=사료'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/1b404894349986e6a7289a0f1eda7efd.png"></span>
			<span>사료</span>
		</button>
		<button onclick="location.href='?p_type=고양이&mode=스크래쳐'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/90d1e1890d7e8f75802ba1e117c1d7d7.png"></span>
			<span>스크래쳐</span>
		</button>
		<button onclick="location.href='?p_type=고양이&mode=식기'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/30b8f9b758a595c1f585894f450aed7f.png"></span>
			<span>식기</span>
		</button>
		<button onclick="location.href='?p_type=고양이&mode=영양제'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/82e61db6782bef62dd6159c9142afa76.png"></span>
			<span>영양제</span>
		</button>
		<button onclick="location.href='?p_type=고양이&mode=위생'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/24b313a97a22687f5e4c6107aa85a603.png"></span>
			<span>위생</span>
		</button>
		<button onclick="location.href='?p_type=고양이&mode=이동장'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/12b2dcb095b24975d79e25dc9551485a.png"></span>
			<span>이동장</span>
		</button>
		<button onclick="location.href='?p_type=고양이&mode=장난감'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/13d45171ec58ad82b39b26d266326e90.png"></span>
			<span>장난감</span>
		</button>
		<button onclick="location.href='?p_type=고양이&mode=집/하우스'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/071701334a45191e7a5c38c21b42a11d.png"></span>
			<span>집/하우스</span>
		</button>
		<button onclick="location.href='?p_type=고양이&mode=캣타워/캣폴'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/234f1ad05d9869d303eca055a669187d.png"></span>
			<span>캣타워/캣폴</span>
		</button>
		<button onclick="location.href='?p_type=고양이&mode=캣휠'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/bb5c1787b43170da68657c9f2e14da5a.png"></span>
			<span>캣휠</span>
		</button>
		<button onclick="location.href='?p_type=고양이&mode=패션'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/2baf1523d50f7df35aa55a6a1caa20e2.png"></span>
			<span>패션</span>
		</button>
		<button onclick="location.href='?p_type=고양이&mode=펫가전'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/fb0f4a5176b5080f58d2bd816950d6b3.png"></span>
			<span>펫가전</span>
		</button>
		<button onclick="location.href='?p_type=고양이&mode=화장실'">
			<span><img src="${pageContext.request.contextPath}/images/products/menu/86707a6af731a282cff5d728079efbe3.png"></span>
			<span>화장실</span>
		</button>
	</div>
	</c:if>
	<form name="p_search" method="get" action="/products/ShoppingList" style="position:relative;">
		<input type="text" name="keyword" id="keyword" autocomplete="off">
		<input type="submit" value="검색">
		<div id="suggestions" style="border:1px solid #cccccc;position:absolute;background:white;width:170px;z-index:10">
		</div>
	</form>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		$("#keyword").on("keyup", function(){
		    let q = $(this).val();
		
		    if(q.length < 1){
		        $("#suggestions").empty();
		        return;
		    }
		
		    $.ajax({
		        url: "/products/autocomplete",
		        data: { keyword: q },
		        success: function(list){
		            let html = "";
		            list.forEach(function(item){
		                // highlight 필드 사용
		                html += "<div class='item'>" + item.highlight + "</div>";
		            });
		            $("#suggestions").html(html);
		        },
		        error: function(){
		            console.log("autocomplete error");
		        }
		    });
		});
		
		// 추천어 클릭 시 검색창에 채움
		$(document).on("click",".item",function(){
		    // <em> 태그 제거 후 input에 넣기
		    $("#keyword").val($(this).text());
		    $("#suggestions").empty();
		});
	</script>
	<table border="1">
		<tr>	
			<c:forEach var="list" items="${ShoppingList}" varStatus="status">
				<td>
				<div class="image-wrap">
					<div class="image"><img src="${pageContext.request.contextPath}/images/products/main/${fn:replace(list.omainimg, '%', '%25')}"></div>
					<button type="button" class="fav-heart-btn" onclick="toggleFavorite(${list.pno}, this)">♥</button>
				</div>
				<div>${list.pbrand}</div>
				<div><a href="/products/ShoppingView?p_no=${list.pno}">${list.ptitle}</a></div>
				<div class="price-row">
					<span>판매가 <fmt:formatNumber value="${list.oprice}" />원</span>
					<button type="button" class="btn-cart-icon" onclick="addToCart(${list.pno}, this)">🛒</button>
				</div>
				</td>
			<c:if test="${status.count%4==0}">
				<tr></tr>
			</c:if>
			</c:forEach>
		</tr>
	</table>
<div>
	<a href="javascript:history.back();">뒤로가기</a>
</div>

<%-- 담기/찜하기 성공 시 화면 하단에 뜨는 공용 토스트 안내창 --%>
<div id="globalToast">
	<span class="toast-icon"></span>
	<span class="toast-msg"></span>
	<a href="${pageContext.request.contextPath}/cart/list" class="toast-link toast-link-cart">장바구니 보기</a>
	<a href="${pageContext.request.contextPath}/favorite/list" class="toast-link toast-link-fav">관심상품 보기</a>
</div>

<script>
var contextPath = "${pageContext.request.contextPath}";
var toastTimer = null;

function addToCart(pNo, btnEl) {
    btnEl.disabled = true;
    fetch(contextPath + "/cart/add", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ pNo: pNo, oNo: null, quantity: 1 })
    })
        .then(function (res) { return res.json(); })
        .then(function (result) {
            if (result.success) {
                // 성공 시 alert() 대신 화면 하단 공용 토스트로 표시 (장바구니 링크만 노출)
                showActionBanner("🛒", result.message || "장바구니에 담았어요", "cart");
            } else {
                alert(result.message || "담기에 실패했어요");
            }
        })
        .catch(function () {
            alert("장바구니 담기 중 오류가 발생했어요.");
        })
        .finally(function () {
            btnEl.disabled = false;
        });
}

// 관심상품 토글 
function toggleFavorite(pNo, btnEl) {
    fetch(contextPath + "/favorite/toggle", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ pNo: pNo })
    })
        .then(function (res) { return res.json(); })
        .then(function (result) {
            if (result.success) {
                btnEl.classList.toggle("active", result.data === true);
                // 관심상품에 "추가"된 경우에만 토스트 표시 (해제 시에는 안 띄움) - 내 파트 신규 추가분
                if (result.data === true) {
                    showActionBanner("♥", result.message || "관심상품에 담았어요", "favorite");
                }
            } else {
                alert(result.message || "처리 중 오류가 발생했어요.");
            }
        })
        .catch(function () {
            alert("관심상품 처리 중 오류가 발생했어요.");
        });
}

// 화면 하단 공용 토스트 표시 - action이 "cart"면 장바구니 링크만, "favorite"면 관심상품 링크만 보이게 함
function showActionBanner(icon, message, action) {
    var toast = document.getElementById("globalToast");
    if (!toast) return;

    toast.querySelector(".toast-icon").innerText = icon;
    toast.querySelector(".toast-msg").innerText = message;

    var cartLink = toast.querySelector(".toast-link-cart");
    var favLink = toast.querySelector(".toast-link-fav");
    cartLink.classList.toggle("show", action === "cart");
    favLink.classList.toggle("show", action === "favorite");

    toast.style.display = "flex";

    if (toastTimer) {
        clearTimeout(toastTimer);
    }
    toastTimer = setTimeout(function () {
        toast.style.display = "none";
    }, 3000);
}
</script>
</body>
</html>
