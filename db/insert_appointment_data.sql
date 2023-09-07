CREATE SEQUENCE generate_appointments_id START 1;

CREATE OR REPLACE FUNCTION generate_random_appointments()
RETURNS VOID AS $$
DECLARE
    num_appointments INTEGER := 3;
    appointment_timestamp TIMESTAMP := now();
    end_date TIMESTAMP := appointment_timestamp + INTERVAL '3 months';
    random_patient_id INTEGER;
    medical_professional RECORD;
BEGIN
    FOR medical_professional IN SELECT * FROM healthcare.medical_professionals
    LOOP
        While appointment_timestamp < end_date
        LOOP
            random_patient_id := (SELECT patient_id FROM healthcare.patients ORDER BY RANDOM() LIMIT 1);

            INSERT INTO healthcare.appointments (appointment_id, patient_id, medical_professional_id, appointment_datetime)
            VALUES
            (
                NEXTVAL('generate_appointments_id'),
                random_patient_id,
                medical_professional.medical_professional_id,
                appointment_timestamp
            );
            appointment_timestamp := appointment_timestamp + INTERVAL '1 day';
        END LOOP;
        appointment_timestamp := now();
    END LOOP;

END;
$$ LANGUAGE PLPGSQL;

SELECT generate_random_appointments();
