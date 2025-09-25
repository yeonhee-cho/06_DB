CREATE TABLE shop_items (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    stock INT NOT NULL,
    price INT NOT NULL
);

CREATE TABLE customer_points (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    points INT DEFAULT 0
);

CREATE TABLE order_history (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id VARCHAR(50) NOT NULL,
    item_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO shop_items (item_id, item_name, stock, price) VALUES
(101, '키보드', 10, 30000),
(102, '마우스', 5, 25000),
(103, '모니터', 0, 150000);

INSERT INTO customer_points (customer_id, customer_name, points) VALUES
('user01', '홍길동', 1000);

-- =================================
-- 문제 1: 정상 주문 (COMMIT)
-- =================================

-- 1. START TRANSACTION;으로 트랜잭션을 시작하세요.
START TRANSACTION;

-- 2. shop_items 테이블에서 키보드의 재고(stock)를 1개 줄이세요.
-- UPDATE 재고 줄이기
UPDATE shop_items
SET stock = stock - 1
WHERE item_name = '키보드';

-- 3. customer_points 테이블에서 홍길동 고객의 포인트(points)를 300점(가격의 1%) 추가해주세요.
-- UPDATE
-- POINT = POINT + 300
UPDATE customer_points
SET points = points + 300
WHERE customer_name = '홍길동';

-- 4. order_history 테이블에 홍길동 고객이 키보드를 주문했다는 내역을 기록하세요;
-- VALUES ('user01', 101)
INSERT INTO order_history (customer_id, item_id)
VALUES ('user01', 101);

-- 5. 모든 작업이 성공했으므로 COMMIT;으로 트랜잭션을 완료하세요.
COMMIT;

-- 키보드 재고가 9개, 홍길동 포인트가 1300점이 되었는지 확인
SELECT * FROM shop_items WHERE item_id = 101;
SELECT * FROM customer_points WHERE customer_id = 'user01';
SELECT * FROM order_history;


-- =================================
-- 문제 2: 주문 완전 실패 (ROLLBACK)
-- =================================
-- 1. 트랜잭션을 시작하세요.
START TRANSACTION;

-- 2. `customer_points` 테이블에 새로운 고객 이몽룡(user02, 초기 포인트 0)을 추가하세요.
INSERT INTO customer_points (customer_id, customer_name, points) 
VALUES ('user02', '이몽룡', DEFAULT); 

-- 3. `shop_items` 테이블에서 마우스의 재고를 1개 줄이세요.
UPDATE shop_items 
SET stock = stock - 1
WHERE item_name = '마우스';


-- 4. (오류 발생) `order_history` 기록 단계에서 문제가 생겼다고 가정하고, `ROLLBACK;`을 실행하여 모든 작업을 취소하세요.
ROLLBACK;

-- 마우스 재고가 그대로 5개이고, '이몽룡' 고객 정보가 없는지 확인
SELECT * FROM shop_items WHERE item_id = 102;
SELECT * FROM customer_points WHERE customer_id = 'user02';


-- =================================
-- 문제 3: 여러 상품 주문 중 일부만 성공 (SAVEPOINT)
-- =================================
-- 1. 트랜잭션을 시작하세요.
START TRANSACTION;
-- 2. **(마우스 주문)**: 마우스 재고를 1개 줄이고, 홍길동에게 포인트 250점을 추가하고, 주문 내역을 기록하세요.

-- 마우스 재고를 1개 줄이기
UPDATE shop_items 
SET stock = stock - 1
WHERE item_name = '마우스';

-- 홍길동에게 포인트 250점을 추가
UPDATE customer_points 
SET points = points + 250
WHERE item_name = '홍길동';

-- 주문 내역을 기록
INSERT INTO order_history (customer_id, item_id)
VALUES ('user01', 102);

-- 3. 마우스 주문이 성공했으니, `SAVEPOINT mouse_order_success;`로 중간 저장 지점을 만드세요.
SAVEPOINT mouse_order_success;

-- 4. **(모니터 주문 시도)**: 모니터 재고를 줄이려고 시도합니다. (재고가 0이라 실패)
UPDATE shop_items 
SET stock = stock - 1
WHERE item_name = '모니터';

-- 5. 모니터 주문이 실패했으므로, `ROLLBACK TO SAVEPOINT mouse_order_success;`를 실행하여 '마우스' 주문 성공 시점으로 되돌아가세요.
ROLLBACK TO SAVEPOINT mouse_order_success;
-- Error Code: 1305. SAVEPOINT mouse_order_success does not exist	0.000 sec 존재하지 않음


-- 6. '마우스' 주문은 유효하므로 `COMMIT;`으로 최종 확정하세요.

-- 마우스 재고는 4개로 줄었지만, 모니터 재고는 그대로 0개인지 확인
SELECT * FROM shop_items;
-- 홍길동의 최종 포인트가 1300점(기존) + 250점(마우스) = 1550점이 되었는지 확인
SELECT * FROM customer_points;
-- 주문 내역에 마우스만 추가되었는지 확인
SELECT * FROM order_history;

SELECT * FROM shop_items;
SELECT * FROM customer_points;
SELECT * FROM order_history;
