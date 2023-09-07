CREATE TABLE IF NOT EXISTS "healthcare"."patients" (
  "patient_id" INT PRIMARY KEY,
  "user_id" INt, FOREIGN KEY ("user_id") REFERENCES healthcare.users ("id"),
  "name" VARCHAR,
  "dob" TIMESTAMP(0),
  "contact_information" VARCHAR,
  "emergency_contacts" VARCHAR,
  "insurance_information" VARCHAR
);
