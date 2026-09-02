-- World Cup Database — dump.sql
-- Restore: psql -U postgres < dump.sql
-- atau: psql -U postgres -d worldcup < dump.sql setelah CREATE DATABASE
-- FCC: Build a World Cup Database

DROP DATABASE IF EXISTS worldcup;
CREATE DATABASE worldcup;

\c worldcup

DROP TABLE IF EXISTS games, teams CASCADE;

CREATE TABLE teams (
  team_id SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE games (
  game_id SERIAL PRIMARY KEY,
  year INT NOT NULL,
  round VARCHAR(50) NOT NULL,
  winner_id INT NOT NULL REFERENCES teams(team_id),
  opponent_id INT NOT NULL REFERENCES teams(team_id),
  winner_goals INT NOT NULL,
  opponent_goals INT NOT NULL
);

-- Seed teams (dari games.csv)
INSERT INTO teams(name) VALUES
  ('France'),('Croatia'),('England'),('Belgium'),('Uruguay'),('Brazil'),('Russia'),('Sweden'),
  ('Argentina'),('Portugal'),('Mexico'),('Japan'),('Spain'),('Denmark'),('Switzerland'),('Colombia'),
  ('Germany'),('Netherlands'),('Costa Rica'),('Algeria'),('Nigeria'),('Chile'),('Greece'),('USA');

-- Seed games (30 rows — sama dengan games.csv, FK via subquery)
INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES
  (2018,'Final', (SELECT team_id FROM teams WHERE name='France'), (SELECT team_id FROM teams WHERE name='Croatia'), 4, 2),
  (2018,'Semi-Final', (SELECT team_id FROM teams WHERE name='Croatia'), (SELECT team_id FROM teams WHERE name='England'), 2, 1),
  (2018,'Semi-Final', (SELECT team_id FROM teams WHERE name='France'), (SELECT team_id FROM teams WHERE name='Belgium'), 1, 0),
  (2018,'Quarter-Final', (SELECT team_id FROM teams WHERE name='France'), (SELECT team_id FROM teams WHERE name='Uruguay'), 2, 0),
  (2018,'Quarter-Final', (SELECT team_id FROM teams WHERE name='Belgium'), (SELECT team_id FROM teams WHERE name='Brazil'), 2, 1),
  (2018,'Quarter-Final', (SELECT team_id FROM teams WHERE name='Croatia'), (SELECT team_id FROM teams WHERE name='Russia'), 4, 3),
  (2018,'Quarter-Final', (SELECT team_id FROM teams WHERE name='England'), (SELECT team_id FROM teams WHERE name='Sweden'), 2, 0),
  (2018,'Eighth-Final', (SELECT team_id FROM teams WHERE name='France'), (SELECT team_id FROM teams WHERE name='Argentina'), 4, 3),
  (2018,'Eighth-Final', (SELECT team_id FROM teams WHERE name='Uruguay'), (SELECT team_id FROM teams WHERE name='Portugal'), 2, 1),
  (2018,'Eighth-Final', (SELECT team_id FROM teams WHERE name='Brazil'), (SELECT team_id FROM teams WHERE name='Mexico'), 2, 0),
  (2018,'Eighth-Final', (SELECT team_id FROM teams WHERE name='Belgium'), (SELECT team_id FROM teams WHERE name='Japan'), 3, 2),
  (2018,'Eighth-Final', (SELECT team_id FROM teams WHERE name='Russia'), (SELECT team_id FROM teams WHERE name='Spain'), 5, 4),
  (2018,'Eighth-Final', (SELECT team_id FROM teams WHERE name='Croatia'), (SELECT team_id FROM teams WHERE name='Denmark'), 3, 2),
  (2018,'Eighth-Final', (SELECT team_id FROM teams WHERE name='Sweden'), (SELECT team_id FROM teams WHERE name='Switzerland'), 1, 0),
  (2018,'Eighth-Final', (SELECT team_id FROM teams WHERE name='England'), (SELECT team_id FROM teams WHERE name='Colombia'), 5, 4),
  (2014,'Final', (SELECT team_id FROM teams WHERE name='Germany'), (SELECT team_id FROM teams WHERE name='Argentina'), 1, 0),
  (2014,'Semi-Final', (SELECT team_id FROM teams WHERE name='Germany'), (SELECT team_id FROM teams WHERE name='Brazil'), 7, 1),
  (2014,'Semi-Final', (SELECT team_id FROM teams WHERE name='Argentina'), (SELECT team_id FROM teams WHERE name='Netherlands'), 4, 2),
  (2014,'Quarter-Final', (SELECT team_id FROM teams WHERE name='Germany'), (SELECT team_id FROM teams WHERE name='France'), 1, 0),
  (2014,'Quarter-Final', (SELECT team_id FROM teams WHERE name='Brazil'), (SELECT team_id FROM teams WHERE name='Colombia'), 2, 1),
  (2014,'Quarter-Final', (SELECT team_id FROM teams WHERE name='Argentina'), (SELECT team_id FROM teams WHERE name='Belgium'), 1, 0),
  (2014,'Quarter-Final', (SELECT team_id FROM teams WHERE name='Netherlands'), (SELECT team_id FROM teams WHERE name='Costa Rica'), 4, 3),
  (2014,'Eighth-Final', (SELECT team_id FROM teams WHERE name='Germany'), (SELECT team_id FROM teams WHERE name='Algeria'), 2, 1),
  (2014,'Eighth-Final', (SELECT team_id FROM teams WHERE name='France'), (SELECT team_id FROM teams WHERE name='Nigeria'), 2, 0),
  (2014,'Eighth-Final', (SELECT team_id FROM teams WHERE name='Brazil'), (SELECT team_id FROM teams WHERE name='Chile'), 3, 2),
  (2014,'Eighth-Final', (SELECT team_id FROM teams WHERE name='Colombia'), (SELECT team_id FROM teams WHERE name='Uruguay'), 2, 0),
  (2014,'Eighth-Final', (SELECT team_id FROM teams WHERE name='Netherlands'), (SELECT team_id FROM teams WHERE name='Mexico'), 2, 1),
  (2014,'Eighth-Final', (SELECT team_id FROM teams WHERE name='Costa Rica'), (SELECT team_id FROM teams WHERE name='Greece'), 5, 3),
  (2014,'Eighth-Final', (SELECT team_id FROM teams WHERE name='Argentina'), (SELECT team_id FROM teams WHERE name='Switzerland'), 1, 0),
  (2014,'Eighth-Final', (SELECT team_id FROM teams WHERE name='Belgium'), (SELECT team_id FROM teams WHERE name='USA'), 2, 1);

CREATE INDEX IF NOT EXISTS idx_games_winner ON games(winner_id);
CREATE INDEX IF NOT EXISTS idx_games_opponent ON games(opponent_id);
