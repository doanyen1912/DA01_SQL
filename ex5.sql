--EX1: 
select b.continent,
floor(avg(a.population))
from city as a 
left join country as b
on a.countrycode=b.code 
where b.continent is NOT NULL
group by b.continent;
