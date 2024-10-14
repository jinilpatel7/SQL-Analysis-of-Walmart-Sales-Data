CREATE DATABASE walmartsales;
use walmartsales;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create table
CREATE TABLE walmart_sales(
	invoice_id VARCHAR(100) NOT NULL PRIMARY KEY,
    branch VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    customer_type VARCHAR(100) NOT NULL,
    gender VARCHAR(100) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT NOT NULL,
    total DECIMAL NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(100) NOT NULL,
    cogs DECIMAL NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL,
    rating FLOAT
);

-- Load the data from the constituencywise_details.csv file into the table 
show variables like 'secure_file_priv';
show variables like '%local%';
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/WalmartSalesData.csv"
INTO TABLE walmart_sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

SELECT * FROM walmart_sales;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- adding new column time_of_day
ALTER TABLE walmart_sales ADD COLUMN time_of_day VARCHAR(100);
UPDATE walmart_sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

SELECT * FROM walmart_sales;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Add day_name column
ALTER TABLE walmart_sales ADD COLUMN day_name VARCHAR(20);

UPDATE walmart_sales
SET day_name = DAYNAME(date);
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Add month_name column
ALTER TABLE walmart_sales ADD COLUMN month_name VARCHAR(20);

UPDATE walmart_sales
SET month_name = MONTHNAME(date);
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Find all the unique cities
SELECT DISTINCT(city) FROM walmart_sales;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Find all the branch from that city
SELECT DISTINCT(city), branch FROM walmart_sales;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- find all unique product_line
SELECT DISTINCT (product_line) FROM walmart_sales;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- -- What is the most selling product line?
SELECT product_line, SUM(quantity) AS Total_Quantity_Sold
FROM walmart_sales
GROUP BY product_line
ORDER BY Total_Quantity_Sold DESC;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- What is the total revenue by month
SELECT month_name AS Month, SUM(total) AS Revenue
FROM walmart_sales
GROUP BY Month
ORDER BY Revenue DESC;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Monthly COGS values
SELECT month_name AS Month, SUM(cogs) AS cogs
FROM walmart_sales
GROUP BY Month
ORDER BY cogs DESC;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- product line and there revenue
SELECT product_line, SUM(total) AS Revenue
FROM walmart_sales
GROUP BY product_line
ORDER BY Revenue DESC;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- city, branch with their revenue
SELECT city, branch, SUM(total) AS Revenue
FROM walmart_sales
GROUP BY city, branch 
ORDER BY Revenue DESC;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- What product line had the largest VAT?
SELECT
	product_line,
	AVG(tax_pct) as avg_tax
FROM walmart_sales
GROUP BY product_line
ORDER BY avg_tax DESC;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales
SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 5.5 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM walmart_sales
GROUP BY product_line;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- -- Which branch average selling was more then average product sold?
SELECT branch, AVG(quantity) AS qty
FROM walmart_sales
GROUP BY branch
HAVING qty > (SELECT AVG(quantity) FROM walmart_sales);
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- What is the count of male and female product line wise?
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM walmart_sales
GROUP BY gender, product_line
ORDER BY product_line DESC;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- What is the average rating of each product line
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM walmart_sales
GROUP BY product_line
ORDER BY avg_rating DESC;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Select different customer type
SELECT DISTINCT customer_type FROM walmart_sales;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- How many unique payment methods does the data have?
SELECT DISTINCT payment FROM walmart_sales;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- count of customer type?
SELECT
	customer_type, count(*) as count
FROM walmart_sales
GROUP BY customer_type
ORDER BY count DESC;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- What is the count of gender of customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM walmart_sales
GROUP BY gender
ORDER BY gender_cnt DESC;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- What is the gender distribution per branch?
SELECT
	gender, branch, 
	COUNT(*) as gender_count
FROM walmart_sales
GROUP BY gender, branch
ORDER BY branch;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Number of customers in each time of the day per weekday 
SELECT
	time_of_day, day_name, 
	COUNT(*) AS total_customers
FROM walmart_sales
GROUP BY time_of_day, day_name 
ORDER BY day_name ;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM walmart_sales
GROUP BY customer_type
ORDER BY total_revenue;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM walmart_sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM walmart_sales
GROUP BY customer_type
ORDER BY total_tax;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------
