-- ================================================
-- TCL(Transaction Control Language)
-- 트랜젝션 제어 언어
-- Transaction : 업무, 처리
-- 				 데이터베이스의 논리적 연산 단위
-- Oracle은 기본적으로 Auto Commit이 비활성화되어있어 COMMIT을 명시적으로 실행해야 변경 사항이 영구 저장
-- MySQL은 기본적으로 Auto Commit이 비활성화되어있어 각 DML 구문이 실행될 때마다 자동으로 커밋된다.
-- 		   자동저장이 아닌 개발자가 제어하는 저장을 하고 싶다면
-- START TRANSACTION; 또는 SET autocommit = 0;을 먼저 실행해준다.
-- 자동저장 끄기
/*
COMMIT : 메모리 버퍼(트랜젝션)에 임시 저장된 데이터 변경 사항을 DB에 반영
		 메모장이나, 포토샵에서 이미지나 글자를 저장하기 전 단계
         COMMIT은 메모장아나, 포토샵에 작성한 이미지나 글자 데이터를 DB에 저장하는 역할

ROLLBACK : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 삭제하고 마지막 COMMIT 상태로 돌아감
		   기존에 작업한 데이터를 지우고 마지막에 저장한 상태로 되돌아가기
           
SAVEPOINT : 트랜잭션 내에 저장 지점을 정의하며, ROLLBACK 수행 시 전체 작업을 삭제하는 것이 아닌
			지정한 SAVEPOINT까지만 일부 되돌아가기(임시저장상태로 돌아가기)
            SAVEPOINT 포인트이름1;
            ...
            SAVEPOINT 포인트이름2;
            ...
            SAVEPOINT 포인트이름3;
            
            ROLLBACK TO SAVEPOINT 포인트이름2; -- 포인트2 지점까지 데이터 변경사항 삭제
            포인트이름3에 저장된 내역 또한 사라짐
            
사용예시
계좌이체
	1번 A의 계좌에서 5만원을 차감한다.(UPDATE)
    2번 B의 계좌에서 5만원을 추가한다.(UPDATE)
    성공 시나리오 : 1번과 2번 작업이 모두 성공적으로 끝나면, 이 거래를 확정 --> COMMIT
    실패 시나리오 : 1번은 성공했지만 시스템 오류로 인해 2번 작업 실패 (은행 점검시간 걸림)
					이 때, COMMIT하지않고 ROLLBACK을 하면 1번 작업(A계좌에서 5만원 차감)이 취소되어
					A 계좌에서 돈이 사라지는 현상을 막고 마치 계좌이체가 없던 일처럼 돌리는 것
		온라인 쇼핑 주문 : 재고 감소  + 주문 내역 생성 + 포인트 적립
		항공권 /  숙소 예약 : 좌석 예약 + 결제 정보 기록 + 예약자 정보 생성 하나의 단위로 움직이는 것

	복잡하고 긴 작업 중 일부만 되돌리고 싶을 때 SAVEPOINT 사용해서 중간지점까지 되돌리기
*/
-- ================================================

DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS events; -- 외래키 때문에 위에 있을 경우 삭제 불가하므로 bookings먼저 삭제해주기!
-- 만드는 것은 events 먼저, 외래키로 인해 bookings 먼저 삭제해주기
DROP TABLE IF EXISTS attendees;

CREATE TABLE events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(100) NOT NULL,
    total_seats INT NOT NULL,
    available_seats INT NOT NULL 
);

CREATE TABLE attendees (
    attendee_id INT PRIMARY KEY AUTO_INCREMENT,
    attendee_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL,
    attendee_id INT NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (attendee_id) REFERENCES attendees(attendee_id)
);

INSERT INTO events (event_name, total_seats, available_seats) 
VALUES ('SQL 마스터 클래스', 100, 2); 

START TRANSACTION; -- 이제부터는 수동 저장
INSERT INTO attendees
VALUES (1, '김철수', 'culsoo@gmail.com');

-- SQL 마스터 클래스 이벤트의 남은 좌석 1개 줄이기
-- 김철수씨가 예약
UPDATE events
SET available_seats = available_seats - 1 --  acailable_seats 예약가능 좌석 1개 축소
WHERE event_id = 1;

-- 주의 : SELECT에서 데이터가 제대로 보인다하여 COMMIT이 무조건 완성되는 것은 아님
-- SQL에서 보이더라도 자동커믹이 아닐 때는 java에서 데이터 불러오기를 했을 때
-- 저장된 데이터가 불러오지 않을 수 있음
-- 지금 DATEBASE 자체가 아니라 DATEBASE에 데이터를 명시하는 SCHEMAS 명세 상태임
-- java는 SCHEMAS가 아니라 DATEBASE랑 상호 소통한다,

-- 김철수 id : 1 이 SQL_마스터 클래스를 예약했다는 최종 내역을 저장 
INSERT INTO bookings (event_id, attendee_id)
VALUES (1,1);

COMMIT; -- 김철수 씨의 예약을 모두 확정하는 단계, 예약이 잘 완료되고, 좌석도 무사히 줄었다.

SELECT * FROM attendees;
SELECT * FROM events;
SELECT * FROM bookings;

-- 박영희씨가 클래스 예약을 시도했지만 좌석이 없어서 실패한 시나리오
-- ROLLBACK;

-- CTRL + S는 저장하기와 동시에 COMMIT 상태로 저장됨 -> 저장 전에 확인해야 제대로 보임!!
-- START TRANSACTION : COMMIT 하기 전까지 유효 어디서 부터 어디까지 흐름 추적하고 
-- 					   COMMIT 저장 완료되면 추적을 중단하겠다.
START TRANSACTION;
INSERT INTO attendees VALUES(2, '박영희', 'hee.park@gmail.com');
SELECT * FROM attendees;
ROLLBACK;

-- 일부만 성공 SAVEPOINT
-- 담당자가 이민준과 최지아의 예약을 동시에 진행하지만 좌석은 1개 뿐이기 때문에
-- 이민준 성공 최지아는 실패!

-- 이민준 예약 성공 직후 SAVEPOINT 중간 저장해두기
-- 최지안 예약이 실패하면 그 중간 저장 지점으로 되돌아가서 이민준씨의 예약만 살리기
START TRANSACTION;
INSERT INTO attendees VALUES(3, '이민준', 'joon@gmail.com');
SELECT * FROM attendees;

-- 예약하고자 하는 클래스는 동일하므로 수정 안함
UPDATE events
SET available_seats = available_seats - 1 --  acailable_seats 예약가능 좌석 1개 축소
WHERE event_id = 1;

-- 예약자 id만 수정
INSERT INTO bookings (event_id, attendee_id)
VALUES (1,3);

SAVEPOINT booking_joon_ok;

INSERT INTO attendees VALUES(4, '최지아', 'jia@gmail.com');

-- 좌석을 주려했지만 0개라 실패 박철수와 이민준이 이미 좌석 예약 완료한 상태

-- 중간 저장 지점인 이민준 성공으로 돌아가기
ROLLBACK TO SAVEPOINT booking_joon_ok;

-- 이민준씨의 예약이 완료된 시점에서 최종 확정
COMMIT;

SELECT * FROM attendees;

-- 확인 결과 : 이민준 예약은 완료되었지만, 최지아의 정보는 롤백되어 남아있지 않는다.