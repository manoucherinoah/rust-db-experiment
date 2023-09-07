CREATE TABLE IF NOT EXISTS "healthcare"."bills"(
  "id" INT PRIMARY KEY,
  "appointment_id" INT, FOREIGN KEY ("appointment_id") REFERENCES healthcare.appointments ("appointment_id"),
  "patient_id" INT, FOREIGN KEY ("patient_id") REFERENCES healthcare.patients ("patient_id"),
  "medical_professional_id" INT, FOREIGN KEY ("medical_professional_id") REFERENCES healthcare.medical_professionals ("medical_professional_id"),
  "status" VARCHAR,
  "price" NUMERIC
);
