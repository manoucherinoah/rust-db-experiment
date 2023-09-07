CREATE SEQUENCE generate_customer_satisfaction_score_id START 1;

CREATE OR REPLACE FUNCTION generate_customer_satisfaction_scores()
RETURNS VOID AS $$
DECLARE
    min_score INTEGER := 1; -- Minimum customer satisfaction score
    max_score INTEGER := 10; -- Maximum customer satisfaction score
    appointment_record RECORD;
    department_names TEXT[] := ARRAY['Cardiology', 'Orthopedics', 'Gynecology', 'Pediatrics', 'Neurology']; -- Add more department names as needed
    random_department TEXT;
BEGIN
    FOR appointment_record IN SELECT * FROM healthcare.appointments
    LOOP
        random_department := department_names[1 + floor(random() * array_length(department_names, 1))];

        INSERT INTO healthcare.customer_satisfaction_score (id, patient_id, department, date, score)
        VALUES
        (
            NEXTVAL('generate_customer_satisfaction_score_id'),
            appointment_record.patient_id,
            random_department,
            appointment_record.appointment_datetime::date,
            min_score + floor(random() * (max_score - min_score + 1)) -- Generate a random score between min_score and max_score
        );
    END LOOP;
END;
$$ LANGUAGE PLPGSQL;

SELECT generate_customer_satisfaction_scores();