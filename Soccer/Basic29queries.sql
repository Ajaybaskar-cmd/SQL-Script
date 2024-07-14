show databases;
use soccer;
show tables;
select *from player_mast;
select *from refree_mast;

##--------------------------------------------------------------------##
use soccer;
/*1.count the number of venues for EURO cup 2016. */
select count(*)from soccer_vanue;

/*2.count the number of countries that participated in the 2016-EURO Cup.*/
select count(distinct team_id) from player_mast;

/*3.find the number of goals scored within normal play during the EURO cup 2016.*/
select *from goal_details;

select count(*) from goal_details;

/*4.find the number of matches that ended with a result.*/
select * from match_mast;
alter table match_mast drop column `index`;

select count(*) from match_mast where results= 'Win';

/* 5.find the number of matches that ended in draws.*/
select count(*) from match_mast where results= 'draw';

/*6.find out when the Football EURO cup 2016 will begin.*/
select play_date as beginning_date from match_mast 
	where match_no = 1;
    
/*7.find the number of self-goals scored during the 2016 European Championship.*/
select *from goal_details;

select count(*) from goal_details where goal_type = 'o';

/* 8.count the number of matches ended with a results in-group stage.*/
select count(match_no) from match_mast where play_stage = 'g'
	and results = 'win';
    
/*9.find the number of matches that resulted in a penalty shootout.*/
select * from penalty_shootout;
select count(distinct match_no) from penalty_shootout;

/*10 .find number of matches decided by penalties in the Round 16.*/
select *from match_mast;

select count(*) from match_mast where decided_by = 'p'
	and play_stage = 'r';
    
/*11. find the number of goals scored in every match within a normal play schedule. Sort the result-set on match number. 
Return match number, number of goal scored.*/
select *from goal_details;

select match_no,count(goal_type) from goal_details
	group by match_no;
    
/*12.find the matches in which no stoppage time was added during the first half of play. 
Return match no, date of play, and goal scored.*/
select *from match_mast;

select match_no,play_date,goal_score from match_mast where stop1_sec = 0;

/*13. count the number of matches that ended in a goalless draw at the group stage. 
Return number of matches.*/

select *from match_details;

select count(distinct(match_no)) from match_details where win_lose = 'd'
	and goal_score = 0
    and play_stage = 'g';
    
/*14.calculate the number of matches that ended in a single goal win, excluding matches decided by penalty shootouts.
 Return number of matches*/
 select *from match_details;
 select count(goal_score) from match_details 
	where win_lose = 'win'
    and goal_score = 1
    and decided_by <>'p';

/* 15.count the number of players replaced in the tournament. Return number of players as "Player Replaced".*/

use soccer;
select *from player_in_out;
select count(*) as 'player replaced' from player_in_out 
	where in_out = 'I';
    
/*16.count the total number of players replaced during normal playtime. Return number of players as "Player Replaced".*/
select count(*) from player_in_out 
	where in_out = 'I' and play_schedule = 'NT';
    
/*17. count the number of players who were replaced during the stoppage time. Return number of players as "Player Replaced".*/
select *from player_in_out;
select count(*) as 'player replaced' from player_in_out
	where in_out = 'I' and play_schedule = 'ST';
    
/*18.count the number of players who were replaced during the first half. Return number of players as "Player Replaced".*/
select count(*) from player_in_out 
	where in_out = 'o' and play_half = 1
    and play_schedule = 'NT';
    
/*19.count the total number of goalless draws played in the entire tournament. Return number of goalless draws.*/
select *from match_details;
select count(distinct match_no) from match_details
	where goal_score = 0
    and win_lose = 'd';

/*20.calculate the total number of players who were replaced during the extra time.*/
select *from player_in_out ;
select distinct play_schedule from player_in_out;
select count(player_id) from player_in_out 
	where in_out='i'
    and play_schedule = 'et';

/*21. count the number of substitutes during various stages of the tournament.*/
select *from player_in_out;
select play_half,play_schedule,count(*) from player_in_out
	where in_out='i'
    group by play_half,play_schedule
    order by play_half,play_schedule,count(*);
    
/*22.count the number of shots taken in penalty shootouts matches. Number of shots as "Number of Penalty Kicks".*/
select *from penalty_shootout;
select count(*) from penalty_shootout;

/*23. count the number of shots that were scored in penalty shootouts matches. 
Return number of shots scored goal as "Goal Scored by Penalty Kicks".*/

select count(*) from penalty_shootout 
	where score_goal = 'y';
