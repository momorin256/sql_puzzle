create table PriceByAge (
  product_id char(10) not null,
  low_age integer not null,
  high_age integer not null,
  product_price decimal(8, 2) not null,
  check (low_age <= high_age),
  primary key (product_id, low_age)
);

insert into PriceByAge values
  ('P01', 0, 15, 20.00),
  ('P01', 16, 64, 18.00),
  ('P01', 65, 150, 17.00),
  ('P02', 1, 5, 20.00);

-- A1

create table Sequence (seq integer not null primary key);

insert into Sequence
with Digits(n) as
(
  values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)
)
select
  D0.n + D1.n * 10 + D2.n * 100
from
  Digits as D0, Digits as D1, Digits as D2;

select
  P0.product_id
from
  PriceByAge as P0, Sequence as S0
where
  S0.seq between 0 and 150
  and S0.seq between P0.low_age and P0.high_age
group by
  P0.product_id
having
  count(S0.seq) = 151;
