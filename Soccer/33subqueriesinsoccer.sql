use soccer;

/*1.find out which teams played the first match of the 2016 Euro Cup. Return match number, country name.*/
select *from match_details;
select *from soccer_country;

select m.match_no,s.country_name from match_details m,soccer_country s
	where m.team_id = s.country_id
    and m.match_no = 1;
    
##using inner join
select match_no,country_name from match_details
	join soccer_country on match_details.team_id = soccer_country.country_id
    and match_no = 1;
   
   
/*2. find the winner of EURO cup 2016. Return country name.*/
select country_name from soccer_country 
	where country_id in (select team_id from match_details
		where win_lose = 'w' and play_stage = 'F');

##using inner join
select country_name from soccer_country s
	join match_details m on m.team_id = s.country_id
    and m.win_lose = 'w' and m.play_stage = 'F';

##using exists clause 
select country_name from soccer_country 
	where exists (select 1 from match_details
		where match_details.team_id = soccer_country.country_id
        and play_stage = 'F' and win_lose = 'W');
        
##using where clause
select country_name from soccer_country,match_details
	where soccer_country.country_id = match_details.team_id
    and play_stage = 'F' and win_lose = 'W';
    
/*3. find the highest audience match. Return match_no, play_stage, goal_score, audience.*/
select *from match_mast;
select max(audence) from match_mast;
##using subquery
select match_no,play_stage,goal_score,audence from match_mast
	where audence in (select max(audence) from match_mast);
    
##order by with limit
select match_no,play_stage,goal_score,audence from match_mast
	order by audence desc limit 1;

##join with the sbquery
select match_no,play_stage,goal_score,audence from match_mast a
	join (select max(audence) as max_audience from match_mast) b
    on a.audence = b.max_audience;
  
  
/*4. find the match number in which Germany played against Poland. Group the result set on match number. 
Return match number.*/
select match_no from match_details 
	where team_id in (select country_id from soccer_country 
		where country_name = 'Germany')
	or team_id in (select country_id from soccer_country 
		where country_name = 'poland')
        group by match_no
        having count(distinct team_id) = 2;

##using join 
select match_no from match_details m
	join soccer_country s on s.country_id = m.team_id
    and s.country_name in('germany','poland')
    group by match_no
    having count(distinct team_id) = 2;
    
##using exists
select match_no from match_details m
	where exists (select 1 from soccer_country s
		where s.country_id = m.team_id
        and s.country_name in ('germany','poland'))
        group by m.match_no
        having count(distinct team_id) = 2;

#using intersect
select match_no from match_details
	where team_id = (select country_id from soccer_country
		where country_name in ('Germany','poland'))
        group by match_no 
        having count(distinct team_id) =2;
        

/*5.find the result of the match where Portugal played against Hungary.*/

select mm.match_no,mm.play_stage,mm.play_date,mm.results,mm.goal_score from match_mast mm
	where mm.match_no = (select match_no from match_details md
		where md.team_id in (select country_id from soccer_country s
			where s.country_name in ('portugal','hungary'))
            );
##using join with where
select mm.match_no,mm.play_stage,mm.play_date,mm.results,mm.goal_score from match_mast mm
	join match_details md on md.match_no = mm.match_no
    join soccer_country s on s.country_id = md.team_id
    where s.country_name in ('portugal','hungary')
    group by mm.match_no
    having count(distinct md.team_id) = 2;

/*6.find the players who scored the most goals in each match.
 Group the result set on match number, country name and player name.
 Sort the result-set in ascending order by match number. Return match number, country name, player name and number of matches*/
 use soccer;
 select match_no,country_name,player_name,count(match_no) from goal_details g,soccer_country s,player_mast p
	where g.team_id = s.country_id
    and g.player_id = p.player_id
    group by match_no,country_name,player_name
    order by match_no;
    
#Using INNER JOIN and GROUP BY:
select match_no,country_name,player_name,count(match_no) from goal_details g
	join soccer_country s on s.country_id = g.team_id
    join player_mast p on p.player_id = g.player_id
    group by match_no,country_name,player_name
    order by match_no;
    

/*7. find the highest audience match. Return country name of the teams.*/
##Using JOIN and WHERE:
select distinct country_name from soccer_country s
	join goal_details g on g.team_id = s.country_id
		where g.match_no in (select m.match_no from match_mast m
			where m.audence = (select max(audence) from match_mast));
    
# using subqueries
select country_name from soccer_country
	where country_id in (select team_id from goal_details
		where match_no = (select match_no from match_mast 
			where audence in (select max(audence) from match_mast)));
            
#Using EXISTS:
select country_name from soccer_country s
	where exists (select 1 from goal_details g
		where g.team_id = s.country_id 
        and exists (select 1 from match_mast m
			where m.match_no = g.match_no
            and m.audence= (select max(audence) from match_mast)));
	

/*8.find the player who scored the last goal for Portugal against Hungary. Return player name.*/
select player_name from player_mast 
	where player_id = (select player_id from goal_details 
		where match_no = (select match_no from match_details
			where team_id in (select country_id from soccer_country 
				where country_name = 'hungary'
                or team_id = (select country_id from soccer_country
					where country_name = 'portugal')
                    group by match_no  having count(team_id) =2
				)));
                
#using join and subquery
SELECT pm.player_name
FROM player_mast pm
JOIN goal_details gd ON pm.player_id = gd.player_id
JOIN match_details md ON gd.match_no = md.match_no
JOIN soccer_country sc ON md.team_id = sc.country_id
JOIN soccer_team st ON sc.country_id = st.team_id
WHERE md.match_no = (
    SELECT md.match_no
    FROM match_details md
    JOIN soccer_country sc ON md.team_id = sc.country_id
    WHERE sc.country_name IN ('Hungary', 'Portugal')
    GROUP BY md.match_no
    HAVING COUNT(DISTINCT sc.country_id) = 2
)
AND sc.country_name = 'Portugal'
AND gd.goal_time = (
    SELECT MAX(gd.goal_time)
    FROM goal_details gd
    JOIN match_details md ON gd.match_no = md.match_no
    JOIN soccer_country sc ON md.team_id = sc.country_id
    JOIN soccer_team st ON sc.country_id = st.team_id
    WHERE md.match_no = (
        SELECT md.match_no
        FROM match_details md
        JOIN soccer_country sc ON md.team_id = sc.country_id
        WHERE sc.country_name IN ('Hungary', 'Portugal')
        GROUP BY md.match_no
        HAVING COUNT(DISTINCT sc.country_id) = 2
    )
    AND sc.country_name = 'Portugal'
    AND gd.team_id = st.team_id
);


/*9.find the second-highest stoppage time in the second half.*/
select stop2_sec from match_mast 
	where stop2_sec in (select max(stop2_sec) from match_mast
		where stop2_sec <(select max(stop2_sec) from match_mast));
        
#another way
select max(stop2_sec) from match_mast 
	where stop2_sec <> (select max(stop2_sec) from match_mast);
    
#Using a Subquery and NOT IN:
select max(stop2_sec) from match_mast 
	where stop2_sec not in (select max(stop2_sec) from match_mast );
    
    
/*10.find the teams played the match where the second highest stoppage time had been added in the second half of play. 
Return country name of the teams.*/
select country_name from soccer_country s
	where s.country_id in (select team_id from match_details md
		where md.match_no = (select match_no from match_mast mm
			where mm.stop2_sec in(select max(stop2_sec) from match_mast mm1
				where mm1.stop2_sec not in (select max(stop2_sec) from match_mast))));
                
#Using Subqueries and JOIN:
select country_name from soccer_country s
	join match_details md on md.team_id = s.country_id
    where md.match_no in (select match_no from match_mast mm
		where mm.stop2_sec in (select max(stop2_sec) from match_mast
			where stop2_sec <> (select max(stop2_sec) from match_mast)));
            
#another way
select country_name from soccer_country sc
	join match_details md on md.team_id = sc.country_id 
    join match_mast mm on mm.match_no = md.match_no
    where mm.stop2_sec = (select max(stop2_sec) from match_mast 
		where stop2_sec not in (select max(stop2_sec) from match_mast));
        
        
/*11.find the teams played the match where second highest stoppage time had been added in second half of play.
 Return match_no, play_date, stop2_sec.*/
 select match_no,play_date,stop2_sec from match_mast
	where stop2_sec in (select max(stop2_sec) from match_mast
		where stop2_sec not in (select max(stop2_sec) from match_mast));

#Using Subquery with Correlation:
select match_no,play_date,stop2_sec from match_mast a
	where (select count(distinct b.stop2_sec) from match_mast b
		where b.stop2_sec > a.stop2_sec) =1;
use soccer;
        
/* 12. find the team, which was defeated by Portugal in EURO cup 2016 final. Return the country name of the team*/
select country_name from soccer_country 
	where country_id in (select team_id from match_details 
		where play_stage = 'F' 
        and team_id <> (select country_id from soccer_country
			where country_name = 'Portugal'));
##using join and where clause
select country_name from soccer_country s
	join match_details m on m.team_id = s.country_id
    and m.play_stage = 'F'
    and team_id <> (select country_id from soccer_country where country_name = 'portugal');
#using exists
select country_name from soccer_country s
	where exists (select 1 from match_details m
		where m.team_id = s.country_id and m.play_stage = 'F')
        and s.country_id <> (select country_id from soccer_country
			where country_name = 'portugal');
#using joins with subquery
select country_name from soccer_country s
	join match_details m on m.team_id = s.country_id
    and m.play_stage = 'F'
    where s.country_id not in (select country_id from soccer_country
		where country_name = 'Portugal');
        
/* 13. find the club, which supplied the most number of players to the 2016-EURO cup. Return club name, number of players.*/
select playing_club,count(playing_club) from player_mast
	group by playing_club
    having count(playing_club) = (select max(mycount) 
		from (select playing_club,count(playing_club)mycount from player_mast
			group by playing_club)pm
);

##using windows functions
select playing_club,mycount from 
	(select playing_club,count(playing_club) mycount,
		rank() over(order by playing_club desc) rnk 
	from player_mast
	group by playing_club
	)ranked
where rnk = 1;

use soccer;

/* 14. find the player who scored the first penalty of the tournament. Return player name and Jersey number.*/
select player_name,jersey_no from player_mast
	where player_id = (select player_id from goal_details 
		where goal_type = 'p'
        and match_no = (select min(match_no) from goal_details
			where goal_type = 'P' and play_stage = 'g'));
       
        