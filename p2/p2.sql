CREATE TABLE employees (
 emp_no int,
  birth_date date,
 first_name varchar(14),
 last_name varchar(16),
gender character(1),
hire_date date,
 dept_no varchar(5),
 from_date date
);


CREATE TABLE salaries (
  emp_no INT,
  salary INT,
  from_date DATE,
  to_date DATE
);

--EN CONSOLA
-- \copy employees FROM '/Users/Romi1/Downloads/data2/employees.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- \copy salaries FROM '/Users/Romi1/Downloads/data2/salaries.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

CREATE TABLE employees2 (
emp_no int,
birth_date date,
first_name varchar(14),
last_name varchar(16),
gender character(1),
hire_date date,
dept_no varchar(5),
from_date date
) PARTITION BY RANGE (date_part('year',hire_date));

CREATE TABLE employees2_menor1988 PARTITION OF employees2
FOR VALUES FROM (MINVALUE) TO (1988);

CREATE TABLE employees2_entre1988_1994 
PARTITION OF employees2 
FOR VALUES FROM (1988)
TO (1994);

CREATE TABLE employees2_mayor1994
PARTITION OF employees2 
FOR VALUES FROM (1994)
TO (MAXVALUE);

INSERT INTO employees2 (emp_no, birth_date, first_name, last_name, gender, hire_date, dept_no, from_date)
SELECT emp_no, birth_date, first_name, last_name, gender, hire_date, dept_no, from_date
FROM employees;

INSERT INTO employees2 (emp_no, birth_date, first_name, last_name, gender, hire_date, dept_no, from_date)
SELECT emp_no, birth_date, first_name, last_name, gender, hire_date, dept_no, from_date
FROM employees;


--Consultas

EXPLAIN ANALYZE
SELECT *
FROM employees2
WHERE hire_date < DATE '1986-01-01';

EXPLAIN ANALYZE
SELECT *
FROM employees
WHERE hire_date < DATE '1986-01-01';


EXPLAIN ANALYZE
SELECT *
FROM employees2
WHERE hire_date >= DATE '1988-01-01' AND hire_date < DATE '1995-01-01';

EXPLAIN ANALYZE
SELECT *
FROM employees
WHERE hire_date >= DATE '1988-01-01' AND hire_date < DATE '1995-01-01';

EXPLAIN ANALYZE
SELECT *
FROM employees2
WHERE hire_date >= DATE '1995-01-01';

EXPLAIN ANALYZE
SELECT *
FROM employees
WHERE hire_date >= DATE '1995-01-01';

--Creación de indices

CREATE INDEX idx_hire_date ON employees (hire_date);
CREATE INDEX idx_hire_date2 ON employees2 (hire_date);

-- SET enable_seqscan = off;

EXPLAIN ANALYZE
SELECT *
FROM employees2
WHERE hire_date < DATE '1986-01-01';

EXPLAIN ANALYZE
SELECT *
FROM employees
WHERE hire_date < DATE '1986-01-01';


EXPLAIN ANALYZE
SELECT *
FROM employees2
WHERE hire_date >= DATE '1988-01-01' AND hire_date < DATE '1995-01-01';

EXPLAIN ANALYZE
SELECT *
FROM employees
WHERE hire_date >= DATE '1988-01-01' AND hire_date < DATE '1995-01-01';

EXPLAIN ANALYZE
SELECT *
FROM employees2
WHERE hire_date >= DATE '1995-01-01';

EXPLAIN ANALYZE
SELECT *
FROM employees
WHERE hire_date >= DATE '1995-01-01';