--EX1: 
select name from city 
where population > 120000 and countrycode = 'USA';
--EX2:
select * from city 
where countrycode = 'JPN';
--EX3:
select city, state from station;
--EX4:
select distinct city from station 
where city like in ('%i','%e','%a','%e','%i','%u');
--EX5:
select distinct city 
from station 
where city like in ('%a','%e','%i','%o','%u');
--EX6:
Select DISTINCT CITY
FROM
STATION
Where CITY NOT LIKE 'A%' AND CITY NOT LIKE 'E%' AND CITY NOT LIKE 'I%' AND CITY NOT LIKE 'O%' AND CITY NOT LIKE 'U%';\
--EX7:
SELECT name
FROM Employee
ORDER BY name;
--EX8:
SELECT name
FROM Employee
WHERE salary > 2000 AND months < 10
ORDER BY employee_id;
--EX9: 
select product_id
from Products
where low_fats = "Y" and recyclable = "Y";
--EX10: 
SELECT name FROM customer
WHERE referee_id != 2 OR referee_id IS NULL;
--EX11:
SELECT name,population,area FROM WORLD 
WHERE area >= 3000000 OR population >= 25000000;
--EX12:
SELECT DISTINCT author_id as id 
FROM Views
WHERE author_id = viewer_id
ORDER BY author_id;
--EX13: 
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL;
--EX14:
elect * from lyft_drivers
where yearly_salary < 30000 or yearly_salary > 70000 ;
--EX15:
select * from uber_advertising
where money_spent > 10000 and year = 2019;
