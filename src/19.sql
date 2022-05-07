create table SalesData (
  district_id integer not null,
  sales_person varchar(10) not null,
  sales_id integer not null,
  sales_amt decimal(5, 2) not null
);

insert into SalesData values
  (1, 'Curly', 5, 3.00),
  (1, 'Harpo', 11, 4.00),
  (1, 'Larry', 1, 50.00),
  (1, 'Larry', 2, 50.00),
  (1, 'Larry', 3, 50.00),
  (1, 'Moe', 4, 5.00),
  (2, 'Dick', 8, 5.00),
  (2, 'Fred', 7, 5.00),
  (2, 'Harry', 6, 5.00),
  (2, 'Tom', 7, 5.00),
  (3, 'Irving', 10, 5.00),
  (3, 'Melvin', 9, 7.00),
  (4, 'Jenny', 15, 20.00),
  (4, 'Jessie', 16, 10.00),
  (4, 'Mary', 12, 50.00),
  (4, 'Oprah', 14, 30.00),
  (4, 'Sally', 13, 40.00);

-- A1
select
  district_id,
  sales_person,
  sales_id,
  sales_amt
from
  SalesData as S0
where
  2 >= (
    select count(*)
    from SalesData as S1
    where S0.district_id = S1.district_id
      and S0.sales_amt < S1.sales_amt
  );

-- A1'

select
  S0.district_id, S0.sales_person
from
  SalesData as S0
  left outer join SalesData as S1
    on S0.district_id = S1.district_id
      and S0.sales_amt <= S1.sales_amt
group by
  S0.district_id, S0.sales_person, S0.sales_id, S0.sales_amt
having
  count(*) <= 3;

-- A2

select
  district_id,
  sales_person,
  sales_amt,
  sales_rank
from
  (
    select
      district_id,
      sales_person,
      sales_amt,
      rank() over (partition by district_id order by sales_amt desc)
    from
      SalesData as S0
  ) as T(district_id, sales_person, sales_amt, sales_rank)
where
  sales_rank <= 3
order by
  district_id, sales_rank;
