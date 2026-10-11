-- Assumptions: 
-- '9999-01-01' means currently employed in the department 

-- 1 
SELECT 
    e.first_name,
    e.last_name,
    e.emp_no,
    d.dept_no,
    d.dept_name
FROM employees e 
JOIN dept_emp de 
ON e.emp_no = de.emp_no 
JOIN departments d 
ON de.dept_no = d.dept_no 
WHERE de.to_date = '9999-01-01'
ORDER BY d.dept_no, e.emp_no;

-- 2 
-- Query should return 0 as previously found that all managgers employee numbers are not present in employees.csv or salaries.csv.
SELECT     
    e.first_name, 
    e.last_name
    d.dept_no,
    d.dept_name,
    s.salary AS employee_salary,
    dm.emp_no AS manager_emp_no,
    ms.salary AS manager_salary
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
JOIN dept_manager dm ON d.dept_no = dm.dept_no
JOIN salaries s ON e.emp_no = s.emp_no
JOIN salaries ms ON dm.emp_no = ms.emp_no
WHERE de.to_date = '9999-01-01'
AND   dm.to_date = '9999-01-01'
AND   s.to_date = '9999-01-01'
AND   ms.to_date = '9999-01-01'
AND  s.salary > ms.salary;

-- 3
WITH rnk AS (
    SELECT 
        e.emp_no,
        e.first_name,
        e.last_name,
        s.salary,
        d.dept_no,
        d.dept_name,
        DENSE_RANK() OVER (PARTITION BY d.dept_no ORDER BY s.salary DESC) AS rank
    FROM employees e
    JOIN salaries s ON e.emp_no = s.emp_no
    JOIN dept_emp de ON e.emp_no = de.emp_no
    JOIN departments d ON de.dept_no = d.dept_no
    WHERE de.to_date = '9999-01-01'
    AND   s.to_date = '9999-01-01'
)
SELECT 
    emp_no,
    first_name,
    last_name,
    salary,
    dept_no,
    dept_name
FROM rnk 
WHERE rank = 1
ORDER BY dept_no, emp_no;

-- 4 
-- Query will return both employees that have no current department or are in a department with no current manager 
SELECT 
    e.first_name,
    e.last_name,
    e.emp_no,
    d.dept_no,
    d.dept_name
FROM employees e 
LEFT JOIN dept_emp de 
    ON e.emp_no = de.emp_no
    AND de.to_date = '9999-01-01'
LEFT JOIN departments d
    ON d.dept_no = de.dept_no  
LEFT JOIN dept_manager dm 
    ON de.dept_no = dm.dept_no
    AND dm.to_date = '9999-01-01'
WHERE dm.emp_no IS NULL
ORDER BY e.emp_no;

-- 5
SELECT 
    e.emp_no,
    e.first_name, 
    e.last_name
FROM employees e
JOIN dept_emp de 
    ON e.emp_no = de.emp_no
JOIN dept_manager dm
    ON de.dept_no = dm.dept_no
WHERE de.to_date = '9999-01-01'
    AND   dm.to_date = '9999-01-01'
    AND   e.emp_no = dm.emp_no;

-- 6
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    e.hire_date AS employee_hire_date,
    d.dept_no,
    d.dept_name,
    m.emp_no AS manager_emp_no,
    m.first_name AS manager_first_name,
    m.last_name AS manager_last_name,
    m.hire_date AS manager_hire_date
FROM employees e
JOIN dept_emp de
    ON e.emp_no = de.emp_no
JOIN departments d
    ON de.dept_no = d.dept_no
JOIN dept_manager dm
    ON d.dept_no = dm.dept_no
JOIN employees m
    ON dm.emp_no = m.emp_no
WHERE de.to_date = '9999-01-01'
AND   dm.to_date = '9999-01-01'
AND  e.hire_date < m.hire_date
ORDER BY d.dept_no, e.hire_date, e.emp_no;

