<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>유기동물 리스트</title>
</head>
<link rel="stylesheet" href="/css/stray/straylist.css">
<script>
// 지역 데이터
const regionData = {
	"서울": ["전체","가정보호","강남구","강동구","강서구","관악구","광진구","구로구","금천구","노원구","도봉구",
    		"동대문구","동작구","마포구","서대문구","서초구","성동구","성북구","송파구","양천구","영등포구","용산구",
    		"은평구","종로구","중구","중랑구"],
	"부산": ["전체","강서구","금정구","기장군","남구","동구","동래구","부산진구","북구","사상구","사하구","서구",
			"수영구","연제구","영도구","중구","해운대구"],
	"대구": ["전체","남구","달서구","달성군","동구","북구","서구","수성구","중구"],
	"인천": ["전체","강화군","계양구","남동구","동구","미추홀구","부평구","서구","연수구","옹진군","중구"],
	"광주": ["전체","광산구","남구","동구","북구","서구"],
	"세종": ["전체"],
    "대전": ["전체","대덕구","동구","서구","유성구","중구"],
    "울산": ["전체","남구","동구","북구","울주군","중구"],
    "경기도": ["전체","가평군","고양시","과천시","광명시","광주시","구리시","군포시","김포시","남양주시","동두천시",
    		"부천시","성남시","수원시","시흥시","안산시","안성시","안양시","양주시","양평군","여주시","연천군","오산시",
    		"용인시","의왕시","의정부시","이천시","파주시","평택시","포천시","하남시","화성시"],
    "강원도": ["전체","강릉시","고성군","동해시","삼척시","속초시","양구군","양양군","영월군","원주시","인제군",
    		"정선군","철원군","춘천시","태백시","평창군","홍천군","화천군","횡성군"],
    "충청북도": ["전체","괴산군","단양군","보은군","영동군","옥천군","음성군","제천시","증평군","진천군","청주시",
        	"충주시"],
    "충청남도": ["전체","계룡시","공주시","금산군","논산시","당진시","보령시","부여군","서산시","서천군","아산시",
    		"연기군","예산군","천안시","청양군","태안군","홍성군"],
    "전라북도": ["전체","고창군","군산시","김제시","남원시","무주군","부안군","순창군","완주군","익산시","임실군",
        	"장수군","전주시","정읍시","진안군"],
	"전라남도": ["전체","강진군","고흥군","곡성군","광양시","구례군","나주시","담양군","목포시","무안군","보성군",
        	"순천시","신안군","여수시","영광군","영암군","완도군","장성군","장흥군","진도군","함평군","해남군",
        	"화순군"],
	"경상북도": ["전체","경산시","경주시","고령군","구미시","군위군","김천시","문경시","봉화군","상주시","성주군",
			"안동시","영덕군","영양군","영주시","영천시","예천군","울릉군","울진군","의성군","청도군","청송군",
			"칠곡군","포항시"],
	"경상남도": ["전체","거제시","거창군","고성군","김해시","남해군","밀양시","사천시","산청군","양산시","의령군",
			"진주시","창녕군","창원시","통영시","하동군","함안군","함양군","합천군"],
	"제주": ["전체","서귀포시","제주시"]
};
function submitFilterForm(page) {
    const form = document.getElementById('filterForm');
    
    if (page) {
        document.getElementById('formPage').value = page;
    }

    const inputs = form.querySelectorAll('input');
    // 모든 필드 우선 재활성화 후 빈 값만 제외
    inputs.forEach(input => {
        input.disabled = false;
        if (!input.value || input.value.trim() === '') {
            input.disabled = true; // 비어 있는 파라미터는 URL에 안 붙음
        }
    });

    form.submit();
}

// 강아지/고양이 탭 선택 (stray_category)
function selectAnimal(type) {
    const categoryInput = document.getElementById('formStrayCategory');
    if (categoryInput.value === type) {
        categoryInput.value = ''; // 동일 탭 클릭 시 필터 해제
    } else {
        categoryInput.value = type;
    }
    
    document.getElementById('formBreed').value = '';
    
    document.getElementById('formStatus').value = document.getElementById('subStatusSelect').value;
    document.getElementById('formAgeRange').value = document.getElementById('subAgeSelect').value;
    document.getElementById('formGender').value = document.getElementById('subGenderSelect').value;
    document.getElementById('formNeuter').value = document.getElementById('subNeuterSelect').value;

    submitFilterForm(1);
}

// 지역 드롭다운 열기/닫기
function toggleRegionDropdown() {
    const dropdown = document.getElementById('regionDropdown');
    const btn = document.getElementById('regionToggleBtn');
    dropdown.classList.toggle('show');
    btn.classList.toggle('active');
    document.getElementById('breedDropdown')?.classList.remove('show');
}

//필터 패널 열기/닫기 토글
function toggleDetailFilter() {
    const panel = document.getElementById('detailFilterPanel');
    const btn = document.getElementById('filterToggleBtn');
    
    panel.classList.toggle('show');
    btn.classList.toggle('active');
}

// 품종 드롭다운 열기/닫기
function toggleBreedDropdown() {
    const dropdown = document.getElementById('breedDropdown');
    const btn = document.getElementById('breedToggleBtn');
    dropdown.classList.toggle('show');
    btn.classList.toggle('active');
    document.getElementById('regionDropdown')?.classList.remove('show');
}

// 품종 목록 호출
async function loadBreeds(strayCategory) {
    const breedSelect = document.getElementById('breedSelect');
    if (!breedSelect) {
        return;
    }
    
    breedSelect.innerHTML = '<option value="">로딩 중...</option>';
    
    try {
        const query = strayCategory ? ('?stray_category=' + encodeURIComponent(strayCategory)) : '';
        const res = await fetch('/api/breeds' + query);
        
        if (!res.ok) {
            throw new Error('HTTP status ' + res.status);
        }
        
        const breedList = await res.json();

        const formBreedInput = document.getElementById('formBreed');
        const currentBreed = formBreedInput ? formBreedInput.value : '';

        breedSelect.innerHTML = '<option value="">전체 품종</option>';
        
        if (Array.isArray(breedList)) {
            breedList.forEach(function(name) {
                if (name) {
                    const opt = document.createElement('option');
                    opt.value = name;
                    opt.textContent = name;
                    if (currentBreed === name) {
                        opt.selected = true;
                    }
                    breedSelect.appendChild(opt);
                }
            });
        }
    } catch(err) {
        console.error('품종 목록 로드 에러:', err);
        breedSelect.innerHTML = '<option value="">전체 품종</option>';
    }
}

// 지역 필터 적용
function applyRegionFilter() {
    const sido = document.getElementById('sidoSelect').value;
    const gungu = document.getElementById('gunguSelect').value;

    document.getElementById('formSido').value = sido;
    document.getElementById('formGungu').value = (gungu === '전체') ? '' : gungu;

    // 현재 열려있는 서브 필터들의 값도 함께 hidden form에 최신화
    document.getElementById('formStatus').value = document.getElementById('subStatusSelect').value;
    document.getElementById('formAgeRange').value = document.getElementById('subAgeSelect').value;
    document.getElementById('formGender').value = document.getElementById('subGenderSelect').value;
    document.getElementById('formNeuter').value = document.getElementById('subNeuterSelect').value;

    submitFilterForm(1);
}

//품종 필터 적용
function applyBreedFilter() {
    document.getElementById('formBreed').value = document.getElementById('breedSelect').value;
    
    document.getElementById('formStatus').value = document.getElementById('subStatusSelect').value;
    document.getElementById('formAgeRange').value = document.getElementById('subAgeSelect').value;
    document.getElementById('formGender').value = document.getElementById('subGenderSelect').value;
    document.getElementById('formNeuter').value = document.getElementById('subNeuterSelect').value;

    submitFilterForm(1);
}

function goPage(page) {
    submitFilterForm(page);
}

//선택된 필터 알약 태그 렌더링 함수
function renderSelectedTags() {
    const wrap = document.getElementById('selectedTagsWrap');
    if (!wrap) return;

    const statusVal = document.getElementById('formStatus').value;
    const ageVal = document.getElementById('formAgeRange').value;
    const genderVal = document.getElementById('formGender').value;
    const neuterVal = document.getElementById('formNeuter').value;

    let html = '';

    // 1. 상태 태그
    if (statusVal) {
        html += '<span class="filter-tag">상태: ' + statusVal + 
                ' <button type="button" class="filter-tag-del" onclick="removeFilter(\'formStatus\')">✕</button></span>';
    }

    // 2. 나이 태그
    if (ageVal) {
        let ageText = ageVal;
        if (ageVal === '0') ageText = '1살 미만';
        else if (ageVal === 'young') ageText = '1살 ~ 3살';
        else if (ageVal === 'adult') ageText = '4살 ~ 7살';
        else if (ageVal === 'senior') ageText = '8살 이상';

        html += '<span class="filter-tag">나이: ' + ageText + 
                ' <button type="button" class="filter-tag-del" onclick="removeFilter(\'formAgeRange\')">✕</button></span>';
    }

    // 3. 성별 태그
    if (genderVal) {
        let genderText = (genderVal === 'M') ? '남아' : (genderVal === 'F' ? '여아' : '미상');
        html += '<span class="filter-tag">성별: ' + genderText + 
                ' <button type="button" class="filter-tag-del" onclick="removeFilter(\'formGender\')">✕</button></span>';
    }

    // 4. 중성화 태그
    if (neuterVal) {
        let neuterText = (neuterVal === 'Y') ? '완료' : (neuterVal === 'N' ? '미완료' : '알수없음');
        html += '<span class="filter-tag">중성화: ' + neuterText + 
                ' <button type="button" class="filter-tag-del" onclick="removeFilter(\'formNeuter\')">✕</button></span>';
    }

    // 태그가 하나라도 있으면 태그 바 출력
    if (html !== '') {
        html += '<button type="button" class="filter-reset-btn" onclick="resetAllSubFilters()">초기화</button>';
        wrap.innerHTML = html;
        wrap.style.display = 'flex';
    } else {
        wrap.innerHTML = '';
        wrap.style.display = 'none';
    }
}

//서브 필터 셀렉트 선택 시 (값 전송 후 폼 제출)
function applySubFilter() {
    const status = document.getElementById('subStatusSelect').value;
    const age = document.getElementById('subAgeSelect').value;
    const gender = document.getElementById('subGenderSelect').value;
    const neuter = document.getElementById('subNeuterSelect').value;

    if (status) document.getElementById('formStatus').value = status;
    if (age) document.getElementById('formAgeRange').value = age;
    if (gender) document.getElementById('formGender').value = gender;
    if (neuter) document.getElementById('formNeuter').value = neuter;

    submitFilterForm(1);
}

// ✕ 버튼 클릭 시 해당 조건만 삭제
function removeFilter(hiddenId) {
    const input = document.getElementById(hiddenId);
    if (input) {
        input.value = '';
    }
    submitFilterForm(1);
}

// 전체 초기화
function resetAllSubFilters() {
    document.getElementById('formStatus').value = '';
    document.getElementById('formAgeRange').value = '';
    document.getElementById('formGender').value = '';
    document.getElementById('formNeuter').value = '';

    submitFilterForm(1);
}

//초기 이벤트
document.addEventListener('DOMContentLoaded', () => {
    const sidoSelect = document.getElementById('sidoSelect');
    const gunguSelect = document.getElementById('gunguSelect');
    
    const curStatus = document.getElementById('formStatus').value;
    const curAge = document.getElementById('formAgeRange').value;
    const curGender = document.getElementById('formGender').value;
    const curNeuter = document.getElementById('formNeuter').value;
    
    if (curStatus || curAge || curGender || curNeuter) {
        document.getElementById('detailFilterPanel')?.classList.add('show');
        document.getElementById('filterToggleBtn')?.classList.add('active');
        renderSelectedTags();
    }
    
    // 지역 셀렉트 이벤트 (기존 유지)
    sidoSelect.addEventListener('change', function() {
        const selectedSido = this.value;
        gunguSelect.innerHTML = '';

        if (!selectedSido || !regionData[selectedSido]) {
            gunguSelect.innerHTML = '<option value="">전체</option>';
            return;
        }

        regionData[selectedSido].forEach(gungu => {
            const opt = document.createElement('option');
            opt.value = (gungu === '전체') ? '' : gungu;
            opt.textContent = gungu;
            gunguSelect.appendChild(opt);
        });
    });

    // 선택 상태 복원
    const currentSido = document.getElementById('formSido').value;
    const currentGungu = document.getElementById('formGungu').value;
    if (currentSido) {
        sidoSelect.value = currentSido;
        sidoSelect.dispatchEvent(new Event('change'));
        if (currentGungu) {
            gunguSelect.value = currentGungu;
        }
    }

    let currentCategory = document.getElementById('formStrayCategory') ? document.getElementById('formStrayCategory').value : '';
    
    if (!currentCategory) {
        currentCategory = 'DOG';
    }

    loadBreeds(currentCategory);
	
    // 바깥 클릭 시 드롭다운 닫기
    document.addEventListener('click', (e) => {
        if (!e.target.closest('.region-filter-wrap')) {
            document.getElementById('regionDropdown').classList.remove('show');
            document.getElementById('regionToggleBtn').classList.remove('active');
        }
        if (!e.target.closest('.breed-filter-wrap')) {
            document.getElementById('breedDropdown').classList.remove('show');
            document.getElementById('breedToggleBtn').classList.remove('active');
        }
    });
});

/* function toggleWish(strayNo, btnEl) {
    const contextPath = '${pageContext.request.contextPath}';
    
    // Spring Security CSRF 사용 중인 경우 대비
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content');
    const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');

    const headers = { 
        "Content-Type": "application/json" 
    };
    if (csrfHeader && csrfToken) {
        headers[csrfHeader] = csrfToken;
    }

    fetch(contextPath + "/wish/toggle", {
        method: "POST",
        headers: headers,
        body: JSON.stringify({ strayNo: strayNo })
    })
    .then(async function (res) {
        // 비로그인 상태 (401, 403 Forbidden, 혹은 로그인 화면으로 튕긴 경우)
        if (res.status === 401 || res.status === 403 || res.redirected) {
            if (confirm("로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?")) {
                location.href = contextPath + "/login"; // 실제 로그인 URL에 맞게 수정
            }
            return null;
        }

        // 응답이 JSON인지 확인
        const contentType = res.headers.get("content-type");
        if (!contentType || !contentType.includes("application/json")) {
            throw new Error("비정상 응답 (로그인 세션 만료 등)");
        }

        return res.json();
    })
    .then(function (result) {
        if (!result) return;

        if (result.success) {
            btnEl.classList.toggle("active", result.data === true);
            if (result.data === true) {
                showActionBanner("♥", result.message || "관심동물에 담았어요", "wish");
            }
        } else {
            alert(result.message || "처리 중 오류가 발생했어요.");
        }
    })
    .catch(function (err) {
        console.error("찜 에러 상세:", err);
        alert("관심동물 처리 중 오류가 발생했어요.");
    });
}

function showActionBanner(icon, message, action) {
    var toast = document.getElementById("globalToast");
    if (!toast) return;

    toast.querySelector(".toast-icon").innerText = icon;
    toast.querySelector(".toast-msg").innerText = message;

    var favLink = toast.querySelector(".toast-link-fav");
    favLink.classList.toggle("show", action === "wish");

    toast.style.display = "flex";

    if (toastTimer) clearTimeout(toastTimer);
    toastTimer = setTimeout(function () {
        toast.style.display = "none";
    }, 3000);
} */
</script>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
<form id="filterForm" action="/stray/StrayList" method="get" style="display:none;">
    <input type="hidden" name="page" id="formPage" value="${empty currentPage ? 1 : currentPage}">
    <input type="hidden" name="stray_category" id="formStrayCategory" value="${not empty stray_category ? stray_category : (empty param.stray_category ? 'DOG' : param.stray_category)}">
    <input type="hidden" name="stray_name" id="formBreed" value="${not empty stray_name ? stray_name : param.stray_name}">
    <input type="hidden" name="sido" id="formSido" value="${not empty sido ? sido : param.sido}">
    <input type="hidden" name="gungu" id="formGungu" value="${not empty gungu ? gungu : param.gungu}">
    
    <!-- 상세 필터: 컨트롤러 모델 변수와 param 양쪽 모두 대응 -->
    <input type="hidden" name="stray_status" id="formStatus" value="${not empty stray_status ? stray_status : param.stray_status}">
    <input type="hidden" name="age_range" id="formAgeRange" value="${not empty age_range ? age_range : param.age_range}">
    <input type="hidden" name="stray_gender" id="formGender" value="${not empty stray_gender ? stray_gender : param.stray_gender}">
    <input type="hidden" name="stray_neuter" id="formNeuter" value="${not empty stray_neuter ? stray_neuter : param.stray_neuter}">
</form>

<div class="adoption-search-wrap">
    <h2 class="search-header-title">보호소 입양</h2>
    
    <!-- 상단 노란 필터 카드 -->
    <div class="filter-card">
        <img src="/images/stray/menu/cat_n_dog.png" class="character-banner-img" alt="캐릭터">      
        <!-- 강아지 / 고양이 탭 (두 가지 모델 변수 형태 모두 대응) -->
		<div class="animal-tabs">
		    <button type="button" 
		            class="animal-tab ${(searchDto.stray_category == 'DOG') ? 'active' : ''}" 
		            onclick="selectAnimal('DOG')">
		        <img src="/images/stray/menu/dog_head.png" alt="강아지">
		        <span>강아지</span>
		    </button>
		    <button type="button" 
		            class="animal-tab ${(searchDto.stray_category == 'CAT') ? 'active' : ''}" 
		            onclick="selectAnimal('CAT')">
		        <img src="/images/stray/menu/cat_head.png" alt="고양이">
		        <span>고양이</span>
		    </button>
		</div>
    
        <!-- 품종 선택 영역 -->
        <div class="breed-filter-wrap">
            <button type="button" class="pill-btn breed-btn" id="breedToggleBtn" onclick="toggleBreedDropdown()">
                <span>${empty stray_name ? '품종' : stray_name}</span>
                <span class="arrow-icon"></span>
            </button>
    
            <div class="breed-dropdown" id="breedDropdown">
                <div class="dropdown-group">
                    <label>품종 선택</label>
                    <select id="breedSelect">
                        <option value="">전체 품종</option>
                    </select>
                </div>
                <button type="button" class="dropdown-submit-btn" onclick="applyBreedFilter()">적용</button>
            </div>
        </div>
        <!-- 지역 선택 영역 -->
        <div class="region-filter-wrap">
            <button type="button" class="pill-btn region-btn" id="regionToggleBtn" onclick="toggleRegionDropdown()">
                <span>${empty sido ? '지역' : (empty gungu ? sido : sido.concat(' ').concat(gungu))}</span>
                <span class="arrow-icon" id="regionArrow"></span>
            </button>
    
            <div class="region-dropdown" id="regionDropdown">
                <div class="dropdown-group">
                    <label>시/도</label>
                    <select id="sidoSelect">
                        <option value="">전체</option>
                        <option value="서울">서울특별시</option>
                        <option value="부산">부산광역시</option>
                        <option value="대구">대구광역시</option>
                        <option value="인천">인천광역시</option>
                        <option value="광주">광주광역시</option>
                        <option value="세종">세종특별자치시</option>
                        <option value="대전">대전광역시</option>
                        <option value="울산">울산광역시</option>
                        <option value="경기도">경기도</option>
                        <option value="강원도">강원도</option>
                        <option value="충청북도">충청북도</option>
                        <option value="충청남도">충청남도</option>
                        <option value="전라북도">전라북도</option>
                        <option value="전라남도">전라남도</option>
                        <option value="경상북도">경상북도</option>
                        <option value="경상남도">경상남도</option>
                        <option value="제주">제주특별자치도</option>         
                    </select>
                </div>
                <div class="dropdown-group">
                    <label>군/구</label>
                    <select id="gunguSelect">
                        <option value="">전체</option>
                    </select>
                </div>
                <button type="button" class="dropdown-submit-btn" onclick="applyRegionFilter()">적용</button>
            </div>
        </div>
    </div> 
    <div class="filter-sub-wrap">
    	<div class="filter-action-row">
	        <button type="button" class="simple-filter-btn" id="filterToggleBtn" onclick="toggleDetailFilter()">
	            <i class="filter-icon"></i>
	            필터
	        </button>
	
	        <!-- 필터 클릭 시 옆에 열리는 영역 -->
			<div class="detail-filter-panel" id="detailFilterPanel">
			    <!-- 1. 상태 -->
			    <div class="filter-select-item">
			        <select id="subStatusSelect" onchange="applySubFilter()">
			            <option value="">상태</option>
			            <option value="보호중">보호중</option>
			            <option value="공고중">공고중</option>
			            <option value="종료">종료</option>
			        </select>
			        <span class="arrow"></span>
			    </div>
			
			    <span class="filter-divider"></span>
			
			    <!-- 2. 나이 -->
			    <div class="filter-select-item">
			        <select id="subAgeSelect" onchange="applySubFilter()">
			            <option value="">나이</option>
			            <option value="0">1살 미만</option>
			            <option value="young">1살 ~ 3살</option>
			            <option value="adult">4살 ~ 7살</option>
			            <option value="senior">8살 이상</option>
			        </select>
			        <span class="arrow"></span>
			    </div>
			
			    <span class="filter-divider"></span>
			
			    <!-- 3. 성별 -->
			    <div class="filter-select-item">
			        <select id="subGenderSelect" onchange="applySubFilter()">
			            <option value="">성별</option>
			            <option value="M">남아</option>
			            <option value="F">여아</option>
			            <option value="Q">미상</option>
			        </select>
			        <span class="arrow"></span>
			    </div>
			
			    <span class="filter-divider"></span>
			
			    <!-- 4. 중성화 -->
			    <div class="filter-select-item">
			        <select id="subNeuterSelect" onchange="applySubFilter()">
			            <option value="">중성화</option>
			            <option value="Y">완료</option>
			            <option value="N">미완료</option>
			            <option value="Q">알수없음</option>
			        </select>
			        <span class="arrow"></span>
			    </div>
			</div>
	    </div>
		    <div class="selected-tags-wrap" id="selectedTagsWrap" style="display: none;"></div>
		
		    <div class="stray-count-info">
		        <span class="yellow-dots">
		            <span></span>
		            <span style="margin-top: 4px;"></span>
		        </span>
		        <span>
		            <strong><fmt:formatNumber value="${totalCount}" pattern="#,###"/></strong> 마리의 아이들이 보호자를 기다리고 있어요
		        </span>
		    </div>
	</div>
</div> 

<div class="stray-grid-wrap">
    <div class="stray-card-grid">
        <c:forEach var="list" items="${StrayAnimalList}">
            <c:set var="currentYear" value="<%= java.time.LocalDate.now().getYear() %>" />
            <c:set var="age" value="${currentYear - list.stray_age}" />
            <c:set var="addrParts" value="${fn:split(list.stray_shelter_addr, ' ')}" />

            <c:set var="cardImg" value="${fn:replace(list.stray_img, '[', '%5B')}" />
            <c:set var="cardImg" value="${fn:replace(cardImg, ']', '%5D')}" />
   			
            <div class="stray-card">
                <div class="card-thumb-wrap">
                    <div class="card-thumb">
				    <c:choose>
				        <%-- DB에 아예 없으면 표시 --%>
				        <c:when test="${empty list.stray_img}">
				            <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 200 200' width='100%25' height='100%25'%3E%3Crect width='100%25' height='100%25' fill='%23f0f0f0'/%3E%3Ctext x='50%25' y='50%25' dominant-baseline='middle' text-anchor='middle' fill='%23aaa' font-size='14'%3E이미지 준비중%3C/text%3E%3C/svg%3E" alt="준비중">
				        </c:when>
				        <%-- onerror 처리 및 인코딩된 경로 사용 --%>
				        <c:otherwise>
				            <img src="/uploadImages/${cardImg}"
				                 alt="${list.stray_name}" 
				                 loading="lazy"
				                 onerror="this.onerror=null; this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' viewBox=\'0 0 200 200\' width=\'100%25\' height=\'100%25\'%3E%3Crect width=\'100%25\' height=\'100%25\' fill=\'%23f0f0f0\'/%3E%3Ctext x=\'50%25\' y=\'50%25\' dominant-baseline=\'middle\' text-anchor=\'middle\' fill=\'%23aaa\' font-size=\'14\'%3E이미지 없음%3C/text%3E%3C/svg%3E';">
				        </c:otherwise>
				    </c:choose>
					</div>
				</div>
                <div class="card-body">
                    <!-- 노란색 보호중 뱃지 -->
                    <span class="badge-status">${list.stray_status}</span>
                    <!-- 품종 나이 -->
                    <div class="card-title">
                        <a href="/stray/StrayView?stray_no=${list.stray_no}">
                            <c:choose>
                                <c:when test="${list.stray_category == 'DOG'}">[강아지] </c:when>
                                <c:when test="${list.stray_category == 'CAT'}">[고양이] </c:when>
                            </c:choose>
                            ${list.stray_name}
                        </a>
                        <span class="divider">|</span>
                        <span>
                            <c:choose>
                                <c:when test="${age <= 0}">1살 미만</c:when>
                                <c:otherwise>${age}살</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <!-- 성별 · 중성화 여부 -->
                    <div class="card-info">
                        <c:choose>
                            <c:when test="${list.stray_gender == 'M'}">남아</c:when>
                            <c:when test="${list.stray_gender == 'F'}">여아</c:when>
                            <c:otherwise>미상</c:otherwise>
                        </c:choose>
                        <c:choose>
                            <c:when test="${list.stray_neuter == 'Y'}"> · 중성화 완료</c:when>
                            <c:when test="${list.stray_neuter == 'N'}"> · 중성화 미완료</c:when>
                            <c:otherwise> · 중성화 미상</c:otherwise>
                        </c:choose>
                    </div>
                    <%-- <button type="button" class="fav-heart-btn" onclick="toggleWish(${list.stray_no}, this)">♥</button> --%>
                </div>

                <!-- 하단 구분선 + 지역 정보 + 빼꼼 캐릭터 -->
                <div class="card-footer">
                    <div class="card-addr">
                        지역 : ${addrParts[0]} ${addrParts[1]}
                    </div>
                    <c:choose>
                        <c:when test="${list.stray_category == 'DOG'}">
                            <img class="peek-character" src="/images/stray/menu/stray-dog.png" alt="강아지">
                        </c:when>
                        <c:when test="${list.stray_category == 'CAT'}">
                            <img class="peek-character" src="/images/stray/menu/stray-cat.png" alt="고양이">
                        </c:when>
                    </c:choose>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<div class="pagination">
    <%-- 이전 블록 버튼 (<) --%>
    <c:if test="${hasPrev}">
        <a href="javascript:void(0);" onclick="goPage(${startPage - 1})" class="arrow">&lt;</a>
    </c:if>
    
    <%-- 페이지 번호 --%>
    <c:forEach begin="${startPage}" end="${endPage}" var="i">
        <c:choose>
            <c:when test="${currentPage == i}">
                <strong>${i}</strong>
            </c:when>
            <c:otherwise>
                <a href="javascript:void(0);" onclick="goPage(${i})">${i}</a>
            </c:otherwise>
        </c:choose>
    </c:forEach>

    <%-- 다음 블록 버튼 (>) --%>
    <c:if test="${hasNext}">
        <a href="javascript:void(0);" onclick="goPage(${endPage + 1})" class="arrow">&gt;</a>
    </c:if>
</div>

<%-- <div id="globalToast">
    <span class="toast-icon"></span>
    <span class="toast-msg"></span>
    <a href="${pageContext.request.contextPath}/stray/StrayWishList" class="toast-link toast-link-fav">관심동물 보기</a>
</div> --%>
<%@ include file="../footer.jsp" %>
</body>
</html>