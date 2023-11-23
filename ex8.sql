--EX1: 
with erliest_date as(
  select *,
  first_value(order_date ) over (partition by customer_id order by order_date  ) as first_order
  from delivery) 
  
  select
  round((avg(order_date = customer_pref_delivery_date)*100),2)  as immediate_percentage 
  from erliest_date;
-- em lam ntn nhung dap an ra 42,86 khac voi dap an dung ac sua giup e aj-- 
--EX2: 
with first_date as (
select player_id,
first_value(event_date) over(partition by player_id) AS first_of_date
from activity
group by player_id)
select round(sum(b.player_id)/count(distinct a.player_id),2) as  fraction 
from Activity as a 
left join first_date as b 
on a.player_id = b.player_id and a.event_date = b.first_of_date +1 ; 
-- bai nay e lam case test 1 thi dung nhung sang case test 2 lai bi lech dap an ac xem giup e a--
--EX3: 
select  
      case 
        when id % 2 = 0 then id - 1
        when id % 2 = 1 and id < (select count(*) from seat)then id + 1
        else id
      end as id, 
    student from seat
    order by id;
--EX4:
select
    visited_on,
    (
        select SUM(amount)
        from customer
        where visited_on between DATE_SUB(c.visited_on, INTERVAL 6 day) and c.visited_on
    ) as amount,
    ROUND(
        (
            select SUM(amount) / 7
            from customer
            where visited_on between DATE_SUB(c.visited_on, INTERVAL 6 day) and c.visited_on
        ),
        2
    ) as average_amount
from customer c
where visited_on >= (
        select DATE_ADD(MIN(visited_on), INTERVAL 6 day)
        from customer
    )
group by visited_on;
--EX5: 
select round(sum(tiv_2016), 2) as tiv_2016 from insurance 
where pid in 
(select pid from insurance group by lat, lon having count(*) = 1) 
AND pid not in
(select pid from insurance group by tiv_2015 having count(*) = 1);
--EX6:
select Department, employee, salary from (
    select d.name as Department
        , e.name as employee
        , e.salary
        , DENSE_RANK() OVER (PARTITION BY d.name order by e.salary DESC) as drk
    from Employee e JOIN Department d on e.DepartmentId= d.Id
) t where t.drk <= 3
--EX7:
select 
 a.person_name
from Queue as a 
join Queue as b 
on a.turn >= b.turn
group by a.turn
having sum(b.weight) <= 1000
order by sum(b.weight) desc
limit 1
--EX8:
select distinct product_id, 10 as price 
from Products where product_id not in
(select distinct product_id from Products where change_date <='2019-08-16' )
union 
select product_id, new_price as price 
from Products
where (product_id,change_date) in (select product_id , max(change_date) as date
from Products where change_date <='2019-08-16' group by product_id)

