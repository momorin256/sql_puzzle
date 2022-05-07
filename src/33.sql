create table Machines (
  machine_name varchar(10) not null primary key,
  purchase_date date not null,
  initial_cost decimal(10, 2) not null,
  lifespan integer not null
);

create table Batches (
  batch_id integer not null,
  machine_name varchar(10) not null references Machines(machine_name),
  batch_date date not null,
  batch_cost decimal(6, 2) not null,
  batch_hrs decimal(4, 2) not null,
  primary key (batch_id, machine_name)
);

insert into Machines values
  ('M01', '2022-01-01', 1000.0, 100),
  ('M02', '2022-02-01', 2000.0, 100),
  ('M03', '2022-03-01', 3000.0, 100);

insert into Batches values
  (1, 'M01', '2022-05-01', 100.0, 1.5),
  (1, 'M02', '2022-05-01', 100.0, 1.5),
  (2, 'M01', '2022-05-02', 200.0, 2.5),
  (2, 'M03', '2022-05-02', 200.0, 2.5),
  (3, 'M01', '2022-05-01', 300.0, 3.5);

-- 2022-05-01 M01: cost = 100.0 + 300.0 + (1000.0 / (100.0 * 24)), hours = 1.5 + 3.5

select
  B0.machine_name,
  B0.batch_date,
  (sum(B0.batch_cost) + (M0.initial_cost / (M0.lifespan * 24))) / sum(B0.batch_hrs)
from
  Batches as B0
  inner join Machines as M0
    on B0.machine_name = M0.machine_name
group by
  B0.machine_name, B0.batch_date, M0.initial_cost, M0.lifespan;
