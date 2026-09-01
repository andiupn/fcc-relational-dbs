#!/bin/bash
# Salon — solution.sh (setup + verify)
# Usage: chmod +x solution.sh && ./solution.sh

set -e
PSQL="psql -U postgres"

echo "=== Salon — setup ==="
psql -U postgres -f dump.sql

echo "-> Verify tables & seed"
psql -U postgres -d salon -c "SELECT 'services' AS t, count(*) FROM services UNION ALL SELECT 'customers', count(*) FROM customers UNION ALL SELECT 'appointments', count(*) FROM appointments;"

psql -U postgres -d salon -c "SELECT service_id, name FROM services ORDER BY service_id;"
psql -U postgres -d salon -c "\d customers"
psql -U postgres -d salon -c "\d appointments"

# Test salon.sh non-interaktif (simulate input)
echo "-> Dry-run salon.sh (simulate) ..."
chmod +x salon.sh
printf "1\n555-9999\nTest User\n09:30\n" | ./salon.sh || true
echo "-> After dry-run check:"
psql -U postgres -d salon -c "SELECT c.name, c.phone, s.name AS service, a.time FROM appointments a JOIN customers c ON a.customer_id=c.customer_id JOIN services s ON a.service_id=s.service_id ORDER BY appointment_id DESC LIMIT 3;"

# Export
pg_dump -U postgres -d salon --no-owner --no-privileges -f salon.sql
ls -lh salon.sql dump.sql salon.sh
echo "=== DONE ==="
