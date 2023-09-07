CREATE SEQUENCE IF NOT EXISTS user_sequence START 1;

CREATE OR REPLACE FUNCTION get_username()
RETURNS TEXT AS
$$
DECLARE
    random_number INTEGER;
    random_name TEXT;
BEGIN
    SELECT name INTO random_name
    FROM (
        VALUES
            ('Adam'), ('Bill'), ('Bob'), ('Calvin'), ('Donald'), ('Dwight'), ('Frank'), ('Fred'), ('George'), ('Howard'),
            ('James'), ('John'), ('Jacob'), ('Jack'), ('Martin'), ('Matthew'), ('Max'), ('Michael'),
            ('Paul'), ('Peter'), ('Phil'), ('Roland'), ('Ronald'), ('Samuel'), ('Steve'), ('Theo'), ('Warren'), ('William'),
            ('Abigail'), ('Alice'), ('Allison'), ('Amanda'), ('Anne'), ('Barbara'), ('Betty'), ('Carol'), ('Cleo'), ('Donna'),
            ('Jane'), ('Jennifer'), ('Julie'), ('Martha'), ('Mary'), ('Melissa'), ('Patty'), ('Sarah'), ('Simone'), ('Susan')
    ) AS names(name)
    ORDER BY random()
    LIMIT 1;

    random_number := (random() * 81 + 10)::INT;
   	random_name := CONCAT(random_name, '_');

    RETURN CONCAT(random_name, random_number);
END;
$$
LANGUAGE plpgsql;

-- Generate random data for the accounts table
INSERT INTO healthcare.users (
    id,
    username,
    password,
    email,
    role
)
SELECT
    nextval('user_sequence') AS id,
    username,
    md5(random()::text) AS hashed_password,
    username || '@example.com' AS email,
    CASE WHEN random() < 0.3 THEN 'medical_professional' ELSE 'patient' END AS role
FROM (
    SELECT get_username() AS username
    FROM generate_series(1, 25)
) AS usernames;