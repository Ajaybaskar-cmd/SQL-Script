use coffeeshop;
show tables;

select * from coffeeshopsales;

select  * from coffeeshopsales order by transaction_id;

/* Create the table like coffeeshopsales */
CREATE TABLE coffeesales LIKE coffeeshopsales;

select * from coffeesales;

/* Insert the value for the new table */
INSERT INTO coffeesales 
	SELECT * FROM coffeeshopsales ORDER BY 1;
    
/* Cleaning the data for new table */
SELECT * FROM coffeesales;

#Delete the unrequired columns
ALTER TABLE coffeesales DROP COLUMN transaction_time;

#Remove duplicates
select distinct * from coffeesales;

with cte as (
	select *,row_number() over(partition by transaction_id,transaction_date,transaction_qty,store_id,store_location,
		product_id,unit_price,product_category,product_type,product_detail) as rn 
        from coffeesales
        )
	select * from cte where rn>1;
    
select * from coffeesales where transaction_id = 239;

CREATE TABLE `coffeesales2` (
  `transaction_id` int DEFAULT NULL,
  `transaction_date` text,
  `transaction_qty` int DEFAULT NULL,
  `store_id` int DEFAULT NULL,
  `store_location` text,
  `product_id` int DEFAULT NULL,
  `unit_price` double DEFAULT NULL,
  `product_category` text,
  `product_type` text,
  `product_detail` text,
  `rn` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from coffeesales2;

#Insert the values with rank
insert into coffeesales2 
	select *,row_number() over(partition by transaction_id,transaction_date,transaction_qty,store_id,store_location,
		product_id,unit_price,product_category,product_type,product_detail) as rn 
        from coffeesales;
        
select * from coffeesales2;
select distinct rn from coffeesales2;

#Remove the Duplicates
SELECT * FROM coffeesales2 where rn > 1;

DELETE FROM coffeesales2 where rn > 1;

SELECT * FROM coffeesales2;

select distinct * from coffeesales ;

-- Find the duplicates
SELECT * FROM coffeesales2;

SELECT * FROM (SELECT *,ROW_NUMBER() OVER(PARTITION BY transaction_id) as row_no FROM coffeesales) sourc 
WHERE row_no = 1  ;

	
#CHANGE THE DATATYPE IN EVERY COLUMN
SELECT * FROM coffeesales2;

SELECT transaction_date,STR_TO_DATE(transaction_date,'%m/%d/%Y') FROM coffeesales2;

UPDATE coffeesales2 SET transaction_date = STR_TO_DATE(transaction_date,'%m/%d/%Y');

SELECT * FROM coffeesales2;

#change the data type
ALTER TABLE coffeesales2 MODIFY COLUMN transaction_date DATE;



/* STANDARDIZE THE DATA IN EVERY COLUMN */
SELECT * FROM coffeesales2;

#Find the year of the sales
SELECT DISTINCT YEAR(transaction_date) FROM coffeesales2;

SELECT * FROM coffeesales2;

SELECT DISTINCT transaction_qty FROM coffeesales2;

SELECT DISTINCT store_id FROM coffeesales2;

SELECT DISTINCT store_location FROM coffeesales2;

SELECT DISTINCT product_id FROM coffeesales2
ORDER BY 1;

SELECT DISTINCT unit_price FROM coffeesales2;

SELECT DISTINCT product_category FROM coffeesales2;

SELECT DISTINCT product_type FROM coffeesales2 ORDER BY 1;

SELECT DISTINCT product_detail FROM coffeesales2 ORDER BY 1;



/* Find null values */

use coffeeshop;
select * from coffeesales2;

select * from coffeesales2 where transaction_id is null;
select * from coffeesales2 where transaction_date is null;
select * from coffeesales2 where transaction_qty is null;
select * from coffeesales2 where store_id is null;
select * from coffeesales2 where store_location is null;
select * from coffeesales2 where product_id is null;
select * from coffeesales2 where unit_price is null;
select * from coffeesales2 where product_category is null;
select * from coffeesales2 where product_type is null;
select * from coffeesales2 where product_detail is null;
#There is no null values so take 

#Delete the rank column
select * from coffeesales2 where rn<1;

ALTER TABLE coffeesales2 DROP COLUMN rn;



/* Exploration */
SELECT * FROM coffeesales2;

#Find Total price
SELECT ROUND(SUM(transaction_qty * unit_price),2) AS Total_Sales FROM coffeesales2;
-- Find Monthwise

SELECT MONTHNAME(transaction_date) AS Month_name,ROUND(SUM(transaction_qty * unit_price),2) AS Total_Sales FROM coffeesales2
	GROUP BY Month_name;
    
-- Month wise increasing progress
SELECT MONTH(transaction_date) AS Month_name,
	ROUND(SUM(unit_price * transaction_qty)) as Total_sales, -- Total sales
	ROUND((SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty),1) -- Month sales Difference
	OVER(ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty),1) -- division by previous month
	OVER(ORDER BY MONTH(transaction_date)) * 100) AS Num_of_percentage 
FROM coffeesales2
GROUP BY Month_name;

-- Every Month
-- Important 
SELECT MONTH(transaction_date) AS Month_name,
	ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales,
	ROUND(SUM(unit_price * transaction_qty),2) -
	LEAD(ROUND(SUM(unit_price * transaction_qty),2)) OVER(ORDER BY MONTH(transaction_date)) as Difference_sale_month,
    SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty)) OVER(ORDER BY MONTH(transaction_date)) AS Profit_previous_month
FROM coffeesales2
GROUP BY month_name;

-- Count the total order in every month

SELECT
	MONTH(transaction_date) AS Month_name,
	COUNT(transaction_id) as Total_Orders,
	ROUND(SUM(unit_price * transaction_qty)) as Total_sales
FROM coffeesales2 
	GROUP BY month_name
	ORDER BY month_name;


-- Difference between month on month orders
SELECT
	MONTH(transaction_date) AS Month_name,
	COUNT(transaction_id) as Total_Orders,
	ROUND(SUM(unit_price * transaction_qty)) as Total_sales,
    COUNT(transaction_id) - LAG(COUNT(transaction_id)) OVER(ORDER BY MONTH(transaction_date)) AS Dif_month_order,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id)) OVER(ORDER BY MONTH(transaction_date))) / 
    LAG(COUNT(transaction_id)) OVER(ORDER BY MONTH(transaction_date)) * 100 AS Diff_Percentage
FROM coffeesales2 
	GROUP BY month_name;
    
    
-- Find the total quantity sold
SELECT * FROM coffeesales2;

SELECT SUM(transaction_qty) AS total_sold_qty FROM coffeesales2;


use coffeeshop;
-- Find total sales,total_qty,total_orders

SELECT 
	MONTH(transaction_date) as Month_name,
	CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2),'k') as Total_sales,
    CONCAT(ROUND(SUM(transaction_qty)/1000,1),'k') as Total_qty_sold,
    CONCAT(ROUND(COUNT(transaction_id)/1000,1),'k') as Total_orders
FROM coffeesales2
	GROUP BY month_name
    ORDER BY month_name;
    
-- Find the total sales in weekday and weekends
-- sun = 1, mon = 2 ,...... sat = 7

SELECT 
	CASE WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN 'Weekends'
    ELSE 'Weekdays'
    END AS day_type,
    MONTH(transaction_date) as Month_name,
    ROUND(SUM(unit_price * transaction_qty),1) as Total_sales
FROM coffeesales2
GROUP BY day_type,MONTH(transaction_date)
ORDER BY day_type;

-- Using with cte above query
WITH sale_cte(day_type,month_name,total_sales) as (
SELECT 
	CASE WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN 'Weekends'
    ELSE 'Weekdays'
    END AS day_type,
    MONTH(transaction_date) as Month_name,
    ROUND(SUM(unit_price * transaction_qty),1) as Total_sales
FROM coffeesales2
GROUP BY day_type,MONTH(transaction_date)
ORDER BY day_type
)
SELECT day_type,SUM(total_sales)
FROM sale_cte
GROUP BY day_type;


-- Find the total sales in every location
SELECT 
	store_location,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_sales
FROM coffeesales2
GROUP BY store_location
ORDER BY total_sales DESC;

-- Find the total sales in every day in seperate month

SELECT 
	DAY(transaction_date) as Day_of_month,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_sales
FROM coffeesales2
WHERE MONTHNAME(transaction_date) = 'june'
GROUP BY day_of_month
ORDER BY Day_of_month;

use coffeeshop;

-- Find the sales type
-- totalsales > avg_sales  'aboverage'   ts<as ' below averae'  ts == as 'equal to aveg

SELECT 
	day_of_month,
    total_sales,
    avg_sales,
	CASE 
		WHEN total_sales > avg_sales THEN 'Above average'	
        WHEN total_sales < avg_sales THEN 'Below average'
        ELSE 'Equal to average'
	END AS sales_type,
    Total_sales
FROM (
SELECT 
	DAY(transaction_date) AS day_of_month,
    ROUND(SUM(unit_price * transaction_qty),1) AS total_sales,
    ROUND(AVG(SUM(unit_price * transaction_qty)) OVER(),1) AS avg_sales
FROM coffeesales2
WHERE
	MONTH(transaction_date) = 2   -- fEBRUARY MONTH
GROUP BY 
	DAY(transaction_date)) AS sales_data;
    
    
-- Find the top 10 highest selling product
SELECT 
	product_category,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1),'k') AS Total_sales
FROM coffeesales2
WHERE 
	MONTH(transaction_date) = 2
GROUP BY product_category
LIMIT 5;

-- Find the most selling product type
SELECT 
	product_type,
    ROUND(SUM(unit_price * transaction_date),1) AS total_sales
FROM coffeesales2
WHERE 
	MONTH(transaction_date) = 1
GROUP BY
	product_type;