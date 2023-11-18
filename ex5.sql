--EX1: 
select b.continent,
floor(avg(a.population))
from city as a 
left join country as b
on a.countrycode=b.code 
where b.continent is NOT NULL
group by b.continent;
--EX2:
SELECT
ROUND(SUM(CASE 
WHEN b.signup_action = 'Confirmed' THEN 1 ELSE 0
END)*1.0 / COUNT(b.signup_action),2) 
FROM emails AS a  
LEFT JOIN texts AS b 
ON a.email_id = b.email_id
WHERE a.email_id is NOT NULL ;
--EX3:
SELECT b.age_bucket,
ROUND(
SUM(case when a.activity_type = 'send' then time_spent else 0 end)*100.0/
(SUM(case when a.activity_type = 'open' then time_spent else 0 end) + 
SUM(case when a.activity_type = 'send' then time_spent else 0 end))
,2) AS send_perc ,
ROUND(
SUM(case when a.activity_type = 'open' then time_spent else 0 end)*100.0/
(SUM(case when a.activity_type = 'send' then time_spent else 0 end) + 
SUM(case when a.activity_type = 'open' then time_spent else 0 end))
,2) AS open_perc


FROM activities AS a  
LEFT JOIN age_breakdown AS b  
ON a .user_id = b.user_id
GROUP BY b.age_bucket;
--EX4: 
SELECT a.customer_id 

FROM customer_contracts AS a  
LEFT JOIN products as b  
ON a.product_id = b.product_id
GROUP BY a.customer_id
HAVING 
  COUNT(DISTINCT b.product_category) = 3;
--EX5: 
select mgr.employee_id,
mgr.name,
COUNT(emp.employee_id) as reports_count,
ROUND(AVG(emp.age)) as average_age
from employees emp
join employees mgr
on emp.reports_to = mgr.employee_id
group by employee_id
order by employee_id;
--EX6: 
SELECT 
    a.product_name, 
    SUM(b.unit) AS unit  
FROM Products a
LEFT JOIN Orders b 
ON a.product_id = b.product_id 
WHERE MONTH(b.order_date) = '02' AND YEAR(b.order_date) = '2020'
GROUP BY a.product_name
HAVING SUM(b.unit) >= 100;
--EX7:
SELECT page_id
FROM pages
WHERE page_id NOT IN (
		SELECT page_id
		FROM page_likes
		)
ORDER BY page_id ASC; 

