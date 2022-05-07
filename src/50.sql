create table AnthologyContributors (
  isbn char(10) not null,
  contributor varchar(10) not null,
  category integer not null,
  primary key (isbn, contributor)
);

select
  contributor
from
  AnthologyContributors
where
  category in (1, 2, 3)
group by
  contributor
having
  count(distinct category) = 2;

-- A2

select distinct
  A0.contributor
from
  AnthologyContributors as A0
where
  2 = (
    select
      count(distinct A1.category)
    from
      AnthologyContributors as A1
    where
      A1.contributor = A0.contributor
      and A1.category in (1, 2, 3)
  );