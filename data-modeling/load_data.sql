\copy recipe_data FROM 'data/W_Recipe_Data.csv' WITH (FORMAT csv, HEADER true);

INSERT INTO dim_users (user_id)
SELECT DISTINCT user_id
FROM recipe_data
WHERE user_id IS NOT NULL
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO dim_recipes (
    recipe_id,
    user_id,
    version_no,
    recipe_name,
    description,
    created_at,
    updated_at,
    runnable,
    running,
    parent_id
)
SELECT 
    id AS recipe_id,
    user_id,
    version_no,
    name AS recipe_name,
    description,
    created_at,
    updated_at,
    runnable,
    running,
    parent_id
FROM recipe_data
ON CONFLICT (recipe_id) DO NOTHING;


INSERT INTO dim_applications (application_name)
SELECT DISTINCT 
    TRIM(BOTH '"' FROM TRIM(split_values.split_app)) AS application_name
FROM recipe_data S
CROSS JOIN LATERAL regexp_split_to_table(
    TRIM(BOTH '{}' FROM s.applications), 
    ','
) AS split_values(split_app)
WHERE s.applications IS NOT NULL 
    AND TRIM(BOTH '"' FROM TRIM(split_values.split_app)) <> ''
ON CONFLICT (application_name) DO NOTHING;


INSERT INTO dim_categories (category_name)
SELECT DISTINCT 
    TRIM(BOTH '"' FROM TRIM(split_values.category_name)) AS category_name
FROM recipe_data s
CROSS JOIN LATERAL regexp_split_to_table(
    TRIM(BOTH '{}' FROM s.categories), 
    ','
) AS split_values(category_name)
WHERE s.categories IS NOT NULL 
    AND TRIM(BOTH '"' FROM TRIM(split_values.category_name)) <> ''
ON CONFLICT (category_name) DO NOTHING;


INSERT INTO dim_business_objects (business_object_name)
SELECT DISTINCT 
    TRIM(BOTH '"' FROM TRIM(object_name)) AS business_object_name
FROM recipe_data s
CROSS JOIN LATERAL regexp_split_to_table(
    TRIM(BOTH '{}' FROM s.business_objects), 
    ','
) AS object_name
WHERE s.business_objects IS NOT NULL 
    AND TRIM(BOTH '"' FROM TRIM(object_name)) <> ''
ON CONFLICT (business_object_name) DO NOTHING;

INSERT INTO fact_recipe_metrics (
    recipe_id,
    job_succeed_count,
    job_failed_count,
    total_job_count
)
SELECT 
    id AS recipe_id,
    job_succeed_count,
    job_failed_count,
    job_succeed_count + job_failed_count AS total_job_count
FROM recipe_data
ON CONFLICT (recipe_id) DO NOTHING;


INSERT INTO bridge_recipe_applications (recipe_id, application_id)
SELECT DISTINCT 
    s.id AS recipe_id,
    a.application_id
FROM recipe_data s
CROSS JOIN LATERAL regexp_split_to_table(
    TRIM(BOTH '{}' FROM s.applications), 
    ','
) AS split_values(split_app)
JOIN dim_applications a
    ON TRIM(BOTH '"' FROM TRIM(split_values.split_app)) = a.application_name
WHERE s.applications IS NOT NULL 
    AND TRIM(BOTH '"' FROM TRIM(split_values.split_app)) <> ''
ON CONFLICT (recipe_id, application_id) DO NOTHING;


INSERT INTO bridge_recipe_categories (recipe_id, category_id)
SELECT DISTINCT
    s.id AS recipe_id,
    c.category_id
FROM recipe_data s
CROSS JOIN LATERAL regexp_split_to_table(
    TRIM(BOTH '{}' FROM s.categories), 
    ','
) AS split_values(category_name)
JOIN dim_categories c
    ON TRIM(BOTH '"' FROM TRIM(split_values.category_name)) = c.category_name
WHERE s.categories IS NOT NULL 
    AND TRIM(BOTH '"' FROM TRIM(split_values.category_name)) <> ''
ON CONFLICT (recipe_id, category_id) DO NOTHING;


INSERT INTO bridge_recipe_business_objects (recipe_id, business_object_id)
SELECT DISTINCT
    s.id AS recipe_id,
    bo.business_object_id
FROM recipe_data s
CROSS JOIN LATERAL regexp_split_to_table(
    TRIM(BOTH '{}' FROM s.business_objects),
    ','
) AS split_values(split_object)
JOIN dim_business_objects bo
    ON TRIM(BOTH '"' FROM TRIM(split_values.split_object)) = bo.business_object_name
WHERE s.business_objects IS NOT NULL
    AND TRIM(BOTH '"' FROM TRIM(split_values.split_object)) <> ''
ON CONFLICT (recipe_id, business_object_id) DO NOTHING;

