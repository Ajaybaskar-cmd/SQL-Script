/* 10 exercise for basic queries for movie database*/
/*1 return movie title and movie year*/
use movie;
show tables;
select *from movie;

select mov_title,mov_year from movie;

/*2 find the american movie release year*/
select mov_year from movie where mov_title like '%american beauty';
/*or*/
select mov_year from movie where mov_title='american beauty';

/*3 find the movie in released year =1999*/
select mov_title from movie where mov_year=1999;

/* 4. find the movie released before 1998 */
select mov_title from movie where mov_year<1998;

/*5. find the name of all reviewer and movies in single list */
/* use union */
select reviewer.rev_name from reviewer 
union 
select movie.mov_title from movie;

/* 6.find all reviewer rated 7 or more rating */
select reviewer.rev_name from reviewer,rating where
reviewer.rev_id=rating.rev_id
and rating.rev_stars>=7
and reviewer.rev_name is not null;

/*7. find the movies without any ratings*/
select mov_title from movie where
mov_id not in(
/* sub queries*/
select mov_id from rating);

/* find the movie with id 905 or 907 or 917 */
select mov_title from movie where mov_id=905 
or mov_id = 907 or mov_id =917;

/*or*/
select mov_title from movie where mov_id in (905,907,917);

/*9 find the movie word 'boogie nights' result in ascending order */
select mov_id,mov_title,mov_year from movie where
mov_title like '%boogie nights'
order by mov_year asc;

/*10 find the actor_id where frst name 'woody' lname ='allen'*/

select act_id from actor where act_fname='woody' and act_lname='allen';



