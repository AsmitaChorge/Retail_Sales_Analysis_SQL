--SQL Retail sales analysis 

CREATE TABLE retail_sales
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,	
				sale_time TIME,
				customer_id	INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(20),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);
DROP TABLE retail_sales;

ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;

SELECT * FROM retail_sales;

SELECT COUNT(*) FROM retail_sales;


--DATA CLEANING--

SELECT * FROM retail_sales
WHERE
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;


DELETE FROM retail_sales
WHERE
transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL
OR gender IS NULL OR age IS NULL OR category IS NULL OR quantity IS NULL OR 
price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;


--DATA EXPLORATION--

--how many sales we have?
SELECT COUNT(*) AS total_sale FROM retail_sales; 


--how many unique customers we have?
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM retail_sales; 

--how many unique categories we have?
SELECT COUNT(DISTINCT category) AS total_sale FROM retail_sales; 

--What are those unique categories' names?
SELECT DISTINCT category FROM retail_sales;


SELECT * FROM retail_sales;


---Data Analysis and Business Key Problems & answers---

--Q1 retrieve all columns for sales made on "2022-11-05"--

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05'

---Q2: retrieve all transactions where the category is 'Clothing' and the quantity
-- Sold is more than 10 in the month of nov-2022.

--quantity sold of clothing category
select 
category,
sum(quantity)
from retail_sales
where category = 'Clothing'
group by 1

--only quantity sold which is more than 4 and month is nov-2022(main Q)

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
and 
quantity >=4

--Q3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT
category,
SUM(total_sale) as net_sale,
COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1


--Q4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT 
ROUND(AVG(age)) as avg_age
FROM retail_sales
WHERE category = 'Beauty'



--Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale >1000

--Q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
category,
gender,
COUNT(*) AS total_trans
FROM retail_sales
GROUP BY
category, gender
ORDER BY 1


--Q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT * FROM
(
SELECT
EXTRACT (YEAR FROM sale_date) AS year,
EXTRACT (MONTH FROM sale_date) AS month,
AVG(total_sale) AS avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale)DESC) AS rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1


SELECT 
year,
month,
avg_sale
FROM
(
SELECT
EXTRACT (YEAR FROM sale_date) AS year,
EXTRACT (MONTH FROM sale_date) AS month,
AVG(total_sale) AS avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale)DESC) AS rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1


--Q8 Write a SQL query to find the top 5 customers based on the highest total sales

SELECT 
customer_id,
SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


--Q9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
category,
COUNT(DISTINCT customer_id) AS cnt_unique_customer
FROM retail_sales
GROUP BY category


--Q10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)


WITH  hourly_sales
AS
(
SELECT *,
CASE
WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
WHEN EXTRACT(HOUR FROM sale_time)  BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END as shift
FROM retail_sales
)
SELECT
shift,
COUNT(*) total_orders
FROM hourly_sales
GROUP BY shift


-- SELECT EXTRACT(HOUR FROM CURRENT_TIME)



-- END--









