CREATE SEQUENCE generate_bills_id START 1;

CREATE OR REPLACE FUNCTION generate_bills()
RETURNS VOID AS $$
DECLARE
    appointment_record RECORD;
    max_price NUMERIC := 600.00; -- Set the maximum price for the appointment
BEGIN
    FOR appointment_record IN SELECT * FROM healthcare.appointments
    LOOP
        INSERT INTO healthcare.bills (id, appointment_id, patient_id, medical_professional_id, status, price)
        VALUES
        (
            NEXTVAL('generate_bills_id'),
            appointment_record.appointment_id,
            appointment_record.patient_id,
            appointment_record.medical_professional_id,
            'pending',
            ROUND((RANDOM() * max_price)::numeric, 2) -- Generate a random price between 0 and max_price rounded to 2 decimal places
        );
    END LOOP;
END;
$$ LANGUAGE PLPGSQL;

SELECT generate_bills();