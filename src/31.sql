create table Products (
  item_id integer not null primary key
);

create table Customers (
  customer_id integer not null primary key,
  acct_balance decimal (12, 2) not null
);

create table OrderDetails (
  order_id integer not null,
  item_id integer not null references Products(item_id),
  primary key (order_id, item_id)
);

create table Orders (
  customer_id integer not null references Customers(customer_id),
  order_id integer not null primary key
);

insert into Products values
  (1), (2), (3);

insert into Customers values
  (1, 10.00), -- product 1, 2, 3
  (2, 20.00), -- product 1, 2
  (3, 30.00), -- product 1
  (4, 40.00), -- product 1, 2
  (5, 55.00); -- product 1, 2, 3

insert into OrderDetails values
  (1, 1), (2, 2), (3, 3),
  (4, 1), (5, 2),
  (6, 1),
  (7, 1), (8, 2),
  (9, 1), (10, 2), (11, 3);

insert into Orders values
  (1, 1), (1, 2), (1, 3),
  (2, 4), (2, 5),
  (3, 6),
  (4, 7), (4, 8),
  (5, 9), (5, 10), (5, 11);

-- A1

select
  order_all,
  avg(acct_balance)
from
(
  select
    C0.customer_id,
    C0.acct_balance,
    count(distinct P0.item_id) = (select count(*) from Products)
  from
    Customers as C0
    inner join Orders as O0
      on C0.customer_id = O0.customer_id
    inner join OrderDetails as D0
      on O0.order_id = D0.order_id
    inner join Products as P0
      on D0.item_id = P0.item_id
  group by
    C0.customer_id, C0.acct_balance
) as T(customer_id, acct_balance, order_all)
group by
  order_all;

/*
 order_all |         avg         
-----------+---------------------
 f         | 30.0000000000000000
 t         | 32.5000000000000000
*/

-- A2

create view CustomerOrders(customer_id, acct_balance, item_id) as
select C0.customer_id, C0.acct_balance, P0.item_id
from Customers as C0
  inner join Orders as O0
    on C0.customer_id = O0.customer_id
  inner join OrderDetails as D0
    on O0.order_id = D0.order_id
  inner join Products as P0
    on D0.item_id = P0.item_id;

select
  avg(
    case
      when (
        select count(distinct C1.item_id)
        from CustomerOrders as C1
        where C1.customer_id = C0.customer_id
      ) = (select count(*) from Products) then C0.acct_balance
      else null
    end) as order_all,
  avg(
    case
      when (
        select count(distinct item_id)
        from CustomerOrders
        where CustomerOrders.customer_id = C0.customer_id
      ) <> (select count(*) from Products) then C0.acct_balance
      else null
    end) as order_some
from
  CustomerOrders as C0;

/*
      order_all      |     order_some      
---------------------+---------------------
 32.5000000000000000 | 30.0000000000000000
*/

-- A3

(
  select
    avg(acct_balance)
  from
    Customers as C0
  where
    exists ( -- order some
      select item_id from Products
      where
        item_id not in (
          select item_id
          from Orders as O0
            inner join OrderDetails as D0
              on O0.order_id = D0.order_id
          where O0.customer_id = C0.customer_id
        )
    )
)
union
(
  select
    avg(acct_balance)
  from
    Customers as C0
  where
    not exists ( -- order all
      select item_id from Products
      where
        item_id not in (
          select item_id
          from Orders as O0
            inner join OrderDetails as D0
              on O0.order_id = D0.order_id
          where O0.customer_id = C0.customer_id
        )
    )
);
