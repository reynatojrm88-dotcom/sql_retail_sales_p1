DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
        transactions_id	INT PRIMARY KEY,
        sale_date DATE,	
        sale_time	TIME,
        customer_id INT,
        gender	VARCHAR(15),
        age	INT,
        category VARCHAR(15),
        quantiy	INT,
        price_per_unit FLOAT,
        cogs	FLOAT,
        total_sale INT
)

SELECT * FROM retail_sales;

SELECT * FROM retail_sales limit 10;

SELECT
    COUNT(*) AS total_transactions
FROM retail_sales;

/* Dealing with NULL values */
--Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
OR sale_time IS NULL
OR gender IS NULL
OR category IS NULL
OR quantiy IS NULL  
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

/* DELETE NULL values */
DELETE FROM retail_sales
WHERE transactions_id IS NULL
OR sale_time IS NULL
OR gender IS NULL
OR category IS NULL
OR quantiy IS NULL  
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

-- Data Exploration
-- How many sales we have?

SELECT COUNT(*) AS total_sale
FROM retail_sales;

--How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales;

--How many categories of products we have? 
SELECT COUNT(DISTINCT category) AS total_categories
FROM retail_sales


SELECT category from retail_sales
GROUP BY category;

-- Data Analysis & Business Key Problems & Answers
--Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * from retail_sales
WHERE sale_date = '2022-11-05';


--Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 1o in the month of Nov-2022

SELECT 
category,
SUM(quantiy) AS total_quantity
FROM  retail_sales
WHERE category = 'Clothing'
AND 
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
GROUP BY category


SELECT *
FROM  retail_sales
WHERE category = 'Clothing'
AND 
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'

--quantity > 10 

SELECT *
FROM  retail_sales
WHERE category = 'Clothing'
AND 
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND 
quantiy >= 4;




-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
category,
SUM(total_sale) AS net_sales,
COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category



-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.


SELECT 
category,
ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;

SELECT 
age
FROM retail_sales
WHERE category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.


SELECT *

FROM retail_sales
WHERE total_sale > 1000; 



-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT
category, 
gender,
COUNT(transactions_id) as total_transaction
FROM retail_sales
GROUP BY gender, category
ORDER BY category

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year


SELECT * FROM 
( 

    SELECT 
        EXTRACT(YEAR FROM sale_date) as year,
        EXTRACT(MONTH FROM sale_date) as month,
        AVG(total_sale) as avg_total_sales,
        RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as sales_rank 
    FROM retail_sales
    GROUP BY 1, 2
) as t1
WHERE sales_rank = 1
--ORDER BY 1, 3 DESC;




-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales


SELECT 
customer_id,
SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;
--ORDER BY total_sale DESC


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
category,
COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening >17)


WITH hourly_sale
AS
(
SELECT *,
CASE 
    WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
END AS shift
FROM retail_sales
)
SELECT shift,
COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

--End of Project