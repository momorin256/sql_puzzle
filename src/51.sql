create table Budgeted (
  task integer not null primary key,
  category integer not null,
  est_cost decimal(8, 2) not null
);

create table Actual (
  voucher integer not null primary key,
  task integer not null references Budgeted(task),
  act_cost decimal(8, 2) not null
);

insert into Budgeted values
  (1, 100, 100.00),
  (2, 100, 15.00),
  (3, 100, 6.00),
  (4, 200, 8.00),
  (5, 200, 11.00);

insert into Actual values
  (1, 1, 10.00),
  (2, 1, 20.00),
  (3, 1, 15.00),
  (4, 2, 32.00),
  (5, 4, 8.00),
  (6, 5, 3.00),
  (7, 5, 4.00);

select
  B0.category,
  sum(B0.est_cost) as est,
  sum(T.act_cost) as act
from
  Budgeted as B0
  left outer join
  (
    select
      A0.task, sum(A0.act_cost)
    from
      Actual as A0
    group by
      A0.task
  ) T(task, act_cost)
    on B0.task = T.task
group by
  B0.category;
