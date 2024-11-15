with stg_orders as (
    select 
        o.OrderID,
        replace(to_date(o.OrderDate)::varchar, '-', '')::int as orderdatekey,
        md5(cast(coalesce(cast(o.CustomerID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as customerkey,
        md5(cast(coalesce(cast(o.EmployeeID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as employeekey
    from {{ source('northwind', 'Orders') }} o
),
stg_order_details as (
    select
        od.OrderID,
        md5(cast(coalesce(cast(od.ProductID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as productkey,
        od.Quantity as quantity,
        (od.Quantity * od.UnitPrice * (1 - od.Discount)) as total_sales_amount
    from {{ source('northwind', 'Order_Details') }} od
)

select 
    md5(cast(coalesce(cast(o.OrderID as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(od.productkey as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as saleskey,
    o.orderdatekey,
    o.customerkey,
    o.employeekey,
    od.productkey,
    od.quantity,
    od.total_sales_amount
from stg_orders o
join stg_order_details od on o.OrderID = od.OrderID
