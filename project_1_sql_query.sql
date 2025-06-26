----Table creation

create table retail_sales_analysis (
				transactions_id	int PRIMARY KEY,
				sale_date	DATE,
				sale_time  TIME,
				customer_id INT,
				gender	VARCHAR(8),
				age	INT,
				category VARCHAR(15),
				quantity	INT,
				price_per_unit	FLOAT,
				cogs FLOAT,
				total_sale FLOAT
)
select * from retail_sales_analysis;

---Data cleaning
---checking for null values

select * from retail_sales_analysis 
where transactions_id is null;

select * from retail_sales_analysis 
where sale_date is null;

select * from retail_sales_analysis
where transactions_id is null
      or
	  sale_date is null
	  or 
	  sale_time is null
	  or
	  customer_id is null
	  or
	  gender is null
	  or
	  age is null
	  or
	  category is null
	  or
	  quantity is null
	  or
	  price_per_unit is null
	  or
	  cogs is null
	  or
	 total_sale is null;

--Delete the null values
Delete from retail_sales_analysis
where transactions_id is null
      or
	  sale_date is null
	  or 
	  sale_time is null
	  or
	  customer_id is null
	  or
	  gender is null
	  or
	  age is null
	  or
	  category is null
	  or
	  quantity is null
	  or
	  price_per_unit is null
	  or
	  cogs is null
	  or
	 total_sale is null;

--Counting rows after deleting null values

select count(*) from retail_sales_analysis;

---exploratory data analysis

---How many sales we have
select count(*) as total_Sales from retail_sales_analysis;

---How many customers we have
select count(distinct customer_id) as total_customers from retail_sales_analysis;

---How many categories we have
select count(distinct category) as categories from retail_sales_analysis;
select distinct category from retail_sales_analysis;
select * from retail_sales_analysis limit 5;

---Finding average age of men and women 
select gender, round(avg(age),0) as mean_age_value 
from retail_sales_analysis
group by gender;

---Finding category and total quantity for each category in ascending order
select category, sum(quantity) as total_quantity_per_category
from retail_sales_analysis
group by category
order by category ;

---How many goods sold in beauty ctaegory
Select category,count(cogs) as total_good_sold
from retail_sales_analysis
group by category

---How much amount did you spend on each category
Select category,sum(cogs) as total_good_sold
from retail_sales_analysis
group by category

---Gender and total amount spend on each category
select gender,category,
count(quantity) as total_quantity,
sum(cogs) as total_spend
from retail_sales_analysis
group by gender, category;

---Finding on what date we sell the maximum quanttiy of products
select sale_date,max(quantity) as max_quantity
from retail_sales_analysis
group by sale_date
having max(quantity)>3
order by max(quantity);


---Data analysis & Business problems and answers
---Question 1
---write an sql query to retrieve all columns which are made on'2022-11-05'
select * from retail_sales_analysis
where sale_date='2022-11-05';

---write an sql query to retrieve all transactions where category is clothing and the 
---quantity sold is more than 10 in the month of nov-2022
select *
from retail_sales_analysis
where category='Clothing'
and sale_date between '2022-11-01' and '2022-11-30'
and quantity>=4;

---Write an SQL query to calculate total sales for each category
select category,sum(total_sale) as total_Sales
from retail_sales_analysis
group by category;

---write an sql query to find the avg age of customers who purchased in beauty category
select round(avg(age),0) as average_Age
from retail_sales_analysis
where category='Beauty';

---write an sql query to find all transactions where the total_sale is greater than 1000
select * 
from retail_sales_analysis
where total_sale > 1000;

---write an sql query to find total no of  transactions made by
---each gender in each category
select category,gender,count(transactions_id) as total_no_of_transactions
from retail_sales_analysis
group by category,gender
order by category;

---write an sql query to calculate the avergae sale for each month.
---Find the out best-selling month in each year
with cte as (select 
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as average_sales,
rank() over (partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales_analysis
group by 1,2)
select * from cte
where rank = 1 ;

---write an sql query to find the top 5 customers based on highest total_Sales
select customer_id,sum(total_sale) as total_sales
from retail_sales_analysis
group by customer_id
limit 5;

---Write an sql query to find the unique number of customers who purchased items from each category
select category,count(distinct customer_id) as total_unique_customers
from retail_sales_analysis
group by category;

---Write a sql query to craete each shift and numner of orders
---Morning<=12, afternoon between 12&17 and evening>17
select 
case  when extract (hour from sale_time) < 12 then 'Morning'
     when extract (hour from sale_time) between 12 and 17 then 'Afternoon'
	 else 'Evening'
	 end as Shift_timings,
	 count(*) as number_of_orders
from retail_sales_analysis
group by Shift_timings
order by Shift_timings

