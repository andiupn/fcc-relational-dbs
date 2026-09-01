#!/bin/bash
# Number Guessing — solution.sh (setup + verify)
# Usage: chmod +x solution.sh && ./solution.sh

set -e

echo "=== Number Guessing — setup ==="
psql -U postgres -f dump.sql

echo "-> Verify"
psql -U postgres -d number_guess -c "\d users"
psql -U postgres -d number_guess -c "\d games"
psql -U postgres -d number_guess -c "SELECT 'users' AS t, count(*) FROM users UNION ALL SELECT 'games', count(*) FROM games;"
psql -U postgres -d number_guess -c "SELECT u.username, g.guesses FROM games g JOIN users u USING(user_id) ORDER BY g.game_id;"

echo "-> Test number_guess.sh syntax only (interactive skip)"
chmod +x number_guess.sh
bash -n number_guess.sh && echo "bash -n OK"

echo "-> Export"
pg_dump -U postgres -d number_guess --no-owner --no-privileges -f number_guess.sql
ls -lh number_guess.sql dump.sql number_guess.sh
echo "=== DONE — run ./number_guess.sh manually to play ==="
