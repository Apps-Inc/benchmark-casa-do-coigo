CREATE TABLE IF NOT EXISTS books (
    id SERIAL PRIMARY KEY,
    title TEXT UNIQUE NOT NULL,
    abstract VARCHAR(500) NOT NULL,
    summary TEXT,
    price decimal NOT NULL,
    num_pages INT NOT NULL,
    isbn TEXT UNIQUE NOT NULL, -- VARCHAR(13)?
    publication_date TIMESTAMP WITH TIME ZONE NOT NULL,

    category INT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    author INT NOT NULL REFERENCES authors(id) ON DELETE CASCADE,

    time_registered TIMESTAMP WITH TIME ZONE NOT NULL
);
