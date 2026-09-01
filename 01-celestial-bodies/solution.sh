#!/bin/bash
# Celestial Bodies — solution.sh
# Menjalankan semua langkah FCC di Codespace terminal (PostgreSQL harus running)
# Usage: chmod +x solution.sh && ./solution.sh

set -e

PSQL="psql -U postgres"
DB="universe"

echo "=== Celestial Bodies — setup universe DB ==="

# 1) Pastikan PostgreSQL jalan (CodeAlly/Codespaces biasanya sudah)
# sudo service postgresql start  (uncomment jika perlu)
# sudo service postgresql status || sudo service postgresql start

# 2) Restore dump.sql (idempotent: DROP + CREATE)
echo "-> Restoring dump.sql ..."
$PSQL -f dump.sql

# 3) Verifikasi
echo "-> Verifying counts ..."
$PSQL -d $DB -c "SELECT 'galaxy' AS table_name, count(*) FROM galaxy UNION ALL SELECT 'star', count(*) FROM star UNION ALL SELECT 'planet', count(*) FROM planet UNION ALL SELECT 'moon', count(*) FROM moon ORDER BY 1;"

echo "-> Schema check (FKs) ..."
$PSQL -d $DB -c "\d galaxy"
$PSQL -d $DB -c "\d star"
$PSQL -d $DB -c "\d planet"
$PSQL -d $DB -c "\d moon"

# 4) Simpan dump terbaru untuk submit (jika FCC minta dump)
echo "-> Exporting universe.sql ..."
pg_dump -U postgres -d $DB --no-owner --no-privileges -f universe.sql
ls -lh universe.sql dump.sql

echo "=== DONE — universe DB siap. Lanjutkan submit di FCC (link repo / token) ==="
