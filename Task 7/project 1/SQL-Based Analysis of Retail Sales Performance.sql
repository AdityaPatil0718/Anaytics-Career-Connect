create schema SuperMarket_Sales;
use SuperMarket_Sales;

use supermarket_sales;
create table supermarket_sales(
Invoice_ID  text,
Branch text, 
City  text,
Customer_type text,  
Gender  text,
Product_line text, 
Unit_price  bigint,
Quantity  int,
Tax_5  double,
Total double,
Date text,
Time  text,
Payment  text,
cogs  double,
gross_margin_percentage bigint,
gross_income  double,
Rating double);

select * from supermarket_sales;

-- 1. Convert Date column to proper format (assuming it's in MM/DD/YYYY)
ALTER TABLE supermarket_sales 
ADD COLUMN Date_Formatted DATE;

UPDATE supermarket_sales 
SET Date_Formatted = STR_TO_DATE(Date, '%m/%d/%Y');

-- 2. Convert Time column to proper format
ALTER TABLE supermarket_sales 
ADD COLUMN Time_Formatted TIME;

UPDATE supermarket_sales 
SET Time_Formatted = STR_TO_DATE(Time, '%H:%i');

select * from supermarket_sales;


-- 3. Exploratory Data Analysis (EDA)

-- Customer Segmentation
-- Query to count transactions by customer type
select Customer_type, count(*) as Transaction_count
from supermarket_sales
group by Customer_type;


-- Analyze average spending per customer type
select Customer_type, avg(Total) as Avg_Spending
from supermarket_sales
Group by Customer_type;


-- Sales Trend Analysis
-- Determine sales performance over time
select Date_Formatted, sum(Total) as Total_sales
from supermarket_sales
group by Date_Formatted
order by Date_Formatted;



-- Identify peak sales days and time slots
select Date_Formatted, Time_Formatted, sum(Total) as Sales
from supermarket_sales
group by Date_Formatted, Time_Formatted
order by Sales Desc
limit 10;


-- Product Line Performance
-- Rank  product line by total revenue
select Product_line, sum(Total) as Total_Revenue
from supermarket_sales
group by Product_line
order by Total_Revenue desc;



-- Compute avg quantity sold per product category
select Product_line, Avg(Quantity) as Avg_Quantity_Sold
from supermarket_sales
group by Product_line;


-- Payment Method Insights
-- Determine the most preferred payment methods
Select Payment, count(*) as Payment_Count
from supermarket_sales
group by Payment
order by Payment_Count desc;


-- Evaluate the correlation between payment methods and customer satisfaction
select Payment, avg(Rating) as AVG_Customer_Satisfaction
from supermarket_sales
Group by Payment
Order by AVG_Customer_Satisfaction DESC;



-- 4. Performance Analysis

-- Branch and City-wise sales performance
select Branch, City, sum(Total) as Total_Sales
from supermarket_sales
group by Branch, City
order by Total_Sales desc;

-- Customer Type Revenue Contribution
SELECT Customer_type, SUM(Total) AS Total_Revenue 
FROM supermarket_sales
GROUP BY Customer_type
ORDER BY Total_Revenue DESC;

-- Product Line Profitability
SELECT Product_line, SUM(gross_income) AS Total_Profit, 
       (SUM(gross_income) / SUM(cogs)) * 100 AS Profit_Margin_Percentage
FROM supermarket_sales
GROUP BY Product_line
ORDER BY Total_Profit DESC;

-- Gross Income & Margins Analysis
SELECT SUM(gross_income) AS Total_Gross_Income, 
       AVG(gross_margin_percentage) AS Avg_Gross_Margin_Percentage
FROM supermarket_sales;

-- 5. Customer Satisfaction Analysis

-- Analyze customer ratings by product line and store branch
SELECT Product_line, Branch, AVG(Rating) AS Avg_Rating 
FROM supermarket_sales
GROUP BY Product_line, Branch
ORDER BY Avg_Rating DESC;

-- Identify factors influencing higher customer satisfaction scores
SELECT Product_line, Payment, Customer_type, AVG(Rating) AS Avg_Rating 
FROM supermarket_sales
GROUP BY Product_line, Payment, Customer_type
ORDER BY Avg_Rating DESC;


-- 6. Additional Business Insights

-- Identify top 5 best-selling products by quantity
SELECT Product_line, SUM(Quantity) AS Total_Quantity_Sold 
FROM supermarket_sales
GROUP BY Product_line
ORDER BY Total_Quantity_Sold DESC
LIMIT 5;

-- Identify least selling products
SELECT Product_line, SUM(Quantity) AS Total_Quantity_Sold 
FROM supermarket_sales
GROUP BY Product_line
ORDER BY Total_Quantity_Sold ASC
LIMIT 5;

-- Identify the most profitable branch
SELECT Branch, SUM(gross_income) AS Total_Profit 
FROM supermarket_sales
GROUP BY Branch
ORDER BY Total_Profit DESC
LIMIT 1;

-- Determine if discounts affect ratings (by comparing total sales and rating per product line)
SELECT Product_line, AVG(Total) AS Avg_Total_Spent, AVG(Rating) AS Avg_Rating 
FROM supermarket_sales
GROUP BY Product_line
ORDER BY Avg_Rating DESC;

-- Identify busiest hours for sales
SELECT HOUR(Time_Formatted) AS Hour, COUNT(*) AS Transaction_Count 
FROM supermarket_sales
GROUP BY Hour
ORDER BY Transaction_Count DESC
LIMIT 5;

select * from supermarket_sales;


SELECT customers.name, orders.total_price 
FROM customers 
JOIN orders ON customers.id = orders.customer_id;

