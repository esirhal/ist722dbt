with f_sales as (
    select * from {{ ref('fact_sales') }}
),
d_customer as (
    select customerkey, customerid, contactname as customername
    from {{ ref('dim_customer') }}
),
d_employee as (
    select employeekey, employeeid, employeenamefirstlast as employeename
    from {{ ref('dim_employee') }}
),
d_product as (
    select productkey, productid, productname
    from {{ ref('dim_product') }}
),
d_date as (
    select datekey as orderdatekey, date as order_date
    from {{ ref('dim_date') }}
)

select 
    f.saleskey,  -- Ensure this is correct
    f.orderdatekey,
    d_date.order_date,
    f.customerkey,
    d_customer.customername, 
    f.employeekey,
    d_employee.employeename,
    f.productkey,
    d_product.productname,
    f.quantity,
    f.total_sales_amount
from f_sales f
left join d_customer on f.customerkey = d_customer.customerkey
left join d_employee on f.employeekey = d_employee.employeekey
left join d_product on f.productkey = d_product.productkey
left join d_date on f.orderdatekey = d_date.orderdatekey
