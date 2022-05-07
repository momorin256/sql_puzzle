create table PrinterControl (
  printer_name VARCHAR(4) not null primary key,
  user_id VARCHAR(10)
);

insert into PrinterControl values
  ('LPT1', 'chacha'),
  ('LPT2', 'lee'),
  ('LPT3', 'thomas'),
  ('LPT4', NULL),
  ('LPT5', NULL);

-- A1. conditional branching with case expression
-- chacha -> LPT1
select distinct
  case
    when exists (select 0 from PrinterControl where user_id = 'chacha')
      then (select printer_name from PrinterControl where user_id = 'chacha')
    when 'chacha' < 'n' then 'LPT4'
    else 'LPT5'
  end
from PrinterControl;

--- aaa -> LTP4
select distinct
  case
    when exists (select 0 from PrinterControl where user_id = 'aaa')
      then (select printer_name from PrinterControl where user_id = 'aaa')
    when 'aaa' < 'n' then 'LPT4'
    else 'LPT5'
  end
from PrinterControl;

-- xxx -> LPT5
select distinct
  case
    when exists (select 0 from PrinterControl where user_id = 'xxx')
      then (select printer_name from PrinterControl where user_id = 'xxx')
    when 'xxx' < 'n' then 'LPT4'
    else 'LPT5'
  end
from PrinterControl;

-- A2. conditional branching with coalesce

select
  coalesce(
    min(printer_name),
    (select min(printer_name) from PrinterControl where user_id is NULL))
from PrinterControl
where user_id = 'chacha';

-- A3. reconsider table difinition
create table PrinterControl2 (
  printer_name VARCHAR(4) not null primary key,
  user_id_start VARCHAR(10) not null,
  user_id_end VARCHAR(10) not null
);

insert into PrinterControl2 values
  ('LPT1', 'chacha', 'chacha'),
  ('LPT2', 'lee', 'lee'),
  ('LPT3', 'thomas', 'thomas'),
  ('LPT4', 'a', 'mzzzzzzzzz'),
  ('LPT5', 'n', 'zzzzzzzzzz');

select min(printer_name)
from PrinterControl2
where 'chacha' between user_id_start and user_id_end;

select min(printer_name)
from PrinterControl2
where 'aaa' between user_id_start and user_id_end;

select min(printer_name)
from PrinterControl2
where 'xxx' between user_id_start and user_id_end;
