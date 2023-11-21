--EX4:
SELECT page_id
FROM pages
WHERE page_id NOT IN (
		SELECT page_id
		FROM page_likes
		)
ORDER BY page_id ASC;
--EX5:
SELECT EXTRACT(month FROM event_date) AS month,
COUNT(DISTINCT user_id) AS monthly_active_users

FROM user_actions
WHERE user_id in (
SELECT user_id FROM user_actions
WHERE EXTRACT(month FROM event_date) = 6  )
And EXTRACT(month FROM event_date) = 7 
GROUP BY EXTRACT(month FROM event_date);
--EX6:
SELECT 
LEFT(trans_date, 7) AS month, country, 
COUNT(id) AS trans_count, 
SUM(state = 'approved') AS approved_count, 
SUM(amount) AS trans_total_amount, 
SUM(CASE 
    WHEN state = 'approved' THEN amount 
    ELSE 0 
    END) AS approved_total_amount
FROM Transactions
GROUP BY month, country;
--EX7:
SELECT product_id,
 year AS first_year, quantity, price
FROM Sales
WHERE (product_id, year) IN (
SELECT product_id, MIN(year) as year
FROM Sales
GROUP BY product_id) ;
--EX8:
SELECT  customer_id
FROM Customer GROUP BY customer_id
HAVING COUNT(distinct product_key) = 
(SELECT COUNT(product_key) FROM Product);
--EX9:
SELECT employee_id FROM Employees
WHERE manager_id NOT IN (SELECT employee_id FROM Employees)
AND salary < 30000
ORDER BY employee_id;
--EX10:
SELECT 
COUNT(DISTINCT company_id) AS duplicate_companies
FROM (
  SELECT 
    company_id, 
    title, 
    description, 
    COUNT(job_id) AS job_count
  FROM job_listings
  GROUP BY company_id, title, description
) AS job_count_cte
WHERE job_count > 1;
