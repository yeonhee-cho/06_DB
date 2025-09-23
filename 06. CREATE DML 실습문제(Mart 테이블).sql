-- ===========================================
-- 자료형 날짜 : YEAR 년도 TIME HH:MM:SS 형태로 저장(시:분:초)
-- ===========================================

USE delivery_app;

-- 1. MART 테이블 생성 문제
-- 다음 조건에 맞는 MART 테이블을 생성하세요.
-- - mart_id: 자동증가 기본키
-- - mart_name: 마트명 (100자, NULL 불가)
-- - location: 위치 (255자, NULL 불가)
-- - phone: 전화번호 (20자)
-- - open_time: 개점시간 (TIME 타입)
-- - close_time: 폐점시간 (TIME 타입)
-- - is_24hour: 24시간 운영여부 (BOOLEAN, 기본값 FALSE)
-- - created_at: 등록일시 (TIMESTAMP, 기본값 현재시간)
-- - updated_at: 수정일시 (TIMESTAMP, 기본값 현재시간, 수정시 자동 업데이트)
-- - updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

-- CREATE TABLE 을 실행할 때 2가지 방법
-- 1. 모든 테이블 삭제 후 다시 생성
-- 테이블이 존재할 경우에만 삭제 
DROP TABLE IF EXISTS mart;
-- 2. 테이블 존재 유무 확인 후 생성
-- 테이블이 존재하지 않을 때 생성
CREATE TABLE IF NOT EXISTS mart (
    mart_id INT AUTO_INCREMENT PRIMARY KEY, -- PRIMARY KEY 는 자동 생성
    mart_name VARCHAR(100) NOT NULL, 
    location VARCHAR(255) NOT NULL,
    phone VARCHAR(20), -- 벌쳐 하이픈 들어가서 문자열로, INT는 010으로 작성할 경우 맨 앞에 있는 0 자동 삭제(주민번호도 마찬가지) 따라서 벌쳐 형태로 작성해줌
    open_time TIME,
    close_time TIME,
    is_24hour BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- ON UPDATE CURRENT_TIMESTAMP : 수정이 들어가면 업데이트!

-- 2. INSERT 문제
-- 다음 마트 정보를 INSERT하세요.

-- 문제 2-1: 모든 컬럼값을 지정하여 삽입
-- 이마트 강남점, 서울시 강남구 테헤란로 123, 02-123-4567, 08:00, 24:00, 24시간 운영 아님
-- (TIMESTAMP 컬럼은 DEFAULT 사용)
INSERT INTO mart (mart_name, location, phone, open_time, close_time)
VALUES('이마트 강남점', '서울시 강남구 테헤란로 123', '02-123-4567','08:00', '24:00');

-- 문제 2-2: 컬럼명을 명시하여 삽입 (24시간 운영 정보와 TIMESTAMP 없이)
-- 롯데마트 잠실점, 서울시 송파구 올림픽로 456, 02-456-7890, 09:00, 23:00
INSERT INTO mart (mart_name, location, phone, open_time, close_time) 
VALUES('롯데마트 잠실점', '서울시 송파구 올림픽로 456', '02-456-7890', '09:00', '23:00');

-- 문제 2-3: DEFAULT 값 활용하여 삽입
-- CU 편의점 역삼점, 서울시 강남구 역삼로 789, 02-789-0123, 24시간 운영
INSERT INTO mart (mart_name, location, phone, is_24hour) 
VALUES('CU 편의점 역삼점', '서울시 강남구 역삼로 789', '02-789-0123', true); 
-- ? DEFAULT 값 활용하여
INSERT INTO mart
VALUES(DEFAULT, 'CU 편의점 역삼점', '서울시 강남구 역삼로 789', '02-789-0123', NULL, NULL, true, DEFAULT, DEFAULT); 
-- AUTO_INCREMENT는 DEFAULT를 작성하지 않아도 자동으로 번호 순번 매김을 DEFAULT로 설정되어있다.

-- 삽입된 데이터 확인
SELECT * FROM mart;

-- 3. UPDATE 문제
-- 문제 3-1: 이마트 강남점의 전화번호를 '02-111-1111'로 변경하세요.
UPDATE mart
SET phone = '02-111-1111'
WHERE mart_name = '이마트 강남점';

-- 문제 3-2: 24시간 운영이 아닌 마트들의 폐점시간을 22:00으로 일괄 변경하세요.
SELECT * FROM mart;
SET SQL_SAFE_UPDATES = 1;

UPDATE mart
SET close_time = '22:00'
WHERE is_24hour = false;

-- 문제 3-3: CU 편의점 역삼점의 개점시간과 폐점시간을 각각 00:00, 23:59로 변경하세요.
UPDATE mart
SET open_time = '00:00', close_time = '23:59'
WHERE mart_name = 'CU 편의점 역삼점';

-- 업데이트 결과 확인 (created_at과 updated_at 시간 차이 확인)
SELECT mart_name, created_at, updated_at FROM mart;

-- 4. DELETE 문제
INSERT INTO mart (mart_name, location, phone, open_time, close_time, is_24hour)
VALUES
('세븐일레븐 논현점', '서울시 강남구 논현로 111', '02-111-2222', NULL, NULL, TRUE),
('GS25 삼성점', '서울시 강남구 삼성로 222', NULL, '06:00:00', '24:00:00', FALSE);

-- 삽입 확인
SELECT * FROM mart;

-- 문제 4-1: 전화번호가 NULL인 마트를 삭제하세요.
SELECT * FROM mart WHERE phone IS NULL;
DELETE
FROM mart
WHERE phone IS NULL;
SET SQL_SAFE_UPDATES = 1;

-- 문제 4-2: 24시간 운영이 아니고 폐점시간이 22:00인 마트를 삭제하세요.
SELECT * FROM mart WHERE is_24hour = false AND close_time = '22:00:00'; 
DELETE
FROM mart
WHERE is_24hour = false 
AND close_time = '22:00:00';
SET SQL_SAFE_UPDATES = 1;

-- 문제 4-3: 마트명에 '편의점'이 포함된 마트를 삭제하세요.
SELECT * FROM mart WHERE mart_name LIKE '%편의점%';
DELETE
FROM mart
WHERE mart_name LIKE '%편의점%';
SET SQL_SAFE_UPDATES = 1;

-- 삭제 결과 확인
SELECT * FROM mart;

-- 최종 확인
SELECT * FROM mart;
DESCRIBE mart;

-- 추가
INSERT INTO mart (mart_name, location, phone, open_time, close_time, is_24hour)
VALUES
('홈플러스 강남점', '서울시 강남구 도곡로 300', '02-300-4000', '10:00:00', '23:00:00', FALSE),
('코스트코 양재점', '서울시 서초구 양재대로 400', '02-400-5000', '10:00:00', '22:00:00', FALSE),
('하나로마트 서초점', '서울시 서초구 서초대로 500', '02-500-6000', '08:00:00', '21:00:00', FALSE);

-- NOW() = 현재 시간과 INTERVAL 10 MINUTE = 10분이라는 시간 간격의 단위
-- DATE_SUB() 날짜에서 지정한 간격을 빼는 함수
-- 현재 시간에서 10분을 뺀 시간이 등록 시간보다 큰가 작은가 비교
-- DATE_SUB(NOW(), INTERVAL 10 MINUTE);
-- 이용해서 등록된지 10분 이내의 마트만 조회하기
SELECT * 
FROM mart
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 10 MINUTE);

-- * 전화번호 핸드폰 번호 주민등록번호의 경우에는 VARCHAR 사용
-- ex) 010- 형태와 00년생부터 시작하는 사람들을 위해 VARCHAR 사용