create table Schedule (
  route_nbr integer not null,
  depart_time time not null,
  arrive_time time not null,
  check (depart_time < arrive_time),
  primary key (route_nbr, depart_time)
);

insert into Schedule values
  (3, '10:00', '14:00'),
  (4, '16:00', '17:00'),
  (5, '18:00', '19:00'),
  (6, '20:00', '21:00'),
  (7, '11:00', '13:00'),
  (8, '15:00', '16:00'),
  (9, '18:00', '20:00');

select
  *
from
  Schedule as S0
where
  S0.depart_time = (
    select min(S1.depart_time)
    from Schedule as S1
    where S1.depart_time >= '16:30');