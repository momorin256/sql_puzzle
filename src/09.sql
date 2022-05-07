create table Seats (
  seat_id integer not null primary key
);

-- This restaurant has 10 seats (1, 2, ... ,10).
-- 5, 6, 9 seats are in used now.
insert into Seats values
  (0),
  (5), (6), (9),
  (11);

-- A1
select F.seat_id, min(L.seat_id), (min(L.seat_id) - F.seat_id + 1) as available
from
  (
    select seat_id + 1
    from Seats
    where
      not exists (
        select 0 from Seats as S2
          where S2.seat_id = Seats.seat_id + 1)
      and seat_id + 1 between 1 and 10
  ) as F(seat_id)
inner join
  (
    select seat_id - 1
    from Seats
    where
      not exists (
        select 0 from Seats as S2
          where S2.seat_id = Seats.seat_id - 1)
      and seat_id - 1 between 1 and 10
  ) as L(seat_id)
on L.seat_id >= F.seat_id
group by F.seat_id;

-- subquery: first empty seat
select seat_id + 1
from Seats
where
  not exists (
    select 0 from Seats as S2
      where S2.seat_id = Seats.seat_id + 1)
  and seat_id + 1 between 1 and 10;

-- subquery: last empty seat
select seat_id - 1
from Seats
where
  not exists (
    select 0 from Seats as S2
      where S2.seat_id = Seats.seat_id - 1)
  and seat_id - 1 between 1 and 10;

-- A2
select
  S1.seat_id + 1, min(S2.seat_id) - 1
from
  Seats as S1
inner join
  Seats as S2
    on S1.seat_id < S2.seat_id
group by
  S1.seat_id
having
  S1.seat_id + 1 < min(S2.seat_id);

-- A3: window function
select
  seat_id + 1, lead - 1, (lead - seat_id - 1) as available
from
  (
    select
      seat_id,
      lead(seat_id) over (order by seat_id)
    from Seats
  ) as T(seat_id, lead)
where
  lead - seat_id - 1 > 0;
