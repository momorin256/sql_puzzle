create table Tickets (
  buyer_name varchar(5) not null,
  ticket_nbr integer not null check (ticket_nbr > 0),
  primary key (buyer_name, ticket_nbr)
);

insert into Tickets values
  ('a', 2), ('a', 3), ('a', 4),
  ('b', 4),
  ('c', 1), ('c', 2), ('c', 3), ('c', 4), ('c', 5),
  ('d', 1), ('d', 6), ('d', 7), ('d', 9),
  ('e', 10);

-- A1
select
  T0.buyer_name
from
  Tickets as T0
where
  not exists (
    select
      *
    from
      Tickets as T1
    where
      T0.buyer_name = T1.buyer_name
      and T0.ticket_nbr + 1 = T1.ticket_nbr
  )
group by
  T0.buyer_name
having
  count(*) > 1;

-- A2
select
  T.buyer_name
from
(
  select
    buyer_name,
    ticket_nbr,
    row_number() over (partition by buyer_name order by ticket_nbr)
  from
    Tickets as T0
) as T(buyer_name, ticket_nbr, rn)
group by
  T.buyer_name
having
  1 < count(distinct (T.ticket_nbr - T.rn));

-- A3
select
  buyer_name,
  prev + 1 as start,
  ticket_nbr - 1 as end
from
(
  select
    buyer_name,
    ticket_nbr,
    lag(ticket_nbr) over (partition by buyer_name order by ticket_nbr)
  from
    Tickets
) as T(buyer_name, ticket_nbr, prev)
where
  prev < ticket_nbr - 1;

-- A4
with recursive CTE(buyer_name, ticket_nbr) as
(
  (
    select
      buyer_name, max(ticket_nbr)
    from
      Tickets
    group by
      buyer_name
  )
  union all
  (
    select
      buyer_name, ticket_nbr - 1
    from
      CTE
    where
      ticket_nbr - 1 >= 0
  )
)
select
  *
from CTE;
