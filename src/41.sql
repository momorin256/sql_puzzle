create table Items (
  item_id integer not null primary key
);

insert into Items values
  (10), (20), (30), (40), (50);

create table Estimates (
  item_id integer not null references Items(item_id),
  estimated_amt decimal(8, 2) not null
);

insert into Estimates values
  (10, 300.00), (10, 50.00),
  (20, 325.00), (20, 110.00),
  (40, 25.00);

create table Actuals (
  item_id integer not null references Items(item_id),
  actual_amt decimal(8, 2) not null,
  check_id char(4) not null,
  primary key (item_id, check_id)
);

insert into Actuals values
  (10, 300.00, '1111'),
  (20, 325.00, '2222'), (20, 100.00, '3333'),
  (30, 525.00, '1111');

-- A1
select
  T0.item_id,
  T0.estimate_tot,
  T1.actual_tot,
  T1.check_id
from
  (
    select
      I0.item_id, sum(E0.estimated_amt)
    from
      Items as I0
      left outer join Estimates as E0
        on I0.item_id = E0.item_id
    group by
      I0.item_id
  ) as T0(item_id, estimate_tot)
  cross join
  (
    select
      I1.item_id,
      sum(A0.actual_amt),
      (
        case
          when count(*) = 1 then max(A0.check_id)
          else 'Mixed'
        end
      )
    from
      Items as I1
      left outer join Actuals as A0
        on I1.item_id = A0.item_id
    group by
      I1.item_id
  ) as T1(item_id, actual_tot, check_id)
where
  T0.item_id = T1.item_id
  and not ((T0.estimate_tot is null) and (T1.actual_tot is null));

-- A2

select
  *
from
  (
    select
      I0.item_id,
      (
        select
          sum(A0.actual_amt) as actual_tot
        from
          Actuals as A0
        where
          I0.item_id = A0.item_id
        group by
          I0.item_id
      ),
      (
        select
          sum(E0.estimated_amt) as estimated_tot
        from
          Estimates as E0
        where
          I0.item_id = E0.item_id
        group by
          E0.item_id
      ),
      (
        select
          case
           when count(*) = 1 then max(A1.check_id)
           else 'Mixed'
          end
        from
          Actuals as A1
        where
          I0.item_id = A1.item_id
        group by
          I0.item_id
      )
    from
      Items as I0
  ) as T
where
  not ((T.actual_tot is null) and (T.estimated_tot is null));
