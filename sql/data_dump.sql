SELECT dm.*
FROM dept_manager_staging dm
LEFT JOIN employees e ON dm.emp_no = e.emp_no
WHERE e.emp_no IS NULL;