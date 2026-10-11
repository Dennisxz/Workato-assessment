\copy employees FROM 'data/employees.csv' WITH (FORMAT csv, HEADER true);
\copy departments FROM 'data/departments.csv' WITH (FORMAT csv, HEADER true);
\copy dept_emp FROM 'data/dept_emp.csv' WITH (FORMAT csv, HEADER true);
\copy dept_manager FROM 'data/dept_manager.csv' WITH (FORMAT csv, HEADER true);
\copy salaries FROM 'data/salaries.csv' WITH (FORMAT csv, HEADER true);
\copy titles FROM 'data/titles.csv' WITH (FORMAT csv, HEADER true);