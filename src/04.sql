create table Personnel (
  emp_id integer not null primary key,
  emp_name varchar(30) not null
);

create table Badges (
  badge_id integer not null primary key,
  emp_id integer not null references Personnel(emp_id),
  issued_date date not null,
  badge_status char(1) not null
    check (badge_status in ('A', 'I'))
);

-- ERROR:  cannot use subquery in check constraint
create table Badges (
  badge_id integer not null primary key,
  emp_id integer not null references Personnel(emp_id),
  issued_date date not null,
  badge_status char(1) not null
    check (badge_status in ('A', 'I')),
  constraint employee_has_one_valid_badge check (
    1 = all (select count(*) from Badges where badge_status = 'A' group by emp_id))
);

insert into Personnel values (1, 'Alice'), (2, 'Bob');

insert into Badges values
  (1, 1, '2022-05-02', 'A'),
  (2, 1, '2022-05-01', 'I'),
  (3, 2, '2022-05-02', 'A'),
  (4, 2, '2022-05-01', 'I');

-- issue new badges
insert into Badges values
  (5, 1, '2022-05-03', 'A'),
  (6, 2, '2022-05-03', 'A');

-- diactivate
update Badges as B1
  set badge_status = 'I'
where
  exists (
    select 0 from Badges as B2
      where B1.emp_id = B2.emp_id
        and B1.issued_date < B2.issued_date);

-- activate
update Badges as B1
  set badge_status = 'A'
where
  not exists (
    select 0 from Badges as B2
      where B1.emp_id = B2.emp_id
        and B1.issued_date < B2.issued_date);

-- list of employees and activated badges
select P.emp_id, P.emp_name, B.badge_id
from Badges as B
  inner join Personnel as P
    on P.emp_id = B.emp_id
where badge_status = 'A';