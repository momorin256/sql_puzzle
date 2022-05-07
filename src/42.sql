create table Samples (
  sample_id integer not null,
  fish_name varchar(10) not null,
  found_tally integer not null,
  primary key (sample_id, fish_name)
);

insert into Samples values
  (1, 'minnow', 18),
  (1, 'pike', 7),
  (2, 'pike', 4),
  (2, 'carp', 3),
  (3, 'carp', 9);

create table SampleGroups (
  group_id integer not null,
  sample_id integer not null references Samples(sample_id),
  primary key (group_id, sample_id)
);

insert into SampleGroups values
  (1, 1), (1, 2),
  (2, 1), (2, 2), (2, 3);

-- A1

select
  S0.fish_name,
  sum(S0.found_tally) / (
    select count(*)
    from SampleGroups as G1
    where G1.group_id = 1)
from
  SampleGroups as G0
  inner join Samples as S0
    on G0.sample_id = S0.sample_id
where
  G0.group_id = 1
group by
  S0.fish_name;

-- Exstra
create table Fishes (
  fish_name varchar(10) not null primary key,
  group_id integer not null
);

create table Groups (
  group_id integer not null,
  group_dscr varchar(20) not null
);

create table Samples (
  sample_id integer not null,
  fish_name varchar(10) not null,
  found_tally integer not null
);
