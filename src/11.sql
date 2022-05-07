create table Projects (
  workorder_id char(1) not null,
  step_nbr integer not null
    check (step_nbr between 0 and 1000),
  step_status char(1) not null
    check (step_status in ('C', 'W')),
  primary key (workorder_id, step_nbr)
);

insert into Projects values
  ('A', 0, 'C'),
  ('A', 1, 'W'),
  ('A', 2, 'W'), -- A should be selected
  ('B', 0, 'W'),
  ('B', 1, 'W'),
  ('C', 0, 'C'),
  ('C', 1, 'C');

-- A1
select
  workorder_id
from
  Projects as P0
where
  step_nbr = 0
  and step_status = 'C'
  and not exists (
    select 0 from Projects as P1
    where P1.workorder_id = P0.workorder_id
      and step_nbr <> 0
      and step_status = 'C');

-- A1'
select distinct
  workorder_id
from
  Projects as P0
where
  exists (
    select 0
    from Projects as P1
    where P0.workorder_id = P1.workorder_id
      and P1.step_nbr = 0
      and P1.step_status = 'C'
  )
  and not exists (
    select 0
    from Projects as P1
    where P1.workorder_id = P0.workorder_id
      and step_nbr <> 0
      and step_status = 'C');

-- A2
select
  workorder_id
from
  Projects as P0
group by
  workorder_id
having count(*) = sum(
  case
    when step_nbr = 0 and step_status = 'C' then 1
    when step_nbr <> 0 and step_status = 'W' then 1
    else 0
  end);
