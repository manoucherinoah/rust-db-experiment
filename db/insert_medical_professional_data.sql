CREATE SEQUENCE IF NOT EXISTS medical_professional_sequence START 1;

INSERT INTO healthcare.medical_professionals (medical_professional_id, user_id, name)
SELECT
    nextval('medical_professional_sequence') AS medical_professional_id,
    id AS user_id,
    get_name() AS name
FROM healthcare.users
WHERE role = 'medical_professional';
