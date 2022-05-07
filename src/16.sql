create table Jobs (
  job_id integer not null primary key,
  start_date date not null
);

create table Personnel (
  emp_id integer not null primary key,
  emp_name varchar(10) not null
);

create table Teams (
  job_id integer not null
    references Jobs(job_id),
  mech_type char(1) not null
    check (mech_type in ('P', 'A')),
  emp_id integer not null
    references Personnel(emp_id),
  primary key (job_id, mech_type)
);

insert into Jobs values
  (1, '2022-05-01'), (2, '2022-05-02'), (3, '2022-05-03'), (4, '2022-05-04');

insert into Personnel values (1, 'Alice'), (2, 'Bob');

insert into Teams values
  (1, 'P', 1), (1, 'A', 2), -- Job 1: Primary = Alice, Assistant = Bob
  (2, 'P', 1), (2, 'A', 1), -- Job 2: Primary = Alice, Assistant = Alice
  (3, 'P', 1);              -- Job 3: Primary = Alice, Assistant = NULL
                            -- Job 4: Primary = NULL, Assistant = NULL

/* required result
 job_id | primary_mech | assistant_mech 
--------+--------------+----------------
      1 | Alice        | Bob
      2 | Alice        | Alice
      3 | Alice        | 
      4 |              | 
*/

-- A1

select
  J.job_id,
  max(case when mech_type = 'P' then P.emp_name else NULL end) as primary_mech,
  max(case when mech_type = 'A' then P.emp_name else NULL end) as assistant_mech
from
  Jobs as J
  left outer join Teams as T
    on J.job_id = T.job_id
  left outer join Personnel as P
    on P.emp_id = T.emp_id
group by
  J.job_id;

-- A2

select
  J.job_id,
  (
    select emp_id
    from Teams as T
    where T.job_id = J.job_id and T.mech_type = 'P'
  ),
  (
    select emp_id
    from Teams as T
    where T.job_id = J.job_id and T.mech_type = 'A'
  )
from
  Jobs as J;
