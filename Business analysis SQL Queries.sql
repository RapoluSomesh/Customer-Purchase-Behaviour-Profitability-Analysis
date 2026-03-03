create database business;
use business;

# creating Table for importing dataset in this table
create table sales_data (
	order_id varchar(10),
    customer_id varchar(10),
    order_date varchar(20),
    region varchar(20),
    product_category varchar(50),
    quality int,
    sales decimal(10,2),
    cost decimal(10,2)
);

select * from sales_data limit 10;

#Adding Profit Column

alter table sales_data add column profit decimal(10,2);

set sql_safe_updates = 0;

update sales_data 
set profit = sales - cost;

#Adding Profit Margin Column
alter table sales_data 
add column profit_margin decimal(10,2);

update sales_data 
set profit_margin = (profit / sales)* 100;

#changing date format in new column
ALTER TABLE sales_data
ADD COLUMN order_date_clean DATE;

UPDATE sales_data
SET order_date_clean = STR_TO_DATE(order_date, '%d-%m-%Y');

#1 Monthly Revenue Trend
SELECT 
    MONTH(order_date_clean) AS month,
    SUM(sales) AS total_revenue
FROM sales_data
GROUP BY month
ORDER BY total_revenue DESC;

#2 Repeat Customers
SELECT 
    customer_id,
    COUNT(order_id) AS purchase_count
FROM sales_data
GROUP BY customer_id
HAVING purchase_count > 1;

#3 Region-wise Sales
SELECT 
    region,
    SUM(sales) AS total_sales
FROM sales_data
GROUP BY region
ORDER BY total_sales DESC;

#4 Category-wise Revenue
SELECT 
    product_category,
    SUM(sales) AS category_sales
FROM sales_data
GROUP BY product_category
ORDER BY category_sales DESC;

#5 Profit by Category
SELECT 
    product_category,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY product_category
ORDER BY total_profit DESC;

#6 Average Order Value (AOV)
SELECT 
    SUM(sales) / COUNT(DISTINCT order_id) AS avg_order_value
FROM sales_data;

#7 Average Profit Margin
SELECT 
    AVG(profit_margin) AS avg_profit_margin
FROM sales_data;

#8 Total Customers
SELECT 
    COUNT(DISTINCT customer_id) AS total_customers
FROM sales_data;