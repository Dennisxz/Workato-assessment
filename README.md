#Workato-assessment

Notices and changes: 
1. Removal of Foreign key in dept_manager to employees 
    The supplied dept_manager.csv contained manager employee numebrs that were not present in employees.csv. I tried to load the provided data as is with the chosen foreign key in dept_manager, however the dabase showed that all data were not present. 
    Therefore the decision was to load the provided data as-is and preserve the manager records. This is done by removing the foreign key relationship from dept_manager to employees. 

2. Query 2 listed as 0, because all managers were not found in employees.csv or salaries.csv 
    This was checked during data insertion, that all managers in dept_manager.csv were not found in employees.csv or salaries.csv. 


Workato Skills Test Answer
1. Create Workato recipes to load data from W_recipe_data into the schema/tables designed in the Data Modeling
section

I would create a Workato recipe that loads the file into PostgreSQL using a staging-first approach to prevent bad data from leaking into the database. The raw file is first loaded into recipe_data. Then the recipe runs transformation SQL to split multi-value
columns like applications, categories, and business_objects into their respective dimension and bridge tables.The flow of events would be: 

- validate file
- download file
- parse worksheet/CSV rows
- load raw rows into recipe_data staging table
- execute SQL transforms
- populate dimensions, bridge tables, and metrics table
- validate row counts to confirm success or failure 
- archive files 
- send notification of success of failures


2. Load data when a new file appears

For file-based loading, I would use a Dropbox trigger, which will then send the file into the system for building. 

Recipe flow:
1. Trigger when a new or updated file appears in Dropbox.
2. Check that the Dropbox path contains W_Recipe_Data.
3. Check that the file extension is .xlsx or .csv.
4. Download the file.
5. Parse the worksheet or CSV rows.
6. Validate required columns.
7. Truncate or prepare the staging table.
8. Insert each parsed row into recipe_data.
9. Run transform SQL to populate the normalized schema.
10. Run post-load validation checks.
11. Move the file to an archive folder.
12. Send a success notification.

I would also track the Dropbox file path and revision number so the same file version is not processed twice.

3. Load data periodically every 4 hours
For scheduled loading, I would create a second Workato recipe or duplicate the first recipe with a scheduled
trigger. This process will run the same as the one previously talked about.  The scheduled version is useful when the source system drops files on a predictable cadence or when the team wants batch control instead of event-driven processing.

4. Exception Handling: Missing file

For the event-driven recipe, a missing file usually means the trigger does not fire.
For the scheduled recipe, I would instead first search the input folder for the file in question. If the file truly does not exist, then we will stop the job and send a notification about it, to be resolved by the team. This is to rule out deliberate file exclusions in the event of a job no longer requiring the file. 


5. Exception Handling: Bad file

For bad files, the workflow will reject the contents because it will be caught during initial loading, triggering the error handling to send a message of bad file found, so we are able to effectively understand and track what is the error. 


6.Exception Handling: Bad data in file

For bad data, the workflow will also reject the contents when the file is loaded into the staging table. The subsequent insersions into the dabase will be rejected because of the foreign key restriction. This then will cause the error handling to be triggered once again and for a message to be sent to notify of the error. 
