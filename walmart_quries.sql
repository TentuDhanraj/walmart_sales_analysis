-- ================================================
-- Walmart Sales Analysis
-- Author: Dhanraj 
-- Tool: PostgreSQL
-- Date: February 2026
-- ================================================
-- Find the total revenue (unit_price × quantity) per category, ordered from highest to lowest.

SELECT 
	unit_price,
	quantity,
	ROUND(
		unit_price * quantity, 2
	) AS total_price
FROM walmart_sales
WHERE unit_price IS NOT NULL
ORDER BY total_price desc;

--  Which branch generated the most transactions? Which generated the highest average rating?
SELECT 
	branch,
	count(*) AS total_transactions
FROM walmart_sales
GROUP BY branch
ORDER BY total_transactions DESC;

SELECT 
    branch,
    ROUND(AVG(rating), 2) AS avg_rating
FROM walmart_sales
GROUP BY branch
ORDER BY avg_rating DESC;

-- List all cities where the average profit_margin is above 0.40.
SELECT * FROM walmart_sales;

SELECT 	
	city,
	ROUND(AVG(profit_margin),2) AS avg_profit
FROM walmart_sales
GROUP BY city
HAVING AVG(profit_margin) > 0.40
ORDER BY avg_profit DESC;

-- Find the top 5 busiest hours of the day by number of transactions (extract hour from the time column).
WITH hour_extraction AS (
    SELECT 
        EXTRACT(HOUR FROM time) AS sale_hour,
        invoice_id
    FROM walmart_sales
)
SELECT 
    sale_hour,
    COUNT(invoice_id) AS total_transactions
FROM hour_extraction
GROUP BY sale_hour
ORDER BY total_transactions DESC
LIMIT 5;

-- Which payment method is most popular in each city?

WITH payment_counts AS (
	SELECT 
		city,
		payment_method,
		COUNT(invoice_id) AS number_of_transactions,
		RANK() OVER(PARTITION BY city ORDER BY COUNT(invoice_id)) AS rankings
		FROM walmart_sales
	GROUP BY 1,2
 )
SELECT 
	city,
	payment_method,
	rankings
FROM payment_counts
WHERE rankings = 1;

-- Write a query to find months with total revenue above a certain threshold.

SELECT 
    EXTRACT(MONTH FROM date) AS sale_month,
    SUM(unit_price * quantity) AS total_revenue
FROM walmart_sales
GROUP BY 1
HAVING SUM(unit_price * quantity) > 500
ORDER BY total_revenue DESC;


-- Identify any branches that appear in more than one city — is that possible in this dataset? Write a query to check.

SELECT 
    branch, 
    COUNT(DISTINCT city) AS city_count
FROM walmart_sales
GROUP BY branch
HAVING COUNT(DISTINCT city) > 1;

-- Calculate a running total of revenue ordered by date for each branch using a window function.

SELECT 
    branch,
    date,
    SUM(unit_price * quantity) OVER (
        PARTITION BY branch 
        ORDER BY date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue
FROM walmart_sales
ORDER BY branch, date;

-- Find all transactions where unit_price is above the average unit_price for that category.

WITH category_averages AS (
    SELECT 
        *,
        AVG(unit_price) OVER(PARTITION BY category) as avg_cat_price
    FROM walmart_sales
)
SELECT 
    invoice_id,
    category,
    unit_price,
    ROUND(avg_cat_price, 2) AS category_avg
FROM category_averages
WHERE unit_price > avg_cat_price;

-- Return the highest-rated transaction for each category (handle ties).

WITH rated_transactions AS (
    SELECT 
        category,
        invoice_id,
        rating,
        unit_price,
        RANK() OVER(PARTITION BY category ORDER BY rating DESC) as rating_rank
    FROM walmart_sales
)
SELECT 
    category,
    invoice_id,
    rating,
    unit_price
FROM rated_transactions
WHERE rating_rank = 1;