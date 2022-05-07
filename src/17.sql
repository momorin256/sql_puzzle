create table CandidateSkills (
  candidate_id integer not null,
  skill_code varchar(15) not null
    check (skill_code in ('accounting', 'inventory', 'manufacturing')),
  primary key (candidate_id, skill_code)
);

create table JobOrders (
  job_id integer not null,
  skill_group integer not null,
  skill_code varchar(15) not null
    check (skill_code in ('accounting', 'inventory', 'manufacturing')),
  primary key (job_id, skill_group, skill_code)
);

insert into CandidateSkills values
  (100, 'accounting'),
  (100, 'inventory'),
  (100, 'manufacturing'),
  (200, 'accounting'),
  (200, 'inventory'),
  (300, 'manufacturing'),
  (400, 'inventory'),
  (400, 'manufacturing'),
  (500, 'accounting'),
  (500, 'manufacturing');

insert into JobOrders values
  (1, 1, 'inventory'), -- ('inventory' and 'manufacturing') or 'accounting'
  (1, 1, 'manufacturing'),
  (1, 2, 'accounting'),
  (2, 1, 'inventory'), -- ('inventory' and 'manufacturing') or ('accounting' and 'manufacturing')
  (2, 1, 'manufacturing'),
  (2, 2, 'accounting'),
  (2, 2, 'manufacturing'),
  (3, 1, 'manufacturing'), -- 'manufacturing'
  (4, 1, 'inventory'), -- ('inventory' and 'manufacturing' and 'accounting')
  (4, 1, 'manufacturing'),
  (4, 1, 'accounting');

select distinct
  J0.job_id, C0.candidate_id
from
  JobOrders as J0
  inner join CandidateSkills as C0
    on J0.skill_code = C0.skill_code
group by
  J0.job_id, J0.skill_group, C0.candidate_id
having
  count(*) = (
    select count(*)
    from JobOrders as J1
    where J1.job_id = J0.job_id and J1.skill_group = J0.skill_group
  );
