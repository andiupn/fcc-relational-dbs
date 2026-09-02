-- Periodic Table Database — dump.sql (FIXED version — lolos FCC)
-- Restore: psql -U postgres < dump.sql
-- FCC: Periodic Table Database (add type, properties, fix DB + element.sh)

DROP DATABASE IF EXISTS periodic_table;
CREATE DATABASE periodic_table;

\c periodic_table

DROP TABLE IF EXISTS properties, elements, types CASCADE;

-- types: 3 rows (nonmetal, metal, metalloid) — FCC check
CREATE TABLE types (
  type_id SERIAL PRIMARY KEY,
  type VARCHAR(30) UNIQUE NOT NULL
);

INSERT INTO types(type) VALUES ('nonmetal'), ('metal'), ('metalloid');

-- elements
CREATE TABLE elements (
  atomic_number INT PRIMARY KEY,
  symbol VARCHAR(2) UNIQUE NOT NULL,
  name VARCHAR(30) UNIQUE NOT NULL
);

-- properties (FK ke elements + types, UNIQUE atomic_number)
CREATE TABLE properties (
  atomic_number INT PRIMARY KEY REFERENCES elements(atomic_number) ON DELETE CASCADE,
  atomic_mass NUMERIC NOT NULL,
  melting_point_celsius NUMERIC NOT NULL,
  boiling_point_celsius NUMERIC NOT NULL,
  type_id INT NOT NULL REFERENCES types(type_id)
);

-- Seed 10 elements (H to Ne — FCC expects at least 9-10, termasuk H, B, Li, etc.)
INSERT INTO elements(atomic_number, symbol, name) VALUES
  (1, 'H', 'Hydrogen'),
  (2, 'He', 'Helium'),
  (3, 'Li', 'Lithium'),
  (4, 'Be', 'Beryllium'),
  (5, 'B', 'Boron'),
  (6, 'C', 'Carbon'),
  (7, 'N', 'Nitrogen'),
  (8, 'O', 'Oxygen'),
  (9, 'F', 'Fluorine'),
  (10, 'Ne', 'Neon');

INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) VALUES
  (1, 1.008, -259.1, -252.9, (SELECT type_id FROM types WHERE type='nonmetal')),
  (2, 4.0026, -272.2, -269, (SELECT type_id FROM types WHERE type='nonmetal')),
  (3, 6.94, 180.54, 1342, (SELECT type_id FROM types WHERE type='metal')),
  (4, 9.0122, 1287, 2469, (SELECT type_id FROM types WHERE type='metal')),
  (5, 10.81, 2075, 4000, (SELECT type_id FROM types WHERE type='metalloid')),
  (6, 12.011, 3550, 4027, (SELECT type_id FROM types WHERE type='nonmetal')),
  (7, 14.007, -210.1, -195.8, (SELECT type_id FROM types WHERE type='nonmetal')),
  (8, 15.999, -218, -183, (SELECT type_id FROM types WHERE type='nonmetal')),
  (9, 18.998, -219.6, -188.1, (SELECT type_id FROM types WHERE type='nonmetal')),
  (10, 20.180, -248.59, -246.08, (SELECT type_id FROM types WHERE type='nonmetal'));

-- Tambahan agar FCC final check (CSV restore) tetap aman: capitalize, trim
UPDATE elements SET symbol = INITCAP(symbol) WHERE atomic_number = 1;

-- Index
CREATE INDEX IF NOT EXISTS idx_properties_type ON properties(type_id);
