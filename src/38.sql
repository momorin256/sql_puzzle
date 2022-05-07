create table Journal (
  acct_id integer not null,
  trx_date date not null,
  trx_amt decimal(10, 2) not null,
  duration integer not null
);

insert into Journal values
  (1, '2022-05-01', 10.00, 0),
  (1, '2022-05-02', 10.00, 0),
  (1, '2022-05-04', 10.00, 0),
  (1, '2022-05-07', 10.00, 0),
  (2, '2022-05-01', 10.00, 0),
  (2, '2022-05-05', 10.00, 0),
  (2, '2022-05-06', 10.00, 0),
  (2, '2022-05-10', 10.00, 0);

-- ERROR:  window functions are not allowed in UPDATE
update
  Journal
set
  duration = (
    (lead(trx_date) over (partition by acct_id order by trx_date)) - trx_date
  );

update
  Journal
  inner join Journal as J1
    on J1.trx_date = (
      select min(trx_date)
      from Journal as J2
      where J2.acct_id = Journal.acct_id
        and J2.trx_date > Journal.trx_date)
set Journal.duration = J1.trx_date - Journal.trx_date;

-- A1
update
  Journal
set
  duration = (
      (case
        when not exists (select 0 from Journal as J1 where (J1.acct_id = Journal.acct_id) and (J1.trx_date > Journal.trx_date))
          then Journal.trx_date
        else
          (
            select min(trx_date)
            from Journal as J1
            where J1.acct_id = Journal.acct_id
              and J1.trx_date > Journal.trx_date
          )
      end)
      - Journal.trx_date
  );

-- A2
update
  Journal
set
  duration = (
    select
      min(J1.trx_date)
    from
      Journal as J1
    where
      J1.acct_id = Journal.acct_id
      and J1.trx_date > Journal.trx_date
  ) - Journal.trx_date
where
  exists (
    select 0
    from Journal as J2
    where J2.acct_id = Journal.acct_id
      and J2.trx_date > Journal.trx_date
  );

-- A2'
update
  Journal
set
  duration = (
    select
      min(J1.trx_date) - Journal.trx_date
    from
      Journal as J1
    where
      J1.acct_id = Journal.acct_id
      and J1.trx_date > Journal.trx_date
    group by
      Journal.trx_date
  )
where
  exists (
    select 0
    from Journal as J2
    where J2.acct_id = Journal.acct_id
      and J2.trx_date > Journal.trx_date
  );

-- A3
select
  acct_id,
  trx_date,
  trx_amt,
  (lead(trx_date) over (partition by acct_id order by trx_date)) - trx_date
from
  Journal;
