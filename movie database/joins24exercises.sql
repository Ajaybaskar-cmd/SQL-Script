use movie;

/*1.find the all reviewers whose ratings null values */
select rev_name from reviewer r
	join rating ra on ra.rev_id=r.rev_id
    where ra.rev_stars is null;
    
##website method
select rev_name from reviewer
	inner join rating using(rev_id)
    where rev_stars is null;
##using where
select rev_name from reviewer,rating 
	where reviewer.rev_id = rating.rev_id
    and rating.rev_stars is null;

/*2.find the who was cast in the movie 'annie hall' */
select act_fname,act_lname,role from actor
	join movie_cast on actor.act_id = movie_cast.act_id
    join movie on movie.mov_id = movie_cast.mov_id 
    where movie.mov_title='annie hall';
##using where clause
select a.act_fname,a.act_lname,mc.role from actor a,movie_cast mc,movie m
	where a.act_id=mc.act_id and mc.mov_id = m.mov_id 
    and m.mov_title like '%annie hall%';

/* 3.find the director  who directed features role in 'eye wide shut' */
select dir_fname,dir_lname,mov_title from director d
	natural join movie_direction 
    natural join movie 
    natural join movie_cast 
    where role is not null and mov_title='eye wide shut';

##using inner join
select d.dir_fname,d.dir_lname,m.mov_title from director d
	join movie_direction md on md.dir_id=d.dir_id
    join movie m on m.mov_id=md.mov_id
    join movie_cast mc on mc.mov_id = m.mov_id 
    where mc.role is not null and m.mov_title = 'eyes wide shut';
##where clause
select d.dir_fname,d.dir_lname,m.mov_title from director d,movie_direction md,movie m,movie_cast mc
	where d.dir_id=md.dir_id
    and md.mov_id=m.mov_id
    and m.mov_id=mc.mov_id
    and mc.role is not null
    and m.mov_title = 'eyes wide shut';
use movie;

/* 4.find the director of a movie cast role as Sean maguire */
select dir_fname,dir_lname,mov_title from director
	join movie_direction on movie_direction.dir_id=director.dir_id
    join movie on movie.mov_id=movie_direction.mov_id
    join movie_cast on movie_cast.mov_id=movie.mov_id
    where movie_cast.role='sean maguire';

##where clause
select dir_fname,dir_lname,mov_title from movie m,director d,movie_cast mc,movie_direction md
	where d.dir_id=md.dir_id
    and md.mov_id=m.mov_id
    and m.mov_id=mc.mov_id
    and mc.role='sean maguire';
    
/*5. which actor have not appeared in any movie between 1990 and 2000
	return actor name and movie title,release year */
 select act_fname,act_lname,mov_title,mov_year from movie_cast
	join actor on actor.act_id=movie_cast.act_id
    join movie on movie.mov_id=movie_cast.mov_id
		where movie.mov_year not between 1990 and 2000;

## using where clause
select act_fname,act_lname,mov_title from actor a,movie_cast mc,movie m
	where a.act_id = mc.act_id
    and mc.mov_id = m.mov_id
    and m.mov_year not between 1990 and 2000;
    
/* 6.find the director who have directed films in variety of genres 
		group the results director name and sort ascend order by director name */
	
select dir_fname,dir_lname,gen_title,count(gen_title) from genres g
	join movie_genres mg on mg.gen_id=g.gen_id
    join movie_direction md on md.mov_id=mg.mov_id
    join director d on d.dir_id=md.dir_id
	group by d.dir_fname,d.dir_lname,g.gen_title
    order by d.dir_fname,d.dir_lname asc;

## using NATURAL JOIN
select dir_fname,dir_lname,gen_title,count(gen_title) as 'count' from director
	natural join movie_direction
    natural join movie_genres
    natural join genres
    group by dir_fname,dir_lname,gen_title
    order by dir_fname,dir_lname;
##using where clause
select dir_fname,dir_lname,gen_title,count(gen_title) as 'count'  from director d,movie_genres mg,movie_direction md,genres g
	where d.dir_id=md.dir_id
    and md.mov_id=mg.mov_id
    and mg.gen_id=g.gen_id
	group by d.dir_fname,d.dir_lname,g.gen_title
    order by d.dir_fname,d.dir_lname;

use movie;

/* 7. find movies with year and genres return movie,year,genric title */
select mov_title,mov_year,gen_title from movie m
	join movie_genres mg on mg.mov_id=m.mov_id
    join genres g on g.gen_id=mg.gen_id;
##natural join 
select mov_title,mov_year,gen_title from movie
	natural join movie_genres
    natural join genres;
## where clause
select mov_title,mov_year,gen_title from movie m,movie_genres mg,genres g
	where g.gen_id=mg.gen_id
    and m.mov_id=mg.mov_id;

/* 8. find all movies with year and name of the director */
select mov_title,gen_title,dir_fname,dir_lname from movie
	natural join movie_direction
    natural join movie_genres
    natural join director
    natural join genres;
##using join
select mov_title,mov_year,gen_title,dir_fname,dir_lname from movie m
	join movie_genres mg on mg.mov_id=m.mov_id
    join genres g on g.gen_id=mg.gen_id
    join movie_direction md on md.mov_id=m.mov_id
    join director d on d.dir_id=md.dir_id;
##using where clause
select mov_title,gen_title,dir_fname,dir_lname from movie m,
movie_direction md,movie_genres mg,genres g,director d
	where m.mov_id=mg.mov_id
    and g.gen_id=mg.gen_id
    and m.mov_id=md.mov_id
    and d.dir_id=md.dir_id;

/*9.find all movies released before 1st january 1989 return year,duration,dir_name */
select m.mov_title,m.mov_year,m.mov_dt_rel,d.dir_fname,d.dir_lname from movie m
	join movie_direction md on md.mov_id=md.mov_id
    join director d on d.dir_id=md.dir_id
    where m.mov_dt_rel<'1989-01-01'
    order by mov_dt_rel desc;
    
##using where clause
select m.mov_title,m.mov_year,m.mov_dt_rel,d.dir_fname,d.dir_lname from movie m,director d,movie_direction md
	where m.mov_id=md.mov_id
    and md.dir_id=d.dir_id
    and m.mov_dt_rel > '1989-01-01'
    order by m.mov_dt_rel desc;

/*10.calculate average movie length and count the number of movies */
select g.gen_title,count(g.gen_title),avg(m.mov_time) from movie m
	join movie_genres mg on mg.mov_id=m.mov_id
    join genres g on g.gen_id=mg.gen_id
    group by g.gen_title;

##using natural join 
select gen_title,avg(mov_time),count(gen_title) from movie
	natural join movie_genres
    natural join genres
    group by gen_title;
    
use movie;
    
##using where clause
select g.gen_title,avg(m.mov_time),count(g.gen_title) from movie m,genres g,movie_genres mg
	where m.mov_id=mg.mov_id
    and g.gen_id=mg.gen_id
    group by  g.gen_title;
    
## 11.find the movie with the shortest duration
##return the movie_title,mov_year,director first name,lastname,act_fname,lastname,role

select *from movie;
select mov_title,mov_year,dir_fname,dir_lname,act_fname,act_lname,role from movie m
	join movie_direction md on md.mov_id=m.mov_id
    join director d on d.dir_id=md.dir_id
    join movie_cast mc on mc.mov_id=m.mov_id
    join actor a on a.act_id=mc.act_id
    where mov_time in (select min(mov_time) from movie);
##use for natural join 
select mov_title,mov_year,dir_fname,dir_lname,act_fname,act_lname,role from movie 
	natural join movie_direction
    natural join director
    natural join movie_cast
    natural join actor
    where mov_time=(select min(mov_time) from movie);
##using where clause
select m.mov_title,m.mov_year,d.dir_fname,d.dir_lname,a.act_fname,a.act_lname,mc.role 
	from movie m,movie_direction md,movie_cast mc,actor a,director d
    where m.mov_id=md.mov_id
    and md.dir_id=d.dir_id
    and mc.mov_id=m.mov_id
    and mc.act_id=a.act_id
    and m.mov_time=(select min(mov_time) from movie);
    
## 13.Get the reviewer_name,movie title and stars in on order that reviewer name will come first
select rev_name,mov_title,rev_stars from movie m
	join rating r on r.mov_id=m.mov_id
    join reviewer re on re.rev_id=r.rev_id
    where re.rev_name is not null
    order by re.rev_name,m.mov_title,r.rev_stars;
##using where clause
select re.rev_name,m.mov_title,r.rev_stars from movie m,reviewer re,rating r
	where m.mov_id=r.mov_id
    and r.rev_id=re.rev_id
    and re.rev_name is not null
    order by re.rev_name;
##using natural join
select rev_name,mov_title,rev_stars from movie 
	natural join rating
    natural join reviewer
    where rev_name is not null
    order by rev_name;
##using join and connect the table for using method
select rev_name,mov_title,rev_stars from movie 
	join rating using(mov_id)
    join reviewer using(rev_id)
    where rev_name is not null
    order by rev_name;
    
## 12.Find the years in which movie received rating od 3 or 4
select distinct mov_year from movie
	join rating on rating.mov_id=movie.mov_id
    where rev_stars in (3,4);

##using where clause
select distinct mov_year from movie m,rating r
	where m.mov_id=r.mov_id
    and r.rev_stars =3 and 4;
##using natural join
select distinct mov_year from movie
	natural join rating
    where rev_stars in (3,4);
## connecting method use for using
select distinct mov_year from movie
	join rating using(mov_id)
    where rev_stars in (3,4);

##14.Find the movie that have at least one star and received the most stars
select mov_title,max(rev_stars) from movie
	join rating on movie.mov_id=rating.mov_id
    group by mov_title
    having max(rev_stars) >0
    order by mov_title;
#using where clause
select m.mov_title,max(r.rev_stars) from movie m,rating r
	where r.mov_id=m.mov_id
    group by m.mov_title
    having max(r.rev_stars)>0
    order by m.mov_title;

##15.find out which movie have received rating
select mov_title,dir_fname,dir_lname,rev_stars from movie m
	join movie_direction md on m.mov_id=md.mov_id
    join director d on d.dir_id=md.dir_id
    join rating r on r.mov_id=m.mov_id
    where r.rev_stars is not null;
    
use movie;
##16.find the movie in which one or more actor have acted in more than one film
select mov_title,act_fname,act_lname,role from movie m
	join movie_cast mc on mc.mov_id=m.mov_id
    join actor a on a.act_id=mc.act_id
    where a.act_id in (
		select act_id from movie_cast 
        group by act_id having count(*)>=2);
##using EXISTS clause
select mov_title,act_fname,act_lname,role from movie
	join movie_cast on movie_cast.mov_id=movie.mov_id
    join actor on actor.act_id=movie_cast.act_id
    where exists (select 1 from movie_cast
		where movie_cast.act_id=actor.act_id
        group by movie_cast.act_id having count(*)>=2);
##using self join
select mov_title,act_fname,act_lname,role from movie m
	join movie_cast mc on mc.mov_id=m.mov_id
    join actor a on a.act_id=mc.act_id
    join (
		select act_id from movie_cast
        group by act_id having count(*)>=2
        )as multiple on a.act_id=multiple.act_id;
##17.find the actor whose first name is 'claire' and last name is 'danes'
select dir_fname,dir_lname,mov_title,act_fname,act_lname,role from movie m
	join movie_cast mc on mc.mov_id=m.mov_id
    join actor a on a.act_id=mc.act_id
    join movie_direction md on md.mov_id=m.mov_id
    join director d on d.dir_id=md.dir_id
    where a.act_fname like '%claire%';
##using exists
select dir_fname,dir_lname,mov_title,act_fname,act_lname,role from movie m
	join movie_cast mc on mc.mov_id=m.mov_id
    join actor a on a.act_id=mc.act_id
    join movie_direction md on md.mov_id=m.mov_id
    join director d on d.dir_id=md.dir_id
    where exists (
		select 1 from actor where actor.act_id=a.act_id
        and act_fname like '%claire');
##using self join
select dir_fname,dir_lname,mov_title,act_fname,act_lname,role from movie m
	join movie_cast mc on mc.mov_id=m.mov_id
    join actor a on a.act_id=mc.act_id
    join movie_direction md on md.mov_id=m.mov_id
    join director d on d.dir_id=md.dir_id
    join (select act_id from actor 
		where act_fname = 'claire') as ac on ac.act_id=a.act_id;
##using subquery with in clause
select dir_fname,dir_lname,mov_title,act_fname,act_lname,role from movie m
	join movie_cast mc on mc.mov_id=m.mov_id
    join actor a on a.act_id=mc.act_id
    join movie_direction md on md.mov_id=m.mov_id
    join director d on d.dir_id=md.dir_id
    where (a.act_fname) in ('claire');
    
/* 18. Find the actors whose films have been directed by them */
select act_fname,act_lname,mov_title,role from actor a
	join movie_cast mc on mc.act_id = a.act_id
    join movie m on m.mov_id= mc.mov_id
    join movie_direction md on md.mov_id=m.mov_id
    join director d on d.dir_id=md.dir_id
    where a.act_fname = d.dir_fname
    and a.act_lname=d.dir_lname;
## using self join
select a1.act_fname,a1.act_lname,mov_title,role from actor a1
	join movie_cast mc on mc.act_id=a1.act_id
    join movie m on m.mov_id=mc.mov_id
    join movie_direction md on md.mov_id=m.mov_id
    join director d on d.dir_id=md.dir_id
    join actor a2 on a2.act_fname = d.dir_fname and a2.act_lname = d.dir_lname;

/* 19. Find the cast list of the movie 'china town' */
select a.act_fname,a.act_lname from movie_cast mc 
	join actor a on mc.act_id=a.act_id
    join movie m on m.mov_id=mc.mov_id
    and m.mov_title = 'china town';
## Using exists
select a.act_fname,a.act_lname from movie_cast mc
	join actor a on a.act_id= mc.act_id
    where exists ( select 1 from movie m 
		where m.mov_id = mc.mov_id and m.mov_title = 'China town');
##using join and subquery 
select act_fname,act_lname from actor a
	join movie_cast mc on mc.act_id=a.act_id
    where mov_id in (select mov_id from movie m
		where m.mov_id=mc.mov_id and m.mov_title = 'china town');

/* 20.Find the those movies where actor first name is 'harrison ' return movie_title */
select mov_title from movie m
	join movie_cast mc on mc.mov_id=m.mov_id
    join actor a on a.act_id=mc.act_id and a.act_fname='harrison';

##using join and sub query
select mov_title from movie m
	join movie_cast mc on mc.mov_id = m.mov_id
    where act_id in (select act_id from actor a
		where a.act_fname='harrison');
##using exists
select mov_title from movie m
	join movie_cast mc on mc.mov_id = m.mov_id
    where exists (select 1 from actor a 
    where a.act_id=mc.act_id
    and a.act_fname = 'harrison');

/*21.Find the highest rated movies */
select mov_title,mov_year,rev_stars,mov_rel_country from movie m
	join rating r on r.mov_id=m.mov_id
    where r.rev_stars=(select max(rev_stars) from rating);
##using exists
select mov_title,mov_year,rev_stars,mov_rel_country from movie 
	join rating on rating.mov_id=movie.mov_id
    where rating.rev_stars is not null
    order by rev_stars desc
    limit 1;
## using join and subquery
select mov_title,mov_year,rev_stars,mov_rel_country from movie m
	join rating r on r.mov_id = m.mov_id
    join (select max(rev_stars) as max_star from rating) max on
		r.rev_stars=max.max_star;
	
/* Find the highest rated mystery movies */
select mov_title,mov_year,rev_stars  from movie m
	join movie_genres mg on mg.mov_id=m.mov_id
    join genres g on mg.gen_id=g.gen_id 
	join rating r on r.mov_id=m.mov_id
    where g.gen_title = 'mystery' 
		and r.rev_stars >= all(select rev_stars from rating
			join movie_genres on movie_genres.mov_id = r.mov_id
            join genres on genres.gen_id = movie_genres.mov_id
            where gen_title= 'mystery');

##using subquery with join
select mov_title,mov_year,rev_stars  from movie 
	join movie_genres using(mov_id)
    join genres using(gen_id)
    join rating using(mov_id)
		where gen_title = 'mystery' and rev_stars >=all(
			select rev_stars from rating
            join movie_genres using(mov_id)
            join genres using(gen_id)
				where gen_title = 'mystery');

/*23.shows the year when most of the Mystery movies produces, and number of such movies and their average rating */
select mov_year,gen_title,count(gen_title),round((avg(rev_stars)),4) from movie
	natural join rating
    natural join movie_genres
    natural join genres
    where gen_title = 'mystery'
		group by gen_title,mov_year;

##using self join
select m1.mov_year,g1.gen_title,count(g1.gen_title),round((avg(r1.rev_stars)),4) from movie m1
	join rating r1 on r1.mov_id = m1.mov_id
    join movie_genres mg1 on mg1.mov_id = m1.mov_id
    join genres g1 on g1.gen_id = mg1.gen_id
    join movie m2 on m1.mov_year = m2.mov_year
    join movie_genres mg2 on mg2.mov_id = mg1.mov_id
    join genres g2 on g2.gen_id = g1.gen_id
    where g1.gen_title = 'mystery' and g2.gen_title = 'mystery'
		group by g1.gen_title,m1.mov_year;

/*24.which contain the columns movie title, name of the female actor, year of the movie, role, movie genres, the director, 
date of release, and rating of that movie*/

SELECT mov_title, act_fname, act_lname, 
mov_year, role, gen_title, dir_fname, dir_lname, 
mov_dt_rel, rev_stars from movie
	natural join rating
    natural join movie_genres
    natural join genres
    natural join movie_direction
    natural join director
    natural join movie_cast 
    natural join actor
    where act_gender = 'F';
