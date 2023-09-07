CREATE TABLE IF NOT EXISTS "healthcare"."medical_records" (
  "id" INT PRIMARY KEY, FOREIGN KEY ("patient_id") REFERENCES healthcare.patients ("patient_id"),
  "patient_id" INT,
  "records" VARCHAR
);