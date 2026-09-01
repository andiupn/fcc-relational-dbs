# Instructions — 02 World Cup (Codespace Copy-Paste)

## 1) Buka Codespace & cek Postgres

```bash
sudo service postgresql start
psql -U postgres -c "SELECT version();"
cd projects/freecodecamp-fullstack/relational/02-worldcup
ls -lh dump.sql games.csv insert_data.sh queries.sh
```

## 2) One-shot (recommended)

```bash
chmod +x solution.sh insert_data.sh queries.sh
./solution.sh
# Output harus: teams ~24, games 30, lalu 12 query results
```

## 3) Manual (jika FCC minta step-by-step)

```bash
# a) Restore struktur + seed awal
psql -U postgres < dump.sql

# b) Test insert_data.sh (akan TRUNCATE lalu re-import dari CSV)
chmod +x insert_data.sh
./insert_data.sh
# Cek:
psql -U postgres -d worldcup -c "SELECT count(*) FROM teams; SELECT count(*) FROM games;"

# c) Test queries.sh
chmod +x queries.sh
./queries.sh
# Harus keluar angka tanpa error
```

## 4) Jika FCC pakai DB worldcuptest

FCC test suite kadang pakai DB `worldcuptest`:

```bash
psql -U postgres -c "DROP DATABASE IF EXISTS worldcuptest; CREATE DATABASE worldcuptest;"
psql -U postgres -d worldcuptest -f dump.sql
./insert_data.sh test
./queries.sh test
```

## 5) Export & push

```bash
pg_dump -U postgres -d worldcup --no-owner --no-privileges -f worldcup.sql
git add dump.sql worldcup.sql games.csv insert_data.sh queries.sh
git commit -m "worldcup: import csv + queries ready"
git push
```

## 6) Submit FCC

- Buka freecodecamp.org -> World Cup challenge -> paste Solution Link (URL repo / token) -> Run Tests.

## Troubleshooting

- `psql: FATAL: database "worldcup" does not exist` -> `psql -U postgres < dump.sql` (DROP+CREATE).
- `insert_data.sh: permission denied` -> `chmod +x insert_data.sh`.
- Query output kosong -> cek `games.csv` tidak korup: `head -n 5 games.csv ; wc -l games.csv` (harus 31 baris dengan header).
