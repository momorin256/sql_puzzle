create table SalesSlips (
  item_a integer not null,
  item_b integer not null,
  pair_tally integer not null,
  primary key(item_a, item_b)
);

insert into SalesSlips values
  (1, 1, 12),
  (1, 2, 9),
  (2, 1, 5);

select
  item_a,
  item_b,
  (
    select sum(pair_tally)
    from SalesSlips as S1
    where (S0.item_a = S1.item_a and S0.item_b = S1.item_b)
      or (S0.item_a = S1.item_b and S0.item_b = S1.item_a)
  )
from
  SalesSlips as S0
where
  not item_a > item_b;
