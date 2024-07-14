use project;


show tables;
select *from pizza_sales;
select distinct * from pizza_sales;
#create table like pizza sales
create table pizza_sales2 like pizza_sales;
select *from pizza_sales2;

insert into pizza_sales2 
	select *from pizza_sales;

# Calculate the total revenue
select round(sum(total_price)) as total_revenue from pizza_sales;

#calculate the Average  orders value
select sum(total_price) / count(distinct order_id) as Avg_Order_Value from pizza_sales;

#Calculate the total quantity of the pizza sold
select sum(quantity) as Total_Pizza_Sales from pizza_sales;

#Count the total pizza orders
select *from pizza_sales;
select count(distinct order_id) as Total_Orders from pizza_sales;

#calculate Average pizzas per order
select round(sum(quantity) / count(distinct order_id),2) as Avg_Pizza_order from pizza_sales; 

#change data type in order_date
select * from pizza_sales; 
alter table pizza_sales add new_order date;

update pizza_sales set new_order = str_to_date(order_date,"%d-%m-%Y");

#change the column name 
alter table pizza_sales drop column order_date;
select *from pizza_sales;
alter table pizza_sales rename column new_order to order_date;

#Calculate the count order in every day find it day name
select *from pizza_sales;

select dayname(order_date) as Order_Day,count(distinct order_id) as count_order from pizza_sales
	group by dayname(order_date)
    order by count(distinct order_id) desc;
    
#Calculate no of orders in month wise
select monthname(order_date) as Order_Month,count(distinct order_id) as count_order
	from pizza_sales
    group by monthname(order_date)
    order by count(distinct order_id) desc;
    
#Claculate the total sales per pizza category
select * from pizza_sales;

select pizza_category,round(sum(total_price),2) as Total_Price from pizza_sales
	group by pizza_category
    order by Total_Price desc;

#Calculate the percentage of the total sales per pizza category
select pizza_category,round(sum(total_price),2) as Total_Price,round(sum(total_price) * 100 / (select sum(total_price) from pizza_sales),2) as PERCENTAGE
from pizza_sales
group by pizza_category
order by percentage desc;

#Calculate the percentage of the total sales per pizza category in monthwise
select pizza_category,round(sum(total_price),2) as Total_Price,round(sum(total_price) * 100 /
(select sum(total_price) from pizza_sales),2) as PERCENTAGE,
monthname(order_date) as Month_Name
from pizza_sales
group by pizza_category,Month_name;

use project ;
select *from pizza_sales;

/*Data cleaning */
alter table pizza_sales drop column order_time;

select distinct quantity from pizza_sales;

select * from pizza_sales where quantity = 2;

select round(sum(total_price),2) as total_price,pizza_name from pizza_sales
	group by pizza_name;

select * from pizza_sales;

select round(sum(total_price),2) as total_price,pizza_name,pizza_category from pizza_sales
	group by pizza_name,pizza_category
    order by pizza_category;


use project;
select * from pizza_sales;
alter table pizza_sales drop column pizza_ingredients;

with cte(pizza_size,order_date,total_price) as(
	select pizza_size,order_date,round(sum(total_price),2) as Total_Price from pizza_sales
    group by pizza_size,order_date
    order by pizza_size
    )
select pizza_size,monthname(order_date) as Month_Name,round(sum(total_price),2) as Total_Price from cte
	group by Month_name,pizza_size;
    
    
#Dense Rank
with cte(pizza_size,month_name,total_price) as(
	select pizza_size,monthname(order_date) as Month_name,round(sum(total_price),2) as Total_Price from pizza_sales
    group by pizza_size,month_name
    ),
cte2 as (
	select *,dense_rank() over(partition by pizza_size order by total_price) as Ranking from cte
    )
select  * from cte2;




