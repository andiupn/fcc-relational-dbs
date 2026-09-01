#!/bin/bash
# World Cup — solution.sh (all-in-one untuk Codespace)
# Usage: chmod +x solution.sh && ./solution.sh

set -e
PSQL="psql -U postgres"

echo "=== World Cup — setup worldcup DB ==="
echo "-> Restoring dump.sql ..."
$PSQL -f dump.sql

echo "-> Alternative: test insert_data.sh (truncate + re-import dari games.csv) ..."
chmod +x insert_data.sh
./insert_data.sh

echo "-> Running queries.sh ..."
chmod +x queries.sh
./queries.sh

echo "-> Export dump ..."
pg_dump -U postgres -d worldcup --no-owner --no-privileges -f worldcup.sql
ls -lh worldcup.sql dump.sql games.csv

echo "=== DONE ==="
