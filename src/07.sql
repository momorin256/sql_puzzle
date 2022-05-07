create table Portfolios (
  file_id integer not null primary key,
  issue_date date not null
);

create table Succession (
  chain_id integer not null,
  file_id integer not null references Portfolios(file_id),
  next_file_id integer not null references Portfolios(file_id),
  primary key (chain_id, file_id)
);

insert into Portfolios values
  (101, '2022-01-01'),
  (102, '2022-01-02'),
  (103, '2022-01-03'),
  (104, '2022-01-04'),
  (201, '2022-02-01'),
  (202, '2022-02-02'),
  (203, '2022-02-03'),
  (204, '2022-02-04'),
  (999, '2022-09-09');

insert into Succession values
  (1, 101, 102),
  (1, 102, 103),
  (1, 103, 104),
  (1, 104, 999),
  (2, 201, 202),
  (2, 202, 203),
  (2, 203, 204),
  (2, 204, 999);

select distinct P.file_id, P.issue_date
from Portfolios as P
where P.file_id in (
  select max(S1.next_file_id)
    from Succession as S1
  group by chain_id);
