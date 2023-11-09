-- Tabel dimensi dim_user
CREATE TABLE dim_user (
    dim_user_id serial PRIMARY KEY,
    user_name text,
    country text
);

-- Tabel dimensi dim_post
CREATE TABLE dim_post (
    dim_post_id serial PRIMARY KEY,
    post_text text,
    post_date date,
    dim_user_id integer REFERENCES dim_user(dim_user_id),
    CONSTRAINT dim_post_id_unique UNIQUE (dim_post_id)
);

-- Tabel dimensi dim_date
CREATE TABLE dim_date (
    theDate date PRIMARY KEY,
    theDay integer,
    theDayName text,
    theWeek integer,
    theMonth integer,
    theMonthName text,
    theYear integer
);


-- Masukkan data dim_user
INSERT INTO dim_user (user_name, country)
SELECT user_name, country
FROM raw_users;

-- Memasukkan data dim_post
INSERT INTO dim_post (post_text, post_date, dim_user_id)
SELECT post_text, post_date, user_id
FROM raw_posts;

-- Memasukkan data dim_date
INSERT INTO dim_date (date_key, theDay, theDayName, theWeek, theMonth, theMonthName, theYear)
SELECT
    post_date,
    EXTRACT(DAY FROM post_date),
    TO_CHAR(post_date, 'Day'),
    EXTRACT(WEEK FROM post_date),
    EXTRACT(MONTH FROM post_date),
    TO_CHAR(post_date, 'Month'),
    EXTRACT(YEAR FROM post_date)
FROM raw_posts;


-- Tabel fact_post_performance
CREATE TABLE fact_post_performance (
    fact_id serial PRIMARY KEY,
    dim_post_id integer REFERENCES dim_post(dim_post_id),
    dim_date_id integer REFERENCES dim_date(theDate),
    views integer,
    likes integer
);
