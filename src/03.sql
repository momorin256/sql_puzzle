create table Procs (
  proc_id integer not null primary key,
  anest_name VARCHAR(20),
  start_time time,
  end_time time);

insert into Procs values
  (10, 'Baker', '08:00', '11:00'),
  (20, 'Baker', '09:00', '13:00'),
  (30, 'Dow', '09:00', '15:30'),
  (40, 'Dow', '08:00', '13:30'),
  (50, 'Dow', '10:00', '11:30'),
  (60, 'Dow', '12:00', '13:30'),
  (70, 'Dow', '13:30', '14:30'),
  (80, 'Dow', '18:00', '19:00');

select
  anest_name,
  max(proc_count)
from (
  select
    P1.proc_id,
    P1.anest_name,
    count(*)
  from
    Procs as P1
    inner join Procs as P2
      on
        P1.anest_name = P2.anest_name
        and
        ((P1.proc_id = P2.proc_id)
          or (P2.start_time <= P1.start_time and P1.start_time < P2.end_time))
  group by P1.proc_id, P1.anest_name, P1.start_time) T(proc_id, anest_name, proc_count)
group by anest_name;

-- subquery: concurrent procs of each procs
select
  P1.proc_id,
  P1.anest_name,
  count(*)
from
  Procs as P1
  inner join Procs as P2
    on P1.anest_name = P2.anest_name
      and ((P1.proc_id = P2.proc_id)
        or (P2.start_time <= P1.start_time and P1.start_time < P2.end_time))
group by P1.proc_id, P1.anest_name, P1.start_time;

-- clock table
create table Digits(n integer not null);
insert into Digits values
  (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

create view Sequence(seq) as
select d1.n + d2.n * 10 + d3.n * 100 + d4.n * 1000
from digits d1
  cross join digits d2
  cross join digits d3
  cross join digits d4;

create view Clock(clock_time) as 
select '00:00' + seq * interval '1' minute
  from Sequence
  where seq BETWEEN 0 and (60 * 24 - 1);

select anest_name, max(total)
from (
  select anest_name, count(distinct proc_id)
  from Clock
    inner join Procs on clock_time between start_time and end_time
  group by anest_name) as T(anest_name, total)
group by anest_name;

select
  anest_name,
  clock_time,
  (select count(*) from Procs where clock_time between start_time and end_time)
from clock;

select
  X.anest_name, max(X.proc_totally)
from (
  select P1.anest_name, count(distinct proc_id)
  from Procs as P1, Clock as C
  where P1.start_time <= C.clock_time and C.clock_time < P1.end_time
  group by P1.anest_name) as X(anest_name, proc_totally)
group by X.anest_name;