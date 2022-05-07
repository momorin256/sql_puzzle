create table Numbers (
  seq integer not null primary key
);

insert into Numbers values
  (2), (3), (5), (7), (8), (14), (20);

-- A1
select
  seq, next
from
(
  select
    seq,
    lead(seq) over (order by seq)
  from
    Numbers
) T(seq, next)
where
  T.next is not null
  and (T.next - T.seq <> 1);

-- A2
select
  seq
from
  Numbers as N0
where
  N0.seq <> (select max(seq) from Numbers)
  and not exists (
    select *
    from Numbers as N1
    where N0.seq + 1 = N1.seq
  );

-- A3
select distinct
  T.seq - T.rn
from
(
  select
    seq,
    row_number() over (order by seq)
  from
    Numbers
) as T(seq, rn);

-- A4
create view Sequence(i) as
with Digits(n) as
(
  values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)
)
select D0.n + D1.n * 10
from Digits as D0 cross join Digits D1;

(
  select i
  from Sequence
  where i <= (select max(seq) from Numbers)
)
except all
(
  select seq
  from Numbers
);
