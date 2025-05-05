create database if not exists sql_project_ps ;
use sql_project_p2;
select * from retail_sales;
create table retail_sales(
		transactions_id int primary key,
		sale_date date,
		sale_time time,
		customer_id int,
		gender varchar(12),
		age tinyint(3),
		category varchar(10),
		price_per_unit float,
		cogs float, 
		total_sale float);
-- data entered--        
select count(*) from retail_sales;
select * from retail_sales where 
	transactions_id is null or
    sale_date is null or
    sale_time is null or
    customer_id is null or
    gender is null or
    age is null or
    category is null or
    price_per_unit is null or
    cogs is null or 
    total_sale is null;
    
SET SQL_SAFE_UPDATES = 0;
delete from retail_sales where
    transactions_id is null or
    sale_date is null or
    sale_time is null or
    customer_id is null or
    gender is null or
    age is null or
    category is null or
    price_per_unit is null or
    cogs is null or 
    total_sale is null;
    
select count(*) from retail_sales;    
select count(distinct customer_id) as total_sales from retail_sales; 
select distinct category from retail_sales;  
 
-- 1. write a sql query to retrive all the columns forsales made on '2022-11-05'
select * from retail_sales where sale_date='2022-11-05';

-- 2. write a sql query to retrive all tranasctions where the category is "clothing" and the quantity sold is more than 3 in the month of nov-2022.

select category, sum(quantity)  from retail_sales where category= 'clothing' and date_format (sale_date,'YYYT-MM') ='2022-12' and quantity>=3; 
select * from retail_sales where category ='clothing' and date_format(sale_date,'YYYT-MM') ='2022-12' and quantity>=3; 

-- 3. write a sql query to calculate  the total sale for each category.
select category,sum(total_sale), count(*) as total_orders from retail_sales  group by 1;

-- 4. Find the average age of customer who purchased itemsretail_sales from the "Beauty" category.
select round(avg(age)) from retail_sales where category='Beauty';

-- 5. Find all transations where the total_sale is greater than 1k.
select * from retail_sales where total_sale>1800;

-- 6. Find the total number of transactions made by each gender in each category.
select category, gender, count(transactions_id) from retail_sales group by category, gender;

-- 7. Calculate the average sale for each month. Find the best selling month in each year.
select year(sale_date) as year, month(sale_date) as month, avg(total_sale) as avg_sale from retail_sales group by 1,2 order by 1,2;

select year,month,avg_sale 
from (
  select 
	  year (sale_date) as year,
	  month(sale_date) as month, 
	  avg(total_sale) as avg_sale, 
	  rank() over(partition by 
  year (sale_date) order by 
  avg(total_sale)desc ) as rnk 
	  from retail_sales
	  group by year(sale_date),
  month(sale_date)
  ) t1 
  where rnk=1;
      
-- 8. Top 5 customer based on the higest total sale.      
select customer_id, sum(total_sale) from retail_sales group  by 1 order by 2 desc limit 5;

-- 9. Find the number of unique customer who purchased iteams from each category.
select category, count(distinct customer_id ) as unique_customer from retail_sales group by 1 ;

-- 10. Create each shift and number of order. ex: Morning>12, Afternoon 12 & 17, Evening >17.
with hourly_sale as (select *, case when extract(hour from sale_time)<12 then "morning" when extract(hour from sale_time) between 12 and 17 then "aftertnoon" else "evening" end as shift from retail_sales) select shift, count(*) as total_order from hourly_sale group by shift;
      
    

    