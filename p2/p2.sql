COPY employees FROM '/Users/ASUS/Downloads/data2/employees.csv'
DELIMITER ',' 
CSV HEADER;


SELECT * FROM employees;

SELECT MIN(hire_date) AS min_hire_date
FROM employees;

SELECT MAX(hire_date) AS max_hire_date
FROM employees;

SELECT MIN(salary) AS min_Salary
FROM salaries;

SELECT MAX(salary) AS max_Salary
FROM salaries;

SELECT * FROM salaries;


--P3

-- Paso 1: Crear la tabla employees3
CREATE TABLE employees3 (
  emp_no int,
  birth_date date,
  first_name varchar(14),
  last_name varchar(16),
  gender character(1),
  hire_date date,
  dept_no varchar(5),
  from_date date,
  salary int
) PARTITION BY RANGE (date_part('year', hire_date), salary);

-- Paso 2: Agregar la columna "salary" a la tabla employees3 y obtener el último salario de cada empleado desde la tabla "salaries"
--ALTER TABLE employees3 ADD COLUMN salary int;

UPDATE employees3
SET salary = s.salary
FROM (
  SELECT emp_no, salary, row_number() OVER (PARTITION BY emp_no ORDER BY from_date DESC) AS rn
  FROM salaries
) AS s
WHERE employees3.emp_no = s.emp_no AND s.rn = 1;

-- Paso 3: Crear las particiones de la tabla employees3
CREATE TABLE employees3_1985 PARTITION OF employees3
FOR VALUES FROM (1985, 38623) TO (1986, 60000);

CREATE TABLE employees3_1986 PARTITION OF employees3
FOR VALUES FROM (1986, 60000) TO (1987, 80000);

-- Continuar creando las particiones para cada rango de hire_date y salary

-- Paso 4: Crear índices en las columnas hire_date y salary para optimizar las consultas
CREATE INDEX idx_employees3_hire_date ON employees3 (hire_date);
CREATE INDEX idx_employees3_salary ON employees3 (salary);

-- Paso 5: Insertar datos en las particiones
INSERT INTO employees3_1985 (emp_no, birth_date, first_name, last_name, gender, hire_date, dept_no, from_date, salary)
SELECT emp_no, birth_date, first_name, last_name, gender, hire_date, dept_no, from_date, salary
FROM employees NATURAL JOIN salaries
WHERE hire_date >= '1985-01-01' AND hire_date < '1986-01-01' AND salary >= 38623 AND salary < 60000;

INSERT INTO employees3_1986 (emp_no, birth_date, first_name, last_name, gender, hire_date, dept_no, from_date, salary)
SELECT emp_no, birth_date, first_name, last_name, gender, hire_date, dept_no, from_date, salary
FROM employees NATURAL JOIN salaries
WHERE hire_date >= '1986-01-01' AND hire_date < '1987-01-01' AND salary >= 60000 AND salary < 80000;

-- Continuar insertando en las demás particiones según los rangos de hire_date y salary

-- Paso 6: Verificar los datos en las tablas
SELECT * FROM employees3;
SELECT * FROM employees3_1985;
SELECT * FROM employees3_1986;

-- Paso 7: Mostrar el plan de ejecución con Explain Analyze para tres consultas que incluyan hire_date y salary
EXPLAIN ANALYZE SELECT * FROM employees3 WHERE hire_date = '1985-10-14' AND salary<50000;
EXPLAIN ANALYZE SELECT * FROM employees3 WHERE hire_date = '1986-03-15' AND salary>70000;
EXPLAIN ANALYZE SELECT * FROM employees3 WHERE hire_date = '1986-12-31' AND salary BETWEEN 60000 AND 80000;


