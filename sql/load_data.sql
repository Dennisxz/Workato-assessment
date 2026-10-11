\copy employees FROM 'data/employees.csv' WITH (FORMAT csv, HEADER true);
\copy departments FROM 'data/departments.csv' WITH (FORMAT csv, HEADER true);
\copy dept_emp FROM 'data/dept_emp.csv' WITH (FORMAT csv, HEADER true);
\copy dept_manager_staging FROM 'data/dept_manager.csv' WITH (FORMAT csv, HEADER true);

INSERT INTO dept_manager (emp_no, dept_no, from_date, to_date)
SELECT dm.emp_no, dm.dept_no, dm.from_date, dm.to_date
FROM dept_manager_staging dm
JOIN employees e ON dm.emp_no = e.emp_no
JOIN departments d ON dm.dept_no = d.dept_no;

\copy salaries FROM 'data/salaries.csv' WITH (FORMAT csv, HEADER true);
\copy titles FROM 'data/titles.csv' WITH (FORMAT csv, HEADER true);