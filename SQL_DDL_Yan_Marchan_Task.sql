-- Create the main database
CREATE DATABASE medical_records;

-- Connect to the medical_records database
\c medical_records;

-- Create the medical_schema schema
CREATE SCHEMA medical_schema;

-- Create the patients table
CREATE TABLE medical_schema.patients (
    patient_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    date_of_birth DATE CHECK (date_of_birth > '2000-01-01'),
    record_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the doctors table
CREATE TABLE medical_schema.doctors (
    doctor_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    specialty VARCHAR(50) NOT NULL,
    record_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the test_types table
CREATE TABLE medical_schema.test_types (
    test_type_id SERIAL PRIMARY KEY,
    test_name VARCHAR(100) NOT NULL UNIQUE
);

-- Create the tests table with reference to test_types
CREATE TABLE medical_schema.tests (
    test_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL,
    test_type_id INT NOT NULL,
    measured_value DECIMAL NOT NULL CHECK (measured_value >= 0),
    FOREIGN KEY (patient_id) REFERENCES medical_schema.patients(patient_id),
    FOREIGN KEY (test_type_id) REFERENCES medical_schema.test_types(test_type_id),
    record_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the appointments table
CREATE TABLE medical_schema.appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE CHECK (appointment_date > '2000-01-01'),
    FOREIGN KEY (patient_id) REFERENCES medical_schema.patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES medical_schema.doctors(doctor_id),
    record_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data into patients table
INSERT INTO medical_schema.patients (name, gender, date_of_birth) 
VALUES 
    ('John Doe', 'Male', '2005-05-15'), 
    ('Jane Smith', 'Female', '2003-10-20');

-- Insert sample data into doctors table
INSERT INTO medical_schema.doctors (name, specialty) 
VALUES 
    ('Dr. Johnson', 'Cardiology'), 
    ('Dr. Williams', 'Pediatrics');

-- Insert sample data into appointments table
INSERT INTO medical_schema.appointments (patient_id, doctor_id, appointment_date) 
VALUES 
    (1, 1, '2023-01-10'), 
    (2, 2, '2023-03-20');

-- Insert sample data into test_types and tests tables (assuming test types are already defined)
-- Example insertion for test_types
INSERT INTO medical_schema.test_types (test_name) 
VALUES 
    ('Blood Pressure'), 
    ('Blood Sugar');

-- Example insertion for tests using test_type_id (assuming IDs for Blood Pressure and Blood Sugar are 1 and 2 respectively)
INSERT INTO medical_schema.tests (patient_id, test_type_id, measured_value) 
VALUES 
    (1, 1, 120), -- Blood Pressure test for patient 1
    (2, 2, 85);  -- Blood Sugar test for patient 2
