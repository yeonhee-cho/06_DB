-- 1. 데이터베이스 생성 및 사용
-- 힌트: CREATE DATABASE, USE
CREATE DATABASE _________;
USE _________;

-- 2. BOOK 테이블 생성
-- 힌트: BOOK_ID(PK), TITLE(필수), AUTHOR, PRICE(1원이상), STOCK(기본값0, 0이상)
CREATE TABLE BOOK(
    BOOK_ID   VARCHAR(10) PRIMARY KEY ,
    _________ VARCHAR(100) _________,
    _________ VARCHAR(50),
    _________ INT _________,
    _________ INT _________ _________
);

-- 3. 데이터 삽입 (3권의 책)
-- 힌트: B001, B002, B003
INSERT INTO BOOK VALUES (B001, 'TITLE1', 'AUTHOR1', 1, 0);
INSERT INTO BOOK VALUES (_________, _________, _________, _________, _________);
INSERT INTO BOOK VALUES (_________, _________, _________, _________, _________);

-- 4. 컬럼 추가
-- 힌트: ALTER TABLE ADD, CATEGORY 컬럼 추가
ALTER TABLE BOOK ADD _________ VARCHAR(30) DEFAULT _________;

-- 5. 데이터 수정
-- 힌트: UPDATE SET WHERE
UPDATE BOOK SET _________ = 'IT도서' WHERE _________ = 'B001';

-- 6. CUSTOMER 테이블 생성
-- 힌트: CUSTOMER_ID(PK), NAME(필수), EMAIL(중복불가)
CREATE TABLE CUSTOMER(
    _________ VARCHAR(10) _________,
    _________ VARCHAR(20) _________,
    _________ VARCHAR(50) _________
);

-- 7. ORDER_DETAIL 테이블 생성 (외래키 포함)
-- 힌트: 복합키, 외래키 2개
CREATE TABLE ORDER_DETAIL(
    _________ VARCHAR(20),
    _________ VARCHAR(10),
    _________ VARCHAR(10),
    _________ INT,
    
    _________ _________(_________, _________),
    _________ _________ _________ _________(_________, _________)
);

-- 8. SELECT
-- 전체 조회
_________ * _________ BOOK;

-- 조건 조회 (가격 25000원 이상)
SELECT * FROM BOOK _________ _________ >= 25000;

-- 특정 컬럼만 조회 (제목, 가격)
SELECT _________, _________ FROM BOOK;

-- 9. 집계 함수
-- 최대 가격
SELECT _________(_________) FROM BOOK;

-- 평균 가격  
SELECT _________(_________) FROM BOOK;

-- 총 도서 수
SELECT _________(*) FROM BOOK;

-- 10. 
INSERT INTO CUSTOMER VALUES ('C001', '김고객', 'kim@email.com');
INSERT INTO ORDER_DETAIL VALUES ('O001', 'C001', 'B001', 2);

-- 11. 데이터 삭제가 안되는 문제 해결
DELETE FROM BOOK WHERE BOOK_ID = 'B001';

_________ FROM ORDER_DETAIL WHERE BOOK_ID = 'B001';
_________ FROM BOOK WHERE BOOK_ID = 'B001';

-- 12. 외래키 옵션 설정 후 삭제 진행
DROP TABLE ORDER_DETAIL;

CREATE TABLE ORDER_DETAIL(
    ORDER_ID VARCHAR(20) PRIMARY KEY,
    CUSTOMER_ID VARCHAR(10),
    BOOK_ID VARCHAR(10),
    QUANTITY INT,
    
    CONSTRAINT FK_ORDER_CUSTOMER 
    FOREIGN KEY(CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID) _________ _________,
    
    CONSTRAINT FK_ORDER_BOOK 
    FOREIGN KEY(BOOK_ID) REFERENCES BOOK(BOOK_ID) _________ _________
);

-- 14. CASCADE 정상 작동확인
-- 데이터 다시 입력
INSERT INTO ORDER_DETAIL VALUES ('O002', 'C001', 'B002', 1);

-- 테스트
DELETE FROM BOOK WHERE BOOK_ID = 'B002';

SELECT * FROM ORDER_DETAIL;

-- 15. 제약조건 위반
INSERT INTO ORDER_DETAIL VALUES ('O003', 'C999', 'B001', 1);