create table MyTable (
  num integer not null primary key,
  data char(1) not null
);

insert into MyTable values
  (1, 'a'), (2, 'a'),
  (3, 'b'), (6, 'b'),
  (8, 'a');

-- A1
select
  min(low), high, data
from
(
  select
    T0.num,
    max(T1.num),
    T0.data
  from
    MyTable as T0
    inner join MyTable T1
      on T0.data = T1.data
        and T0.num <= T1.num
  where
    not exists (
      select
        *
      from
        MyTable as T2
      where
        (T2.num between T0.num and T1.num)
        and T2.data <> T0.data)
  group by
    T0.num, T0.data
) as Tmp(low, high, data)
group by
  high, data;

-- A2
select
  min(T0.num), max(T0.num), T0.data
from
  MyTable as T0
  left outer join MyTable T1
    on T1.num = (
      select min(T2.num)
      from MyTable as T2
      where T0.num < T2.num and T0.data <> T2.data)
group by
  T0.data, T1.num;
