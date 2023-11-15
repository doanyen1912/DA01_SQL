--EX1: 
SELECT 
SUM(CASE
WHEN device_type = 'laptop' THEN 1 ELSE 0
END) AS laptop_views,
SUM(CASE
WHEN device_type = 'tablet' 
OR device_type='phone'  THEN 1 ELSE 0
END) AS mobile_views
FROM viewership
;
--EX2: 
select x,y,z,
case 
when x + y > z and x + z > y and y + z > x then 'Yes'
else 'No'
end as triangle
from triangle;
--EX3:
SELECT
    ROUND(SUM(CASE 
      WHEN call_category IS NULL OR call_category = 'n/a' THEN 1
      ELSE 0
    END) * 100.0 / COUNT(case_id), 1) AS call_percentage
FROM callers; 
/* cau nay e chay may lan van loi e chua fix dc a */ 
--EX4: 
select name
from customer
where referee_id is null or referee_id !=2 ;
--EX5: 
SELECT
    survived,
    SUM(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
    SUM(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
    SUM(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
FROM titanic
GROUP BY survived;
