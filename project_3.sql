/*Doanh thu theo từng ProductLine, Year  và DealSize*/
select distinct productline,
sum(sales) over (partition by productline )
from public.sales_dataset_rfm_prj_clean_2 
select distinct Year,
sum(sales) over (partition by Year )
from public.sales_dataset_rfm_prj_clean_2 
select distinct DealSize,
sum(sales) over (partition by DealSize )
from public.sales_dataset_rfm_prj_clean_2 
