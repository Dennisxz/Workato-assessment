#Workato-assessment

Notices and changes: 
1. Removal of Foreign key in dept_manager to employees 
    The supplied dept_manager.csv contained manager employee numebrs that were not present in employees.csv. I tried to load the provided data as is with the chosen foreign key in dept_manager, however the dabase showed that all data were not present. 
    Therefore the decision was to load the provided data as-is and preserve the manager records. This is done by removing the foreign key relationship from dept_manager to employees. 

2. Query 2 listed as 0, because all managers were not found in employees.csv or salaries.csv 
    This was checked during data insertion, that all managers in dept_manager.csv were not found in employees.csv or salaries.csv. 