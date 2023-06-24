-- CREATE TABLE employees (
--   emp_no int,
--   birth_date date,
--   first_name varchar(14),
--   last_name varchar(16),
--   gender character(1),
--   hire_date date,
--   dept_no varchar(5),
--   from_date date
-- );


-- CREATE TABLE salaries (
--   emp_no int,
--   salary int ,
--   from_date date,
--   to_date date 
-- );

CREATE TABLE employees1 (
  emp_no int,
  birth_date date,
  first_name varchar(14),
  last_name varchar(16),
  gender character(1),
  hire_date date,
  dept_no varchar(5),
  from_date date
) PARTITION BY LIST(dept_no);

CREATE TABLE employees1_ PARTITION OF employees1 FOR VALUES IN ('d005', 'd008','d009');
CREATE TABLE employees_2 PARTITION OF employees1 FOR VALUES IN ('d001', 'd002', 'd003', 'd004', 'd006', 'd007');
-- COPY employees FROM '/Users/camila/Downloads/data2/employees.csv'
-- DELIMITER ',' 
-- CSV HEADER;
--select * from employees;
-- si se tiene errores de permiso al leer csv en la linea de comando ejecutar:
--\copy employees FROM '/Users/camila/Downloads/data2/employees.csv'WITH (FORMAT csv, HEADER true, DELIMITER ',');
-- lo mismo con employees1

EXPLAIN ANALYZE SELECT * FROM employees where dept_no = 'd009';
EXPLAIN ANALYZE SELECT * FROM employees1 where dept_no = 'd009';
