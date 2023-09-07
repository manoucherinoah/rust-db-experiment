CREATE TABLE IF NOT EXISTS "healthcare"."medical_professionals" (
  "medical_professional_id" INT PRIMARY KEY,
  "user_id" INT, FOREIGN KEY ("user_id") REFERENCES healthcare.users ("id"),
  "name" VARCHAR
);
