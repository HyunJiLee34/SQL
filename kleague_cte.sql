-- 각팀의 최종경기일 검색 단 경기가 없던 팀은제외
select t.team_id, (select max(sche_date)
						from schedule sc
						where sc.hometeam_id = t.team_id or sc.awayteam_id = t.team_id) 최종일자
from team t
group by team_id
having 최종일자 is not null;
-- 예제2-- 
select concat(home_score, ':', away_score)
from schedule;
select * from schedule;

with temp as
(
select t.team_id, sc.sche_date,
case t.team_id
when sc.hometeam_id then (sc.home_score - sc.away_score)
when sc.awayteam_id then (sc.away_score - sc.home_score)
end as 점수차,
case
when sc.home_score > sc.away_score then concat(sc.home_score, ':', sc.away_score)
when sc.home_score < sc.away_score then concat(sc.away_score, ':', sc.home_score)
end as 점수,
case t.team_id
when sc.hometeam_id then sc.awayteam_id
when sc.awayteam_id then sc.hometeam_id
end as 상대팀,
sc.stadium_id
from team t, schedule sc
where t.team_id in (sc.hometeam_id, sc.awayteam_id) and sc.gubun = 'Y' order by t.team_id
)
select team_id, 상대팀, 점수차, 점수, sche_date, stadium_id
from temp
where (team_id, 점수차) in
(
select team_id, max(점수차)
from temp
group by team_id
having max(점수차) > 0
);
-- gk가 4인 이상있는 팀의 팀명과 gk선수의 인원수 팀 전체 선수의 인원수검색--
select team_id,( select count(*)
				from player b
				where a.team_id = b.team_id and position = 'gk') gk수,
				(select count(*)
				from player
				where player.team_id = a.team_id) 선수인원수
from player a
group by team_id
having gk수 >=4
order by team_id;
-- 홈에서 진적이 없는 팀검색 단 홈경기가 없는 팀제외--
select hometeam_id, sc.sche_date
from schedule sc join team ht on ht.team_id = sc.hometeam_id
where hometeam_id not in ( select hometeam_id
							from schedule sc 
							where home_score < away_score)
group by team_id;

-- ---각 팀의 승리게임수 무승부수 패배게임수 팀전체게임수검색--
with win as
(
select t.team_id
from team t, schedule sc
where t.team_id in (sc.hometeam_id, sc.awayteam_id) and (
(t.team_id = sc.hometeam_id and sc.home_score > sc.away_score) or
(t.team_id = sc.awayteam_id and sc.home_score < sc.away_score)
) and sc.gubun = 'Y'
),
lose as
(
select t.team_id
from team t, schedule sc
where t.team_id in (sc.hometeam_id, sc.awayteam_id) and (
(t.team_id = sc.hometeam_id and sc.home_score < sc.away_score) or
(t.team_id = sc.awayteam_id and sc.home_score > sc.away_score)
) and sc.gubun = 'Y'
),
draw as
(
select t.team_id
from team t, schedule sc
where t.team_id in (sc.hometeam_id, sc.awayteam_id) and (
sc.home_score = sc.away_score
) and sc.gubun = 'Y'
),
total_match as
(
select t.team_id
from team t, schedule sc
where t.team_id in (sc.hometeam_id, sc.awayteam_id) and sc.gubun = 'Y'
)
select t.team_id,
(select count(*) from win where team_id = t.team_id) as win,
(select count(*) from lose where team_id = t.team_id) as lose,
(select count(*) from draw where team_id = t.team_id) as draw,
(select count(*) from total_match where team_id = t.team_id) as 'total match'
from team t
order by t.team_id; 