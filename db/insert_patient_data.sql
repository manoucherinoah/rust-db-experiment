CREATE SEQUENCE IF NOT EXISTS patient_sequence START 1;

CREATE OR REPLACE FUNCTION get_name()
RETURNS TEXT AS
$$
DECLARE
    random_number INTEGER;
    random_name TEXT;
BEGIN
    SELECT name INTO random_name
    FROM (
        VALUES
            ('Matthews'),('Smith'),('Jones'),('Davis'),('Jacobson'),('Williams'),('Donaldson'),('Maxwell'),('Peterson'),('Stevens'),
            ('Franklin'),('Washington'),('Jefferson'),('Adams'),('Jackson'),('Johnson'),('Lincoln'),('Grant'),('Fillmore'),('Harding'),('Taft'),
            ('Truman'),('Ebert'),('Ford'),('Carter'),('Reagan'),('Bush'),('Clinton'),('Hancock'), ('Feijó'), ('Manoucheri'), ('Gerard'), ('Vana')
    ) AS names(name)
    ORDER BY random()
    LIMIT 1;


    random_number := (random() * 81 + 10)::INT;

    RETURN random_name;
END;
$$
LANGUAGE plpgsql;

INSERT INTO healthcare.patients (patient_id, user_id, name, dob, contact_information, emergency_contacts, insurance_information)
SELECT
    nextval('patient_sequence') AS patient_id,
    id AS user_id,
    get_name() as name,
    DATE '1970-01-01' + (random() * (DATE '2000-01-01' - DATE '1950-01-01'))::INTEGER AS dob,
    concat('(555) ', floor(random() * 900 + 100), '-', floor(random() * 9000 + 1000)) AS contact_information,
    concat('(555) ', floor(random() * 900 + 100), '-', floor(random() * 9000 + 1000)) AS emergency_contacts,
    CASE
        WHEN random() > 0.5 THEN 'ABC Insurance Co.'
        ELSE 'XYZ Insurance Inc.'
    END AS insurance_information
FROM healthcare.users
WHERE role = 'patient';


