-- 1
SELECT 
    r.user_id, 
    r.recipe_id
FROM dim_recipes r
JOIN bridge_recipe_applications bra 
    ON r.recipe_id = bra.recipe_id
JOIN dim_applications a 
    ON bra.application_id = a.application_id
WHERE r.running = TRUE 
    AND a.application_name IN ('Application A', 'Application B', 'Application C', 'Application D')
GROUP BY r.user_id, r.recipe_id 
HAVING COUNT(DISTINCT a.application_name) = 4;

-- OR if question is asking about any 4 applications as 1 time, from what I have found the only one running only 4 applciations at one time is user_id 43517, running email, marketo, rest and salesforce.
SELECT DISTINCT
    r.user_id
FROM dim_recipes r
JOIN bridge_recipe_applications bra
    ON r.recipe_id = bra.recipe_id
WHERE r.running = true
GROUP BY r.user_id, r.recipe_id
HAVING COUNT(DISTINCT bra.application_id) >= 4
ORDER BY r.user_id;

-- 2
SELECT 
    CASE 
        WHEN parent_id IS NULL THEN 'original'
        ELSE 'cloned'
    END AS recipe_type,
    COUNT(*) AS recipe_count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS percentage
FROM dim_recipes
WHERE running = TRUE
GROUP BY recipe_type;

-- 3
SELECT
    DATE_TRUNC('month', r.created_at) AS month,
    c.category_name,
    COUNT(DISTINCT r.recipe_id) AS recipe_count
FROM dim_recipes r
JOIN bridge_recipe_categories brc
    ON r.recipe_id = brc.recipe_id
JOIN dim_categories c
    ON brc.category_id = c.category_id
GROUP BY month, c.category_name
ORDER BY month, c.category_name;

-- 4
WITH app_count AS (
    SELECT 
        recipe_id, 
        COUNT(DISTINCT application_id) AS application_count
    FROM bridge_recipe_applications
    GROUP BY recipe_id
)
SELECT 
    application_count,
    COUNT(*) AS recipe_count
FROM app_count
GROUP BY application_count
ORDER BY application_count;