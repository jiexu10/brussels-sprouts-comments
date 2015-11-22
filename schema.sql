-- If you want to run this schema repeatedly you'll need to drop
-- the table before re-creating it. Note that you'll lose any
-- data if you drop and add a table:

DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS comments;

-- Define your schema here:

CREATE TABLE recipes (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255),
  ingredients TEXT,
  steps TEXT
);

-- CREATE UNIQUE INDEX title ON recipes(title);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  comment VARCHAR(255),
  recipe_id INTEGER
)
