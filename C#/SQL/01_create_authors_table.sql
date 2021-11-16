-- DROP TABLE authors;

CREATE TABLE IF NOT EXISTS authors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    description VARCHAR(400) NOT NULL,
    time_registered TIMESTAMP WITH TIME ZONE NOT NULL
);