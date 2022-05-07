create table FriendsOfPepperoni (
  cust_id integer not null,
  bill_date date not null,
  pizza_amt decimal(8, 2) not null
);

insert into FriendsOfPepperoni values
  (1, '2022-01-01', 10.00), (1, '2022-01-01', 20.00), (1, '2022-01-02', 30.00), (1, '2022-01-04', 40.00),
  (1, '2022-02-01', 10.00), (1, '2022-02-01', 20.00), (1, '2022-02-02', 30.00), (1, '2022-02-04', 40.00),
  (1, '2022-03-01', 10.00), (1, '2022-03-01', 20.00), (1, '2022-03-02', 30.00), (1, '2022-03-04', 40.00),
  (1, '2022-04-01', 10.00), (1, '2022-04-01', 20.00), (1, '2022-04-02', 30.00),
  (1, '2022-05-01', 10.00), (1, '2022-05-01', 20.00),

  (2, '2022-01-01', 90.00), (2, '2022-01-01', 80.00), (2, '2022-01-02', 70.00), (2, '2022-01-04', 60.00),
  (2, '2022-02-01', 90.00), (2, '2022-02-01', 80.00), (2, '2022-02-02', 70.00), (2, '2022-02-04', 60.00),
  (2, '2022-03-01', 90.00), (2, '2022-03-01', 80.00), (2, '2022-03-02', 70.00), (2, '2022-03-04', 60.00),
  (2, '2022-04-01', 90.00), (2, '2022-04-01', 80.00), (2, '2022-04-02', 70.00),
  (2, '2022-05-01', 90.00), (2, '2022-05-01', 80.00);

select
  F0.cust_id,
  (
    select sum(pizza_amt)
    from FriendsOfPepperoni as F1
    where F1.cust_id = F0.cust_id
      and F1.bill_date >= (current_date - interval '30' day)
  ),
  (
    select sum(pizza_amt)
    from FriendsOfPepperoni as F1
    where F1.cust_id = F0.cust_id
      and F1.bill_date between (current_date - interval '60' day) and (current_date - interval '31' day)
  ),
  (
    select sum(pizza_amt)
    from FriendsOfPepperoni as F1
    where F1.cust_id = F0.cust_id
      and F1.bill_date between (current_date - interval '90' day) and (current_date - interval '61' day)
  ),
  (
    select sum(pizza_amt)
    from FriendsOfPepperoni as F1
    where F1.cust_id = F0.cust_id
      and F1.bill_date <= (current_date - interval '91' day)
  )
from
  FriendsOfPepperoni as F0
group by
  F0.cust_id;
