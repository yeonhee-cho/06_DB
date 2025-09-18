/*
SELECT 문 해석 순서
5 : SELECT 컬럼명 AS 별칭, 계산식, 함수식
1 : FROM 참조할 테이블명
2 : WHERE 컬럼명 | 함수식 비교 연산자 비교값
3 : GROUP BY 그룹을 묶을 컬럼명
4 : HAVING 그룹함수식 비교 연산자 비교값
6 : ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식[NULLS FIRST | LAST];
*/

-- employees 테이블에서 사원 수 조회
SELECT dept_id, COUNT(*)
FROM employees
GROUP BY dept_id;

-- employees 테이블에서 부서별로 보너스를 주고 싶음
-- 보너스를 주는 조건은 연봉 60000000 이상인 사원만 보너스 제공
-- 보너스를 받는 사원 수를 부서별로 조회
SELECT dept_id, COUNT(*)
FROM employees
WHERE salary >= 60000000
GROUP BY dept_id;

-- employees 테이블에서 
-- 부서 ID, 부서별 급여의 합계 AS 급여 합계 
-- 부서 별 급여의 평균(정수처리 - 내림 처리) AS 급여 평균
-- 인원 수 조회 AS 인원 수
-- 부서 ID 순으로 오름차순 정렬
/*
SELECT dept_id, COUNT(*), SUM(salary), FLOOR(AVG(salary))
FROM employees
GROUP BY dept_id;
*/

SELECT dept_id AS `부서 아이디`, 
       SUM(salary) AS `급여 합계`, 
       FLOOR(AVG(salary)) AS `급여 평균`, 
       COUNT(*) AS `인원 수`
FROM employees
GROUP BY dept_id
ORDER BY dept_id;

SELECT dept_id AS `부서 아이디`, 
       SUM(salary) AS `급여 합계`, 
       FLOOR(AVG(salary)) AS `급여 평균`, 
       COUNT(*) AS `인원 수`
FROM employees
GROUP BY `부서 아이디`
ORDER BY `부서 아이디`;

-- 부서 ID가 4, 5 인 부서의 평균 급여 조회 WHERE IN()
-- SELECT dept_id, FLOOR(AVG(salary))
SELECT dept_id AS `부서 아이디`, FLOOR(AVG(salary)) AS `급여 평균`
FROM employees
WHERE dept_id IN(4,5)
GROUP BY `부서 아이디`;

-- employees 테이블에서 직급 별 2020년도 이후 입사자들의 급여 합 조회
-- position_id YEAR(hire_date) salary
-- SELECT FROM WHERE GROUP BY
SELECT position_id, SUM(salary) AS `급여 합`
FROM employees
WHERE YEAR(hire_date) >= 2020
GROUP BY position_id;

/*
GROUP BY 사용 시 주의사항
SELECT 문에 GROUP BY 절을 사용할 경우
SELECT 절에 명시한 조회하려는 컬럼 중
그룹 함수가 적용되지 않은 컬럼은
모두 다 GROUP BY 절에 작성해야 함
*/

-- employees 테이블에서 부서 별로 같은 직급인 사원의 급여 합계를 조회하고
-- 부서 ID 오름차순으로 정렬
SELECT position_id, SUM(salary) AS `급여 합`
FROM employees
GROUP BY position_id
ORDER BY dept_id;
/*
0	135	16:32:32	SELECT position_id, SUM(salary) AS `급여 합`
 FROM employees
 GROUP BY position_id
 ORDER BY dept_id
 LIMIT 0, 1000	Error Code: 1055. Expression #1 of ORDER BY clause is not in GROUP BY clause and contains nonaggregated column 'employee_management.employees.dept_id' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by	0.000 sec
 */
 
-- 1. employees 테이블에서 부서 별로 직급이 같은 직원의 수를 조회하고
-- 부서 ID, 직급 ID 오름차순으로 정렬
SELECT dept_id, position_id, COUNT(*)
FROM employees
GROUP BY dept_id, position_id
ORDER BY dept_id, position_id;
/*
GROUP BY dept_id, position_id
dept_id와 position_id의 조합을 기준으로 데이터를 묶는다.

예)
부서 10, 직위 1
부서 10, 직위 2
부서 20, 직위 1
등등...
각 조합마다 COUNT(*)로 몇 명의 직원이 존재하는지 계산하겠다.
ORDER BY dept_id, position_id
계산한 결과를 
부서 ID -> 직위 ID 순서로 오름차순 정렬
부서로 정렬된 뒤, 그 안에서 직위별로 정렬
*/
-- 2. 부서별 평균 급여를 조회하고
-- 부서를 조회하여 부서 ID 오름차순으로 정렬
SELECT dept_id, AVG(salary)
FROM employees
GROUP BY dept_id
ORDER BY dept_id;

/*********************************
WHERE 절 : 지정된 테이블에서 어떤 행만을 조회 결과로 삼을건지 조건을 지정하는 구문
		   ( 테이블 내에 특정 행만 뽑아서 쓰겠다는 조건문 )
           
HAVING 절 : 그룹 함수로 구해 올 그룹에 대한 조건을 설정할 때 사용
            ( 그룹에 대한 조건, 어떤 그룹만 조회하겠다 )
            
HAVING 컬럼명 | 함수식 비교 연산자 비교 값 
*********************************/

USE employee_management;
/*
SELECT * FROM departments;
-- 부서에서 budget 평균이 30000000 이상인
-- 부서를 조회하여 부서코드를 오름차순으로 정렬

SELECT dept_code, AVG(budget)
FROM departments
-- WHERE budget >= 30000000; -- budget(예산)이 30000000 이상인 부서만 조회하겠다.
GROUP BY dept_code
HAVING AVG(budget) >= 30000000; -- 그룹 budget(예산) 평균이 30000000 이상인 부서만 조회하겠다.
*/

SELECT * FROM employees;

-- 직원이 2명 이상인 부서 보기
SELECT dept_id, COUNT(*)
FROM employees
WHERE count(*) >= 2; 
-- Error Code: 1111. Invalid use of group function
-- 그룹 함수를 잘 못 사용했을 때 나타내는 문제

-- dept_id로 묶은 그룹에서 총 인원이 
-- 2명 이상인 부서 아이디만 조회
SELECT dept_id, COUNT(*)
FROM employees
GROUP BY dept_id
HAVING count(*) >= 2;

/*
WHERE : 개별 직원 조건
급여가 5천만원 이상인 직원 찾기
WHERE salary >= 50000000

HAVING : 부서나 그룹 조건
평균 급여가 5천만원 이상인 "부서" 찾기
HAVING AVG(salary) >= 50000000

SROUP BY HAVING = 
함수(COUNT, AVG, SUM, MIN, MAX 등) 특정 그룹의 숫자 데이터를 활용해서 조건별로 조회할 때 사용
*/

-- 평균 급여가 7천만원 이상인 부서 조회
-- dept_id, salary employees
SELECT dept_id, FLOOR(AVG(salary))
FROM employees
GROUP BY dept_id
HAVING AVG(salary) >= 70000000;

-- 급여 총 합이 1억 5천만원 이상인 부서 조회
SELECT dept_id, FLOOR(SUM(salary))FROM employees
GROUP BY dept_id
HAVING SUM(salary) >= 150000000;

-- WHERE dept_id
-- employees e departments d 연결
-- 평균 급여가 8천만원 이상인 부서의 이름 조회
SELECT d.dept_name, AVG(e.salary)
FROM employees e, departments d 
WHERE e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) >= 80000000;

/**********************************************************
수업용_SCRIPT_2를 활용하여 GROUP BY HAVING 실습하기
기본 문법 순서
SELECT 컬럼명, 집계함수()
FROM 테이블이름
WHERE 조건 -- 개별 행 하나씩에 대한 조건
GROUP BY 컬럼명 -- 그룹 만들기 (SELECT ORDER에서 집계함수로 작성되지 않은 컬럼명칭 모두 작성)
HAVING 집계조건 -- 조회할 그룹에 대한 조건
ORDER BY -- 정렬 기준

* 주의 할 점 : 
  숫자 값에 NULL이 존재한다면 WHERE로 NULL을 먼저 필터링 처리
  WHERE 컬럼이름 IS NOT NULL
  과 같이 NULL이 존재하지 않는 데이터들을 통해서 조회

-----------------------------------------------------

집계함수
COUNT(*) : 개수 세기
AVG() : 합에 대한 평균
MAX() : 최고로 높은 숫자
MIN() : 최고로 낮은 숫자

테이블 구조
store (가게 테이블)
번호, 가게명, 카테고리, 평점, 배달비
id, name, category, rating, delivery_fee

menus(메뉴 테이블)
메뉴번호, 가게번호, 메뉴명, 가격, 인기메뉴여부
id, store_id, name, price, is_popular
**********************************************************/
SELECT *
FROM stores;
-- stores 테이블에서
-- 각 카테고리 별로 가게가 몇 개 씩 존재하는지 확인하기
-- SELECT category AS 가게수
SELECT category, COUNT(*) AS 가게수
FROM stores
GROUP BY category
ORDER BY COUNT(*) DESC; -- COUNT(*) 내림차순 정렬

-- stores 테이블에서
-- 각 카테고리 별 평균 배달비 구하기
-- null 존재하는지 확인하고, null이 아닌 배달비만 조회
SELECT category, AVG(delivery_fee)
FROM stores
WHERE delivery_fee IS NOT NULL
GROUP BY category;

# 실습문제
-- FROM stores
-- 평점이 4.5 이상인 가게들만 골라서 카테고리별 개수 구하기
SELECT category, AVG(rating), COUNT(*)
FROM stores
WHERE rating >= 4.5 -- 치킨 카테고리에서 가게별로 4.5 이상인 가게들만 조회하기
GROUP BY category;

SELECT category, AVG(rating), COUNT(*)
FROM stores
GROUP BY category
HAVING AVG(rating) >= 4.5; -- 카테고리 별로 평점을 모은 후에 평점이 4.5 이상으로 그룹만 카테고리 조회 
-- 위 문제랑은 맞지 않음

/*
0	95	14:38:19	SELECT category, AVG(rating), COUNT(*),
FROM stores
GROUP BY category
HAVING AVG(rating) >= 4.5	Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'FROM stores
GROUP BY category
HAVING AVG(rating) >= 4.5' at line 2	0.000 sec
*/

-- 배달비가 null이 아닌 가게들만으로 카테고리별 평균 평점 구하기,
-- FUNCTION COUNT ROUND(AVG(rating), 2)
SELECT category, ROUND(AVG(rating), 2)
FROM stores
WHERE delivery_fee IS NOT NULL
GROUP BY category;

-- 가게가 3개 이상인 카테고리만 보기
-- 개수를 내림차순 정렬
SELECT category, COUNT(*)
FROM stores
GROUP BY category
HAVING COUNT(*) >= 3
ORDER BY COUNT(*) DESC;


-- 평균 배달비가 3000원 이상인 카테고리 구하기
SELECT category, AVG(delivery_fee)
FROM stores
WHERE delivery_fee IS NOT NULL
GROUP BY category
HAVING AVG(delivery_fee) <= 3000
ORDER BY AVG(delivery_fee);

-- 가게별로 메뉴가 몇 개씩 존재하는지 조회
-- 가게명, 카테고리 메뉴 개수 조회
SELECT s.name, s.category, COUNT(*) AS 메뉴개수
FROM stores s, menus m
WHERE s.id = m.store_id
GROUP BY s.name, s.category;

SELECT s.name, s.category, COUNT(*) AS 메뉴개수
FROM stores s, menus m
WHERE s.id = m.store_id
GROUP BY s.id;

SELECT * FROM stores;

SELECT menus.id, menus.store_id, menus.name, menus.description, menus.price, menus.is_popular
FROM menus, stores
WHERE menus.store_id = stores.id;

SELECT category, COUNT(*)
FROM menus, stores
WHERE menus.store_id = stores.id
GROUP BY category;
