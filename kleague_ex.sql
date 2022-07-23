-- 1번-- 
select player_id, player_name, back_no
from player
where team_id = 'k07';
-- 2번-- 
select player_name, team_id, position, nation
from player
where nation = '브라질' and position ='MF' or nation="러시아" and position="FW";
select player_name, team_id, position, nation
from player
where (position,nation) in (('MF','브라질'),('FW','러시아'));
-- 3번-- 
select *
from player
where player_name like '장%';
-- 4번
select player_name, position, team_id
from player
where position is null;
-- 5번
select player_name 선수이름, birth_date 생년월일, month(birth_date) 월, day(birth_date) 일
from player;
-- 6번
select player_name 선수이름, timestampdiff(year,birth_date,date(now())) 나이
from player;
-- 7번
select player_name, coalesce(position, '****'), coalesce(height,0)
from player
where team_id = 'k08';
-- 8번
select player_name, e_player_name, nickname, coalesce(E_PLAYER_NAME,nickname) 별칭
from player;
-- 다시9번-- 
select player_name, count(player_name) 동명이인수
from player
group by player_name
having count(player_name)>=2;
-- 10번
select position, round(avg(height),2)
from player
group by position
having avg(height)>=180;
-- 다시11번 팀별로 각각의 생월에 대한 선수의 평균 키를 구하시오
SELECT	PLAYER_NAME, TEAM_ID, birth_date,								/* 2단계 */
		CASE MONTH(BIRTH_DATE) WHEN 1 THEN HEIGHT END M01,
        CASE MONTH(BIRTH_DATE) WHEN 2 THEN HEIGHT END M02,
		CASE MONTH(BIRTH_DATE) WHEN 3 THEN HEIGHT END M03,
        CASE MONTH(BIRTH_DATE) WHEN 4 THEN HEIGHT END M04,
        CASE MONTH(BIRTH_DATE) WHEN 5 THEN HEIGHT END M05,
        CASE MONTH(BIRTH_DATE) WHEN 6 THEN HEIGHT END M06,
        CASE MONTH(BIRTH_DATE) WHEN 7 THEN HEIGHT END M07,
        CASE MONTH(BIRTH_DATE) WHEN 8 THEN HEIGHT END M08,
        CASE MONTH(BIRTH_DATE) WHEN 9 THEN HEIGHT END M09,
        CASE MONTH(BIRTH_DATE) WHEN 10 THEN HEIGHT END M10,
        CASE MONTH(BIRTH_DATE) WHEN 11 THEN HEIGHT END M11,
        CASE MONTH(BIRTH_DATE) WHEN 12 THEN HEIGHT END M12,
        CASE WHEN MONTH(BIRTH_DATE) IS NULL THEN HEIGHT END 생일모름
FROM	PLAYER; 

-- 다시12번--
select team_id, count(player_name) 인원수,
sum(case position when 'FW' then 1 else 0 end) fw,
sum(case position when 'GK' then 1 else 0 end) gk,
sum(case position when 'MF' then 1 else 0 end) fw,
sum(case position when 'DF' then 1 else 0 end) df,
sum(case when position is null then 1 else 0 end) undefined
from player 
group by team_id;
-- 13번-- 
select stadium_name,stadium_id, seat_count
from stadium
order by 1, 3 desc
limit 0,3

-- 14번
select player_name
from player
where team_id = 'k02'
union
select player_name
from player
where team_id = 'k07'
order by player_name;

-- 다시15번
select player_name
from player x
where x.team_id = 'k02' and exists 
	(select 1
    from player y
    where x.player_id = y.player_id and y.position='GK');
    
select player_name
from player
where team_id ="k02" and 
player_name in ( select player_name
				from player
				where position = 'gk');
-- 16번
select "p" 구분코드, position 포지션, avg(height) 평균키
from player
group by position
union
select "n" 구분코드, team_id 팀, avg(height) 평균키
from player
group by team_id;

-- 17번
select *
from player
where team_id ="K07" and position <> "mf";
select *
from player
where team_id ='k07' and 
player_id not in ( select player_id
						from player
                        where position ='gk');
select *
from player x
where x.team_id ='k07' and
not exists ( select 1
			from player y
            where x.player_id = y.player_id and position='df');
            
-- 18번
select p.player_name 선수이름, p.back_no 등번호, t.region_name 연고지, t.team_name 팀이름
from player p, team t
where p.team_id = t.team_id;

select p.player_name 선수이름, p.back_no 등번호, t.region_name 연고지, t.team_name 팀이름, p.team_id
from player p join team t on p.team_id = t.team_id;

-- 19번
select p.player_name, p.back_no, t.team_name, t.region_name
from player p join team t on p.team_id = t.team_id
where p.position ="gk";

select p.player_name, p.back_no, t.team_name, t.region_name
from player p , team t 
where p.team_id = t.team_id and p.position ="gk"
order by p.back_no ;

-- 20번
select p.player_name, t.team_name, s.*
from player p join team t on p.team_id = t.team_id join stadium s on s.stadium_id = t.stadium_id;

-- 21번
select t.team_name, t.region_name, s.stadium_name, p.player_name, p.position
from team t join stadium s on t.stadium_id = s.stadium_id join player p on p.team_id = t.team_id
where p.position = 'gk';
select t.team_name, t.region_name, s.stadium_name, p.player_name, p.position
from team t join stadium s using(stadium_id) join player p using(team_id)
where p.position = 'gk';

-- 다시22번 
-- 홈팀이 3점 이상 차이로 승리한 경기의 경기장 이름, 경기 일정, 홈팀 이름과 원정팀 이름 정보 출력
select s.stadium_name 경기장이름, sch.SCHE_DATE 경기일정, aw.team_name away팀이름, ht.team_name home팀이름, sch.home_score
from stadium s join schedule sch on s.stadium_id = sch.stadium_id join team ht on ht.team_id = sch.hometeam_id
join team aw on aw.team_id = sch.awayteam_id
where sch.home_score >= sch.away_score +3;

-- 23번
SELECT HT.TEAM_NAME, AW.TEAM_NAME, S.STADIUM_NAME
FROM SCHEDULE SCH JOIN TEAM HT ON SCH.HOMETEAM_ID = HT.TEAM_ID
JOIN TEAM AW ON SCH.AWAYTEAM_ID = AW.TEAM_ID
JOIN STADIUM S ON S.STADIUM_ID = SCH.STADIUM_ID
GROUP BY HT.TEAM_NAME;

-- 24번
SELECT COUNT(SCHE_DATE), SCHE_DATE
FROM SCHEDULE
GROUP BY SCHE_DATE
;
-- 선수들의 평균 키보다 작은 선수들을 출력 비연관 서브쿼리
select player_name 선수이름
from player
where height <= (select avg(height)
				from player);
                
-- 정현수 선수의 소속팀 정보 검색 비연관 서브쿼리
select team.*
from team
where TEAM_ID = ANY ( select TEAM_ID
		from PLAYER
        WHERE PLAYER_NAME = '정현수');
SELECT TEAM.*
FROM TEAM
WHERE TEAM_ID IN (SELECT TEAM_ID
				FROM PLAYER
                WHERE PLAYER_NAME='정현수');
                
-- 각 팀에서 제일 키가 작은 선수들 검색 비연관 서브쿼리
SELECT TEAM_ID, PLAYER_NAME
FROM PLAYER
WHERE (TEAM_ID,HEIGHT) IN (SELECT TEAM_ID, MIN(HEIGHT)
							FROM PLAYER
                            GROUP BY TEAM_ID);
                            
SELECT TEAM_ID, MIN(HEIGHT)
							FROM PLAYER
                            GROUP BY TEAM_ID;
					-- 	이러한 특성을 갖는 선수이름을 뽑아라

-- 포지션이 GK인 선수들 검색 연관 서브쿼리

SELECT PLAYER_Name, position
FROM PLAYER
WHERE player_name IN (SELECT player_name
					from player
                    where position ='gk');
                    -- 이렇게하면 동명이인나옴 동명이인이 안나오게하려면 고유값 player_id 사용해야함
-- exists사용
-- 연관 서브쿼리는 for문과 비슷함
select player_name, position
from player x
where exists( select 1
			from player y 
            where x.player_id = y.player_id and y.position = 'gk');
-- 브라질 혹은 러시아 출신 선수가 있는 팀 검색 exists 사용
select team_id, team_name
from team x
where exists( select team_id
			from player y
            where x.team_id=y.team_id and y.nation in ('브라질','러시아')
            );
-- exists 사용 x
select team_id, team_name
from team x 
where team_id = any(select team_id
					from player y
                    where x.team_id = y.team_id and y.nation in('브라질','러시아')
                    );
-- 20120501부터 20120502까지 열렸던 경기장 조회
select s.stadium_id, s.stadium_name
from stadium s
where exists ( select *
				from schedule sc
                where sc.sche_date between '20120501' and '20120502' and s.stadium_id = sc.stadium_id);
                
-- 각팀에서 제일 키가 큰 선수들을 검색 비연관
select team_ID, player_name, height
from player
where (team_id, height)= any ( select team_id, max(height)
									from player
									group by team_id)
                                    ;
-- 각 팀에서 소속팀의 평균키보다 작은 선수검색
select team_id, player_name, height
from player p 
where p.height <  ( select avg(y.height)
				from player y
                where p.team_id = y.team_id);
                
-- 선수정보와 소속팀의 평균키 함께 검색
select team_id, player_name, height,
( select avg(height)
from player y 
where x.team_id = y.team_id) 팀평균키
from player x;
-- 팀명과 소속 선수의 인원수 검색
select team_name,
( select count(*)
	from player b
    where b.team_id = a.team_id) 인원수
from team a;
-- 각 팀의 마지막 경기가 진행된 날짜 검색
select team_name, 
(select max(sche_date)
from schedule s
where s.hometeam_id = t.team_id or s.awayteam_id = t.team_id) 마지막경기
from team t;
-- k09 팀의 선수이름, 포지션, 백넘버 검색
select player_name 선수이름, position 포지션, back_no 백넘버
from player
where team_id='k09';

with temp as
( select player_name, position, back_no, team_id
	from player
    order by player_id desc)
select player_name, position
from temp
where team_id='k09';

-- 포지션이 mf인 선수들의 소속팀명 및 선수 정보 검색(비연관, 다중행)
select t.team_name, p.player_name, p.back_no
from (select player_name, back_no, team_id
	from player
    where position = 'mf') as p, team t
where t.team_id = p.team_id;

-- 키가 제일 큰 5명 선수들 정보 검색
select player_name 선수명, position 포지션, back_no 백넘버, height 키
from ( select player_name, height,  position, back_no
		from player
        where height is not null
		order by height desc) as temp;
-- k02팀의 평균키 보다 평균키가 작은 팀의 이름과 해당 팀의 평균키 검색
select t.team_name, avg(p.height)
from player p join team t using(team_id)
group by t.team_id, t.team_name
having avg(p.height) <=(select round(avg(height),2)
					from player
					where team_id = 'k02');
                    
-- 예제 2
select t.team_name 팀이름, max(sc.sche_date)
from team t join schedule sc using(stadium_id)
where sc.hometeam_id = t.team_id or sc.awayteam_id = t.team_id and sche_date is not null
group by team_name
order by team_id;

-- 예제 3번
select team_name "팀 이름" , (select count(*)
							from player p
                            where p.team_id =t.team_id and p.position = 'gk') 'gk수',
                            (select count(*)
                            from player p
                            where p.team_id =t.team_id) '멤버 수'
                            
from team t
where (select count(*)
	from player p
	where p.team_id =t.team_id and p.position = 'gk') >=4 ;
    
-- 예제 4
select ht.team_id, home_score, away_score
from team ht join schedule sc on ht.team_id = sc.hometeam_id join team aw on aw.team_id = sc.awayteam_id
where sc.stadium_id = ht.stadium_id
group by team_id
having sc.home_score > all (select scc.away_score
							from schedule scc
							where sc.sche_date = scc.sche_date);

WITH TEMP1_SCHEDULE AS 			/* 홈팀명을 갖는 SCHEDULE */
(
		SELECT 	S.STADIUM_ID, SCHE_DATE, TEAM_NAME AS HOMETEAM_NAME, AWAYTEAM_ID, 
				HOME_SCORE, AWAY_SCORE
		FROM	SCHEDULE S JOIN TEAM T ON S.HOMETEAM_ID = T.TEAM_ID
),
TEMP2_SCHEDULE AS				/* 홈팀명, 어웨이팀명을 갖는 SCHEDULE */
(
		SELECT	T1.STADIUM_ID, SCHE_DATE, HOMETEAM_NAME, TEAM_NAME AS AWAYTEAM_NAME,
				HOME_SCORE, AWAY_SCORE
		FROM	TEMP1_SCHEDULE T1 JOIN TEAM T ON T1.AWAYTEAM_ID = T.TEAM_ID
)
select STADIUM_ID, SCHE_DATE, HOMETEAM_NAME,  AWAYTEAM_NAME,
				HOME_SCORE, AWAY_SCORE
from temp2_schedule;

-- 날짜별 경기수를 출력하시오 단 누락된 날짜가 없게 하시오
with recursive dates(n) as
(
select cast(min(sche_date) as date)
from schedule
union all
select n + interval 1 day
from dates
where n + interval 1 day <='2012-03-31'
)
select dates.n, coalesce(count(sc.sche_date),0) as number_of_games
from dates left join schedule sc on dates.n = sc.sche_date
group by dates.n;

-- 선수들의 평균 키보다 작은 선수들의 이름, 포지션, 백넘버를 출력
select player_name 선수이름, position, back_no
from player
where height <= (select avg(height)
				from player)
order by player_name;

-- 각 팀에서 키가 제일 작은 선수들 검색
select player_name, team_id, height
from player a
where height = (select min(height)
				from player b
                where b.team_id = a.team_id)
order by team_id
;
select player_name, team_id, height
from player
where (team_id,height) in ( select team_id, min(height)
							from player
							group by team_id);
-- 포지션이 gk 인 선수검색
select player_name
from player a
where exists (select position
				from player b
                where a. player_id = b.player_id and b.position='gk')
                ;
-- 러시아 혹은 브라질 출신 선수가 있는 팀 검색
select team_id
from TEAM A
WHERE TEAM_ID = ANY (SELECT TEAM_ID
					FROM PLAYER B
					WHERE B.NATION IN ('브라질','러시아') AND A.TEAM_ID = B.TEAM_ID);
                    
-- 20120501부터 20120502 사이에 열렸던 경기장 조회
SELECT STADIUM_ID, STADIUM_NAME
FROM STADIUM A
WHERE STADIUM_ID = ANY( SELECT STADIUM_ID
					FROM SCHEDULE B
                    WHERE SCHE_DATE BETWEEN '20120501' AND '20120502' AND A.STADIUM_ID=B.STADIUM_ID);
                    
-- 각 팀에서 제일 키가 큰 선수들을 검색
SELECT TEAM_ID, PLAYER_NAME, HEIGHT
FROM PLAYER A
WHERE HEIGHT = ( SELECT MAX(HEIGHT)
		FROM PLAYER B
        WHERE A.TEAM_ID = B.TEAM_ID);
        
-- 소속 팀의 평균 키보다 작은 선수들을 검색
SELECT A.TEAM_ID, A.PLAYER_NAME, A.HEIGHT
FROM PLAYER A
WHERE A.HEIGHT < ( SELECT AVG(B.HEIGHT)
				FROM PLAYER B
                WHERE A.TEAM_ID = B.TEAM_ID)
ORDER BY TEAM_ID;

-- 각팀의 평균키 구하기
SELECT TEAM_ID, PLAYER_NAME, HEIGHT, ( SELECT AVG(HEIGHT)
										FROM PLAYER B
                                        WHERE A.TEAM_ID = B.TEAM_ID) 평균키
FROM PLAYER A
WHERE HEIGHT < (SELECT AVG(HEIGHT)
				FROM PLAYER B
                WHERE B.TEAM_ID = A.TEAM_ID);

-- 팀명과 소속 선수의 인원수를 검색

SELECT TEAM_NAME, (
					SELECT COUNT(*)
					FROM PLAYER
                    WHERE PLAYER.TEAM_ID = TEAM.TEAM_ID
                    )
FROM TEAM;

-- 각 팀의 마지막 경기가 진행된 날짜 검색

SELECT TEAM_ID, ( SELECT MAX(SCHE_DATE)
					FROM SCHEDULE S
					WHERE S.HOMETEAM_ID = T.TEAM_ID OR S.AWAYTEAM_ID = T.TEAM_ID) 마지막경기
FROM TEAM T;
-- K09 팀의 선수이름, 포지션, 백넘버 검색
SELECT PLAYER_NAME, POSITION, BACK_NO
FROM PLAYER
WHERE TEAM_ID = 'K09'
ORDER BY PLAYER_ID DESC;

SELECT PLAYER_NAME, POSITION, BACK_NO
FROM ( 
		SELECT TEAM_ID, PLAYER_ID, PLAYER_NAME, POSITION, BACK_NO
        FROM PLAYER
        ORDER BY PLAYER_ID DESC ) AS TEMP
WHERE TEAM_ID='K09';

WITH TEMP AS
(SELECT PLAYER_NAME, BACK_NO
FROM PLAYER
WHERE POSITION = 'MF'
)
SELECT TEAM_NAME, TEMP.POSITION, TEMP.BACK_NO
FROM TEMP, TEAM;


with recursive dates(n) as
(
select cast(min(sche_date) as date)
from schedule
union all
select n + interval 1 day
from dates
where n + interval 1 day <='2012-03-31'
)
select dates.n, coalesce(count(sc.sche_date),0) as number_of_games
from dates left join schedule sc on dates.n = sc.sche_date
group by dates.n;

-- 선수들의 평균 키보다 작은 선수들의 이름, 포지션, 백넘버를 출력하시오
select player_name, position, back_no, height
from player
where height < (select avg(height)
				from player);

-- 정현수 선수의 소속팀의 연고지명, 팀명, 영문팀명 출력
select region_name, team_name, e_team_name
from team
where team_id = any (select team_id
					from player
					where player_name ="정현수");
-- 각 팀에서 제일 키가 작은 선수들의 팀아이디, 선수명, 포지션, 백넘버, 키 출력
select team_id, position, back_no, height, player_name
from player a
where (team_id,height) in (select team_id,min(height)
							from player
							group by team_id)
order by team_id;
-- 포지션이 gk인 선수들을 검색( 연관 섭쿼리)
select player_name, position
from player a
where player_id in ( select player_id
					from player b
                    where a.player_id = b.player_id and b.position = 'gk');
-- 브라질 혹은 러시아 출신 선수가 있는 팀 검색
select team_name
from team
where team_id in (select team_id
				from player
                where nation in ('브라질','러시아') and player.team_id = team.team_id);
-- 20120501부터 20120502 사이 경기가 열렸던 경기장을 조회 (연관 서브쿼리), 경기장아이디, 경기장명 출력

select stadium_name, stadium_id, stadium_name
from stadium
where stadium_id = any( select stadium_id
						from schedule sc
                        where sc.stadium_id = stadium.stadium_id and sche_date between  '20120501'and '20120502') ;
                        
                        -- 각 팀에서 제일 키가 큰 선수들의 팀 아이디, 이름, 키 출력
select team_id, player_name, height
from player a
where height = (select max(height)
				from player b
               where a.team_id= b.team_id)
group by team_id;

-- 소속 팀의 평균 키보다 작은 선수들의 팀 아이디, 이름, 포지션, 백넘버, 키 출력
select team_id, player_name, position, back_no, height
from player a
where height < (select avg(height)
				from player b
                where a.team_id = b.team_id);
-- 팀 아이디, 선수명, 키, 소속 팀의 평균 키 출력
select team_id, player_name, height, ( select avg(height)
										from player b
                                        where b.team_id = a.team_id) 소속팀의평균키
from player a;

-- 팀 아이디, 팀명, 팀인원수 출력
select team_id, team_name, (select count(*)
							from player b
                            where b.team_id = a.team_id)
from team a;
-- 팀 아이디, 팀명, 각팀의 마지막 경기가 진행된 날짜 출력
select team_id, team_name, (select max(sche_date)
							from schedule
                            where schedule.awayteam_id = team.team_id or schedule.hometeam_id = team.team_id)
from team;

-- 포지션이 mf인 선수들의 소속팀명 및 선수이름과 백넘버 출력
select team_name, player_name, back_no
from (
	select team_id, player_name, back_no
    from player
    where position='mf') p, team t
where p.team_id = t.team_id;

-- 키가 제일 큰 5명의 선수들의 이름, 포지션, 백넘버 출력

select player_name, position, back_no, height
from player 
where height is not null
order by height desc
limit 5;

-- k02팀의 평균키보다 평균키가 작은 팀의이름과 해당 팀의 평균키를 출력
select team.team_name, avg(player.height)
from player join team using(team_id)
group by team_name
having avg(height) < (select avg(height)
					from player
                    where team_id = 'k02');