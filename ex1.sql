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

