use world_layoffs;
show tables;


select *from layoffs;

## 1. Remove duplicates
## 2.Standardize the data
## 3. Null values or blank values
## 4. Remove any columns

 create table layoffs_staging
 like layoffs;
 
 select *from layoffs_staging;
 
 ## find the duplicates
 with duplicate_cte as 
(
	select *,
    ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,
    'date',stage,country,funds_raised_millions) as row_num
    from layoffs_staging
)
select *from duplicate_cte
where row_num>1;

select *from layoffs_staging where company='zymergen';
show tables;
drop database world_layoffs;

    
 #Insert the value from layoffs
 
 insert layoffs_staging
 select *from layoffs;
 
 create database world_layoffs;