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
--Question 1 :
select replacement_cost
from film
order by replacement_cost asc
limit 1;
-- Question 2: 
select  /*
(case 
 when replacement_cost >= 9.99 and replacement_cost <= 19.99 then 'low'
 when replacement_cost >= 20.00 and replacement_cost <= 24.99 then 'medium'
 else 'high'
end) as price,*/
sum (case 
	  when replacement_cost >= 9.99 and replacement_cost <= 19.99 
	  then 1 else 0 
	  end )
from film

;
-- Question 3: 
select a.length,c.name
from film /*title,length*/ as a 
left join film_category as b
on a.film_id = b.film_id
left join category as c 
on b.category_id = c.category_id
where c.name = 'Drama' or c.name='Sports'
order by c.name asc, a.length desc
limit 1
;
-- Question 4: 
select c.name,count(c.name) as so_luong
from film /*title,length*/ as a 
left join film_category as b
on a.film_id = b.film_id
left join category as c 
on b.category_id = c.category_id
group by c.name 
order by count(c.name) desc
limit 1

;
-- Question 5: 
select a.first_name ||' '|| a.last_name as name,
count(film_id) as count_film
from actor /*first last name */ as a 
left join film_actor /*actor_id*/ as b
on a.actor_id = b.actor_id
group by a.actor_id
order by count(film_id) desc
limit 1;
-- 2 cau nay e k ra dap an dung e chua sua dc c sua giup e voi a 
-- Question 6: 
select 
count(distinct a.city_id) as so_luong
from city as a 
left join address as b 
on a.city_id=b.city_id
left join customer as c 
on b.address_id = c.address_id
where c.customer_id is null ;
-- Question 7: 
select 
b.city,
sum(e.amount) as tong_dt
from address as a 
left join city as b
on a.city_id = b.city_id
left join country as c
on b.country_id = c.country_id
left join customer as d
on a.address_id = d.address_id
left join payment as e 
on d.customer_id = e.customer_id
group by b.city 
having sum(e.amount) is not null
order by sum(e.amount) desc
limit 1
;

-- Question 8: 
select 
c.country ||' '|| b.city as infor,
sum(e.amount) as tong_dt
from address as a 
left join city as b
on a.city_id = b.city_id
left join country as c
on b.country_id = c.country_id
left join customer as d
on a.address_id = d.address_id
left join payment as e 
on d.customer_id = e.customer_id
group by c.country ||' '|| b.city 
having sum(e.amount) is not null
order by sum(e.amount) asc/*dap an la doanh thu thap nhat*/
limit 1
;
