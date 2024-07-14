use movie;

/* SUBQUERIES 16 EXERCISES */
/* 1.Find the actor who played role in ANNIE HALL */
select *from actor where 
	act_id in(select act_id from movie_cast where
		mov_id in(select mov_id from movie where mov_title='annie hall'));
        
/*2.When release the movie_year i 'American beauty' */
select mov_year from movie where mov_title='american beauty';

/*3.Find the movie in released in 1999 */
select mov_title from movie where mov_year=1999;

/*4.find the movie from released in before 1998 */
select mov_title from movie where mov_year<1998;

/*5.find the name of all reviewers and movies in single list */
select reviewer.rev_name from reviewer,movie union 
select movie.mov_title from movie;

/*2.find the director of film cast role in 'Eye wideshut' */
select dir_fname,dir_lname from director
   where dir_id in(select dir_id from movie_direction 
      where mov_id in(select mov_id from movie_cast where role=any
        (select role from movie_cast 
           where mov_id in (select mov_id from movie where mov_title='Eyes wide shut'))));
           
           
/*3.find movie in not released movie in uk */
select mov_title,mov_year,mov_time,mov_dt_rel as date_of_release,
  mov_rel_country as Releasing_country from movie where mov_rel_country not in ('uk');
  
  /* or */
  select *from movie m  /* another name use of m */
  where not exists(select 1 from movie where mov_rel_country='uk' and mov_id =m.mov_id);
  
/*find for movies who reviewer is unknown */

select mov_title,mov_year,mov_dt_rel,dir_fname,dir_lname,act_fname,act_lname
  from movie a,movie_direction b,director c,rating d,reviewer e,actor f,movie_cast g
    where a.mov_id=b.mov_id
	  and b.dir_id=c.dir_id
      and a.mov_id=d.mov_id
      and d.rev_id=e.rev_id
      and a.mov_id=g.mov_id
      and g.act_id=f.act_id
      and e.rev_name is null;

/* alternative solution join the table */
select  a.mov_title,a.mov_year,a.mov_dt_rel,c.dir_fname,c.dir_lname,f.act_fname,f.act_lname
   from movie a
   join movie_direction b on a.mov_id = b.mov_id
   join director c on b.dir_id = c.dir_id
   join rating d on a.mov_id = d.mov_id
   join reviewer e on d.rev_id=e.rev_id
   join movie_cast g on a.mov_id = g.mov_id
   join actor f on g.act_id = f.act_id
   where e.rev_name is null;
   
   
/* 5. find the movie director directed by the woody allen */
select mov_title from movie 
  where mov_id in (select mov_id from movie_direction 
      where dir_id in (select dir_id from director 
        where dir_fname = 'woody' and dir_lname = 'allen'));
        
## using for join the tables another option
select m.mov_title from movie m
  join movie_direction md on m.mov_id=md.mov_id
  join director d on md.dir_id = d.dir_id
   where d.dir_fname='woody' and d.dir_lname='allen';
   
##using exists
select mov_title from movie m 
  where exists (select 1 from movie_direction md
    join director d on md.dir_id = d.dir_id
    where md.mov_id = m.mov_id
    and d.dir_fname='woody' and d.dir_lname='allen');
    
## using scalar subquery
select mov_title from movie 
  where mov_id in (select mov_id from movie_direction 
    join director on director.dir_id = movie_direction.dir_id
    where director.dir_fname='woody');
    
/*6 those years at least one movie received from three stars */
select distinct mov_year from movie 
  where mov_id in (select mov_id from rating 
    where rev_stars>=3);
    
##using exists
select distinct mov_year from movie m
  where exists (select 1 from rating r
  where m.mov_id=r.mov_id and r.rev_stars>=3)
   order by mov_year;
##inner join
select distinct mov_year from movie m
  join rating r on m.mov_id = r.mov_id 
  where r.rev_stars>3 order by m.mov_year;
  
  /*7. query to search for do not have any ratings */
  select mov_title from movie 
    where mov_id not in(select mov_id from rating);
    
##using join
select mov_title from movie 
 left join rating on movie.mov_id=rating.mov_id
	where rating.mov_id is null;
##using not exists
select mov_title from movie 
	where not exists (select 1 from rating
		where movie.mov_id = rating.mov_id);
        
/*8.fond those reviewers who have not given to certain films */
select rev_name from reviewer 
	where rev_id in (select rev_id from rating
		where rev_stars is null);
        
##using join 
select rev_name from reviewer r
	join rating ra on r.rev_id =ra.rev_id
		where rev_stars is null;
        
##using exists
select rev_name from reviewer r
	where exists (select 1 from rating ra
		where r.rev_id = ra.rev_id and ra.rev_stars is null);

/*9.find the movies reviewed by reviewer have been received by rating sort the result -set in ascending order */
select rev_name,mov_title,rev_stars from movie,reviewer,rating
	where reviewer.rev_id = rating.rev_id
    and movie.mov_id=rating.mov_id 
    and reviewer.rev_name is not null
    and rating.rev_stars is not null
order by rev_name,mov_title,rev_stars;

##using join
select r.rev_name,m.mov_title,ra.rev_stars from reviewer r
	join rating ra on ra.rev_id = r.rev_id
    join movie m on m.mov_id = ra.mov_id
    where r.rev_name is not null
    and ra.rev_stars is not null
    order by r.rev_name,ra.rev_stars,m.mov_title;

##using join subqueries
select r.rev_name,m.mov_title,ra.rev_stars 
	from (select *from reviewer where rev_name is not null) r
		join (select *from rating where rev_stars is not null) ra on r.rev_id = ra.rev_id 
        join movie m on m.mov_id = ra.mov_id
	order by r.rev_name,ra.rev_stars,m.mov_title;
    
/*10.fond the movies have reviewed by reviewer and received a rating group set on reviewer name movie title */
select rev_name,mov_title from movie,reviewer,rating,rating r
	where rating.mov_id=movie.mov_id
    and reviewer.rev_id=rating.rev_id
    and rating.rev_id=r.rev_id
    group by reviewer.rev_name,movie.mov_title
    having count(*)>1;
    
##using inner join
select r.rev_name,mov_title from reviewer r
	inner join rating on r.rev_id = rating.rev_id
    inner join movie m on rating.mov_id = m.mov_id
    inner join rating ra on ra.rev_id = rating.rev_id
    group by r.rev_name,m.mov_title 
    having count(*)>1;

use movie;

/* 11. find the movies which have highest stars group the movie title and sort the movie name */
select mov_title,max(rev_stars) as max FROM movie,rating
	where movie.mov_id = rating.mov_id 
    and rev_stars is not null
    group by mov_title
    order by mov_title asc;
    
##using inner join
select mov_title,max(rev_stars) as max from movie m
	join rating r on m.mov_id = r.mov_id
		where r.rev_stars is not null
		group by m.mov_title
        order by m.mov_title asc;
/*12 .find the all reviewers who rated the movie in 'american beauty' */
select rev_name from reviewer 
	where rev_id in (select rev_id from rating 
		where mov_id in (select mov_id from movie
			where mov_title = 'american beauty'));
            
##equal to method
select r.rev_name from reviewer r,rating ra,movie m
	where r.rev_id = ra.rev_id
    and ra.mov_id = m.mov_id
    and m.mov_title like '%american%';
##using inner join
select r.rev_name from reviewer r
	inner join rating ra on r.rev_id = ra.rev_id 
    inner join movie m on m.mov_id = ra.mov_id
    where m.mov_title = 'american beauty';
/*13.find the movies that have not reviewed by any reviewer body 'paul monks' */
select mov_title from movie
	where mov_id in (select mov_id from rating
		where rev_id not in (select rev_id from reviewer
			where rev_name = 'paul monks'));
	
##using inner join
select mov_title from movie m
	join rating ra on m.mov_id = ra.mov_id
    where ra.rev_id not in (select rev_id from reviewer 
		where rev_name='paul monks');

/*14.find the movies from lowest ratings  where rev_name ,mov_title ,rev_stars*/
select r.rev_name,m.mov_title,ra.rev_stars from reviewer r, rating ra,movie m
	where ra.rev_stars =(select min(rev_stars) from rating)
    and ra.rev_id = r.rev_id 
    and ra.mov_id= m.mov_id;

##using join and subquery
select r.rev_name,m.mov_title,ra.rev_stars from reviewer r
	join rating ra on ra.rev_id = r.rev_id
    join movie m on m.mov_id = ra.mov_id
    where ra.rev_stars=(select min(rev_stars) from rating);
use movie;

/* 15. find the movies from directed by 'james cameron */
select mov_title from movie 
	where mov_id in (select mov_id from movie_direction 
		where dir_id in (select dir_id from director 
        where dir_fname = 'james'
        and dir_lname = 'cameron'));
##using join
select mov_title from movie m
	join movie_direction md on md.mov_id = m.mov_id 
    join director d on d.dir_id=md.dir_id
		where d.dir_fname like '%james' and d.dir_lname like '%cameron';
##using exists
select m.mov_title from movie m
	where exists (select 1 from movie_direction md 
    join director d on d.dir_id=md.dir_id
    where md.mov_id=m.mov_id and d.dir_fname='james' and d.dir_lname='cameron');

/*16 .find the movies which one or more actor appeared the one film */
select mov_title from movie 
	where mov_id in (select mov_id from movie_cast
		where act_id in (select act_id from movie_cast group by act_id
        having count(act_id)>1));
##using inner join
select mov_title from movie m
	join movie_cast mc on mc.mov_id = m.mov_id
    join actor a on a.act_id = mc.act_id
		where a.act_id in (select act_id from movie_cast
        group by act_id having count(act_id)>1);