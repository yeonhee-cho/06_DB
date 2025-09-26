-- 문제 1: 기본 계정 생성
-- 다음 정보로 계정을 생성하세요.
-- - **아이디**: student01
-- - **비밀번호**: Study123!
-- - **접속 위치**: localhost에서만 접속 가능
CREATE USER 'student01'@'localhost' IDENTIFIED BY 'Study123!';

-- 문제 2: 원격 접속 계정 생성
-- 다음 정보로 계정을 생성하세요.
-- - **아이디**: remote_dev
-- - **비밀번호**: DevWork456#
-- - **접속 위치**: 어디서든 접속 가능
CREATE USER 'remote_dev'@'%' IDENTIFIED BY 'DevWork456#';

-- 문제 3: 특정 IP 대역 계정 생성
-- 다음 정보로 계정을 생성하세요.
-- - **아이디**: office_worker
-- - **비밀번호**: Office789$
-- - **접속 위치**: 192.168.10.* IP 대역에서만 접속 가능
CREATE USER 'office_worker'@'192.168.10.%' IDENTIFIED BY 'Office789$';

-- 문제 4: 웹 애플리케이션 계정 생성 (권한 포함)
-- 다음 요구사항으로 계정을 생성하고 권한을 부여하세요.
-- - **아이디**: webapp_user
-- - **비밀번호**: WebApp2024!
-- - **접속 위치**: localhost
-- - **데이터베이스**: shop_db
-- - **권한**: SELECT, INSERT, UPDATE, DELETE
-- 계정을 생성
CREATE USER 'webapp_user'@'localhost' IDENTIFIED BY 'WebApp2024!'; 
-- 권한을 부여
GRANT SELECT, INSERT, UPDATE, DELETE ON shop_db TO 'webapp_user'@'localhost';

-- 문제 5: 관리자 계정 생성
-- 다음 요구사항으로 관리자 계정을 생성하세요.
-- - **아이디**: db_admin
-- - **비밀번호**: Admin#2024Secure
-- - **접속 위치**: 192.168.1.100 IP에서만 접속
-- - **권한**: 모든 데이터베이스에 대한 모든 권한 (GRANT 권한 포함)
-- 계정을 생성
CREATE USER 'db_admin'@'192.168.1.100' IDENTIFIED BY 'Admin#2024Secure'; 
-- 권한을 부여
GRANT ALL PRIVILEGES ON *.* TO 'db_admin'@'192.168.1.100';

-- 문제 6: 읽기 전용 계정 생성
-- 다음 요구사항으로 계정을 생성하세요.
-- - **아이디**: report_viewer
-- - **비밀번호**: ViewOnly999@
-- - **접속 위치**: 어디서든 접속 가능
-- - **데이터베이스**: company_db의 모든 테이블
-- - **권한**: SELECT만 가능
-- 계정을 생성
CREATE USER 'report_viewer'@'%' IDENTIFIED BY 'ViewOnly999@'; 
-- 권한을 부여
GRANT SELECT ON company_db TO 'report_viewer'@'%';