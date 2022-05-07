create table Consultans (
  emp_id integer not null primary key,
  emp_name char(10) not null
);

insert into Consultans values
  (1, 'Larry'),
  (2, 'Moe'),
  (3, 'Curly');

create table Billings (
  emp_id integer not null references Consultans(emp_id),
  bill_date date not null,
  bill_rate decimal(5, 2) not null
);

insert into Billings values
  (1, '1990-01-01', 25.00),
  (2, '1989-01-01', 15.00),
  (3, '1990-01-01', 20.00),
  (1, '1991-01-01', 30.00);

create table HoursWorked (
  job_id integer not null,
  emp_id integer not null,
  work_date date not null,
  bill_hrs decimal(5, 2),
  primary key (job_id, emp_id, work_date)
);

insert into HoursWorked values
  (4, 1, '1990-07-01', 3),
  (4, 1, '1990-08-01', 5),
  (4, 2, '1990-07-01', 2),
  (4, 1, '1991-07-01', 4);

-- Larry: (3 + 5) * 25.00 + 4 * 30.00 = 320.00

select
  C0.emp_name, sum(H0.bill_hrs * B0.bill_rate)
from
  Consultans as C0
  inner join HoursWorked as H0
    on C0.emp_id = H0.emp_id
  inner join Billings as B0
    on H0.emp_id = B0.emp_id
      and B0.bill_date = (
        select max(bill_date)
        from Billings
        where emp_id = H0.emp_id
          and bill_date <= H0.work_date)
group by
  C0.emp_name;
