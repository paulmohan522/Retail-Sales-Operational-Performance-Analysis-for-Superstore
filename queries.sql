1. List the top 10 products by total sales

select product_name,round(sum(sales),2) as total_salesfrom products1group by product_nameorder by total_sales desclimit 10;

2. Calculate average shipping delay per region

select region,round(avg(ship_date - order_date),2) as avg_shipping_delay_daysfrom products1group by region;

3. Return all orders where:
Shipping Delay > 5 days
Returned = 'Yes'

select *from products1where (ship_date - order_date) > 5and return_status = 'Yes';

4. Calculate monthly total sales and profit

select date_trunc('month', order_date) as month,round(sum(sales),2) as total_sales,round(sum(profit),2) as total_profitfrom products1group by monthorder by month;

5. Get total profit and total sales by customer segment

select segment,round(sum(sales),2) as total_sales,round(sum(profit),2) as total_profitfrom products1group by segment;

6. Identify the most and least profitable sub-categories

Most Profitable Sub-Category
select sub_category,round(sum(profit),2) as total_profitfrom products1group by sub_categoryorder by total_profit desclimit 1;

Least Profitable Sub-Category
select sub_category,round(sum(profit),2) as total_profitfrom products1group by sub_categoryorder by total_profit asclimit 1;

7. Show return rate (as a percentage) by category

select category,round(count(case when return_status = 'Yes' then 1 end) * 100.0 / count(*),2) || '%' as return_rate_percentagefrom products1group by category;

8. Find orders where:
Profit is negative
Discount is greater than 30%

select *from products1where profit < 0and discount > 0.30;

9. Group by Discount Reason and return:
Total sales
Total number of returns

select discount_reason,round(sum(sales),2) as total_sales,count(case when return_status = 'Yes' then 1 end) as total_returnsfrom products1group by discount_reason;

10. Compare the average sales of returned vs. non-returned orders
select return_status,round(avg(sales),2) as avg_salesfrom products1group by return_status;

11. Find states with total sales over $500,000 and return:
Total profit
Number of orders

select state,round(sum(sales),2) as total_sales,round(sum(profit),2) as total_profit,count(order_id) as total_ordersfrom products1group by statehaving sum(sales) > 500000order by total_sales desc;

12. Count how many customers placed more than 5 orders

select count(*)from (select customer_namefrom products1group by customer_namehaving count(order_id) > 5) as customers;

13. Join customer and order data (if tables are split) to show:
Customer name
Total orders
Total sales

select c.customer_name,count(o.order_id) as total_orders,round(sum(o.sales),2) as total_salesfrom customers cjoin orders oon c.customer_id = o.customer_idgroup by c.customer_nameorder by total_sales desc;

14. List the number of unique products sold per category

select category,count(distinct product_name) as unique_productsfrom products1group by category;

15. Show the average discount offered by region and segment

select region,segment,round(avg(discount) * 100,2) || '%' as avg_discountfrom products1group by region, segmentorder by region, segment;

Task 5: Extract a Clean Business-Focused Sample of Superstore Data
SQL Query

select *from products1where order_date >= '2021-01-01'and sales > 200and segment in ('Consumer','Corporate')and region in ('East','South','Central')and (return_status = 'Yes'or profit < 0or discount >= 0.20)order by order_datelimit 50000;