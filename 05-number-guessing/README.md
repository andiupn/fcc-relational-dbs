# 05 — Number Guessing Game

Bash game loop + psql `number_guess` DB.

## File

- `dump.sql` — CREATE DATABASE number_guess + users/games + seed
- `number_guess.sh` — FCC game (random 1-1000, hint higher/lower, count, insert)
- `solution.sh` — restore + verify + bash -n
- `instructions.md` — langkah Codespace

## Schema

```sql
users(user_id SERIAL PK, username VARCHAR(22) UNIQUE NOT NULL)
games(game_id SERIAL PK, user_id INT FK -> users, guesses INT NOT NULL)
```

## Cara Run di Codespace

```bash
cd 05-number-guessing
psql -U postgres < dump.sql
chmod +x number_guess.sh
./number_guess.sh
# Enter your username: andi
# Welcome, andi! It looks like this is your first time here.
# Guess the secret number between 1 and 1000:
# 500 -> It's lower/higher ...
# You guessed it in X tries. The secret number was Y. Nice job!
# Second run same username -> Welcome back, andi! You have played N games, and your best game took M guesses.
```

One-shot verify:

```bash
chmod +x solution.sh && ./solution.sh
```

## Submit

Push `number_guess.sql`/`dump.sql` + `number_guess.sh`.

## Troubleshooting

- `role freecodecamp does not exist` -> number_guess.sh auto-fallback ke postgres.
- `That is not an integer, guess again:` -> input harus integer 1-1000.
- `psql: FATAL: database "number_guess" does not exist` -> `psql -U postgres < dump.sql`.
