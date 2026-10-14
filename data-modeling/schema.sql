DROP TABLE IF EXISTS recipe_data;

CREATE TABLE dim_users (
    user_id BIGINT PRIMARY KEY
);

CREATE TABLE dim_recipes (
    recipe_id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL, 
    version_no INT,
    recipe_name TEXT,
    description TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    runnable BOOLEAN,
    running BOOLEAN,
    parent_id BIGINT,
    FOREIGN KEY (user_id) REFERENCES dim_users(user_id)
);

CREATE TABLE dim_applications (
    application_id BIGSERIAL PRIMARY KEY,
    application_name TEXT UNIQUE NOT NULL
);

CREATE TABLE dim_categories (
    category_id BIGSERIAL PRIMARY KEY,
    category_name TEXT UNIQUE NOT NULL
);

CREATE TABLE dim_business_objects (
    business_object_id BIGSERIAL PRIMARY KEY,
    business_object_name TEXT UNIQUE NOT NULL
);

CREATE TABLE bridge_recipe_applications (
    recipe_id BIGINT NOT NULL,
    application_id BIGINT NOT NULL,
    PRIMARY KEY (recipe_id, application_id),
    FOREIGN KEY (recipe_id) REFERENCES dim_recipes(recipe_id),
    FOREIGN KEY (application_id) REFERENCES dim_applications(application_id)
);

CREATE TABLE bridge_recipe_categories (
    recipe_id BIGINT NOT NULL,
    category_id BIGINT NOT NULL,
    PRIMARY KEY (recipe_id, category_id),
    FOREIGN KEY (recipe_id) REFERENCES dim_recipes(recipe_id),
    FOREIGN KEY (category_id) REFERENCES dim_categories(category_id)
);

CREATE TABLE bridge_recipe_business_objects (
    recipe_id BIGINT NOT NULL,
    business_object_id BIGINT NOT NULL,
    PRIMARY KEY (recipe_id, business_object_id),
    FOREIGN KEY (recipe_id) REFERENCES dim_recipes(recipe_id),
    FOREIGN KEY (business_object_id) REFERENCES dim_business_objects(business_object_id)
);

CREATE TABLE fact_recipe_metrics (
    recipe_id BIGINT PRIMARY KEY,
    job_succeed_count INT,
    job_failed_count INT,
    total_job_count INT,
    FOREIGN KEY (recipe_id) REFERENCES dim_recipes(recipe_id)
);

CREATE TABLE recipe_data (
    id BIGINT,
    user_id BIGINT,
    version_no INT,
    name TEXT,
    description TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    applications TEXT,
    categories TEXT,
    business_objects TEXT,
    runnable BOOLEAN,
    running BOOLEAN,
    job_succeed_count INT,
    job_failed_count INT,
    parent_id BIGINT
);
