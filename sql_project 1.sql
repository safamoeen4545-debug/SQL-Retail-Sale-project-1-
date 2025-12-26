delete from retail_sales
where
     transaction_id is null
	 or
	 sale_date is null
	 or
	 sale_time is null
	 or
	 gender is null
	 or
	 category is null
	 or
	 quantity is null
	 or
	 cogs is null
	 or
	 total_sale is null;
	 
--How maney sales we have
select count (*) as total_sale from retail_sales

--HOW MANEY unique CUSTOMER WE HAVE
select count (distinct customer_id) as total_sale from retail_sales

select distinct category from retail_sales

--Data Analysis & Business – Key Problems & Answers

--My Analysis & Findings
--Q1. Write an SQL query to retrieve all columns for sales made on 2022-11-05.
--Q2. Write an SQL query to retrieve all transactions where the category is ‘Clothing’ and the quantity sold is more than 4 in the month of November 2022.
--Q3. Write an SQL query to calculate the total sales (total_sale) for each category.
--Q4. Write an SQL query to find the average age of customers who purchased items from the ‘Beauty’ category.
--Q5. Write an SQL query to find all transactions where the total_sale is greater than 1000.
--Q6. Write an SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
--Q7. Write an SQL query to calculate the average sale for each month and identify the best-selling month in each year.
--Q8. Write an SQL query to find the top 5 customers based on the highest total sales.
--Q9. Write an SQL query to find the number of unique customers who purchased items from each category.
--Q10. Write an SQL query to create shifts and count the number of orders for each shift (Example: Morning ≤ 12, Afternoon between 12 and 17, Evening > 17).


--Q1. Write an SQL query to retrieve all columns for sales made on 2022-11-05.

select *
from retail_sales
where sale_date = '2022-11-05';


--Q2. Write an SQL query to retrieve all transactions where the category is ‘Clothing’ and the quantity sold is more than 4 in the month of November 2022.


SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity >= 4
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

--Q3. Write an SQL query to calculate the total sales (total_sale) for each category.

select
      category,
      sum(total_sale) as net_sales,
	  count(*) as total_orders
from retail_sales
group by 1

--Q4. Write an SQL query to find the average age of customers who purchased items from the ‘Beauty’ category.

select 
    round(avg(age), 2) as avg_age
	from retail_sales
	where category = 'Beauty'
	
--Q5. Write an SQL query to find all transactions where the total_sale is greater than 1000.

select 
    total_sale
    from retail_sales
	where total_sale = 1000

--Q6. Write an SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
	  
select 
     category,
	 gender,
	 count(*) as total_trans
	 from retail_sales
	 group by category,
	 gender
	 order by 1;
	 
-- Q.7 Write a SQL query to calculate the average sale for each month.Find out best selling month in each year

SELECT
    year,
    month,
    avg_sale
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) t
WHERE rank = 1;


--Q8. Write an SQL query to find the top 5 customers based on the highest total sales.

SELECT customer_id, 
SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

--Q9. Write an SQL query to find the number of unique customers who purchased items from each category.

SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

--Q10. Write an SQL query to create shifts and count the number of orders for each shift (Example: Morning ≤ 12, Afternoon between 12 and 17, Evening > 17).

-- Q.10 Write a SQL query to create each shift and number of orders

WITH hourly_sale AS (
    SELECT
        *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)

SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

--End Project
