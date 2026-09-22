<img width="500" height="400" alt="Image" src="https://github.com/user-attachments/assets/ff26621b-3f04-4bb4-b953-c587cde4b8f5" />

<img width="100" height="400" alt="Image" src="https://github.com/user-attachments/assets/5ad5daa5-bec6-40b3-9d8d-4dd0c4be0137" />

# meongnyang_Jiphapso
yogineun_Meongnyang_Jiphapso_repository_ipnida.

# 팀 프로젝트
Spring Boot를 이용한 팀 프로젝트입니다.

## 프로젝트 소개
반려동물 커뮤니티 위주 올인원 플랫폼을 구현한 웹사이트 개발 프로젝트입니다.

## 개발 환경
- Java
- Spring Boot
- Spring MVC
- MyBatis
- MySQL
- HTML / CSS / JavaScript
- Elasticsearch
- Kibana
- PyCharm
- erwin
- Open office
- starUML
- GitHub

## 주요 기능

### 회원
- 회원가입
- 로그인
- 회원정보 수정
- 회원탈퇴
- 쿠폰 및 포인트 사용, 조회
- 출석체크
- 반려동물 등록 및 관리
- 커뮤니티 이용
- 상품 주문
- 배송 주소록 관리

### 비회원
- 주문
- 비회원 주문조회

### 관리자
- 회원 관리
- 상품 관리
- 주문 관리
- 게시판 관리(리뷰, Q&A, 공지사항 업로드)

### 커뮤니티
- 게시판(Q&A, 라운지, 콘텐츠) 이용
- 게시판 글쓰기 및 수정, 삭제
- 댓글 작성
- 인기글 조회
- 관리자 선정 게시
- 검색 기능

### 이벤트
- 이벤트 제보
- 이벤트 등록 및 수정, 삭제

### 상품
- 상품 등록
- 상품 조회
- 상품 수정
- 상품 삭제

### 장바구니/관심상품
- 장바구니 조회
- 상품 삭제
- 상품 주문

### 주문
- 상품 주문
- 주문 조회
- 검색 기능

### 쿠폰 / 포인트
- 쿠폰 등록
- 쿠폰 및 포인트 회원별 배포
- 쿠폰 배포 관리
- 포인트 배포 관리

### AI(Gemini3.6F) 챗봇 서비스
- 대화

   
## 팀원

| 이미지 | 이름 | 담당 |
|---|---|---|
| <img width="50" height="50" alt="Image" src="https://github.com/user-attachments/assets/ab46faa8-4ef5-4320-b445-ee5c10cacd84" /> | 한지수(팀장) | 메인페이지 구성, 회원 및 동물병원 관련 DAO, DTO, 컨트롤러, 뷰 제작, CSS, 발표자료 제작 및 발표 |
| <img width="50" height="50" alt="Image" src="https://github.com/user-attachments/assets/7b83bc82-449e-47b2-9503-5e4f44e593b3" /> | 김영록 | 상품 및 유기동물 관련 DAO, DTO, 컨트롤러, 뷰 제작, CSS, 발표자료 제작, 배포 우선 테스트 |
| <img width="50" height="50" alt="Image" src="https://github.com/user-attachments/assets/7304c247-39f5-4d51-8131-d0677fbc2554" /> | 도정현 | 커뮤니티 전반 DAO, DTO, 컨트롤러, 뷰 제작, 상품 자료수집 및 업로드, CSS, 발표자료 제작 및 발표|
| <img width="50" height="50" alt="Image" src="https://github.com/user-attachments/assets/3dbba135-082c-4a11-8db0-332bbd7d125d" /> | 이창희 | 주문, 결제, 쿠폰, 포인트, 장바구니, 관심상품 DAO, DTO, 컨트롤러, 뷰 제작, 자료수집 및 업로드, CSS, 발표자료 제작 |

## Git 협업 규칙

- `main` 브랜치 직접 Push 금지
- 개인 브랜치에서 작업
- 작업 완료 후 Commit
- GitHub에 Push
- Pull Request 생성
- 팀원간 점검 후 `main` Merge

## 브랜치

```text
main
├── java/com/springboot/meongnyang_Jiphapso
    ├── auth
    ├── config
    ├── common
    ├── controller
    ├── dao
    ├── dto
    ├── service
├── resources
    ├── mybatis
    ├── static
├── webapp/WEB-INF/views
    ├── admin
    ├── member
    ├── guest
    ├── cart
    ├── community
    ├── event
    ├── favorite
    ├── products
    ├── stray

