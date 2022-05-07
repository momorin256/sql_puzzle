-- mysql  Ver 8.0.28

-- original
CREATE TABLE FiscalYearTable1
(
  fiscal_year INTEGER,
  start_date DATE,
  end_date DATE,
);

-- add constaints
CREATE TABLE FiscalYearTable1
(
  fiscal_year INTEGER NOT NULL PRIMARY KEY,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,

  CONSTRAINT is_valid_start_date CHECK (
    EXTRACT(YEAR FROM start_date) = fiscal_year - 1
    AND EXTRACT(MONTH FROM start_date) = 10
    AND EXTRACT(DAY FROM start_date) = 1),

  CONSTRAINT is_valid_end_date CHECK (
    EXTRACT(YEAR FROM end_date) = fiscal_year
    AND EXTRACT(MONTH FROM end_date) = 9
    AND EXTRACT(DAY FROM end_date) = 30)
);

-- test cases

-- OK
INSERT INTO FiscalYearTable1 VALUES (2022, '2021-10-01', '2022-09-30');

-- NG (invalid start_date)
INSERT INTO FiscalYearTable1 VALUES (2022, '2021-10-22', '2022-09-30');

-- NG (invalid end_date)
INSERT INTO FiscalYearTable1 VALUES (2022, '2021-10-01', '2022-08-30');
