CREATE SEQUENCE generate_medical_records_id START 1;

CREATE OR REPLACE FUNCTION generate_medical_records()
RETURNS VOID AS $$
DECLARE
    min_medical_records INTEGER := 2; -- Minimum number of medical records per patient
    max_medical_records INTEGER := 3; -- Maximum number of medical records per patient (you can adjust this based on your needs)
    record_counter INTEGER;
    patient_record RECORD;
BEGIN
    FOR patient_record IN SELECT * FROM healthcare.patients
    LOOP
        record_counter := min_medical_records + floor(random() * (max_medical_records - min_medical_records + 1));

        FOR i IN 1..record_counter
        LOOP
            INSERT INTO healthcare.medical_records (id, patient_id, records)
            VALUES
            (
                NEXTVAL('generate_medical_records_id'),
                patient_record.patient_id,
                floor(random() * 900000 + 100000) -- Generate a random number to "refer" to a medical record
            );
        END LOOP;
    END LOOP;
END;
$$ LANGUAGE PLPGSQL;

SELECT generate_medical_records();
