/*
고객 아이디, 고객이름, 이메일, 비밀번호, 주소, 가입일
customer_id, customer_name, email, password, phone, address, created_at
*/

-- 문제 1
-- CUSTOMERS 테이블에서 고객명과 이메일 길이를 조회하고, 이메일 길이를 기준으로 내림차순 정렬하시오.
SELECT * FROM customers;

SELECT customer_name, LENGTH(email)
FROM customers
ORDER BY LENGTH(email) DESC;

/*
가게아이디, 가게명, 주소, 번호, 설명, 최소주문금액, 배달비, 평점, 영업시간, 오픈일
store_id, store_name, address, phone, description, min_order_amount, delivery_fee, rating, opening_hours, created_at
*/
-- 문제 2
-- STORES 테이블에서 가게명의 길이가 10자 이상인 가게들의 이름과 글자 수를 조회하시오.
SELECT store_name AS 가게이름, LENGTH(store_name) AS 글자수
FROM stores
WHERE LENGTH(store_name) >= 10;
-- ORDER BY LENGTH(store_name); -- 순서대로 보고 싶은 경우 추가

-- 문제 3
-- CUSTOMERS 테이블에서 이메일에서 '@' 문자의 위치를 찾아 고객명, 이메일, '@위치'로 조회하시오.
SELECT customer_name, email, LOCATE('@', email)
FROM customers;

-- 문제 4
-- CUSTOMERS 테이블에서 고객명, 이메일에서 아이디 부분만 추출하여 '이메일 아이디'라는 별칭으로 조회하시오.
SELECT customer_name, SUBSTRING(email, 1, LOCATE('@', email) - 1) AS `이메일 아이디`
FROM customers;

-- 문제 5
-- CUSTOMERS 테이블에서 고객명, 이메일 아이디, 이메일 도메인을 각각 분리하여 조회하시오.
SELECT customer_name, SUBSTRING(email, 1, LOCATE('@', email) - 1) AS `이메일 아이디`, SUBSTRING(email, LOCATE('@', email) + 1) AS `이메일 도메인`
FROM customers;

/*
메뉴 아이디, 가게아이디, 메뉴이름, 메뉴설명, 가격, 인기유무
menu_id, store_id, menu_name, description, price, is_popular

* 보통 is 명칭을 앞에 사용하면 BOOLEAN 값을 의미 SQL, JAVA, JavaScript, Python 등 어떤 언어에서든
* 개발자들이 많이 활용하는 변수 명칭 방식 
*/
-- 문제 6
-- MENUS 테이블에서 메뉴명에 '치킨'이라는 단어가 포함된 메뉴들을 조회하고, '치킨'을 'Chicken'으로 변경한 결과도 함께 보여주시오.
USE delivery_app;

-- 조회
SELECT *
FROM menus
WHERE menu_name LIKE '%치킨%';

-- 변경 -- TODO 다른 값도 보여줘야하는지?
SELECT menu_name, REPLACE(menu_name, '치킨', 'Chicken')
FROM menus
WHERE menu_name LIKE '%치킨%';

-- 문제 7
-- STORES 테이블에서 가게명에 '점'을 'Store'로 바꾸어 조회하시오. (기존명, 변경명)
SELECT store_name AS 기존명, REPLACE(store_name, '점', 'Store') AS 변경명
FROM stores;

SELECT CONCAT(store_name, ', ', REPLACE(store_name, '점', 'Store')) AS `(기존명, 변경명)`
FROM stores;

-- REGEXP_REPLACE("문자열", "정규표현식", "치환문자열", "검색시작위치", "매칭순번", "일치옵션")
-- REGEXP_REPLACE 정규식을 이용해서 특정 명칭 변경
-- oo$ : oo 단어 마지막으로 조회되는 단어만 변경
-- ^oo : oo 단어를 시작으로 조회되는 단어만 변경
SELECT store_name, REGEXP_REPLACE(store_name, '점$', 'Store') AS `(기존명, 변경명)`
FROM stores;

-- 문제 8
-- MENUS 테이블에서 가격을 1000으로 나눈 나머지를 구하여 메뉴명, 가격, 나머지를 조회하시오.
SELECT *
FROM menus;

SELECT name AS 메뉴명, price AS 가격,  MOD(price, 1000) AS 나머지
FROM menus;

SELECT name AS 메뉴명, price AS 가격,  MOD(price, 1000) AS 나머지
FROM menus
WHERE MOD(price, 1000) != 0; -- 나머지가 0인 값은 모두 제외하고 조회 조건

-- TODO 이게 왜 되는가?
SELECT name AS 메뉴명, price AS 가격,  price % 1000 AS 나머지
FROM menus;

-- 문제 9
-- ORDERS 테이블에서 총 가격의 절댓값을 구하여 주문번호, 총가격, 절댓값을 조회하시오.
USE delivery_db;

SELECT order_id AS 주문번호, total_price AS 총가격, ABS(total_price) AS 절대값
FROM orders; -- 절대값?! ABS?!

-- 문제 10
-- MENUS 테이블에서 가격을 1000으로 나눈 몫을 올림, 내림, 반올림하여 비교해보시오.
SELECT menu_name AS 메뉴이름, price AS 메뉴가격, CEIL(price / 1000) AS 올림, FLOOR(price / 1000) AS 내림, ROUND(price / 1000) AS 반올림
FROM menus;

-- 문제 11
-- STORES 테이블에서 평점을 소수점 첫째 자리까지, 배달비를 백의 자리에서 반올림하여 조회하시오.
SELECT ROUND(rating, 1), ROUND(delivery_fee, -3)
FROM stores;

-- 문제 12
-- MENUS 테이블에서 가격이 10000원 이상인 메뉴들의 가격을 천 원 단위로 반올림하여 조회하시오.
SELECT ROUND(price, -3)
FROM menus
WHERE price >= 10000;

-- 문제 13
-- ORDERS 테이블에서 고객 ID가 짝수인 주문들의 정보를 조회하시오. (MOD 함수 사용)
SELECT * 
FROM orders
WHERE MOD(customer_id, 2) = 0;

-- 문제 14
-- STORES 테이블에서 최소 주문금액을 만 원 단위로 올림하여 조회하시오.
SELECT min_order_amount, CEIL(min_order_amount / 10000)
FROM stores;

-- 문제 15
-- MENUS 테이블에서 인기메뉴 여부를 숫자로 변환하여 조회하시오. (TRUE=1, FALSE=0)
SELECT menu_name, is_popular
FROM menus; -- 이미 숫자여서 조회만 하면 되는거임!!

-- 문제 16
-- 전체 주문의 총 주문금액 합계를 구하시오.
SELECT SUM(total_price) AS 총주문금액
FROM orders;

-- 문제 17 !!!!!!!!!
-- 배달 완료된 주문들의 평균 주문금액을 구하시오. (소수점 내림 처리)
SELECT FLOOR(AVG(total_price)) AS `평균 주문금액`
FROM orders
WHERE order_status = 'Delivered';

-- 문제 18
-- 가장 비싼 메뉴 가격과 가장 저렴한 메뉴 가격을 조회하시오.
SELECT MAX(price) AS `가장 비싼 메뉴`, MIN(price) AS `가장 저렴한 메뉴`
FROM menus;

-- 문제 19
-- 전체 고객 수와 전화번호가 등록된 고객 수를 각각 구하시오.

-- 문제 20
-- 카테고리별로 중복을 제거한 가게 수를 조회하시오.

-- 문제 21
-- 가게별로 메뉴 개수와 평균 메뉴 가격을 조회하시오. (가게명 포함)

-- 문제 22
-- 카테고리별로 가게 수, 평균 평점, 평균 배달비를 조회하시오. (배달비가 NULL이 아닌 경우만)

-- 문제 23
-- 고객별로 총 주문 횟수와 총 주문금액을 조회하시오. (고객명 포함)

-- 문제 24
-- 주문 상태별로 주문 건수와 평균 주문금액을 조회하시오.

-- 문제 25
-- 가게별 인기메뉴 개수와 일반메뉴 개수를 각각 구하시오.
SELECT 가게테이블.store_name, SUM(메뉴테이블.is_popular) AS `인기메뉴 개수`,
COUNT(*) - SUM(메뉴테이블.is_popular) AS `전체 메뉴에서 인기메뉴 개수를 빼면 인기 없는 메뉴 개수 조회`
FROM stores 가게테이블, menus 메뉴테이블
WHERE 가게테이블.store_id = 메뉴테이블.store_id
GROUP BY store_name;

SELECT *
FROM menus;

-- 문제 26
-- 메뉴가 3개 이상인 가게들의 가게명과 메뉴 개수를 조회하시오.

-- 문제 27
-- 평균 메뉴 가격이 15000원 이상인 가게들을 조회하시오. (가게명, 평균가격)

-- 문제 28
-- 총 주문금액이 30000원 이상인 고객들의 고객명과 총 주문금액을 조회하시오.

-- 문제 29
-- 배달비 평균이 3500원 이상인 카테고리들을 조회하시오. (배달비가 NULL이 아닌 경우만)

-- 문제 30
-- 주문 건수가 2건 이상인 주문 상태들과 해당 건수, 총 주문금액을 조회하시오. 총 주문금액 기준으로 내림차순 정렬하시오.