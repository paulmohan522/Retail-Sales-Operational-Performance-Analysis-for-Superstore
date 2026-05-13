-- =========================================================
-- Retail Sales & Operational Performance Analysis
-- Database: PostgreSQL
-- Table Name: products1
-- =========================================================


-- =========================================================
-- 1. List the Top 10 Products by Total Sales
-- =========================================================

SELECT 
    product_name,
    ROUND(SUM(sales), 2) AS total_sales
FROM products1
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;


-- =========================================================
-- 2. Calculate Average Shipping Delay per Region
-- =========================================================

SELECT 
    region,
    ROUND(AVG(ship_date - order_date), 2) AS avg_shipping_delay_days
FROM products1
GROUP BY region;


-- =========================================================
-- 3. Return All Orders Where:
--    - Shipping Delay > 5 Days
--    - Returned = 'Yes'
-- =========================================================

SELECT *
FROM products1
WHERE (ship_date - order_date) > 5
AND return_status = 'Yes';


-- =========================================================
-- 4. Calculate Monthly Total Sales and Profit
-- =========================================================

SELECT 
    DATE_TRUNC('month', order_date) AS month,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM products1
GROUP BY month
ORDER BY month;


-- =========================================================
-- 5. Get Total Profit and Total Sales by Customer Segment
-- =========================================================

SELECT 
    segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM products1
GROUP BY segment;


-- =========================================================
-- 6A. Identify the Most Profitable Sub-Category
-- =========================================================

SELECT 
    sub_category,
    ROUND(SUM(profit), 2) AS total_profit
FROM products1
GROUP BY sub_category
ORDER BY total_profit DESC
LIMIT 1;


-- =========================================================
-- 6B. Identify the Least Profitable Sub-Category
-- =========================================================

SELECT 
    sub_category,
    ROUND(SUM(profit), 2) AS total_profit
FROM products1
GROUP BY sub_category
ORDER BY total_profit ASC
LIMIT 1;


-- =========================================================
-- 7. Show Return Rate (as Percentage) by Category
-- =========================================================

SELECT 
    category,
    ROUND(
        COUNT(CASE WHEN return_status = 'Yes' THEN 1 END) 
        * 100.0 / COUNT(*),
        2
    ) || '%' AS return_rate_percentage
FROM products1
GROUP BY category;


-- =========================================================
-- 8. Find Orders Where:
--    - Profit is Negative
--    - Discount is Greater Than 30%
-- =========================================================

SELECT *
FROM products1
WHERE profit < 0
AND discount > 0.30;


-- =========================================================
-- 9. Group by Discount Reason and Return:
--    - Total Sales
--    - Total Number of Returns
-- =========================================================

SELECT 
    discount_reason,
    ROUND(SUM(sales), 2) AS total_sales,
    COUNT(
        CASE 
            WHEN return_status = 'Yes' THEN 1 
        END
    ) AS total_returns
FROM products1
GROUP BY discount_reason;


-- =========================================================
-- 10. Compare Average Sales of Returned vs Non-Returned Orders
-- =========================================================

SELECT 
    return_status,
    ROUND(AVG(sales), 2) AS avg_sales
FROM products1
GROUP BY return_status;


-- =========================================================
-- 11. Find States with Total Sales Over $500,000
--     Return:
--     - Total Profit
--     - Number of Orders
-- =========================================================

SELECT 
    state,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(order_id) AS total_orders
FROM products1
GROUP BY state
HAVING SUM(sales) > 500000
ORDER BY total_sales DESC;


-- =========================================================
-- 12. Count Customers Who Placed More Than 5 Orders
-- =========================================================

SELECT COUNT(*)
FROM (
    SELECT customer_name
    FROM products1
    GROUP BY customer_name
    HAVING COUNT(order_id) > 5
) AS customers;


-- =========================================================
-- 13. Join Customer and Order Data (If Tables Are Split)
--     Return:
--     - Customer Name
--     - Total Orders
--     - Total Sales
-- =========================================================

SELECT 
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.sales), 2) AS total_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_sales DESC;


-- =========================================================
-- 14. List Number of Unique Products Sold per Category
-- =========================================================

SELECT 
    category,
    COUNT(DISTINCT product_name) AS unique_products
FROM products1
GROUP BY category;


-- =========================================================
-- 15. Show Average Discount Offered by Region and Segment
-- =========================================================

SELECT 
    region,
    segment,
    ROUND(AVG(discount) * 100, 2) || '%' AS avg_discount
FROM products1
GROUP BY region, segment
ORDER BY region, segment;


-- =========================================================
-- Task 5: Extract a Clean Business-Focused Sample
-- =========================================================

SELECT *
FROM products1
WHERE order_date >= '2021-01-01'
AND sales > 200
AND segment IN ('Consumer', 'Corporate')
AND region IN ('East', 'South', 'Central')
AND (
        return_status = 'Yes'
        OR profit < 0
        OR discount >= 0.20
    )
ORDER BY order_date
LIMIT 50000;