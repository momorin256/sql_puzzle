create table Sales (
  customer_name varchar(5) not null,
  sale_date date not null,
  primary key (customer_name, sale_date)
);

insert into Sales values
  ('Alice', '2022-01-01'),
  ('Alice', '2022-01-02'),
  ('Alice', '2022-01-03'), -- Alice 1.0
  ('Betty', '2022-01-01'),
  ('Betty', '2022-01-03'),
  ('Betty', '2022-01-05'),
  ('Betty', '2022-01-07'), -- Betty 2.0
  ('Chris', '2022-01-01'),
  ('Chris', '2022-01-03'),
  ('Chris', '2022-01-07'); -- Chris 3.0

-- A1
select
  customer_name,
  avg(sale_date - prev_sale_date)
from
(
  select
    customer_name,
    sale_date,
    lag(sale_date) over (partition by customer_name order by sale_date)
  from
    Sales
) as T(customer_name, sale_date, prev_sale_date)
where
  prev_sale_date is not null
group by
  customer_name;

-- A2
select
  S0.customer_name,
  avg(S0.sale_date - S1.sale_date)
from
  Sales as S0
  inner join Sales as S1
    on S0.customer_name = S1.customer_name
      and S1.sale_date = (
        select max(S2.sale_date)
        from Sales as S2
        where S2.customer_name = S0.customer_name
          and S2.sale_date < S0.sale_date)
group by
  S0.customer_name;

-- A3
select
  customer_name,
  (max(sale_date) - min(sale_date)) / (count(*) - 1)
from
  Sales
group by
  customer_name
having
  count(*) > 1;
