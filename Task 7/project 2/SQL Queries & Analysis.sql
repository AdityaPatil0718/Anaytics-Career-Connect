Create schema cust_trans_dataset;
use cust_trans_dataset;

-- Joinig tables with left join
select t.*, c.DOB, c.Gender, c.city_code, p.prod_cat, p.prod_subcat
from Transactions t
left join Customer c on t.cust_id = c.customer_Id
left join prod_cat_info p on t.prod_cat_code = p.prod_cat_code 
                         and t.prod_subcat_code = p.prod_sub_cat_code;



-- SQL Queries & Analysis

-- total sales and total tax collected across all transactions.
select
    sum(total_amt) as total_sales, 
    sum(Tax) as total_tax_collected
from Transactions;


-- the most popular product category based on purchase frequency.
select
	p.prod_cat,
    count(t.transaction_id) as purchase_count
from transactions t
left join prod_cat_info p on t.prod_cat_code = p.prod_cat_code
group by p.prod_cat
order by purchase_count desc
limit 1;


-- customer purchase behavior by gender and city.
select
	c.Gender,
    c.city_code,
    count(t.transaction_id) as total_purchases,
    sum(t.total_amt) as total_spent
from transactions t
left join customer c on t.cust_id = c.customer_Id
group by c.Gender, c.city_code
order by total_spent desc;


-- 	Average Spending Per Customer
select 
    c.customer_Id, 
    AVG(t.total_amt) as avg_spending
from Transactions t
left join Customer c on t.cust_id = c.customer_Id
group by c.customer_Id
order by avg_spending desc;


-- Sales Performance Across Different Store Types
select 
    Store_type, 
    count(transaction_id) as total_transactions, 
    sum(total_amt) as total_sales
from Transactions
group by Store_type
order by total_sales desc;


-- Advanced SQL Insights

--  Identify Peak Transaction Periods (Daily & Monthly Trends)
-- For daily trends
select 
    tran_date, 
    count(transaction_id) as total_transactions, 
    sum(total_amt) as total_sales
from Transactions
group by tran_date
order by total_sales desc
limit 10;

-- Compare the Most Profitable Product Categories
select 
    p.prod_cat, 
    sum(t.total_amt) as total_revenue, 
    sum(t.total_amt) - sum(t.Qty * t.Rate) as total_profit
from Transactions t
left join prod_cat_info p on t.prod_cat_code = p.prod_cat_code
group by p.prod_cat
order by total_profit desc
limit 5;


-- Analyze Customer Retention Based on Repeat Purchases
select 
    c.customer_Id, 
    count(distinct t.transaction_id) as purchase_count
from Transactions t
left join Customer c on t.cust_id = c.customer_Id
group by c.customer_Id
having purchase_count > 1
order by purchase_count desc
limit 10;


-- Identify Store Types Generating the Highest Revenue
select 
    Store_type, 
    count(transaction_id) as total_transactions, 
    sum(total_amt) as total_revenue
from Transactions
group by Store_type
order by total_revenue desc;


-- Reporting & Visualization
-- Sales summary Report	
select 
   date_format(tran_date, '%Y-%m') as month, 
    count(transaction_id) as total_transactions, 
    sum(total_amt) as total_sales, 
    sum(Tax) as total_tax_collected
from Transactions
group by month
order by month;


-- Customer Demographics Report
select 
    Gender, 
    city_code, 
    count(customer_Id) as total_customers, 
    count(t.transaction_id) as total_purchases, 
    sum(t.total_amt) as total_spent
from Customer c
left join Transactions t on c.customer_Id = t.cust_id
group by Gender, city_code
order by total_spent desc;


-- Product Demand Report
select 
    p.prod_cat, 
    p.prod_subcat, 
    count(t.transaction_id) as total_purchases, 
    sum(t.Qty) as total_quantity_sold, 
    sum(t.total_amt) as total_revenue
from Transactions t
left join prod_cat_info p on t.prod_cat_code = p.prod_cat_code
group by p.prod_cat, p.prod_subcat
order by total_revenue desc;


-- Analytical Questions to Answer

-- Q1. What is the total revenue and tax collected across all transactions?
select 
    sum(total_amt) as total_revenue, 
    sum(Tax) as total_tax_collected
from Transactions;


-- Q2. Which product subcategory generates the highest sales?
select 
    p.prod_subcat, 
    sum(t.total_amt) as total_sales
from Transactions t
left join prod_cat_info p 
    on t.prod_cat_code = p.prod_cat_code 
    and t.prod_subcat_code = p.prod_sub_cat_code
group by p.prod_subcat
order by total_sales desc
limit 1;


-- What is the average spending per customer by city and gender?
select 
    c.city_code, 
    c.Gender, 
    AVG(t.total_amt) as avg_spending
from Transactions t
left join Customer c on t.cust_id = c.customer_Id
group by c.city_code, c.Gender
order by avg_spending desc;


-- How do sales vary across different store types?
select 
    Store_type, 
    count(transaction_id) as total_transactions, 
    sum(total_amt) as total_sales
from Transactions
group by Store_type
order by total_sales desc;


-- Which product category has the highest profit margin?
select 
    p.prod_cat, 
    sum(t.total_amt - (t.Qty * t.Rate)) as total_profit,
    sum(t.total_amt) as total_revenue,
    (sum(t.total_amt - (t.Qty * t.Rate)) / sum(t.total_amt)) * 100 as profit_margin_percentage
from Transactions t
left join prod_cat_info p on t.prod_cat_code = p.prod_cat_code
group by p.prod_cat
order by total_profit desc
limit 1;
