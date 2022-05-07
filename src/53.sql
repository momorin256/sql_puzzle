create table MyTable (
  lvl integer not null primary key,
  color varchar(10),
  length integer,
  width integer,
  height integer
);

insert into MyTable values
  (1, 'Red', 8, 10, 12),
  (2, null, null, null, 20),
  (3, null, 9, 82, 25),
  (4, 'Blue', null, 67, null),
  (5, 'Gray', null, null, null);

select
  (select max(color) from MyTable where lvl = T.cl),
  (select max(length) from MyTable where lvl = T.ll),
  (select max(width) from MyTable where lvl = T.wl),
  (select max(height) from MyTable where lvl = T.hl)
from
(
  select
    max(
      case
        when color is not null then lvl
        else null
      end),
    max(
      case
        when length is not null then lvl
        else null
      end),
    max(
      case
        when width is not null then lvl
        else null
      end),
    max(
      case
        when height is not null then lvl
        else null
      end)
  from
    MyTable
) as T(cl, ll, wl, hl);
