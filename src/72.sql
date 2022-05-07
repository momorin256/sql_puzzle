create table Clients (
  client_id integer not null primary key
);

create table Employee (
  emp_id integer not null primary key
);

create table Calls (
  client_id integer not null references Clients(client_id),
  emp_id integer not null references Employee(emp_id),
  start_date date not null,
  end_date date, -- null means in progress
  call_id integer not null,
  check (start_date < end_date),
  primary key (client_id, emp_id, start_date, call_id)
);

create table EmployeeSchedule (
  emp_id integer not null references Employee(emp_id),
  start_date date not null,
  end_date date not null,
  check (start_date < end_date),
  primary key (emp_id, start_date)
);

select
  *
from
  Calls as C0
  left outer join EmployeeSchedule as E0
    on E0.start_date <= C0.start_date and C0.end_date <= E0.end_date;

