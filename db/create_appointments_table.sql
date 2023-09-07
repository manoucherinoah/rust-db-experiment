CREATE TABLE IF NOT EXISTS "healthcare"."appointments" (
  "appointment_id" INT PRIMARY KEY,
  "patient_id" INT, FOREIGN KEY ("patient_id") REFERENCES healthcare.patients ("patient_id"),
  "medical_professional_id" INT, FOREIGN KEY ("medical_professional_id") REFERENCES healthcare.medical_professionals ("medical_professional_id"),
  "appointment_datetime" TIMESTAMP(0)
);