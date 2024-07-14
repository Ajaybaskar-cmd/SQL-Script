use project;
show tables;

select *from sales_data_sample;

##change the orginal data for any problem so create the new table insert the values;
create table sales like sales_data_sample;

insert sales 
select *from sales_data_sample;

select *from sales;

/* REMOVE THE DUPLICATES */

##find the duplicates

alter table sales drop column addressline2;
alter table sales RENAME COLUMN addressline1 TO  ADDRESSLINE;

select *,row_number() over(partition by ordernumber,quantityordered,priceeach,orderlinenumber,sales,orderdate,
`status`,qtr_id,month_id,year_id,productline,msrp,productcode,customername,phone,addressline,city,state,
postalcode,country,territory,contactlastname,contactfirstname,dealsize)as row_num
from sales where row_num>1;

CREATE TABLE `sales2` (
  `ORDERNUMBER` int DEFAULT NULL,
  `QUANTITYORDERED` int DEFAULT NULL,
  `PRICEEACH` double DEFAULT NULL,
  `ORDERLINENUMBER` int DEFAULT NULL,
  `SALES` double DEFAULT NULL,
  `ORDERDATE` text,
  `STATUS` text,
  `QTR_ID` int DEFAULT NULL,
  `MONTH_ID` int DEFAULT NULL,
  `YEAR_ID` int DEFAULT NULL,
  `PRODUCTLINE` text,
  `MSRP` int DEFAULT NULL,
  `PRODUCTCODE` text,
  `CUSTOMERNAME` text,
  `PHONE` text,
  `ADDRESSLINE` text,
  `CITY` text,
  `STATE` text,
  `POSTALCODE` text,
  `COUNTRY` text,
  `TERRITORY` text,
  `CONTACTLASTNAME` text,
  `CONTACTFIRSTNAME` text,
  `DEALSIZE` text,
  row_num int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *from sales2;

insert into sales2
select *,row_number() over(partition by ordernumber,quantityordered,priceeach,orderlinenumber,sales,orderdate,
`status`,qtr_id,month_id,year_id,productline,msrp,productcode,customername,phone,addressline,city,state,
postalcode,country,territory,dealsize)as row_num
from sales;

select *from sales;
alter table sales drop column CONTACTFIRSTNAME;

select distinct customername,count(*) from sales group by customername having count(*)>1 order by 1;

with duplicate_cte as 
	(select *,row_number() over(partition by ordernumber,quantityordered,priceeach,orderlinenumber,sales,orderdate,
	`status`,qtr_id,month_id,year_id,msrp,productcode,customername,phone,addressline,city,state,
	postalcode,country,territory,dealsize)as row_num
	from sales
    )
select *from duplicate_cte where row_num>1;

select *from sales;



update sales set orderdate=str_to_date(orderdate,'%m/%d/%Y');
select orderdate,str_to_date(orderdate,'%m/%d/%Y') from sales;

update sales set orderdate=trim(trailing '0:00' from orderdate);

select orderdate,trim(orderdate) from sales;

alter table sales modify column orderdate date;

select *from sales;

select distinct `status` from sales;
select *from sales where `status`='resolved';