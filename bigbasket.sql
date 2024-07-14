use bigbasket;

show tables;

select *from `bigbasket products`;

/* create like this table */

create table bigbasket like `bigbasket products`;
select *from bigbasket;

/* insert the values */

insert bigbasket 
	select * from `bigbasket products`;
    
select *from bigbasket;

/* delete some columns */
alter table bigbasket 
	drop column `description`;

alter table bigbasket 
	drop column `type`;
alter table bigbasket 
	drop column `index`;

select *from bigbasket;

/* finding duplicate values */
select distinct * from bigbasket;

with cte as
(
	select *,row_number() over(partition by product,category,sub_category,brand,sale_price,
    market_price,rating) as row_num from bigbasket
)
select *from cte where row_num>1;
    
select *from bigbasket;

select distinct category from bigbasket order by 1;
select distinct sub_category from bigbasket order by 1;

/* update the column */

select *from bigbasket where sub_category like 'baby%';

select distinct category from bigbasket order by 1;

/* Group by */
select category,sum(sale_price) as total_sale_price,sum(market_price) as total_market_price from bigbasket
	group by category;
    
select *from bigbasket;

select *from bigbasket where category is null;
select *from bigbasket where product is null;
select *from bigbasket where brand is null;
select *from bigbasket where sale_price is null;
select *from bigbasket where rating is null;
select *from bigbasket where market_price is null;

select *from bigbasket;

select distinct brand from bigbasket order by 1;

select brand,count(product),sum(sale_price) from bigbasket
	group by brand;

create view brand_view as
	select brand,count(product) as total_count,sum(sale_price) as total_price from bigbasket
	group by brand;
select * from brand_view;

with max_brand(brand,total_count_product,total_sale_price) as
(
	select brand,count(product) as total_count,sum(sale_price) as total_price from bigbasket
	group by brand
),
max_brand_1 as
(
	select *from max_brand where total_count_product in(select max(total_count_product) from max_brand)
)
select *from max_brand_1;

select * from bigbasket;

select product,max(sale_price) from bigbasket group by product;

with max_prod(product,max_sale_price) as
(
	select product,max(sale_price) from bigbasket group by product
),
max_prod_1 as
(
	select *from max_prod where max_sale_price in 
		(select max(max_sale_price) from max_prod)
)
select *from max_prod_1;

select sale_price,market_price from bigbasket;

select product,sale_price,market_price,(market_price - sale_price) as loss from bigbasket;

create view total_loss as
	select product,sale_price,market_price,(market_price - sale_price) as loss from bigbasket;
    
select *from total_loss where loss>0;
select sum(loss) from total_loss;

select *from bigbasket;

create temporary table low_rating
	select brand,rating from bigbasket;

select *from low_rating where rating<3;

select * from bigbasket;

with cat_cte(category,sub_category,total_sale_price) as
(
	select category,sub_category,sum(sale_price) from bigbasket group by category,sub_category
)
select *from cat_cte where total_sale_price = (select max(total_sale_price) from cat_cte
	where total_sale_price <(select max(total_sale_price) from cat_cte));
    
with low_cat(category,sub_category,low_sale) as 
(
	select category,sub_category,sum(sale_price) from bigbasket group by category,sub_category
)
select *from low_cat where low_sale<500;

select avg(sale_price) from bigbasket;

use bigbasket;

select *from bigbasket;

select count(product),category from bigbasket group by category;

USE BIGBASKET;


    