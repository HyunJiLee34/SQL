-- DDL Test for kleague Sample Database
-- Version 1.0

USE kleague;

DESCRIBE PLAYER;
DESCRIBE TEAM;
DESCRIBE STADIUM;
DESCRIBE SCHEDULE;

-------------------------------------------
-- 1. PK Constraint
-------------------------------------------

-- Q: 키 값의 수정

SELECT 	* FROM TEAM;

UPDATE 	TEAM
SET		TEAM_ID = '***'
WHERE	TEAM_ID = 'K02';

SELECT 	* FROM TEAM;

-- Q: PK constraint (Entity integrity constraint)

/* PK 제약조건 위반으로 실행이 거부됨 */
INSERT INTO 	TEAM (TEAM_ID, REGION_NAME, TEAM_NAME, STADIUM_ID) 
VALUES 			(NULL,'서울','국민대학교','KMU');

/* PK 제약조건 위반으로 실행이 거부됨 */
INSERT INTO		TEAM (TEAM_ID, REGION_NAME, TEAM_NAME, STADIUM_ID) 
VALUES 			('K01','서울','국민대학교','KMU');

SELECT 	* FROM TEAM;


-------------------------------------------
-- 2. FK Constraint
-------------------------------------------

-------------------------------------------
-- 2.1 자식 테이블에 FK 삽입/수정
-------------------------------------------

-- Q: 존재하지 않는 FK 값 'KMU'을 자식 테이블에 insert/update할 때

/* FK 제약조건 위반으로 실행이 거부됨 : KMU라는 경기장이 없음. */
INSERT INTO		TEAM (TEAM_ID, REGION_NAME, TEAM_NAME, STADIUM_ID) 
VALUES			('K20','서울','국민대학교','KMU');

SELECT 	* FROM STADIUM;

/* FK 제약조건 위반으로 실행이 거부됨 : KMU라는 경기장이 없음. */
UPDATE 	TEAM
SET		STADIUM_ID = 'KMU'
WHERE	TEAM_ID = 'K03';

SELECT 	* FROM STADIUM;

-------------------------------------------
-- 2.2 부모 테이블에서 FK 삭제/수정 (RESTRICT인 경우)
-------------------------------------------

SELECT 	CONSTRAINT_SCHEMA, CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME, 
		REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM 	INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE	CONSTRAINT_SCHEMA = 'kleague'
ORDER   BY CONSTRAINT_NAME DESC;

-- 현재의 Referential option의 조합을 확인

SELECT 	CONSTRAINT_SCHEMA, CONSTRAINT_NAME, DELETE_RULE, UPDATE_RULE, 
		TABLE_NAME, REFERENCED_TABLE_NAME
FROM 	INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
WHERE	CONSTRAINT_SCHEMA = 'kleague';

-- Q: 부모 테이블에서 PK 값을 delete할 때, RESTRICT 옵션에서는 부모 테이블에서 delete가 거부됨.

/* 부모 테이블 확인 */
SELECT 	* FROM STADIUM;

/* FK 제약조건 위반으로 실행이 거부됨 */
-- 이유. 경기장 B05를 참조하는 팀이 있음. (FK_TEAM_STADIUM의 옵션이 RESTRICT)
DELETE FROM 	STADIUM
WHERE 			STADIUM_ID = 'B05';

/* 자식 테이블인 TEAM에서 K09 팀의 전용구장이 B05임 */
SELECT 	* FROM TEAM;


-------------------------------------------
-- 2.3 부모 테이블에서 FK 삭제/수정 (CASCADE인 경우)
-------------------------------------------

-- kleague DB를 초기화한 후, 아래 질의를 실행

SELECT 	* FROM STADIUM WHERE STADIUM_ID='B05';
SELECT 	* FROM TEAM WHERE STADIUM_ID='B05';				/* 경기장 B05를 전용구장으로 사용하는 팀은 K09 */
SELECT 	* FROM SCHEDULE WHERE STADIUM_ID='B05';			/* 경기장 B05에서 진행된 경기가 19 경기 */
SELECT	* FROM PLAYER WHERE TEAM_ID='K09';				/* 팀 K09의 소속 선수는 49명 */
SELECT 	* FROM SCHEDULE WHERE HOMETEAM_ID='K09';		/* 팀 K09가 홈팀으로 참여한 경기는 19 경기 */
SELECT 	* FROM SCHEDULE WHERE AWAYTEAM_ID='K09';		/* 팀 K09가 어웨이팀으로 참여한 경기는 17 경기 */

-- 각 테이블의 투플 수를 확인

SELECT 	COUNT(*) FROM STADIUM;		/* 20개 */	
SELECT 	COUNT(*) FROM TEAM;			/* 15개 */
SELECT 	COUNT(*) FROM SCHEDULE;		/* 179개 */
SELECT 	COUNT(*) FROM PLAYER;		/* 480명 */

SELECT	COUNT(*) FROM SCHEDULE WHERE STADIUM_ID = 'B05';	/* 서울월드컵경기장, 19개 */
SELECT	COUNT(*) FROM SCHEDULE WHERE HOMETEAM_ID = 'K09' OR AWAYTEAM_ID = 'K09';	/* 서울 FC의 경기, 36개 */
SELECT	COUNT(*) FROM PLAYER WHERE TEAM_ID = 'K09';		/* 서울 FC의 선수, 49명 */

-- 아래에서 ALTER TABLE 할 때마다, 현재의 Referential option의 조합을 아래 질의를 실행하여 확인

SELECT 	CONSTRAINT_SCHEMA, CONSTRAINT_NAME, DELETE_RULE, UPDATE_RULE, 
		TABLE_NAME, REFERENCED_TABLE_NAME
FROM 	INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
WHERE	CONSTRAINT_SCHEMA = 'kleague';

-- TEAM의 Referential option의 조합을 변경함.

ALTER TABLE 		TEAM
DROP FOREIGN KEY 	FK_TEAM_STADIUM;

ALTER TABLE 	TEAM
ADD CONSTRAINT	FK_TEAM_STADIUM_NEW	FOREIGN KEY (STADIUM_ID) REFERENCES STADIUM(STADIUM_ID)
											ON DELETE CASCADE
											ON UPDATE CASCADE;

-- FK 제약조건에 따라, TEAM에서도 연속적으로 삭제가 실행되어야 하나, 실행이 거부됨. 
-- 이유 1. 경기장 B05를 참조하는 경기들이 있음. (FK_SCHEDULE_STADIUM의 옵션이 RESTRICT)
-- 이유 2. (경기장 B05를 참조하는) K08 팀을 참조하는 선수와 경기들이 있음. 
--        (FK_PLAYER_TEAM, FK_SCHEDULE_HOMETEAM와 FK_SCHEDULE_AWAYTEAM의 옵션이 RESTRICT)

DELETE	FROM STADIUM
WHERE 	STADIUM_ID = 'B05';			/* 에러 */

------------------------------

-- 아래 ALTER TABLE 할 때마다, 현재의 Referential option의 조합을 아래 질의를 실행하여 확인

SELECT 	CONSTRAINT_SCHEMA, CONSTRAINT_NAME, DELETE_RULE, UPDATE_RULE, 
		TABLE_NAME, REFERENCED_TABLE_NAME
FROM 	INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
WHERE	CONSTRAINT_SCHEMA = 'kleague';

-- STADIUM을 참조하는 나머지 모든 테이블 (PLAYER와 SCHEDULE)의 FK Constraint를 CASCADE로 변경함.

ALTER TABLE 		PLAYER
DROP FOREIGN KEY 	FK_PLAYER_TEAM;

ALTER TABLE 		SCHEDULE
DROP FOREIGN KEY 	FK_SCHEDULE_STADIUM,
DROP FOREIGN KEY 	FK_SCHEDULE_HOMETEAM,
DROP FOREIGN KEY 	FK_SCHEDULE_AWAYTEAM;

ALTER TABLE 	PLAYER
ADD CONSTRAINT 	FK_PLAYER_TEAM_NEW	FOREIGN KEY (TEAM_ID) REFERENCES TEAM(TEAM_ID)
											ON DELETE CASCADE
											ON UPDATE CASCADE;

ALTER TABLE 	SCHEDULE
ADD CONSTRAINT 	FK_SCHEDULE_STADIUM_NEW  FOREIGN KEY (STADIUM_ID) REFERENCES STADIUM(STADIUM_ID)
												ON DELETE CASCADE
												ON UPDATE CASCADE,
ADD CONSTRAINT 	FK_SCHEDULE_HOMETEAM_NEW FOREIGN KEY (HOMETEAM_ID) REFERENCES TEAM(TEAM_ID)
												ON DELETE CASCADE
												ON UPDATE CASCADE,
ADD CONSTRAINT 	FK_SCHEDULE_AWAYTEAM_NEW FOREIGN KEY (AWAYTEAM_ID) REFERENCES TEAM(TEAM_ID)
												ON DELETE CASCADE
												ON UPDATE CASCADE;

-- FK 제약조건에 따라, TEAM, PLAYER, SCHEDULE에서도 연속적으로 삭제가 실행됨.
-- Q5: 부모 테이블에서 PK 값을 delete할 때, CASCADE 옵션에서는 자식 테이블에서도 delete가 연속적으로 실행되고, 그 손자로 전파됨.

DELETE FROM 	STADIUM
WHERE 			STADIUM_ID = 'B05';

-- 삭제 명령에 의한, 각 테이블의 투플 수를 확인

SELECT 	COUNT(*) FROM STADIUM;		/* 19개 (20 - 19 = 1개 삭제됨)*/
SELECT 	COUNT(*) FROM TEAM;			/* 14개 (15 - 14 = 1개 삭제됨) */
SELECT 	COUNT(*) FROM SCHEDULE;		/* 143개 (179 - 143 = 36개 삭제됨) */
SELECT 	COUNT(*) FROM PLAYER;		/* 431명 (480 - 431 = 49개 삭제됨) */

------------------------------

-- Q6: 부모 테이블에서 PK 값을 update할 때, CASCADE 옵션에서는 자식 테이블에도 update가 연속적으로 실행됨. 그러나 손자로 전파되지는 않음.

SELECT 	* FROM STADIUM WHERE STADIUM_ID = 'A02';
SELECT 	* FROM TEAM WHERE STADIUM_ID = 'A02';		/* A02 경기장을 전굥구장으로 사용하는 팀은 K12 */

UPDATE	STADIUM
SET		STADIUM_ID = '###'
WHERE	STADIUM_ID = 'A02';

SELECT 	* FROM STADIUM;
SELECT 	* FROM TEAM;
