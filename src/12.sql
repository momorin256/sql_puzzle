create table Claims (
  claim_id integer not null,
  patient_name varchar(10) not null,
  primary key (claim_id, patient_name)
);

create table Defendants (
  claim_id integer not null,
  defendant_name varchar(10) not null,
  primary key (claim_id, defendant_name)
);

create table ClaimStatusCodes (
  claim_status char(2) not null primary key
    check (claim_status in ('AP', 'OR', 'SF', 'CL')),
  claim_seq integer not null
    check (claim_seq > 0)
);

create table LegalEvents (
  claim_id integer not null,
  defendant_name varchar(10) not null,
  claim_status char(2) not null references ClaimStatusCodes(claim_status),
  change_date date not null,
  primary key (claim_id, defendant_name, claim_status),
  foreign key (claim_id, defendant_name) references Defendants(claim_id, defendant_name)
);

insert into Claims values
  (10, 'Smith'),
  (20, 'Johns'),
  (30, 'Brown');

insert into Defendants values
  (10, 'Johnson'),
  (10, 'Mayer'),
  (10, 'Dow'),
  (20, 'Baker'),
  (20, 'Mayer'),
  (30, 'Johnson');

insert into ClaimStatusCodes values
  ('AP', 1),
  ('OR', 2),
  ('SF', 3),
  ('CL', 4);

insert into LegalEvents values
  (10, 'Johnson', 'AP', '1994-01-01'),
  (10, 'Johnson', 'OR', '1994-02-01'),
  (10, 'Johnson', 'SF', '1994-03-01'),
  (10, 'Johnson', 'CL', '1994-04-01'),
  (10, 'Mayer', 'AP', '1994-01-01'),
  (10, 'Mayer', 'OR', '1994-02-01'),
  (10, 'Mayer', 'SF', '1994-03-01'),
  (10, 'Dow', 'AP', '1994-01-01'),
  (10, 'Dow', 'OR', '1994-02-01'),
  (20, 'Mayer', 'AP', '1994-02-01'),
  (20, 'Mayer', 'OR', '1994-01-01'),
  (20, 'Baker', 'AP', '1994-01-01'),
  (30, 'Johnson', 'AP', '1994-01-01');

-- A1
create view Events(claim_id, defendant_name, claim_status, claim_seq, patient_name) as
select
    L.claim_id, L.defendant_name, L.claim_status, C.claim_seq, P.patient_name
from
  LegalEvents as L
inner join ClaimStatusCodes as C
  on L.claim_status = C.claim_status
inner join Claims as P
  on L.claim_id = P.claim_id
where
  C.claim_seq = (
    select max(C2.claim_seq)
    from LegalEvents as L2
    inner join ClaimStatusCodes as C2
      on L2.claim_status = C2.claim_status
    where L2.claim_id = L.claim_id
      and L2.defendant_name = L.defendant_name);

/*
 claim_id | defendant_name | claim_status | claim_seq | patient_name 
----------+----------------+--------------+-----------+--------------
       10 | Johnson        | CL           |         4 | Smith
       10 | Mayer          | SF           |         3 | Smith
       10 | Dow            | OR           |         2 | Smith
       20 | Mayer          | OR           |         2 | Johns
       20 | Baker          | AP           |         1 | Johns
       30 | Johnson        | AP           |         1 | Brown
*/

select
  claim_id, patient_name, claim_status
from
  Events as E0
where
  E0.claim_seq = (
    select min(E1.claim_seq)
    from Events as E1
    where E1.claim_id = E0.claim_id);

/*
 claim_id | patient_name | claim_status 
----------+--------------+--------------
       10 | Smith        | OR
       20 | Johns        | AP
       30 | Brown        | AP
*/

-- A2
select
  C0.claim_id, C0.patient_name, S1.claim_status
from
  Claims as C0
  cross join ClaimStatusCodes as S1
where
  S1.claim_seq = (
    select min(claim_seq)
    from ClaimStatusCodes as S2
    where S2.claim_seq in (
      select
        max(S0.claim_seq)
      from
        LegalEvents as L0
        inner join ClaimStatusCodes as S0
          on L0.claim_status = S0.claim_status
      where
        L0.claim_id = C0.claim_id
      group by
        L0.defendant_name
    )
  );

-- subquery
select
  L0.claim_id, L0.defendant_name, max(S0.claim_seq)
from
  LegalEvents as L0
  inner join ClaimStatusCodes as S0
    on L0.claim_status = S0.claim_status
group by
  L0.claim_id, L0.defendant_name;

/*
 claim_id | defendant_name | max 
----------+----------------+-----
       10 | Johnson        |   4
       10 | Mayer          |   3
       10 | Dow            |   2
       20 | Baker          |   1
       20 | Mayer          |   2
       30 | Johnson        |   1
*/

-- A2'
select
  *
from
  Claims as C0
  cross join ClaimStatusCodes as S0
where
  S0.claim_seq in (
    select
      min(S1.claim_seq)
    from
      ClaimStatusCodes as S1
    where
      S1.claim_seq in (
        select
          max(S2.claim_seq)
        from
          LegalEvents as L0
        inner join
          ClaimStatusCodes as S2
          on L0.claim_status = S2.claim_status
        where
          L0.claim_id = C0.claim_id
        group by
          L0.defendant_name
      )
  );
