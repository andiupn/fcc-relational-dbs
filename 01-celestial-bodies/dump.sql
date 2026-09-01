-- Celestial Bodies Database — dump.sql
-- Restore:  psql -U postgres < dump.sql
-- atau:     createdb universe  (jika DB belum ada) lalu psql -U postgres -d universe -f dump.sql
-- Tested: PostgreSQL 15+ (CodeAlly / GitHub Codespaces)
-- FCC Project: Build a Celestial Bodies Database

-- ------------------------------------------------------------------
-- 1) Database
-- ------------------------------------------------------------------
DROP DATABASE IF EXISTS universe;
CREATE DATABASE universe;

\c universe

-- ------------------------------------------------------------------
-- 2) Tables — sesuai constraint FCC (PK, UNIQUE, NOT NULL, FK)
-- ------------------------------------------------------------------

-- galaxy
DROP TABLE IF EXISTS moon, planet, star, galaxy CASCADE;

CREATE TABLE galaxy (
  galaxy_id SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL,
  description TEXT,
  type VARCHAR(50),
  distance_from_earth NUMERIC,
  number_of_stars BIGINT
);

-- star (FK -> galaxy)
CREATE TABLE star (
  star_id SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL,
  galaxy_id INT NOT NULL REFERENCES galaxy(galaxy_id),
  distance_from_earth NUMERIC,
  age_in_billion_years NUMERIC,
  type VARCHAR(50)
);

-- planet (FK -> star)
CREATE TABLE planet (
  planet_id SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL,
  star_id INT NOT NULL REFERENCES star(star_id),
  has_life BOOLEAN NOT NULL DEFAULT FALSE,
  is_moon BOOLEAN NOT NULL DEFAULT FALSE,
  description TEXT,
  orbit_period_in_days NUMERIC,
  diameter_km NUMERIC
);

-- moon (FK -> planet)
CREATE TABLE moon (
  moon_id SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL,
  planet_id INT NOT NULL REFERENCES planet(planet_id),
  description TEXT,
  diameter_km NUMERIC,
  discovery_year INT
);

-- ------------------------------------------------------------------
-- 3) Seed — minimal lolos FCC (galaxy>=6, star>=6, planet>=12, moon>=20)
-- ------------------------------------------------------------------
INSERT INTO galaxy (name, description, type, distance_from_earth, number_of_stars) VALUES
  ('Milky Way', 'Home galaxy, spiral', 'spiral', 0, 100000000000),
  ('Andromeda', 'Nearest large spiral', 'spiral', 2537000, 1000000000000),
  ('Triangulum', 'Third largest Local Group', 'spiral', 3000000, 40000000000),
  ('Whirlpool', 'Interacting grand-design spiral', 'spiral', 23000000, 100000000000),
  ('Sombrero', 'Unbarred lenticular', 'lenticular', 31000000, 80000000000),
  ('Messier 87', 'Supergiant elliptical with jet', 'elliptical', 55000000, 1000000000000),
  ('Pinwheel', 'Face-on spiral', 'spiral', 21000000, 100000000000),
  ('Black Eye', 'Spiral with dark band', 'spiral', 24000000, 40000000000);

INSERT INTO star (name, galaxy_id, distance_from_earth, age_in_billion_years, type) VALUES
  ('Sun', (SELECT galaxy_id FROM galaxy WHERE name='Milky Way'), 0.0000158, 4.6, 'G-type main-sequence'),
  ('Sirius', (SELECT galaxy_id FROM galaxy WHERE name='Milky Way'), 8.6, 0.242, 'A-type main-sequence'),
  ('Betelgeuse', (SELECT galaxy_id FROM galaxy WHERE name='Milky Way'), 548, 0.008, 'red supergiant'),
  ('Vega', (SELECT galaxy_id FROM galaxy WHERE name='Milky Way'), 25, 0.455, 'A-type main-sequence'),
  ('Andromeda Star 1', (SELECT galaxy_id FROM galaxy WHERE name='Andromeda'), 2537000, 2.0, 'blue giant'),
  ('Triangulum Star A', (SELECT galaxy_id FROM galaxy WHERE name='Triangulum'), 3000000, 1.1, 'yellow dwarf'),
  ('Whirlpool Star X', (SELECT galaxy_id FROM galaxy WHERE name='Whirlpool'), 23000000, 0.9, 'red dwarf'),
  ('Sombrero Star S1', (SELECT galaxy_id FROM galaxy WHERE name='Sombrero'), 31000000, 5.0, 'white dwarf'),
  ('M87 Star Central', (SELECT galaxy_id FROM galaxy WHERE name='Messier 87'), 55000000, 10.0, 'red giant'),
  ('Pinwheel Star P1', (SELECT galaxy_id FROM galaxy WHERE name='Pinwheel'), 21000000, 3.2, 'G-type'),
  ('Black Eye Star B1', (SELECT galaxy_id FROM galaxy WHERE name='Black Eye'), 24000000, 4.0, 'K-type'),
  ('Proxima Centauri', (SELECT galaxy_id FROM galaxy WHERE name='Milky Way'), 4.246, 4.85, 'red dwarf');

INSERT INTO planet (name, star_id, has_life, is_moon, description, orbit_period_in_days, diameter_km) VALUES
  ('Earth', (SELECT star_id FROM star WHERE name='Sun'), true, false, 'Home planet', 365.25, 12742),
  ('Mars', (SELECT star_id FROM star WHERE name='Sun'), false, false, 'Red planet', 687, 6779),
  ('Jupiter', (SELECT star_id FROM star WHERE name='Sun'), false, false, 'Gas giant', 4333, 139820),
  ('Saturn', (SELECT star_id FROM star WHERE name='Sun'), false, false, 'Ringed gas giant', 10759, 116460),
  ('Venus', (SELECT star_id FROM star WHERE name='Sun'), false, false, 'Hot terrestrial', 225, 12104),
  ('Mercury', (SELECT star_id FROM star WHERE name='Sun'), false, false, 'Closest to Sun', 88, 4879),
  ('Neptune', (SELECT star_id FROM star WHERE name='Sun'), false, false, 'Ice giant', 60190, 49244),
  ('Uranus', (SELECT star_id FROM star WHERE name='Sun'), false, false, 'Ice giant tilted', 30687, 50724),
  ('Kepler-442b', (SELECT star_id FROM star WHERE name='Vega'), false, false, 'Exoplanet', 112, 15000),
  ('Proxima b', (SELECT star_id FROM star WHERE name='Proxima Centauri'), false, false, 'Exoplanet habitable zone', 11.2, 12000),
  ('Sirius b-1', (SELECT star_id FROM star WHERE name='Sirius'), false, false, 'Rocky exoplanet', 200, 9000),
  ('Andromeda Planet 1', (SELECT star_id FROM star WHERE name='Andromeda Star 1'), false, false, 'Hypothetical', 400, 13000),
  ('Betelgeuse Planet X', (SELECT star_id FROM star WHERE name='Betelgeuse'), false, false, 'Hypothetical', 800, 20000),
  ('M87 Planet Central', (SELECT star_id FROM star WHERE name='M87 Star Central'), false, false, 'Hypothetical', 1500, 18000);

INSERT INTO moon (name, planet_id, description, diameter_km, discovery_year) VALUES
  ('Moon', (SELECT planet_id FROM planet WHERE name='Earth'), 'Earth''s natural satellite', 3474, -2700),
  ('Phobos', (SELECT planet_id FROM planet WHERE name='Mars'), 'Mars moon', 22.4, 1877),
  ('Deimos', (SELECT planet_id FROM planet WHERE name='Mars'), 'Mars moon', 12.4, 1877),
  ('Io', (SELECT planet_id FROM planet WHERE name='Jupiter'), 'Volcanic', 3643, 1610),
  ('Europa', (SELECT planet_id FROM planet WHERE name='Jupiter'), 'Icy ocean', 3121, 1610),
  ('Ganymede', (SELECT planet_id FROM planet WHERE name='Jupiter'), 'Largest moon', 5268, 1610),
  ('Callisto', (SELECT planet_id FROM planet WHERE name='Jupiter'), 'Heavily cratered', 4820, 1610),
  ('Titan', (SELECT planet_id FROM planet WHERE name='Saturn'), 'Thick atmosphere', 5150, 1655),
  ('Enceladus', (SELECT planet_id FROM planet WHERE name='Saturn'), 'Icy geyser moon', 504, 1789),
  ('Triton', (SELECT planet_id FROM planet WHERE name='Neptune'), 'Retrograde orbit', 2707, 1846),
  ('Titania', (SELECT planet_id FROM planet WHERE name='Uranus'), 'Largest Uranus moon', 1578, 1787),
  ('Oberon', (SELECT planet_id FROM planet WHERE name='Uranus'), 'Second largest Uranus moon', 1522, 1787),
  ('Charon-Moon', (SELECT planet_id FROM planet WHERE name='Kepler-442b'), 'Fictional moon', 800, 2020),
  ('Proxima Moon A', (SELECT planet_id FROM planet WHERE name='Proxima b'), 'Fictional', 600, 2021),
  ('Sirius Moon 1', (SELECT planet_id FROM planet WHERE name='Sirius b-1'), 'Fictional', 500, 2022),
  ('Andromeda Moon 1', (SELECT planet_id FROM planet WHERE name='Andromeda Planet 1'), 'Fictional', 700, 2023),
  ('Betelgeuse Moon X1', (SELECT planet_id FROM planet WHERE name='Betelgeuse Planet X'), 'Fictional', 900, 2020),
  ('M87 Moon 1', (SELECT planet_id FROM planet WHERE name='M87 Planet Central'), 'Fictional', 1000, 2021),
  ('Venus Moon Temp', (SELECT planet_id FROM planet WHERE name='Venus'), 'Hypothetical captured', 300, 2024),
  ('Mercury Moonlet', (SELECT planet_id FROM planet WHERE name='Mercury'), 'Hypothetical', 100, 2024),
  ('Europa-2', (SELECT planet_id FROM planet WHERE name='Jupiter'), 'Fictional second Europa', 3100, 2024),
  ('Titan-2', (SELECT planet_id FROM planet WHERE name='Saturn'), 'Fictional second Titan', 5100, 2024);

-- Index untuk FK (best practice, tidak wajib FCC tapi membantu)
CREATE INDEX IF NOT EXISTS idx_star_galaxy ON star(galaxy_id);
CREATE INDEX IF NOT EXISTS idx_planet_star ON planet(star_id);
CREATE INDEX IF NOT EXISTS idx_moon_planet ON moon(planet_id);

-- Verifikasi cepat (optional, komen jika tidak perlu)
-- SELECT 'galaxy' AS t, count(*) FROM galaxy UNION ALL SELECT 'star', count(*) FROM star UNION ALL SELECT 'planet', count(*) FROM planet UNION ALL SELECT 'moon', count(*) FROM moon;
