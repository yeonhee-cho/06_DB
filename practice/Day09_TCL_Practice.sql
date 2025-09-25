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


-- 1. START TRANSACTION;으로 트랜잭션을 시작하세요.
START TRANSACTION;

-- 2. shop_items 테이블에서 키보드의 재고(stock)를 1개 줄이세요.
-- UPDATE 재고 줄이기

-- 3. customer_points 테이블에서 홍길동 고객의 포인트(points)를 300점(가격의 1%) 추가해주세요.
-- UPDATE
-- POINT = POINT + 300

-- 4. order_history 테이블에 홍길동 고객이 키보드를 주문했다는 내역을 기록하세요;
-- VALUES ('user01', 101)

-- 5. 모든 작업이 성공했으므로 COMMIT;으로 트랜잭션을 완료하세요.
