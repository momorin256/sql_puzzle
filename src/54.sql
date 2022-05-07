create table Customers (
  cust_nbr integer not null primary key,
  first_name varchar(10) not null,
  last_name varchar(10) not null,
  street_address varchar(10) not null,
  city_name varchar(10) not null,
  state_code varchar(10) not null,
  phone_nbr varchar(10) not null
);

select
  C0.cust_nbr, C1.cust_nbr
from
  Customers as C0
  inner join Customers as C1
    on C0.last_name = C1.last_name
      and C0.cust_nbr < C1.cust_nbr
where
  2 <= (
    (case when C0.first_name = C1.first_name then 1 else 0 end)
    + (case when C0.street_address = C1.street_address then 1 else 0 end)
    + (case when C0.city_name = C1.city_name then 1 else 0 end)
    + (case when C0.state_code = C1.state_code then 1 else 0 end)
    + (case when C0.phone_nbr = C1.phone_nbr then 1 else 0 end)
  );
