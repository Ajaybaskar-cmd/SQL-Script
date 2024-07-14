use movie;
show tables;
desc movie;

/* insert into movie table values */
insert into movie values(901,'Vertigo',1958,128,'English',19580824,'UK');
select *from movie;
insert into movie values(902,'The innocents',1961,100,'English',19620219,'SW'),
(903,'Lawrrence of arabia',1962,216,'English',19621211,'UK'),
(904,'The deer hunter',1978,183,'English',19790308,'UK'),
(905,'Amadeous',1984,160,'English',19850107,'UK'),
(906,'Blade runner',1982,117,'English',19820909,'UK');
select *from movie;
insert into movie values(907,'Eyes wide shut',1999,159,'English',19990909,'UK');
select *from movie;
insert into movie values(908,'The usual suspects',1995,106,'English',19950825,'UK'),
(909,'China town',1974,130,'English',19740809,'UK'),
(910,'Boogie nights',1997,155,'English',19980216,'UK'),
(911,'Annie hall',1977,93,'English',19770420,'USA'),
(912,'Princess mononoke',1997,134,'Japanese',20011019,'UK'),
(913,'The shawshank redemption',1994,142,'English',19950217,'UK');
select *from movie;
insert into movie values(914,'American beauty',1999,122,'English',19990909,'UK');
use movie;
select *from movie;
insert into movie values(915,'Titanic',1997,194,'English',19980123,'UK'),
(916,'Good will hunting',1997,126,'English',19980603,'UK'),
(917,'Deliverence',1972,109,'English',19821005,'UK'),
(918,'Trainspotting',1996,94,'English',19960223,'UK'),
(919,'The prestige',2006,130,'English',20061110,'UK'),
(920,'Donnie darko',2001,113,'English',20010101,'UK'),
(921,'Slumdog millionaire',2008,120,'English',20090109,'UK'),
(922,'Aliens',1986,137,'English',19860829,'Uk'),
(923,'Beyond the sea',2004,118,'English',20041126,'UK'),
(924,'Avatar',2009,162,'English',20091217,'UK'),
(925,'Braveheart',1995,178,'English',19950908,'UK'),
(926,'Seven samurai',1954,207,'Japanese',19540426,'JP'),
(927,'Spirited away',2001,125,'Japanese',20030912,'UK'),
(928,'Back to the future',1985,116,'English',19851204,'UK');
select *from movie;

/* create table in reviewer */
create table reviewer(rev_id int,rev_name varchar(30));
desc reviewer;

/*insert into values for reviewer*/
insert into reviewer values(9001,'Righty stock'),
(9002,'Jack malvern');
select *from reviewer;
use movie;
show tables;
insert into reviewer values(9003,'Flagrant Baronessa'),
(9004,'Alec shaw');
insert into reviewer(rev_id) values(9005);
select *from reviewer;
insert into reviewer values(9006,'Victor woeltjen'),
(9007,'Simon wright'),
(9008,'Neal wruck'),
(9009,'Paul monks'),
(9010,'Mike salvati');
insert into reviewer(rev_id) values(9011);
insert into reviewer values(9012,'Wesley s.walker'),
(9013,'Sasha goldshtein'),
(9014,'Josh cates'),
(9015,'Krug stillo'),
(9016,'Scott lebrun'),
(9017,'Hannah steele'),
(9018,'Vincent cadena'),
(9019,'Brandt sponseller'),
(9020,'Richad adams');

select *from reviewer; 

/*create table in rating*/
create table rating(
mov_id int,
rev_id int,
rev_stars float,
num_o_ratings double);
show tables;

/*insert into values for rating*/
insert into rating values(901,9001,8.40,263575),
(902,9002,7.90,20207),
(903,9003,8.30,202778),
(906,9005,8.20,484746),
(924,9006,7.30,null);
select *from rating;

insert into rating values(908,9007,8.60,779489),
(909,9008,null,227235),
(910,9009,3.00,195661),
(911,9010,8.10,203875),
(912,9011,8.40,null),
(914,9013,7.00,862618),
(915,9001,7.70,830095),
(916,9014,4.00,642132),
(925,9015,7.70,81328),
(918,9016,null,580301),
(920,9017,8.10,609451),
(921,9018,8.00,667758),
(922,9019,8.40,511613),
(923,9020,6.70,13091);

select *from rating;

/*create table actor*/
create table actor(
act_id int,
act_fname varchar(15),
act_lname varchar(10),
act_gender varchar(5));
/*insert into values for actor*/
insert into actor values(101,'James','Stewert','M'),
(102,'Deborah','Kerr','F'),
(103,'Peter','OToole','M'),
(104,'Robert','De niro','M'),
(105,'F.murray','Abraham','M'),
(106,'Harrison','Ford','M'),
(107,'Nicole','Kidman','F'),
(108,'Stephen','Baldwin','M'),
(109,'Jack','Nicholson','M'),
(110,'Mark','Wahlberg','M'),
(111,'Woody','Allen','M'),
(112,'Claire','Danes','F'),
(113,'Tim','Robbins','M'),
(114,'Kevin','Spacey','M'),
(115,'Kate','Winslet','F'),
(116,'Robin','Williams','M'),
(117,'Jon','Voight','M'),
(118,'Ewan','Mcgregor','M'),
(119,'Christian','Bale','M'),
(120,'Maggie','Gyllenhall','F'),
(121,'Dev','Patel','M'),
(122,'Sigourney','Weaver','F'),
(123,'David','Aston','M'),
(124,'Ali','Astin','F');

select *from actor;
use movie;

/*create table movie_cast*/
create table movie_cast(
act_id int,
mov_id int,
role varchar(30));
desc movie_cast;

/*insert the values for movie cast*/
insert into movie_cast values(101,901,'John scottie ferguson'),
(102,902,'Miss Giddens'),
(103,903,'T.E.Lawrence'),
(104,904,'Michael'),
(105,905,'Antonio Salieri'),
(106,906,'Rick deckard'),
(107,907,'Alice Harford'),
(108,908,'Mcmanus'),
(110,910,'Eddie adams'),
(111,911,'Alvy singer'),
(112,912,'San'),
(113,913,'Andy Dufresne'),
(114,914,'Lester Burnham'),
(115,915,'Rose dewitt bukater'),
(116,916,'Sean maguire'),
(117,917,'Ed'),
(118,918,'Renton'),
(119,919,'Alfred Borden'),
(120,920,'Elizabeth Darko'),
(121,921,'Older jamal'),
(122,922,'Ripley'),
(114,923,'Bobby darin'),
(109,909,'J.J.Gittes');

select *from movie_cast;

/*create the table for director*/
create table director(
dir_id int,
dir_fname varchar(30),
dir_lname varchar(30));

/*insert the values for director*/
insert into director values(201,'Alfred','Hitchcock'),
(202,'Jack','Clayton'),
(203,'David','Lean'),
(204,'Michael','Cimino'),
(205,'Milos','Forman'),
(206,'Ridley','Scott'),
(207,'Stanley','Kubrick'),
(208,'Brayan','singer'),
(209,'Roman','Polanski'),
(210,'Paul','Thomas andreson'),
(211,'Woody','Allen'),
(212,'Hayao','Miyazaki'),
(213,'Frank','Darabont'),
(214,'Sam','Mendes'),
(215,'James','Cameron'),
(216,'Gus','Van sunt'),
(217,'John','Boorman'),
(218,'Danny','Boyle'),
(219,'Christoper','Nolan'),
(220,'Richard','Kelly'),
(221,'Kevin','Spacey'),
(222,'Andrei','Tarkovsky'),
(223,'Peter','Jackson');

select *from director;

/*create the table for movie_direction*/
create table movie_direction(
dir_id int,
mov_id int);

/*insert the value for movie direction*/
insert into movie_direction values(201,901),
(202,902),(203,903);
select *from movie_direction;

insert into movie_direction values(204,904),
(205,905),(206,906),(207,907),(208,908),
(209,909),(210,910),(211,911),(212,912),
(213,913),(214,914),(215,915),(216,916),
(217,917),(218,918),(219,919),(220,920),
(218,921),(215,922),(221,923);

select *from movie_direction;

/* create the table of movie genres */
create table movie_genres (
mov_id int,
gen_id int);

desc movie_genres;

/* insert the values of movie genres */
insert into movie_genres values(922,1001),(917,1002),(903,1002),(912,1003),
(911,1005),(908,1006),(913,1006),(926,1007),(928,1007),(918,1007),
(921,1007),(902,1008),(923,1009),(907,1010),(927,1010),(901,1010),(914,1011),
(906,1012),(904,1013);

select *from movie_genres;

/* create the table for genres movie type */
create table genres (gen_id int,
gen_title varchar(30));

##insert the values from genres table
insert into genres values (1001,'Action'),(1002,'Adventure'),(1003,'Animation'),
(1004,'Biography'),(1005,'Comedy'),(1006,'Crime'),(1007,'Drama'),(1008,'Horror'),
(1009,'Music'),(1010,'Mystery'),(1011,'Romance'),(1012,'Thriller'),(1013,'War');

select *from genres;











