CREATE TABLE IF NOT EXISTS "healthcare"."customer_satisfaction_score" (
  "id" INT PRIMARY KEY,
  "patient_id" INT, FOREIGN KEY ("patient_id") REFERENCES healthcare.patients ("patient_id"),
  "department" VARCHAR,
  "date" TIMESTAMP(0),
  "score" INT
);
