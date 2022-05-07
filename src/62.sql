create table Names (
  name varchar(10) not null primary key
);

insert into Names values
  ('Ai'), ('Bill'), ('Chika'),
  ('Dan'), ('Emi'), ('Fuku'),
  ('Gouto'), ('Hina'), ('Ichika'),
  ('Jun'), ('Ken'), ('Lan'),
  ('Momori'), ('Norio');

-- A1
select distinct
(
  case mod(rn, 3)
    when 0 then prev2
    when 1 then name
    else prev1
  end
) as name1,
(
  case mod(rn, 3)
    when 0 then prev1
    when 1 then next1
    else name
  end
),
(
  case mod(rn, 3)
    when 0 then name
    when 1 then next2
    else next1
  end
)
from
(
  select
    name,
    row_number() over (order by name),
    max(name) over (order by name rows between 2 preceding and 2 preceding),
    max(name) over (order by name rows between 1 preceding and 1 preceding),
    max(name) over (order by name rows between 1 following and 1 following),
    max(name) over (order by name rows between 2 following and 2 following)
  from
    Names
) as T(name, rn, prev2, prev1, next1, next2)
order by
  name1;

-- A2

-- 2 columns
select
  N0.name, min(N1.name)
from
  Names as N0
  left outer join Names as N1
    on N0.name < N1.name
group by
  N0.name
having
  mod((select count(*) from Names) - (select count(*) from Names where name > N0.name), 2) = 1
order by
  N0.name;

-- 3 columns
select
  N0.name, min(N1.name), min(N2.name)
from
  Names as N0
  left outer join Names as N1
    on N0.name < N1.name
  left outer join Names as N2
    on N1.name < N2.name
group by
  N0.name
having
  mod((select count(*) from Names) - (select count(*) from Names where name > N0.name), 3) = 1
order by
  N0.name;

-- 4 columns
select
  N0.name, min(N1.name), min(N2.name), min(N3.name)
from
  Names as N0
  left outer join Names as N1
    on N0.name < N1.name
  left outer join Names as N2
    on N1.name < N2.name
  left outer join Names as N3
    on N2.name < N3.name
group by
  N0.name
having
  mod((select count(*) from Names) - (select count(*) from Names where name > N0.name), 4) = 1
order by
  N0.name;
