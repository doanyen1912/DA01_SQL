--EX1: 
select name
from students
where marks > 75
order by right(name,3),id;
--EX2:
/*lower(substring(name from 2 for)) */
select user_id,
concat(upper(left(name,1)) , lower(right(name,length(name)-1))) as name

 from users; 
--EX3:
SELECT manufacturer,
concat('$',ROUND(SUM(total_sales)/1000000.0),'milion') AS sales_mil
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer;
--EX4: 
SELECT 
EXTRACT(month FROM submit_date) as mth,
product_id,
ROUND(AVG(stars),2) AS avarage_stars
FROM reviews
GROUP BY EXTRACT(month FROM submit_date),product_id
ORDER BY EXTRACT(month FROM submit_date), product_id;
--EX5: 
SELECT 
sender_id,
COUNT(message_id) as message_count
FROM messages
WHERE EXTRACT(month FROM sent_date) = 8 AND  EXTRACT(year FROM sent_date) = 2022
GROUP BY sender_id
ORDER BY COUNT(message_id) DESC 
LIMIT 2;
--EX6:
select tweet_id
from tweets
where(length(content) > 15);
--EX7: 
select activity_date as day, count(distinct user_id) as active_users 
from Activity
where activity_date between date_add('2019-07-27', interval -29 day) and '2019-07-27'
group by  activity_date;
--EX8:
select 
count (id ) as employeer_id
from employees
where (extract(month from joining_date) between 01 and 07) and extract(year from joining_date) = 2022;
--EX9: 
select 
position('a' in first_name) as find_name
from worker
where first_name = 'Amitah';
--EX10:
select 
substring(title,length(winery)+2,4)
from winemag_p2
where country= 'Macedonia';
