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
em làm như này thì bị báo lỗi total_items does not exis e chưa hiểu sao lại báo lỗi thế */ 
--EX5:
SELECT candidate_id 
FROM candidates
WHERE skill IN ( 'Python', 'Tableau' , 'PostgreSQL')
GROUP BY (candidate_id)
HAVING COUNT(candidate_id) =3
ORDER BY candidate_id;
--EX6: 
