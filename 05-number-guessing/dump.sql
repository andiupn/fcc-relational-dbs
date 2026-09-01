-- Number Guessing Game — dump.sql
-- Restore: psql -U postgres < dump.sql
-- FCC: Number Guessing Game (bash + psql)

DROP DATABASE IF EXISTS number_guess;
CREATE DATABASE number_guess;

\c number_guess

DROP TABLE IF EXISTS games, users CASCADE;

CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  username VARCHAR(22) UNIQUE NOT NULL
);

CREATE TABLE games (
  game_id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users(user_id),
  guesses INT NOT NULL
);

-- Seed contoh (FCC tidak wajib seed, tapi membantu test manual)
INSERT INTO users(username) VALUES ('testuser'), ('alice');
INSERT INTO games(user_id, guesses) VALUES
  ((SELECT user_id FROM users WHERE username='testuser'), 5),
  ((SELECT user_id FROM users WHERE username='testuser'), 8),
  ((SELECT user_id FROM users WHERE username='alice'), 3);

CREATE INDEX IF NOT EXISTS idx_games_user ON games(user_id);
