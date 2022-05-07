create table ServicesSchedule (
  order_id char(1) not null,
  sch_seq integer not null
    check (sch_seq in (1, 2, 3)),
  sch_date date,
  primary key (order_id, sch_seq)
);

insert into ServicesSchedule values
  ('A', 1, '2022-05-01'),
  ('A', 2, '2022-05-02'),
  ('A', 3, '2022-05-03'),
  ('B', 1, '2022-05-01'),
  ('B', 2, '2022-05-02'),
  ('B', 3, null),
  ('C', 1, null),
  ('C', 2, null),
  ('C', 3, '2022-05-03');

select
  order_id,
  max(case sch_seq when 1 then sch_date else null end),
  max(case sch_seq when 2 then sch_date else null end),
  max(case sch_seq when 3 then sch_date else null end)
from
  ServicesSchedule as S0
group by
  order_id;