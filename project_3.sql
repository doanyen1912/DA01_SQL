/*Doanh thu theo từng ProductLine, Year  và DealSize*/
select distinct productline, year_id, dealsize,
sum(sales) over (partition by productline )
from public.sales_dataset_rfm_prj_clean_2 
select distinct Year,
sum(sales) over (partition by Year )
from public.sales_dataset_rfm_prj_clean_2 
select distinct DealSize,
sum(sales) over (partition by DealSize )
from public.sales_dataset_rfm_prj_clean_2 

/*Đâu là tháng có bán tốt nhất mỗi năm?
  Output: MONTH_ID, REVENUE, ORDER_NUMBER*/ 
with cte_rank as (
select distinct year_id,month_id, ordernumber,
sum(sales) ,
row_number() over (partition by year_id order by sum(sales)  ) as rank_sales 
from public.sales_dataset_rfm_prj_clean_2
group by year_id,month_id
order by year_id,month_id) 
select * from cte_rank 
where rank_sales = 12  

/*Product line nào được bán nhiều ở tháng 11?
MONTH_ID, REVENUE, ORDER_NUMBER*/ 
select distinct productline,month_id,ordernumber, 
sum(sales) over (partition by productline )
from public.sales_dataset_rfm_prj_clean_2 
where month_id = 11
order by sum(sales) over (partition by productline ) desc 

/*Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? */ 
with cte as (select distinct year_id,month_id, productline,state, 
sum(sales) over (partition by productline) as sum_sale,
row_number() over(partition by year_id ) as rank_sale
from public.sales_dataset_rfm_prj_clean_2
order by  year_id, sum(sales) over (partition by productline) desc ) 

select * from cte
where state <> 'Tokyo' and state <> 'Osaka' and
rank_sale = 1
--câu này e tính ra sp có doanh thu cao nhất e thấy có tokyo vs osaka là k p uk nên e lọc 2 nc này ạ --  

