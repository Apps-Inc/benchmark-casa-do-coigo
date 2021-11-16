-- Script para inserir dados de teste no banco.
--
-- Por questões de consistência, deve ser possível rodar esse script repetidas
-- vezes e obter o mesmo resultado.

-- # Autores

DELETE FROM authors WHERE id >= 0;
ALTER SEQUENCE authors_id_seq RESTART;
SELECT * FROM authors;

WITH new_rows AS (
    INSERT INTO authors
        (name, email, time_registered, description)
    VALUES
        ('Terry Pratchett', 'mail@terrypratchettbooks.com', '2021-03-12', 'Was an English humorist, satirist, and author of fantasy novels, especially comical works'),
        ('Philip Pullman', 'mail@philip-pullman.com', '2020-04-05', 'An English author of high-selling books, including the fantasy trilogy His Dark Materials and a fictionalised biography of Jesus, The Good Man Jesus and the Scoundrel Christ'),
        ('Stephen King', 'sk@stephenking.com','2021-01-03', 'An American author of horror, supernatural fiction, suspense, crime, science-fiction, and fantasy novels'),

        ('Bjarne Stroustrup', 'mail@stroustrup.com','2021-02-04', 'A Danish computer scientist, most notable for the creation and development of the C++ programming language')
    RETURNING 1
) SELECT COUNT(*) FROM new_rows;

-- # Categorias

DELETE FROM categories WHERE id >= 0;
ALTER SEQUENCE categories_id_seq RESTART;
SELECT * FROM categories;

WITH new_rows AS (
    INSERT INTO categories
        (name, time_registered)
    VALUES
        ('Ficção', '1968-11-20'),
        ('Fantasia', '1950-04-13'),
        ('Horror', '2013-05-09')
    RETURNING 1
) SELECT COUNT(*) FROM new_rows;

-- # Livros

DELETE FROM books WHERE id >= 0;
ALTER SEQUENCE books_id_seq RESTART;
SELECT * FROM books;

WITH new_rows AS (
    INSERT INTO books
        (title, abstract, summary, price, num_pages, isbn, publication_date, time_registered, category, author)
        VALUES
            ('The Colour Of Magic', 'A 1983 fantasy comedy novel by Terry Pratchett, and is the first book of the Discworld series', 'Rincewind did nothing wrong', 10.93, 288, '9780552124751', '2008-06-17', '2021-02-01', 2, 1),
            ('The Golden Compass', 'The first volume of His Dark Materials', 'That''s not a compass, though', 7.89, 368, '9780440238133', '2003-09-09', '2019-01-05', 2, 2),

            ('The C++ Programming Language', 'Mostly about C++', 'May talk about C', 55.50, 1376, '978-0321958327', '2013-07-24', '2020-12-01', 3, 4)
        RETURNING 1
) SELECT COUNT(*) FROM new_rows;

-- # Países

DELETE FROM countries WHERE id >= 0;
ALTER SEQUENCE countries_id_seq RESTART;
SELECT * FROM countries;

WITH new_rows AS (
    INSERT INTO countries
        (name, time_registered)
        VALUES
            ('Brasil', '2013-05-03'),
            ('Portugal', '2014-01-13')
        RETURNING 1
) SELECT COUNT(*) FROM new_rows;

-- # Estados

DELETE FROM states WHERE id >= 0;
ALTER SEQUENCE states_id_seq RESTART;
SELECT * FROM states;

WITH new_rows AS (
    INSERT INTO states
        (name, time_registered, country)
        VALUES
            ('Rio de Janeiro', '2013-05-03', 1),
            ('Bragança', '2014-01-13', 1),
            ('Acre', '1993-05-23', 1)
        RETURNING 1
) SELECT COUNT(*) FROM new_rows;
