#!/bin/bash
# Periodic Table — solution.sh (fix DB + test element.sh)
# Usage: chmod +x solution.sh && ./solution.sh

set -e

echo "=== Periodic Table — setup ==="
psql -U postgres -f dump.sql

echo "-> Verify schema"
psql -U postgres -d periodic_table -c "\d elements"
psql -U postgres -d periodic_table -c "\d properties"
psql -U postgres -d periodic_table -c "\d types"
psql -U postgres -d periodic_table -c "SELECT * FROM types ORDER BY type_id;"
psql -U postgres -d periodic_table -c "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, t.type FROM elements e JOIN properties p USING(atomic_number) JOIN types t USING(type_id) ORDER BY e.atomic_number LIMIT 5;"

echo "-> Test element.sh"
chmod +x element.sh
./element.sh 1
./element.sh H
./element.sh Hydrogen
./element.sh 5
./element.sh B
./element.sh Boron
./element.sh 999 || true
./element.sh Unknown || true
./element.sh || true

# Empty arg test
echo "-> (no arg) should say Please provide..."
./element.sh

echo "-> Export"
pg_dump -U postgres -d periodic_table --no-owner --no-privileges -f periodic_table.sql
ls -lh periodic_table.sql dump.sql element.sh
echo "=== DONE ==="
