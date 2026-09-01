# FCC Relational Databases V8 - 5 Dumps Aman

Repo ini hanya berisi dump.sql + solution.sh + instructions.md untuk 5 labs. Tanpa secret.

- 01-celestial-bodies (universe)
- 02-worldcup (worldcup)
- 03-salon (salon)
- 04-periodic-table (periodic_table)
- 05-number-guessing (number_guess)

Cara pakai di Codespace: curl -o dump.sql https://raw.githubusercontent.com/andiupn/fcc-relational-dbs/main/01-celestial-bodies/dump.sql && psql -U postgres < dump.sql

Test lokal: psql -U postgres -c "SELECT version();"
