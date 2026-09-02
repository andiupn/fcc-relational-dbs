-- Salon Appointment Scheduler — dump.sql
-- Restore: psql -U postgres < dump.sql
-- FCC: Salon Appointment Scheduler (bash + psql interactive)

DROP DATABASE IF EXISTS salon;
CREATE DATABASE salon;

\c salon

DROP TABLE IF EXISTS appointments, customers, services CASCADE;

CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  phone VARCHAR(20) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE services (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE appointments (
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL REFERENCES customers(customer_id),
  service_id INT NOT NULL REFERENCES services(service_id),
  time VARCHAR(20) NOT NULL
);

-- Seed services (FCC biasanya 5, test cek minimal 3)
INSERT INTO services(name) VALUES
  ('cut'), ('color'), ('perm'), ('style'), ('trim');

-- Seed customers + appointments dummy (boleh kosong, tapi seed membantu test manual)
INSERT INTO customers(phone, name) VALUES
  ('555-0001', 'Alice'),
  ('555-0002', 'Bob');

INSERT INTO appointments(customer_id, service_id, time) VALUES
  ((SELECT customer_id FROM customers WHERE phone='555-0001'), (SELECT service_id FROM services WHERE name='cut'), '10:30'),
  ((SELECT customer_id FROM customers WHERE phone='555-0002'), (SELECT service_id FROM services WHERE name='color'), '11:00');

CREATE INDEX IF NOT EXISTS idx_appointments_customer ON appointments(customer_id);
CREATE INDEX IF NOT EXISTS idx_appointments_service ON appointments(service_id);
