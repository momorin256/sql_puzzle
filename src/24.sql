create table MyTable (
  keycol integer not null,
  f1 integer not null,
  f2 integer not null,
  f3 integer not null,
  f4 integer not null
);

insert into MyTable values
  (1, 0, 1, 0, 0), (2, 0, 0, 0, 2), (3, 1, 2, 0, 0), (4, 0, 0, 0, 0);

select
  *
from
  MyTable
where
  ((f1 <> 0) and (f2 = 0) and (f3 = 0) and (f4 = 0))
  or ((f1 = 0) and (f2 <> 0) and (f3 = 0) and (f4 = 0))
  or ((f1 = 0) and (f2 = 0) and (f3 <> 0) and (f4 = 0))
  or ((f1 = 0) and (f2 = 0) and (f3 = 0) and (f4 <> 0));

select
  *
from
  MyTable
where
  f1 + f2 + f3 + f4 in (f1, f2, f3, f4)
  and f1 + f2 + f3 + f4 <> 0;

select
  *
from
  MyTable
where
  1 = abs(sign(f1)) + abs(sign(f2)) + abs(sign(f3)) + abs(sign(f4));

select
  *
from
  MyTable
where
  (f1, f2, f3, f4) in (
    (f1, 0, 0, 0),
    (0, f2, 0, 0),
    (0, 0, f3, 0),
    (0, 0, 0, f4)
  )
  and (f1, f2, f3, f4) <> (0, 0, 0, 0);
