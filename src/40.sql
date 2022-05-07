create table Elements (
  i integer not null primary key
);

insert into Elements values
  (1), (2), (3), (4), (5), (6), (7);

-- A1
select
  E0.i, E1.i, E2.i, E3.i, E4.i, E5.i, E6.i
from
  Elements as E0
  inner join Elements as E1
    on E1.i not in (E0.i)
  inner join Elements as E2
    on E2.i not in (E0.i, E1.i)
  inner join Elements as E3
    on E3.i not in (E0.i, E1.i, E2.i)
  inner join Elements as E4
    on E4.i not in (E0.i, E1.i, E2.i, E3.i)
  inner join Elements as E5
    on E5.i not in (E0.i, E1.i, E2.i, E3.i, E4.i)
  inner join Elements as E6
    on E6.i not in (E0.i, E1.i, E2.i, E3.i, E4.i, E5.i);

-- A1'
select
  E0.i, E1.i, E2.i, E3.i, E4.i, E5.i, (28 - (E0.i + E1.i + E2.i + E3.i + E4.i + E5.i))
from
  Elements as E0
  inner join Elements as E1
    on E1.i not in (E0.i)
  inner join Elements as E2
    on E2.i not in (E0.i, E1.i)
  inner join Elements as E3
    on E3.i not in (E0.i, E1.i, E2.i)
  inner join Elements as E4
    on E4.i not in (E0.i, E1.i, E2.i, E3.i)
  inner join Elements as E5
    on E5.i not in (E0.i, E1.i, E2.i, E3.i, E4.i);
