--EX1: 
select distinct city from station
where (id % 2)=0;
--EX2: 
select 
count(city)-count (distinct city)
from station;
--EX3: 
--EX4:
SELECT
ROUND(CAST(SUM(item_count * order_occurrences)/SUM(order_occurrences) AS decimal),1) as total
FROM items_per_order;
/* SELECT
SUM(item_count * order_occurrences) AS total_items,
SUM(order_occurrences) AS total_orders,
ROUND(CAST(total_items/order_occurrences as decimal),1) AS total
FROM items_per_order; 
em làm như này thì bị báo lỗi total_items does not exis e chưa hiểu sao lại báo lỗi thế aj */ 
/*total_items does not exis
tức là total_items không hề có trong bảng items_per_order 
muồn truy vấn theo cách đó bạn phải làm như này:
SUM(item_count * order_occurrences) AS total_items,
SUM(order_occurrences) AS total_orders,
ROUND(CAST(SUM(order_occurrences)/order_occurrences as decimal),1) AS total
FROM items_per_order; */
--EX5:
SELECT candidate_id 
FROM candidates
WHERE skill IN ( 'Python', 'Tableau' , 'PostgreSQL')
GROUP BY (candidate_id)
HAVING COUNT(candidate_id) =3
ORDER BY candidate_id;
--EX6: 
SELECT user_id,
max(post_date)-min(post_date) AS day_between
FROM posts
WHERE post_date >='2021-01-01' AND post_date <= '2022-01-01'
GROUP BY user_id;
--EX7: 
SELECT card_name,
MAX( issued_amount)- MIN( issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC ;
--EX8: 
SELECT
manufacturer,
COUNT(drug) as drug_count,
abs (SUM(cogs-total_sales))  AS total_loss
FROM pharmacy_sales
WHERE total_sales < cogs
GROUP BY manufacturer
ORDER BY total_loss DESC;
--EX9:
select * 
from cinema
where not (id%2=0) and description != "boring"
order by rating desc; 
--EX10:
select teacher_id,
count(distinct subject_id) as cnt

from Teacher
group by teacher_id;
--EX11:
select user_id,
count(follower_id) as followers_count
from followers
group by user_id;
--EX12: 
select class
from courses
group by class
having count(student) >= 5;


