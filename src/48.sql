create table Inventory (
  goods varchar(10) not null primary key,
  pieces integer not null check (pieces >= 0)
);

insert into Inventory values
  ('CD-ROM', 3), ('Pencil', 2);

create table Sequence (seq integer not null primary key);

insert into Sequence(seq)
with Digits (i) as
(
  values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)
)
select
  D0.i + 10 * D1.i + 100 * D2.i
from
  Digits as D0, Digits as D1, Digits as D2
where
  D0.i + 10 * D1.i + 100 * D2.i > 0;

select
  I0.goods, 1
from
  Inventory as I0
  inner join Sequence as S0
    on I0.pieces >= S0.seq;
