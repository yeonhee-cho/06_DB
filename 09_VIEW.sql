-- ================================================
/*
VIEW 
논리적인 가상 테이블
테이블 모양을 하고 있지만, 실제로 값을 저장하고 있지는 않음
값이 저장된 테이블을 모아서 한 번에 조회하는 테이블

-- SELECT 문의 실행 결과(RESULT SET)를 저장하는 객체

-- VIEW 사용 목적
복잡한 SELECT 문을 쉽게 재사용하기 위해
테이블의 진짜 모습을 감출 수 있어 보안상 유리

VIEW 사용 시 주의사항
가상의 테이블(실체 x) 이기 때문에 ALTER VIEW 구문으로만 수정 가능
VIEW를 이용한 DML(INSERT, UPDATE, DELETE)를 사용 가능한 경우도 있지만 제약이 많이 따르기 때문에 SELECT 용도로 대부분 사용

작성법
CREATE [OR REPLACE] VIEW 뷰이름
AS SELECT 문 
[WITH CHECK OPTION];

1) OR REPLACE 옵션 : 
	기존에 동일한 이름의 VIEW 가 존재하고 변경이 없으면 새로 작성
2) WITH CHECK OPTION 옵션 : 
	WHERE 조건을 위반하는 데이터 수정을 방지
*/
-- ================================================

-- CREATE 에러가 발생하는 것을 방지하기 위해서 IF NOT EXISTS
-- DROP 에러가 발생하는 것을 방지하기 위해서 IF EXISTS
CREATE DATABASE IF NOT EXISTS tje;
USE tje;

CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    parent_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS brands (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(50) NOT NULL,
    brand_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    category_id INT,
    brand_id INT,
    status ENUM('active', 'inactive', 'discontinued') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id)
);

CREATE TABLE IF NOT EXISTS product_tags (
    tag_id INT AUTO_INCREMENT PRIMARY KEY,
    tag_name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS product_tag_relations (
    product_id INT,
    tag_id INT,
    PRIMARY KEY (product_id, tag_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES product_tags(tag_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    reviewer_name VARCHAR(50),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

INSERT INTO categories (category_name, parent_id) VALUES 
('전자제품', NULL),
('스마트폰', 1),
('노트북', 1),
('의류', NULL),
('상의', 4),
('하의', 4);

INSERT INTO brands (brand_name, brand_description) VALUES 
('삼성', '대한민국 대표 전자기업'),
('애플', '미국 프리미엄 전자기업'),
('나이키', '글로벌 스포츠 브랜드'),
('아디다스', '독일 스포츠 브랜드');

INSERT INTO products (product_name, product_description, price, stock_quantity, category_id, brand_id) VALUES 
('갤럭시 S24', '삼성 최신 플래그십 스마트폰', 1200000, 50, 2, 1),
('아이폰 15', '애플 최신 스마트폰', 1300000, 30, 2, 2),
('맥북 프로', '애플 고성능 노트북', 2500000, 20, 3, 2),
('나이키 에어맥스', '편안한 러닝화', 150000, 100, 4, 3),
('아디다스 후디', '따뜻한 후드 티셔츠', 80000, 75, 5, 4);

INSERT INTO product_tags (tag_name) VALUES 
('신상품'), ('인기상품'), ('할인'), ('무료배송'), ('베스트'), ('프리미엄');

INSERT INTO product_tag_relations (product_id, tag_id) VALUES 
(1, 1), (1, 4), (1, 6),  -- 갤럭시: 신상품, 무료배송, 프리미엄
(2, 1), (2, 2), (2, 6),  -- 아이폰: 신상품, 인기상품, 프리미엄  
(3, 5), (3, 6),          -- 맥북: 베스트, 프리미엄
(4, 2), (4, 4),          -- 나이키: 인기상품, 무료배송
(5, 3), (5, 4);          -- 아디다스: 할인, 무료배송

INSERT INTO reviews (product_id, reviewer_name, rating, review_text) VALUES 
(1, '김철수', 5, '정말 좋은 폰입니다. 카메라 화질이 뛰어나요.'),
(1, '이영희', 4, '배터리 지속시간이 만족스럽습니다.'),
(2, '박민수', 5, '아이폰은 역시 아이폰이네요. 완벽합니다.'),
(4, '최영수', 4, '신발이 정말 편해요. 러닝할 때 좋습니다.');

-- 1.
SELECT * FROM brands;
SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM reviews;

-- 브랜드와 카테고리를 모두 한 번에 조회하는 SELECT 완성
-- JOIN OK WHERE OK
-- products categories brands
-- products brands는 brand_id
-- products categories category_id

SELECT b.brand_name, b.brand_description, c.category_name
FROM brands b, categories c
WHERE b.brand_id = c.brand_id; -- c에는 brand_id가 없음 아래 문제에서 category_id 추가해주기

-- =============================================================
-- 문제
-- =============================================================
-- ALTER TABLE을 사용해 brands 테이블에 category_id 컬럼을 추가하고 외래 키 제약 조건을 설정
ALTER TABLE brands ADD category_id INT;
ALTER TABLE brands ADD FOREIGN KEY(category_id) REFERENCES categories(category_id);

-- 하나의 테이블에서 여러 수정을 진행할 경우 ,(콤마)를 이용해서 2개 이상의 쿼리를 수행할 수 있다.
ALTER TABLE brands ADD category_id INT, ADD FOREIGN KEY(category_id) REFERENCES categories(category_id);

--  category_id 컬럼은 현재 NULL 값으로 채워져 있다. 각 브랜드에 맞는 카테고리 ID를 UPDATE 문으로 지정
SELECT * FROM brands;
SELECT * FROM categories;

-- 테이블이 존재하는가? 테이블에 해당하는 컬럼명칭이 있는가? 
SET SQL_SAFE_UPDATES = 1;
UPDATE brands
SET category_id = 1
WHERE brand_description LIKE '%전자%';

UPDATE brands
SET category_id = 4
WHERE brand_description LIKE '%스포츠%';

-- category_id WHERE IN을 활용해서 브랜드 명칭을 넣고, 나이키 아디다스에 해당하는 브랜드 카테고리 아이디는 4로 지정
UPDATE brands
SET category_id = 4
WHERE brand_name IN('나이키', '아디다스');

-- void -> 데이터 추가 return -> 몇 개가 있는지나 update를 했을 때 몇 개가 수정되었는지
-- 개수 확인 후 클라이언트한테 개수에 따른 결과 값을 전달

-- 위 사례를 적용한 후, -- 브랜드 * 카테고리를 모두 한 번에 조회하는 SELECT 완성
-- JOIN OK WHERE OK
-- PRODUCTS CATEGORIES BRANDS   
-- PRODUCTS BRANDS brand_id
-- PRODUCTS CATEGORIES category_id

SELECT b.brand_name, b.brand_description, c.category_name, b.category_id
FROM brands b, categories c
WHERE b.category_id = c.category_id;

-- 테이블 간의 컬럼 연결은 JOIN 형태를 쓰며, 2개 이상의 JOIN이 될 경우에는 WHERE 보다 JOIN 형태가 나음

-- VIEW의 경우에는 생성할 때 기존에 존재하는지 확인하고, 
-- 존재할 경우에 대해 에러 발생이 나지 않도록 설정 할 수 있음
-- CREATE OR REPLACE VIEW -> 새로운 VIEW로 존재한다면 기존 VIEW 테이블 제거하고 덮어씌우기
-- 종합 검색할 때 많이 쓰임
CREATE VIEW category_brand AS 
SELECT b.brand_name, b.brand_description, c.category_name, b.category_id
FROM brands b
JOIN categories c ON b.category_id = c.category_id;

-- 만약 JOIN 형태로 데이터를 조회할 경우 
-- 자바에서는 KEYWORD라는 변수이름으로 
-- 클라이언트가 HTML에서 작성한 데이터를
-- DB에 전달하는 상황
CREATE VIEW category_brand AS 
SELECT b.brand_name, b.brand_description, c.category_name, b.category_id
FROM brands b
JOIN categories c ON b.category_id = c.category_id
WHERE b.brand_description = '%KEYWORD%'
AND b.brand_name = '%KEYWORD%'
AND c.category_name = '%KEYWORD%';

-- 조회 시 JOIN을 하는 시간 단축, ALIAS에 해당하는 제약 설정 하지 않아도 됨
SELECT * FROM category_brand; -- 이렇게 검색 가능함

-- 종합 검색에서 AND를 사용할 때 : 검색 결과를 좁히고 싶을 때 사용하는 용도
-- 특정 인물, 사원 조회할 때 사용
SELECT brand_name, brand_description, category_name, category_id
FROM category_brand
WHERE brand_description = '%KEYWORD%'
AND brand_name = '%KEYWORD%'
AND category_name = '%KEYWORD%';

-- 종합 검색에서 OR를 사용할 때 : 검색 결과 범위를 넓히고 싶을 때 사용
-- 카테고리가 스마트폰이거나 상품설명에 전자가 들어있거나 하는 제품들 모두 조회
-- 다양한 제품을 소비자들이 조회할 수 있도록 많은 상품을 보여줄 때 사용
SELECT brand_name, brand_description, category_name, category_id
FROM category_brand
WHERE brand_description = '%KEYWORD%'
OR brand_name = '%KEYWORD%'
OR category_name = '%KEYWORD%';

-- 자바에서 JOIN 관련 SQL문이 제일 힘듬!
-- 변수 이름 설정