USE delivery_app;
/*
LIBRARY_MEMBER 테이블을 생성하세요.

컬럼 정보:
- MEMBER_NO: 회원번호 (숫자, 기본키)
- MEMBER_NAME: 회원이름 (최대 20자, 필수입력)
- EMAIL: 이메일 (최대 50자, 중복불가) -- UNIQUE : 중복 불가
- PHONE: 전화번호 (최대 15자)
- AGE: 나이 (숫자, 7세 이상 100세 이하만 가능)
- JOIN_DATE: 가입일 (날짜시간, 기본값은 현재시간)

제약조건명 규칙:
- PK: PK_테이블명_컬럼명
- UK: UK_테이블명_컬럼명  
- CK: CK_테이블명_컬럼명
*/
/*
member_no INT PRIMARY KEY, -- CONSTRAINT PK_LIBRARY_MEMBER_MEMBER_NO와 같은 제약 조건 명칭 자동 생성되고 관리
member_name VARCHAR(20) NOT NULL,
email VARCHAR(50) CONSTRAINT UK_LIBRARY_MEMBER_MEMBER_EMAIL UNIQUE,
phone VARCHAR(15),
age INT CONSTRAINT CK_LIBRARY_AGE CHECK(age >= 7 AND age <= 100),
join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
*/

CREATE TABLE library_member(
-- 다른 SQL에서는 컬럼 레벨로 제약조건을 작성할 때 CONSTRAINT를 이용해서
-- 제약조건의 명칭을 설정할 수 있지만
-- MySQL은 제약조건 명칭을 MySQL 자체에서 자동 생성 해주기 때문에 명칭 작성을 컬럼레벨에서 할 수 없음
-- 컬럼명칭  자료형(자료형크기)  제약조건        제약조건명칭             제약조건들설정
-- member_no       INT          CONSTRAINT   PK_LIBRARY_MEMBER_MEMBER_NO    PRIMARY KEY
member_no INT PRIMARY KEY, -- CONSTRAINT PK_LIBRARY_MEMBER_MEMBER_NO와 같은 명칭 자동 생성됨
member_name VARCHAR(20) NOT NULL,
email VARCHAR(5) UNIQUE, -- CONSTRAINT UK_LIBRARY_MEMBER_MEMBER_EMAIL와 같은 제약 조건 명칭 자동 생성되고 관리
phone VARCHAR(15),
age INT CONSTRAINT CK_LIBRARY_AGE CHECK(age >= 7 AND age <= 100),
join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
/*
member_no와 email에는 제약 조건 명칭 설정이 안되지만
단순히 PK, UNIQUE, FK, NOT NULL 과 같이 한 단어로 키 형태를 작성하는 경우 제약 조건 명칭이 설정 불가능하지만
age에서는 제약 조건 명칭이 설정되는 이유
CHECK처럼 제약 조건이 상세할 경우에는 제약 조건 명칭 설정 가능
CHECK만 개발자가 지정한 제약 조건 명칭 설정 가능
*/
-- 우리 회사는 이메일을 최대 20글자 작성으로 설정 -> 21글자 유저가 회원가입이 안된다!! 연락
INSERT INTO library_member (member_no, member_name, email, phone, age)
VALUES (1, '김독서', 'kim@email.com', '010-1234-5678', '25');

-- Error Code library_member: 1406. Date too long for column 'EMAIL' at row 1 0.016 sec
-- 컬럼에서 넣을 수 있는 크기에 비해 데이터 양이 많을 때 발생하는 문제

-- 방법 1번 : DROP 해서 테이블 새로 생성한다. -> 기존 데이터는 ...? 회사 폐업 엔딩..

-- 방법 2번 : EMAIL 컬럼의 크기 변경 ALTER 수정 사용
-- 1. EMAIL 컬럼을 5자에서 50자로 변경
ALTER TABLE library_member
MODIFY email VARCHAR(50) UNIQUE;
-- ALTER로 컬럼 속성을 변경할 경우 컬럼명칭에 해당하는 정보를 하나 더 만들어 놓은 후 해당하는 제약 조건 동작
-- ALTER에서 자세한 설명 진행...

/*
ALTER로 컬럼에 해당하는 조건을 수정할 경우
Indexs 에 컬럼명_1 컬럼명_2 컬럼명_3 ... 과 같은 형식으로 추가가 됨

Indexes
email
email_2와 같은 형태로 존재

email의 경우 제약조건 VARCHAR(5) UNIQUE,
email_2의 경우 제약조건 VARCHAR(50) UNIQUE,

컬럼이름  인덱스들
email     email, email_2 중에서 가장 최근에 생성된 명칭으로 연결
		  하지만 새로 생성된 조건들이 마음에 들지 않아 되돌리고 싶은 경우에는
          email과 같이 기존에 생성한 조건을 인덱스 명칭을 통해 되돌아 설정할 수 있음
          인덱스 = 제약조건명칭 동일

*/

SELECT * FROM library_member;

-- 제약조건 위반 테스트 (에러가 발생해야 정상)
INSERT INTO LIBRARY_MEMBER VALUES (1, '박중복', 'park@email.com', '010-9999-8888', 30, DEFAULT); -- PK 중복
-- Error Code: 1062. Duplicate entry '1' for key 'library_member.PRIMARY'	0.000 sec
INSERT INTO LIBRARY_MEMBER VALUES (6, '이나이', 'lee@email.com', '010-7777-6666', 5, DEFAULT); -- 나이 제한 위반
-- Error Code: 3819. Check constraint 'CK_LIBRARY_AGE' is violated.	0.000 sec

INSERT INTO LIBRARY_MEMBER VALUES (2, '박중복', 'park@email.com', '010-9999-8888', 30, DEFAULT); -- member_no 자동 입력이 아니어서.. 직접 입력해줘야함

/*
온라인 쇼핑몰의 PRODUCT(상품) 테이블과 ORDER_ITEM(주문상품) 테이블을 생성하세요.

1) PRODUCT 테이블:
- PRODUCT_ID: 상품코드 (문자 10자, 기본키)
- PRODUCT_NAME: 상품명 (문자 100자, 필수입력)
- PRICE: 가격 (숫자, 0보다 큰 값만 가능)
- STOCK: 재고수량 (숫자, 0 이상만 가능, 기본값 0)
- STATUS: 판매상태 ('판매중', '품절', '단종' 중 하나만 가능, 기본값 '판매중')

2) ORDER_ITEM 테이블:
- ORDER_NO: 주문번호 (문자 20자)  
- PRODUCT_ID: 상품코드 (문자 10자)
- QUANTITY: 주문수량 (숫자, 1 이상만 가능)
- ORDER_DATE: 주문일시 (날짜시간, 기본값은 현재시간)

주의사항:
- ORDER_ITEM의 PRODUCT_ID는 PRODUCT 테이블의 PRODUCT_ID를 참조해야 함
- ORDER_ITEM은 (주문번호 + 상품코드) 조합으로 기본키 설정 (복합키)

키명칭
-- CONSTRAINT CK_PRODUCT_PRICE
-- CONSTRAINT CK_PRODUCT_STOCK

STATUS VARCHAR(20) DEFAULT '판매중' CONSTRAINT CK_PRODUCT_STATUS CHECK(STATUS IN ('판매중', '품절', '단종'))
-- CONSTRAINT CK_ORDER_ITEM_QUANTITY
*/
CREATE TABLE product (
product_id VARCHAR(10) PRIMARY KEY, -- AUTO_INCREMENT 정수만 가능 VARCHAR에는 사용 불가
product_name VARCHAR(100) NOT NULL,
price INT CONSTRAINT CH_PRODUCT_PRICE CHECK(price > 0),
stock INT DEFAULT 0 CHECK(stock >= 0), -- CONSTRAINT 제약 조건 명칭은 필수가 아님, 작성 안 했을 경우 자동 완성되어짐
status VARCHAR(20) DEFAULT '판매중' CHECK(STATUS IN ('판매중', '품절', '단종'))
);

CREATE TABLE order_item (
order_no VARCHAR(20),
product_id VARCHAR(10), -- PRODUCT 테이블의 PRODUCT_ID를 참조
quantity INT CHECK(quantity >= 1),
order_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO PRODUCT VALUES ('P001', '노트북', 1200000, 10, '판매중');
INSERT INTO PRODUCT VALUES ('P002', '마우스', 25000, 50, '판매중');
INSERT INTO PRODUCT VALUES ('P003', '키보드', 80000, 0, '품절');

INSERT INTO ORDER_ITEM VALUES ('ORD001', 'P001', 2, DEFAULT);
INSERT INTO ORDER_ITEM VALUES ('ORD001', 'P002', 1, DEFAULT);
INSERT INTO ORDER_ITEM VALUES ('ORD002', 'P002', 3, '2024-03-06 14:30:00');

-- CREATE TABLE 할 때 FK(FOREIGN KEY)를 작성하지 않아
-- 존재하지 않는 제품 번호의 주문이 들어오는 문제가 발생
-- 제품이 존재하고, 제품번호에 따른 주문
INSERT INTO PRODUCT VALUES ('ORD003', 'P999', 1, DEFAULT);

-- 테이블 다시 생성
-- 테이블이 존재하는게 맞다면 삭제하겠어
-- 외래키가 설정되어있을 경우 메인 테이블은 
-- 메인을 기준으로 연결된 데이터가 자식 테이블에 존재할 경우
-- 자식 테이블을 삭제한 후 메인 테이블을 삭제할 수 있다.
-- -> order_item 삭제한 후 product 테이블을 삭제할 수 있다.
-- 배달의 민족 - 가게 - 상품 - 주문
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS order_item;

-- 메인이 되는 테이블 생성
CREATE TABLE product (
product_id VARCHAR(10) PRIMARY KEY,
product_name VARCHAR(100) NOT NULL,
price INT CONSTRAINT CH_PRODUCT_PRICE CHECK(price > 0), 
stock INT DEFAULT 0 CHECK(stock >= 0), 
status VARCHAR(20) DEFAULT '판매중' CONSTRAINT CK_PRODUCT_STATUS CHECK(STATUS IN ('판매중', '품절', '단종'))
);

-- order_item에서
-- CONSTRAINT ABC FOREIGN KEY (product_id) REFERENCES product(product_id) 테이블 레벨로 존재하는 외래키를 
-- 위 내용 참조하여 컬럼 레벨로 설정해서 order_item 테이블 생성
-- 상품이 있어야 주문가능
-- MySQL에서 FOREIGN KEY 또한 테이블 컬럼 형태로 작성 필요
CREATE TABLE order_item (
order_no VARCHAR(20),
product_id VARCHAR(10) CONSTRAINT abc FOREIGN KEY REFERENCES product(product_id),
quantity INT CHECK(quantity >= 1),
order_date DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- 잘못된 케이스

CREATE TABLE order_item (
order_no VARCHAR(20),
quantity INT CHECK(quantity >= 1),
order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT 제약조건명칭 FOREIGN KEY(product_id) REFERENCES product(product_id),
);
-- 잘 된 케이스

/*
-- order_item 테이블 안에서 product_id 컬럼은 product 테이블 내에 존재하는 컬럼 중 product_id 컬럼명칭과 연결할 것이다.
-- 단순 참조용
-- product_id VARCHAR(10) REFERENCES product(product_id), -- CONSTRAINT 제약조건 명칭 자동 생성
-- 외래키를 작성할 때에는 반드시 FOREIGN KEY라는 명칭이 컬럼 레벨이나 테이블 레벨에 필수로 무조건 들어가야 함

-- 외래키의 경우에는 보통 테이블 레벨 형태로 작성
-- ORDER_ITEM 테이블 내에 존재하는 product_id 는 product 테이블에 produxt_id를 참조할 것이다.
-- 라는 조건의 내용을 ABC라는 명칭 내에 저장하겠다 설정
*/
-- CONSTRAINT ABC FOREIGN KEY (product_id) REFERENCES product(product_id), -- CONSTRAINT 제약조건 명칭 자동 생성

-- 컬럼레벨 - 한 줄 완성

-- 테이블레벨
-- 위에서 작성한 컬럼명칭에 대한 제약조건을 아래에서 다시 세부작성

INSERT INTO PRODUCT VALUES ('P001', '노트북', 1200000, 10, '판매중');
INSERT INTO PRODUCT VALUES ('P002', '마우스', 25000, 50, '판매중');
INSERT INTO PRODUCT VALUES ('P003', '키보드', 80000, 0, '품절');

INSERT INTO ORDER_ITEM VALUES ('ORD001', 'P001', 2, DEFAULT);
INSERT INTO ORDER_ITEM VALUES ('ORD001', 'P002', 1, DEFAULT);
INSERT INTO ORDER_ITEM VALUES ('ORD002', 'P002', 3, '2024-03-06 14:30:00');

-- CREATE TABLE 할 때 FK(FOREIGN KEY)를 작성하지 않아
-- 존재하지 않는 제품 번호의 주문이 들어오는 문제가 발생
-- 제품이 존재하고, 제품번호에 따른 주문

INSERT INTO PRODUCT VALUES ('ORD003', 'P999', 1, DEFAULT);

-- product 테이블에 존재하지 않은 상품 번호로 주문이 들어와 외래키 조건에 위배되는 현상 발생 으로 주문 받지 않음
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`delivery_app`.`order_item`, CONSTRAINT `ABC` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`))	0.016 sec

/*
대학교 성적 관리를 위한 테이블들을 생성하세요.

1) STUDENT 테이블:
- STUDENT_ID: 학번 (문자 10자, 기본키)
- STUDENT_NAME: 학생이름 (문자 30자, 필수입력)
- MAJOR: 전공 (문자 50자)
- YEAR: 학년 (숫자, 1~4학년만 가능)
- EMAIL: 이메일 (문자 100자, 중복불가)

2) SUBJECT 테이블:
- SUBJECT_ID: 과목코드 (문자 10자, 기본키)
- SUBJECT_NAME: 과목명 (문자 100자, 필수입력)
- CREDIT: 학점 (숫자, 1~4학점만 가능)

3) SCORE 테이블:
- STUDENT_ID: 학번 (문자 10자)
- SUBJECT_ID: 과목코드 (문자 10자)  
- SCORE: 점수 (숫자, 0~100점만 가능)
- SEMESTER: 학기 (문자 10자, 필수입력)
- SCORE_DATE: 성적입력일 (날짜시간, 기본값은 현재시간)

주의사항:
- SCORE 테이블의 STUDENT_ID는 STUDENT 테이블 참조
- SCORE 테이블의 SUBJECT_ID는 SUBJECT 테이블 참조  
- SCORE 테이블은 (학번 + 과목코드 + 학기) 조합으로 기본키 설정
- 같은 학생이 같은 과목을 같은 학기에 중복으로 수강할 수 없음
*/
-- YEAR 과 같이 SQL에서 사용하는 예약어를 SQL에서는 컬럼명칭으로 사용 가능하나 
-- 예약어는 되도록이면 컬럼명칭 사용 지양
CREATE TABLE student (
	student_id VARCHAR(10) PRIMARY KEY,
    student_name VARCHAR(30) NOT NULL,
    major VARCHAR(50),
    year INT CHECK(year >= 1 AND year <= 4), -- CHECK 내에 존재하는 YEAR는 예약어에 해당하는 YEAR 년도 제한이 아니고 "컬럼명 YEAR 값 제한"
    email VARCHAR(100) UNIQUE
);

CREATE TABLE subject (
	subject_id VARCHAR(10) PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    credit INT CHECK(credit >= 1 AND credit <= 4)
);
-- 여기까지는 조건만

-- - SCORE 테이블은 (학번 + 과목코드 + 학기) 조합으로 기본키 설정
-- - 같은 학생이 같은 과목을 같은 학기에 중복으로 수강할 수 없음
CREATE TABLE score (
	student_id VARCHAR(10) PRIMARY KEY, -- student 테이블 참고
    subject_id VARCHAR(10), -- subject 테이블 참고
    score INT CHECK(score >= 0 AND score <= 100),
    semester VARCHAR(10) NOT NULL,
    score_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 외래키 : 컬럼 레벨에 쓸 수 없고 테이블 밑에 씀 
    -- 기본 문법
    -- 제약조건시작 제약조건명칭 외래키(재약조건을 걸 현재 테이블의 컬럼명칭) 참조하다 메인테이블(내에 존재하는 컬럼명칭)
    -- CONSTRAINT 명칭 FOREIGN KEY(컬럼명칭) REFERENCES 다른테이블명칭(다른테이블내에존재하는컬럼명칭)
    
    -- student 테이블과 subject은 score 테이블과 score 테이블 내 데이터가 사라지기 전까지
    -- 연결되어 있는 student 테이블과 subject 테이블은 삭제할 수 없다.
    CONSTRAINT FK_SCORE_STUDENT_ID FOREIGN KEY(student_id) REFERENCES student(student_id),
    CONSTRAINT FK_SCORE_SUBJECT_ID FOREIGN KEY(subject_id) REFERENCES subject(subject_id)
);

-- Error Code : 3813. Colum check constraint 'score_chk_1' references other column. 0.016 sec
-- score INT CHECK(credit >= 0 AND credit <= 100), --> score 컬럼명 제약조건에서 관련없는 credit 명칭을 작성했기 때문
-- score INT CHECK(score >= 0 AND score <= 100), --> 같이 수정하면 에러 문제 해결


INSERT INTO STUDENT VALUES ('2024001', '김대학', '컴퓨터공학과', 2, 'kim2024@univ.ac.kr');
INSERT INTO STUDENT VALUES ('2024002', '이공부', '경영학과', 1, 'lee2024@univ.ac.kr');

INSERT INTO SUBJECT VALUES ('CS101', '프로그래밍기초', 3);
INSERT INTO SUBJECT VALUES ('BM201', '경영학원론', 3);
INSERT INTO SUBJECT VALUES ('EN101', '대학영어', 2);

INSERT INTO SCORE VALUES ('2024001', 'CS101', 95, '2024-1학기', DEFAULT);
INSERT INTO SCORE VALUES ('2024001', 'EN101', 88, '2024-1학기', DEFAULT);
-- Error Code: 1062. Duplicate entry '2024001' for key 'score.PRIMARY'	0.000 sec 에러로 데이터 삽입 불가
INSERT INTO SCORE VALUES ('2024002', 'BM201', 92, '2024-1학기', DEFAULT);

-- 제약조건 위반 테스트
INSERT INTO STUDENT VALUES ('2024003', '박중복', '수학과', 2, 'kim2024@univ.ac.kr'); -- Error 1062 : 이메일 중복
-- Error Code: 1062. Duplicate entry 'kim2024@univ.ac.kr' for key 'student.email'	0.031 sec
INSERT INTO SCORE VALUES ('2024001', 'CS101', 150, '2024-1학기', DEFAULT); -- Error 3819 : score 제약조건 0 ~ 100 점수인데 150점이 들어가려 했기 때문에
-- Error Code: 3819. Check constraint 'score_chk_1' is violated.	0.000 sec
INSERT INTO SCORE VALUES ('2024001', 'CS101', 90, '2024-1학기', DEFAULT); -- 프라이머리 키 중복 에러
-- Error Code: 1062. Duplicate entry '2024001' for key 'score.PRIMARY'	0.000 sec

-- student 테이블에서 이메일에 해당하는 컬럼을 중복 불가하도록 설정 
-- 빈칸 허용 금지
-- 자료형 100까지 제한

-- ALTER MODIFY
-- ALTER TABLE library_member
-- MODIFY email VARCHAR(50) UNIQUE;
ALTER TABLE student
MODIFY email VARCHAR(100) NOT NULL UNIQUE;

-- 에러 상황 email VARCHAR(100) NOT NULL -> email VARCHAR(100) NOT NULL UNIQUE 로 바꾸고자 하는 경우
-- 중복된 데이터가 존재하는 상황에서 UNIQUE를 사용할 경우 중복되는 데이터가 존재하기 때문에 컬럼 제약 조건을 수정할 수 없다 거부
-- 기존 데이터가 제약 조건에 부합하지 않을 경우 발생

-- 데이터를 수정한 다음에 제약조건을 다시 설정

-- 중복된 데이터 SELECT 확인
SELECT email, count(*)
FROM student
WHERE email IS NOT NULL
GROUP BY email
HAVING count(*) > 1;

-- 중복된 이메일에서 둘 중 한 명의 이메일을 수정하거나

-- 모두 삭제

-- 데이터가 키 형태가 아닐 경우에는 안전모드 해지 후 가능
SET SQL_SAFE_UPDATES = 0;
-- Error Code : 1175. You are usin g safe update mode and you tried to update a table without a WHERE thqt uses a KEY column.
DELETE FROM student
WHERE email = 'kim2024@univ.ac.kr';
-- Error Code : 1451. Cannot delete or update a parent row : a foreign key constraint fails (`delivery_app`.
-- 특정학생을 삭제하려 했지만 score 테이블에 외래키를 참조하고 있어 함부로 삭제할 수 없다.

-- 두가지 방법
-- 1. 삭제하고자하는 데이터의 하위 데이터에 존재하는 데이터 먼저 삭제 후
-- 부모 데이터 삭제

-- 2. 외래키 제약 조건을 잠시 종료하고 삭제 (추천하지 않음)
-- 데이터 무결성 조건을 해지할 수 있으므로 실제 DB 서비스에서는 사용 금지
SET FOREIGN_KEY_CHECKS = 0;

-- 3. ON DELETE CASCADE
-- 부모 테이블에 존재하는 데이터 삭제 시 자식 테이블 또한 자동적으로 삭제될 수 있도록 설정 조건
-- 예) 배달어플 - 가나다카페 - 가나다카페메뉴
-- 가나다카페 폐업, 카페 메뉴까지 모두 없애야하는 상황 
-- ON DELETE CASCADE 가 만약에 걸려있다면 가나다카페 폐업과 동시에 메뉴까지 모두 삭제하는 설정

