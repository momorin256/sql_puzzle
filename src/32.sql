create table TaxAuthorities (
  tax_authority char(10) not null,
  tax_area char(10) not null
);

create table TaxRates (
  tax_authority char(10) not null,
  effect_date date not null,
  tax_rate decimal (8, 2) not null,
  primary key (tax_authority, effect_date)
);

insert into TaxAuthorities values
  ('city1', 'city1'),
  ('city2', 'city2'),
  ('city3', 'city3'),
  ('country1', 'city1'),
  ('country1', 'city2'),
  ('country2', 'city3'),
  ('state1', 'city1'),
  ('state1', 'city2'),
  ('state1', 'city3');

insert into TaxRates values
  ('city1', '2020-01-01', 1.0),
  ('city1', '2021-01-01', 1.5),
  ('city2', '2020-01-01', 1.5),
  ('city2', '2021-01-01', 2.0),
  ('city2', '2022-01-01', 2.5),
  ('city3', '2020-01-01', 1.7),
  ('city3', '2020-07-01', 1.9),
  ('country1', '2020-01-01', 2.3),
  ('country1', '2021-10-01', 2.5),
  ('country1', '2022-01-01', 2.7),
  ('country2', '2020-01-01', 2.4),
  ('country2', '2021-01-01', 2.6),
  ('country2', '2022-01-01', 2.8),
  ('state1', '2020-01-01', 0.2),
  ('state1', '2021-01-01', 0.4),
  ('state1', '2021-07-01', 0.6),
  ('state1', '2021-10-01', 0.8);

-- A1
select
  A0.tax_area, sum(R0.tax_rate)
from
  TaxAuthorities as A0
  inner join TaxRates as R0
    on A0.tax_authority = R0.tax_authority
where
  A0.tax_area = 'city2'
  and R0.effect_date = (
    select max(R1.effect_date)
    from TaxRates as R1
    where R1.tax_authority = R0.tax_authority
      and R1.effect_date <= '2021-11-11')
group by
  A0.tax_area;

-- for displaying results
select
  A0.tax_area, A0.tax_authority, R0.effect_date, R0.tax_rate
from
  TaxAuthorities as A0
  inner join TaxRates as R0
    on A0.tax_authority = R0.tax_authority
where
  A0.tax_area = 'city2'
  and R0.effect_date = (
    select max(R1.effect_date)
    from TaxRates as R1
    where R1.tax_authority = R0.tax_authority
      and R1.effect_date <= '2021-11-11');
