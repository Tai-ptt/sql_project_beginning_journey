-- SQL retails sales analysis - P1
CREATE DATABASE sql_project_p2;

-- CREATE TABLE 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
           (
                 transactions_id INT PRIMARY KEY,
                 sale_date DATE,
                 sale_time TIME,
                 customer_id INT,
                 gender	VARCHAR(15),
                 age INT,	
                 category VARCHAR(15),
                 quantiy INT,	
                 price_per_unit	FLOAT, 
                 cogs FLOAT, 
                 total_sale FLOAT
           );

SELECT * FROM retail_sales;

-- data cleaning
SELECT
     COUNT(*)
FROM retail_sales 

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
	 quantiy IS NULL
	 OR
	 price_per_unit IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL
	
DELETE FROM retail_sales 
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
	 quantiy IS NULL
	 OR
	 price_per_unit IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL

-- data exploration
-- how many sales do we have
SELECT COUNT(*) AS total_sale FROM retail_sales 
-- how many customers do we have
SELECT COUNT(DISTINCT customer_id) AS total_sales from retail_sales
-- how many unique customers do we have
SELECT COUNT(DISTINCT category) AS total_sales from retail_sales
SELECT DISTINCT category AS total_sales from retail_sales

-- data analysis and business key problems and answer
-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 and the month of Nov-2022
-- LỆNH NÀY TÍNH TỔNG CỦA TỪNG CATEGORY CỦA TỪNG THỜI ĐIỂM RỒI GÔM NHÓM LẠI ỨNG VỚI KẾT QUẢ TỔNG CỦA NHÓM ĐÓ
SELECT 
     category,
	 SUM(quantiy)
FROM retail_sales
GROUP BY 1

-- GIẢI Q2
SELECT * FROM retail_sales
WHERE category = 'Clothing' 
  and quantiy >= 4 
  and TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' 

-- Q3 Write a SQL query to calculate the total sales (total_sale) for each category
SELECT 
     category,
	 sum(total_sale) AS net_sales,
	 COUNT(*) as total_sales
FROM retail_sales
GROUP BY 1

-- Q4 Write a SQL query to find the average age of customers who purchased items from 'Beauty' category
SELECT 
     category,
	 ROUND(AVG(age), 2)
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY 1

-- Q5 Write a SQL query to find all the transactions where the total_sales is greater than 1000
SELECT * FROM retail_sales
WHERE total_sale > 1000

-- Q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT 
     gender,
	 category,
	 SUM(transactions_id) as tongidcuatransaction,
	 COUNT(*) as total_transorder
FROM retail_sales
GROUP BY gender, category 

-- Q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
     EXTRACT(YEAR FROM sale_date) AS year,
	 EXTRACT(MONTH FROM sale_date) AS month,
	 AVG(total_sale)
FROM retail_sales
GROUP BY year, month
ORDER BY 1, 3 DESC

-- Question: Find out the best selling month in each year ???
-- Note: Với phần câu lệnh có sử dụng rank over partition này thì không được lấy alias trong câu lệnh này
-- Bạn nghĩ có thể dùng alias year và avgtotalsale ngay trong RANK().
-- Nhưng tại thời điểm SQL tính RANK(), alias trong SELECT (year, month, avgtotalsale) chưa tồn tại.
-- Vì vậy SQL bắt buộc bạn viết lại biểu thức gốc (EXTRACT(...), AVG(...)).
SELECT * FROM
(
SELECT 
     EXTRACT(YEAR FROM sale_date) AS year,
	 EXTRACT(MONTH FROM sale_date) AS month,
	 AVG(total_sale) as avgtotalsale,
	 RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY year, month
) as t1
WHERE rank = 1

-- Q8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
     customer_id,
	 SUM(total_sale) as highesttotalsale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q9 Write a SQL query to find the number of unique customers who purcharsed items from each category
SELECT
     category,
	 COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM retail_sales
GROUP BY 1

-- Q10 Write a SQL query to create each shift and number of orders (example: morning < 12, afternoon between 12 and 17. evening > 17)
WITH sale_with_shift as (
SELECT *,
     CASE 
	 WHEN EXTRACT(HOUR FROM sale_time) < 12 then 'Morning'
	 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 then 'afternoon'
	 WHEN EXTRACT(HOUR FROM sale_time) > 17 then 'evening'
	 END AS shift
FROM retail_sales
)
SELECT 
     shift,
	 COUNT(*) AS number_of_order
FROM sale_with_shift
GROUP BY shift

-- end of project
