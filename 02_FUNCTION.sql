/*
함수 : 컬럼값 | 지정된 값을 읽어 연산한 결과를 변환하는 것
단일행 함수 : N개의 행의 컬럼 값을 전달하여 N개의 결과가 반환
그룹 함수 : N개의 행의 컬럼 값을 전달하여 1개의 결과가 반환
            (그룹의 수가 늘어나면 그룹의 수 만큼 결과를 반환)
수는 SELECT절, WHERE절, ORDER BY절, HAVING절에서 사용 가능
*/

-- 단일행 함수
-- 문자열 관련 함수

-- LENGTH(문자열|컬럼명) : 문자열의 길이 반환
SELECT 'HELLO WORLD', length('HELLO WORLD');

-- employees 테이블에서
-- 이메일 길이가 12 이하인 사원 조회
-- 이메일 길이는 오름차순 정렬
SELECT full_name, email, length(email) AS '이메일의 총 길이'
FROM employees
WHERE length(email) <= 12
ORDER BY length(email); -- NULL

-- LOCATE(찾을문자열, 문자열 [, 시작위치])
-- ORACLE에서는 INSTR() 함수
-- 찾을 문자열의 위치를 반환(1부터 시작해서 못찾으면 0 출력)

-- B의 위치 검색 5번째 위치부터 시작해서 검색
SELECT 'AABAACAABBAA' , LOCATE('B', 'AABAACAABBAA', 5); 


-- B의 위치 검색 1부터 시작해서 B가 존재하는 위치를 조회할 수 있다.
SELECT 'AABAACAABBAA' , LOCATE('B', 'AABAACAABBAA');

-- '@' 문자의 위치 찾기 
-- employees 테이블 email에서
-- @ 위치를 찾아서 조회
SELECT email, LOCATE('@', email)
FROM employees;

-- SUBSTRING(문자열, 시작위치 [, 길이])
-- ORACLE 에서는 SUBSTR() 함수
-- 문자열을 시작 위치부터 지정된 길이만큼 잘라내서 반환

-- 시작위치, 자를 길이 지정
SELECT SUBSTRING('ABCDEFG', 2, 3);

-- 시작위치, 자를 길이 미지정
SELECT SUBSTRING('ABCDEFG', 4);

-- employees 테이블
-- 사원명(EMP_NAME), 이메일에서 아이디(@앞까지의 문자열)을
-- 이메일 아이디라는 별칭으로 오름차순 조회
SELECT full_name AS `사원명(EMP_NAME)`, SUBSTRING(email, 1) AS `이메일 아이디`
FROM employees
ORDER BY `이메일 아이디` ASC;

-- SELECT full_name AS `사원명(EMP_NAME)`, SUBSTRING(email, LOCATE(email, '@')) AS `이메일 아이디`
-- SELECT full_name AS `사원명(EMP_NAME)`, SUBSTRING(email, LOCATE('@', email)) AS `이메일 아이디`
-- SUBSTRING(email, LOCATE('@', email)) : 자르기 시작할 위치를 @ 로 설정 -> 이메일의 도메인만 확인 가능한 상태

SELECT full_name AS `사원명(EMP_NAME)`, SUBSTRING(email, 1, LOCATE('@', email)-1) AS `이메일 아이디`
FROM employees
ORDER BY `이메일 아이디`;

SELECT full_name AS `사원명(EMP_NAME)`, 
SUBSTRING(email, 1, LOCATE('@', email)-1) AS `이메일 아이디`,
SUBSTRING(email, LOCATE('@', email)) AS `이메일 도메인`
FROM employees
ORDER BY `이메일 아이디`;

SELECT * FROM departments;

-- REPLACE(문자열, 찾을문자열, 바꿀문자열)
-- 문자열에서 변경할 문자열을 변경 후 반환
-- departments 테이블에서 부-> 팀으로 변경
SELECT dept_name AS "기존 부서 명칭", REPLACE(dept_name, '부', '팀') AS "변경된 부서 명칭"
FROM departments;

-- 숫자 관련 함수

-- MOD(숫자 | 컬럼명, 나눌 값) : 나머지
SELECT MOD(105,100);

-- ABS(숫자 | 컬럼명) : 절대값 -를 양수로 변경
SELECT ABS(10), ABS(-10);

-- CEIL(숫자 | 컬럼명) : 올림;
-- FLOOR(숫자 | 컬럼명) : 내림;
SELECT CEIL(1.1), FLOOR(1.1);

-- ROUND(숫자 | 컬럼명 [, 소수점위치]) : 반올림
-- 소수점 위치 지정 X : 소수점 첫째 자리에서 반올림해서 정수 표현
-- 소수점 위치 지정 O 
-- 1) 양수 : 지정된 위치의 소수점 자리까지 표현
-- 2) 음수 : 지정된 위치의 정수 자리까지 표현

SELECT 123.456,
ROUND(123.456), -- 123
ROUND(123.456, 1), -- 123.5
ROUND(123.456, 2), -- 123.46
ROUND(123.456, -1), -- 120
ROUND(123.456, -2); -- 100

/***************************
N개의 행의 컬럼 값을 전달하여 1개의 결과가 반환
그룹의 수가 늘어나면 그룹의 수만큼 결과를 반환

SUM(숫자가 기록된 컬럼명) : 그룹의 합계를 반환

AVG(숫자만 기록된 컬럼명) : 그룹의 평균

MAX(컬럼명) : 최대값
MIN(컬럼명) : 최소값

날짜 대소 비교 : 과거 < 미래
문자열 대소 비교 : 유니코드 순서(문자열 순서 A < Z)

COUNT(* | [DISTINCT] 컬럼명) : 조회된 행의 개수를 반환
COUNT(*) : 조회된 모든 행의 개수를 반환

COUNT(컬럼명) : 지정된 컬럼 값이 NULL이 아닌 행의 개수를 반환

COUNT(DISTINCT 컬럼명) : 지정된 컬럼에서 중복 값을 제외한 행의 개수를 반환
			(NULL인 행 미포함)
***************************/

-- 모든 사원의 급여 합
SELECT SUM(salary)
FROM employees;

-- 모든 활성 사원의 급여 합
-- salary employment_status = 'Active'
SELECT SUM(salary), employment_status
FROM employees
WHERE employment_status = 'Active';

-- 2020년 이후(2020년 포함) 입사자들의 급여 합 조회
-- WHERE YEAR(hire_date) >= 2020
SELECT SUM(salary)
FROM employees
WHERE YEAR(hire_date) >=  '2020';

-- 모든 사원의 평균 급여 조회
SELECT AVG(salary)
FROM employees;

-- 모든 활성 사원의 급여 평균 조회(소수점 내림 처리)
-- salary employment_status = 'Active'
SELECT floor(AVG(salary))
FROM employees
WHERE employment_status = 'Active';


-- AS 급여 합계 AS 평균 급여를 이용해서 합계와 평균을 모두 조회
SELECT SUM(salary) AS `급여 합계`, AVG(salary) AS `평균 급여`
FROM employees;

-- 모든 사원 중 가장 빠른 입사일, 최근 입사일
-- 이름 오름차순에서 제일 먼저 작성되는 이름
-- 마지막에 작성되는 이름
SELECT MIN(hire_date) AS `최초 입사일`,
	   MAX(hire_date) AS `최근 입사일`,
	   MIN(full_name) AS `가나다 순 첫번째`,
	   MAX(full_name) AS `가나다 순 마지막`
FROM employees
WHERE employment_status = 'Active';

-- COUNT 사용하기
-- employees 테이블에서 전체 활성 사원 수
SELECT COUNT(*)
FROM employees
WHERE employment_status = 'Active';

-- employees 테이블에서 부서 코드가 DEV인 사원의 수
-- JOIN ON
-- WHERE AND
SELECT COUNT(*)
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE dept_code = 'DEV';

-- 전화번호가 있는 사원 수 COUNT(*)
SELECT COUNT(*)
FROM employees
WHERE phone IS NOT NULL;

-- 전화번호가 있는 사원 수
-- NULL 이 아닌 행의 수만 카운트
SELECT COUNT(phone)
FROM employees;

-- 테이블에 존재하는 부서코드의 수를 조회 
-- dept_code 중복없이 조회
SELECT COUNT(DISTINCT d.dept_code)
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

-- WHERE 절로 변경해서 조회하기
-- employees 테이블에서 부서 코드가 DEV인 사원의 수
SELECT COUNT(*)
FROM employees e, departments d
WHERE e.dept_id = d.dept_id
AND dept_code = 'DEV';

-- 테이블에 존재하는 부서코드의 수를 조회 
-- dept_code 중복없이 조회
SELECT COUNT(DISTINCT d.dept_code)
FROM employees e, departments d
WHERE e.dept_id = d.dept_id;

-- employees 테이블에 존재하는 남자 사원의 수
SELECT COUNT(*)
FROM employees
WHERE gender = 'M';