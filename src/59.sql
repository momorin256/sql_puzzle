create table Timesheets (
  task_id char(10) not null primary key,
  start_date date not null,
  end_date date not null,
  check (start_date <= end_date)
);

insert into Timesheets values
  (1, '1997-01-01', '1997-01-03'),
  (2, '1997-01-02', '1997-01-04'),
  (3, '1997-01-04', '1997-01-05'),
  (4, '1997-01-06', '1997-01-09'),
  (5, '1997-01-09', '1997-01-09'),
  (6, '1997-01-09', '1997-01-09'),
  (7, '1997-01-12', '1997-01-15'),
  (8, '1997-01-13', '1997-01-14'),
  (9, '1997-01-14', '1997-01-14'),
  (10, '1997-01-17', '1997-01-17');

-- 1

select
  T0.start_date, T1.end_date
from
  Timesheets as T0
  inner join Timesheets as T1
    on T0.task_id <= T1.task_id
      and T0.end_date <= T1.end_date
order by
  T0.start_date, T1.end_date;

/*
 start_date |  end_date
------------+------------
 1997-01-01 | 1997-01-04
 1997-01-01 | 1997-01-05
 1997-01-01 | 1997-01-09
 1997-01-01 | 1997-01-09
 1997-01-01 | 1997-01-09
 1997-01-01 | 1997-01-14
 1997-01-01 | 1997-01-14
 1997-01-01 | 1997-01-15
 1997-01-01 | 1997-01-17
 1997-01-02 | 1997-01-05
 1997-01-02 | 1997-01-09
 1997-01-02 | 1997-01-09
 1997-01-02 | 1997-01-09
 1997-01-02 | 1997-01-14
 1997-01-02 | 1997-01-14
 1997-01-02 | 1997-01-15
 1997-01-04 | 1997-01-09
 1997-01-04 | 1997-01-09
 1997-01-04 | 1997-01-09
 1997-01-04 | 1997-01-14
 1997-01-04 | 1997-01-14
 1997-01-04 | 1997-01-15
 1997-01-06 | 1997-01-09
 1997-01-06 | 1997-01-09
 1997-01-06 | 1997-01-14
 1997-01-06 | 1997-01-14
 1997-01-06 | 1997-01-15
 1997-01-09 | 1997-01-09
 1997-01-09 | 1997-01-14
 1997-01-09 | 1997-01-14
 1997-01-09 | 1997-01-14
 1997-01-09 | 1997-01-14
 1997-01-09 | 1997-01-15
 1997-01-09 | 1997-01-15
 1997-01-13 | 1997-01-14
(35 rows)
*/

select
  T0.start_date, T1.end_date
from
  Timesheets as T0
  inner join Timesheets as T1
    on T0.task_id < T1.task_id
      and T0.end_date <= T1.end_date
where
  not exists (
    select
      *
    from
      Timesheets as T3
    where
      (T3.start_date < T0.start_date and T0.start_date <= T3.end_date)
      or
      (T3.start_date <= T1.end_date and T1.end_date < T3.end_date)
  );

select
  X.start_date, min(X.end_date)
from
(
  select
    T0.start_date, T1.end_date
  from
    Timesheets as T0, Timesheets as T1, Timesheets as T2
  where
    T0.end_date <= T1.end_date
  group by
    T0.start_date, T1.end_date
  having
    0 = max(
      case
        when (T2.start_date < T0.start_date and T0.start_date <= T2.end_date)
          or (T2.start_date <= T1.end_date and T1.end_date < T2.end_date)
          then 1
        else 0
      end
    )
) as X
group by
  X.start_date;
