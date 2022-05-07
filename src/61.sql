create table Strings (
  str char(7) not null
    check (str similar to '[ABCD]{7}')
);

insert into Strings values
  ('CABBDBC'), ('ABCABCA');

select
  repeat('A', (char_length(str) - char_length(replace(str, 'A', ''))))
  || repeat('B', (char_length(str) - char_length(replace(str, 'B', ''))))
  || repeat('C', (char_length(str) - char_length(replace(str, 'C', ''))))
  || repeat('D', (char_length(str) - char_length(replace(str, 'D', ''))))
from
  Strings;
