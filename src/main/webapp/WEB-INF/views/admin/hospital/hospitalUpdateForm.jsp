<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<style>
	.tag-input-box {
		display: flex; flex-wrap: wrap; gap: 6px;
		border: 1px solid #ccc; padding: 6px; min-height: 38px;
	}
	.tag-input-box .tag {
		background: #eee; padding: 2px 8px; border-radius: 12px;
		display: flex; align-items: center; gap: 4px; font-size: 13px;
	}
	.tag-input-box .tag button {
		border: none; background: none; cursor: pointer; font-weight: bold;
	}
	.tag-input-box input {
		border: none; outline: none; flex: 1; min-width: 80px;
	}
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<form name="hospitalUpdateForm" method="post" action="/hp_update">
		<input type="hidden" name="hp_no" value="${hospitalUpdate.hp_no}">
		<table>
			<tr>
				<td>병원 이름</td>
				<td><input type="text" name="hp_name" value="${hospitalUpdate.hp_name}"></td>
			</tr>
			<tr>
				<td>병원 주소</td>
				<td><input type="text" name="hp_addr" value="${hospitalUpdate.hp_addr}"></td>
			</tr>
			<tr>
				<td>전화번호</td>
				<td><input type="text" name="hp_tel" value="${hospitalUpdate.hp_tel}"></td>
			</tr>
			<tr>
				<td>url</td>
				<td><input type="text" name="hp_url" value="${hospitalUpdate.hp_url}"></td>
			</tr>
			<tr>
				<td>진료시간</td>
				<td><textarea name="hp_hour">${hospitalUpdate.hp_hour}</textarea></td>
			</tr>
			<tr>
				<td>특화 진료</td>
				<td>
					<div class="tag-input-box" id="sp_clinic_box">
						<input type="text" id="sp_clinic_input" placeholder="입력 후 Enter">
					</div>
					<input type="hidden" name="hp_sp_clinic" id="hp_sp_clinic" value="${hospitalUpdate.hp_sp_clinic}">
				</td>
			</tr>
			<tr>
				<td>키워드</td>
				<td>
					<div class="tag-input-box" id="keyword_box">
						<input type="text" id="keyword_input" placeholder="입력 후 Enter">
					</div>
					<input type="hidden" name="hp_keyword" id="hp_keyword" value="${hospitalUpdate.hp_keyword}">
				</td>
			</tr>
		</table>
		<input type="submit" value="수정">
	</form>
<%@ include file="/WEB-INF/views/footer.jsp" %>

<script>
function initTagInput(boxId, inputId, hiddenId) {
	const box = document.getElementById(boxId);
	const input = document.getElementById(inputId);
	const hidden = document.getElementById(hiddenId);

	const tags = hidden.value ? hidden.value.split(',').filter(v => v.trim() !== '') : [];

	function render() {
		box.querySelectorAll('.tag').forEach(el => el.remove());
		tags.forEach((tag, idx) => {
			const span = document.createElement('span');
			span.className = 'tag';
			span.innerHTML = tag + ' <button type="button" data-idx="' + idx + '">x</button>';
			box.insertBefore(span, input);
		});
		hidden.value = tags.join(',');
	}

	input.addEventListener('keydown', function(e) {
		if (e.key === 'Enter') {
			e.preventDefault();
			const val = input.value.trim();
			if (val && !tags.includes(val)) {
				tags.push(val);
				input.value = '';
				render();
			}
		}
	});

	box.addEventListener('click', function(e) {
		if (e.target.tagName === 'BUTTON') {
			const idx = Number(e.target.dataset.idx);
			tags.splice(idx, 1);
			render();
		}
	});

	render();
}

initTagInput('sp_clinic_box', 'sp_clinic_input', 'hp_sp_clinic');
initTagInput('keyword_box', 'keyword_input', 'hp_keyword');
</script>
</body>
</html>