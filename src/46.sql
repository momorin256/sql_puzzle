create table Promotions (
  promo_name varchar(10) not null primary key,
  start_date date not null,
  end_date date not null,
  check (start_date <= end_date)
);

insert into Promotions values
  ('A', '2022-01-01', '2022-01-25'),
  ('B', '2022-02-01', '2022-02-25'),
  ('C', '2022-03-01', '2022-03-25');

create table Sales (
  ticket_id integer not null primary key,
  clerk_name varchar(10) not null,
  sale_date date not null,
  sale_amt decimal(8, 2) not null
);

insert into Sales values
  (11, 'Alice', '2022-01-01', 20.00),
  (12, 'Alice', '2022-01-02', 45.00),
  (13, 'Alice', '2022-02-01', 20.00),
  (14, 'Alice', '2022-03-01', 20.00),
  (15, 'Brown', '2022-01-01', 10.00),
  (16, 'Brown', '2022-02-01', 30.00),
  (17, 'Brown', '2022-02-02', 40.00),
  (18, 'Brown', '2022-03-01', 10.00),
  (19, 'Chris', '2022-01-01', 10.00),
  (20, 'Chris', '2022-02-01', 10.00),
  (21, 'Chris', '2022-03-01', 20.00),
  (22, 'Chris', '2022-03-02', 30.00);

-- A1
select
  P0.promo_name, S0.clerk_name
from
  Promotions as P0
  inner join Sales as S0
    on S0.sale_date between P0.start_date and P0.end_date
group by
  P0.promo_name, P0.start_date, P0.end_date, S0.clerk_name
having
  sum(S0.sale_amt) >= all (
    select sum(S1.sale_amt)
    from Sales as S1
    where S1.sale_date between P0.start_date and P0.end_date
    group by S1.clerk_name
  );

-- A2
with ClerksTotals (clerk_name, promo_name, sales_amt)
as
(
  select S0.clerk_name, P0.promo_name, sum(S0.sale_amt)
  from Promotions as P0
    inner join Sales as S0
      on S0.sale_date between P0.start_date and P0.end_date
  group by S0.clerk_name, P0.promo_name
)
select
  *
from
  ClerksTotals as C0
where
  C0.sales_amt = (
    select max(C1.sales_amt)
    from ClerksTotals as C1
    where C1.promo_name = C0.promo_name
  );
