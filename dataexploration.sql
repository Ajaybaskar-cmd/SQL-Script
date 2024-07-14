/* EXPLORATORY DATA ANALYSIS */
use world_layoffs;
show tables;

select *from stage2;

select max(total_laid_off) from stage2;

select *from stage2 where percentage_laid_off=1;

select company,sum(total_laid_off) from stage2 
	group by company
    order by 2 desc;

select *from stage2;

select company,sum(total_laid_off) from stage2
group by company
order by 2 desc;

select company,industry,sum(total_laid_off) from stage2 
group by industry ,company
order by 3 desc;

select YEAR(`date`),sum(total_laid_off) from stage2
group by `date`
order by 1 desc;

select substring(`date`,1,7) as `month`,sum(total_laid_off)
from stage2
where substring(`date`,6,2) is not null
group by `month`
order by 1 ;

with rolling as
(
	select substring(`date`,1,7) as `month`,sum(total_laid_off) as total_off
    from stage2 
    where substring(`date`,1,7) is not null
    group by `month`
    order by 1
)
select `month`,total_off,sum(total_off) over(order by `month`) as rolling_total
from rolling;

select company,YEAR(`date`),sum(total_laid_off) 
from stage2
group by company,YEAR(`date`)
order by 1;

with company_year(company,years,total_laid_off) as 
(
	select company,YEAR(`date`),sum(total_laid_off)
    from stage2
    group by company,YEAR(`date`)
),
company_year_rank as
(
select *,dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select *from company_year_rank
where ranking <=5;