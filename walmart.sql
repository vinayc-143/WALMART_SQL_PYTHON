create database  walmart_db;
use walmart_db;
select * from  walmart;
select count(*) from walmart;
-- count payment methods and number of transaction by payment  method --
select
payment_method,
count(*) as nos_payments
from walmart
 group by payment_method;
 -- count distinct branches--
 select count(distinct branch) from  walmart;
 -- find the minimum quantity sold--
 select min(quantity) from  walmart;
 -- find the max quantity sold --
  select max(quantity) from  walmart;
   -- BUSINESS PROBLEMS --
   -- Q1.FIND DIFFERENT PAYMENT  METHOD NUMBER OF TRANSACTION  AND QUANTITY SOLD BY PAYMENT METHOD
SELECT
payment_method,
count(*)as nos_payment,
sum(quantity) as no_qty_sold
from walmart
group by  payment_method;
-- Q2 IDENTIFY THE HIGHEST RATED CATEGORY  IN EACH BRANCH  DISPLAY THE BRANCH , CATEGORY ,AND AVG_RATING
SELECT branch, category, avg_rating
FROM (
    SELECT 
        branch,
        category,
        AVG(rating) AS 
        avg_rating,
        RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS top
    FROM walmart
    GROUP BY branch, category
) AS ranked
WHERE top = 1;
-- Q3  IDENTIFY THE BUSIEST DAY FOR EACH BRANCH BASED ON THE  NUMBER OF TRANSACTION
SELECT *
FROM (
    SELECT 
        branch,
        DAYNAME(STR_TO_DATE(date, '%d/%m/%y')) AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS TOP
    FROM walmart
    GROUP BY branch, day_name
) ranked_data
WHERE TOP = 1;
-- Q4  CALCULATE TEHE TOTAL QUANTITY  OF ITEM SOLD PER PAYMENT METHOD
SELECT
payment_method,
sum(quantity) as no_qty_sold
from walmart
group by  payment_method;
 -- Q5 DETERMINE THE  AVERAGE , MIN , MAX RATING OD CATEGORIES  FOR EACH CITY
 SELECT
 CITY,
 CATEGORY,
 MIN(RATING) AS MIN_RATING,
  MAX(RATING) AS MAX_RATING,
   AVG(RATING) AS AVG_RATING
   FROM WALMART
   GROUP BY  CITY,CATEGORY;
   -- Q6 CALCULATE TOTAL PROFIT FOR EACH CATEGORY 
   SELECT
   CATEGORY,
   SUM(UNIT_PRICE * QUANTITY * PROFIT_MARGIN) AS TOTAL_PROFIT
   FROM WALMART
   GROUP BY CATEGORY
   ORDER BY TOTAL_PROFIT DESC ;
   
   -- Q7 DETERMINE THE MOST COMMON PAYMENT METHOD FOR EACH BRANCH --
   WITH CTE AS(
   SELECT
   BRANCH ,PAYMENT_METHOD,
   COUNT(*) AS TOTAL_TRANS,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS top
FROM WALMART
GROUP BY BRANCH ,PAYMENT_METHOD
)
SELECT BRANCH,PAYMENT_METHOD  AS PREFERED_PAYMENT_METHOD
FROM CTE
WHERE top =1;   
-- Q8: Categorize sales into Morning, Afternoon, and Evening shifts --
SELECT
    branch,
    CASE 
        WHEN HOUR(TIME(time)) < 12 THEN 'Morning'
        WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS num_invoices
FROM walmart
GROUP BY branch, shift
ORDER BY branch, num_invoices DESC;

-- Q9: Identify the 5 branches with the highest revenue decrease ratio from last year to current year (e.g., 2022 to 2023)
SELECT
BRANCH,
SUM(TOTAL) AS REVENUE
FROM WALMART
GROUP BY 1