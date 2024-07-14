use world_layoffs;
show tables;
select *from layoffs;

##Cleaning process
##1. Remove Duplicates
##2. Standardize the data
##3. Null values or Blank values
##4. Remove any columns

##Any problem to change orginal data so copy to create the new table
create table stage like layoffs;
select *from stage;
##insert the vlaues for the old table to new table

insert stage 
	select *from layoffs;
select *from stage;

/* REMOVE THE DUPLICATES */

##first find the duplicate;
select *,row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,
stage,country,funds_raised_millions,`date`) as row_num
from stage;

## using ctes function find the duplicates
with duplicate_cte as 
(
	select *,row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,
	stage,country,funds_raised_millions,`date`) as row_num
	from stage
)
select *from duplicate_cte where row_num>1;

select *from stage where company='cazoo';

## i have to delete the duplicates not respond for cte
## so i create the new_table add column in row _num
CREATE TABLE stage2 (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  row_num int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *from stage2;

##insert the values and into the row number
insert into stage2
	select *,row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,
	stage,country,funds_raised_millions,`date`) as row_num
	from stage;

select *from stage2;

## finally i create the row_number into the table 
## and i will delete the duplicates
select *from stage2 where row_num>1;

##delete the duplicates
delete from stage2 where row_num>1;

##finally i delete the duplicates

/* STANDARDIZE THE DATA */
select *from stage2;
select company,trim(company) from stage2;

##update the company
update stage2 set company=trim(company);

##update the column of industry
select distinct industry from stage2;

select *from stage2 where industry like 'crypto%';

update stage2 set industry='Crypto'
	where industry like 'crypto%';

select *from stage where industry like 'crypto%';
select distinct industry from stage2;

select *from stage2;

select distinct country from stage2 order by 1;

select *from stage2;

select *from stage2 where country like 'united states.';

select distinct country,trim(trailing '.' from country) from stage2 order by 1;

update stage2 set country = trim(trailing '.' from country);

##update the column of date
select `date`,str_to_date(`date`,'%m/%d/%Y') from stage2;

update stage2 set `date`=str_to_date(`date`,'%m/%d/%Y');

select `date` from stage2;

##but is not change in data type
alter table stage2 
	modify column `date` date;
    
/* REMOVE NULL VALUES AND BLANK VALUES */
select *from stage2;

select *from stage2 where company is null;

select *from stage2 where location is null;


select *from stage2 where industry is null or industry ='';

update stage2 set industry = null where industry ='';

select company,industry from stage2 where industry is null;

select *from stage2 where company ="carvana";

select a.company,a.industry,b.company,b.industry from stage2 a	
	join stage2 b on a.company=b.company
    where a.industry is null
    and b.industry is not null;
    
update stage2 a join stage2 b on a.company=b.company
set a.industry = b.industry
where a.industry is null
and b.industry is not null;

select *from stage where industry is null;

select *from stage2 where total_laid_off is null
and percentage_laid_off is null;


delete from stage2 where total_laid_off is null
and percentage_laid_off is null;


alter table stage2
	drop column row_num;
    
/* COMPLETE THE DATA CLEANING PROCESS */

