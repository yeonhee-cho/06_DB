-- ========================================
-- MySQL 기반: 온라인 쇼핑몰 데이터베이스
-- ========================================

CREATE DATABASE IF NOTEXISTS online_shop;
USE online_shop;

-- ========================================
-- LEVEL 
-- ========================================

-- 문제 1-1: CATEGORY 테이블 생성
/*
조건:
- category_id: 자동증가 기본키
- category_name: 카테고리명 (50자, NULL 불가, 중복 불가)
- description: 설명 (TEXT)
- is_active: 활성상태 (BOOLEAN, 기본값 TRUE)
- created_at: 등록시간 (TIMESTAMP, 기본값 현재시간)
*/



-- 문제 1-2: CUSTOMER 테이블 생성
/*
조건:
- customer_id: 자동증가 기본키
- username: 사용자명 (30자, NULL 불가, 중복 불가)
- email: 이메일 (100자, NULL 불가, 중복 불가)
- password: 비밀번호 (255자, NULL 불가)
- full_name: 실명 (50자, NULL 불가)
- phone: 전화번호 (20자)
- birth_date: 생년월일 (DATE)
- gender: 성별 (ENUM: 'M', 'F', 'OTHER')
- point: 적립금 (정수, 기본값 0, 0 이상)
- grade: 등급 (VARCHAR(20), 기본값 'BRONZE')
- is_active: 활성상태 (BOOLEAN, 기본값 TRUE)
- join_date: 가입일 (TIMESTAMP, 기본값 현재시간)
- last_login: 마지막 로그인 (TIMESTAMP)
*/



-- 문제 1-3: PRODUCT 테이블 생성
/*
조건:
- product_id: 자동증가 기본키
- product_name: 상품명 (100자, NULL 불가)
- category_id: 카테고리ID (정수, 외래키)
- price: 가격 (정수, NULL 불가, 0 이상)
- discount_rate: 할인율 (DECIMAL(5,2), 기본값 0.00, 0~100 사이)
- stock_quantity: 재고수량 (정수, 기본값 0, 0 이상)
- description: 상품설명 (TEXT)
- brand: 브랜드 (50자)
- weight: 무게 (DECIMAL(8,2))
- status: 상태 (ENUM: 'AVAILABLE', 'OUT_OF_STOCK', 'DISCONTINUED', 기본값 'AVAILABLE')
- created_at: 등록시간 (TIMESTAMP, 기본값 현재시간)
- updated_at: 수정시간 (TIMESTAMP, 기본값 현재시간, 수정시 자동 업데이트)
*/

-- 문제 1-4: INSERT
-- CATEGORY 테이블에 다음 데이터를 삽입하세요
/*
1. 전자제품, '스마트폰, 노트북, 태블릿 등', TRUE
2. 의류, '남성복, 여성복, 아동복', TRUE
3. 도서, '소설, 전문서적, 교육서적', TRUE
4. 스포츠/레저, '운동용품, 아웃도어 장비', TRUE
5. 식품, '신선식품, 가공식품', FALSE
*/



-- CUSTOMER 테이블에 다음 데이터를 삽입하세요
/*
1. hong123, hong@email.com, password123, 홍길동, 010-1111-2222, 1990-05-15, M, 5000, GOLD
2. kim_user, kim@email.com, mypass456, 김영희, 010-3333-4444, 1995-08-20, F, 3000, SILVER  
3. park2024, park@email.com, secure789, 박민수, 010-5555-6666, 1988-12-03, M, 10000, PLATINUM
4. lee_shop, lee@email.com, password999, 이수진, 010-7777-8888, 2000-03-10, F, 1500, BRONZE
5. choi_buy, choi@email.com, pass1234, 최준호, NULL, 1992-07-25, M, 0, BRONZE
*/


-- PRODUCT 테이블에 다음 데이터를 삽입하세요
/*
1. iPhone 15 Pro, 카테고리1, 1200000, 5.00, 50, '최신 아이폰 모델', 'Apple', 200.00, AVAILABLE
2. 삼성 갤럭시 북, 카테고리1, 1500000, 10.00, 30, '고성능 노트북', 'Samsung', 1500.00, AVAILABLE
3. 남성 정장, 카테고리2, 200000, 20.00, 100, '비즈니스 정장', 'Hugo Boss', NULL, AVAILABLE
4. 운동화, 카테고리4, 150000, 15.00, 0, '러닝화', 'Nike', 300.00, OUT_OF_STOCK
5. 요리책, 카테고리3, 25000, 0.00, 200, '집밥 요리 레시피', '맛있는책', 500.00, AVAILABLE
*/
