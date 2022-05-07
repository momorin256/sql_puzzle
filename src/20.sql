create table TestResults (
  test_name varchar(10) not null,
  test_step integer not null,
  comp_date date, -- NULL means not completed yet
  primary key (test_name, test_step)
);

insert into TestResults values
  ('A', 1, '2022-01-01'),
  ('A', 2, '2022-01-02'),
  ('A', 3, '2022-01-03'),
  ('B', 1, '2022-01-01'),
  ('B', 2, NULL),
  ('B', 3, '2022-01-03'),
  ('C', 1, '2022-01-01'),
  ('C', 2, '2022-01-02'),
  ('C', 3, '2022-01-03'),
  ('C', 4, '2022-01-04');

select
  test_name
from
  TestResults as T0
group by
  test_name
having
  count(*) = count(comp_date);
