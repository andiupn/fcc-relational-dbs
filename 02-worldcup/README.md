# 02 — World Cup Database

Import `games.csv` + teams ke PostgreSQL, plus `queries.sh` & `insert_data.sh`.

## File

- `dump.sql` — CREATE DATABASE worldcup + tabel teams/games + 30 rows seed (restore langsung)
- `games.csv` — 30 baris (2018 + 2014) header `year,round,winner,opponent,winner_goals,opponent_goals`
- `insert_data.sh` — script FCC (truncate + loop CSV -> insert teams/games via psql) — support arg `test` untuk DB `worldcuptest`
- `queries.sh` — 12 query FCC (SUM/AVG/MAX/COUNT/JOIN) — support arg `test`
- `solution.sh` — all-in-one (restore dump -> run insert_data.sh -> run queries.sh -> pg_dump)
- `instructions.md` — langkah Codespace

## Schema

```sql
teams(team_id SERIAL PK, name VARCHAR UNIQUE NOT NULL)
games(game_id SERIAL PK, year INT NOT NULL, round VARCHAR NOT NULL,
      winner_id INT FK->teams, opponent_id INT FK->teams,
      winner_goals INT NOT NULL, opponent_goals INT NOT NULL)
```

## Cara Run di Codespace

```bash
cd 02-worldcup
chmod +x solution.sh insert_data.sh queries.sh
./solution.sh
# atau manual:
psql -U postgres < dump.sql
./insert_data.sh
./queries.sh
```

Jika butuh DB test FCC:

```bash
createdb worldcuptest -O postgres
psql -U postgres -d worldcuptest -f dump.sql
./insert_data.sh test
./queries.sh test
```

## Submit

Push `worldcup.sql`/`dump.sql` + `insert_data.sh` + `queries.sh` ke repo terhubung FCC, atau pakai token dari Codespace setelah test pass.

## Troubleshooting

- `games.csv: No such file` -> pastikan `cd 02-worldcup` sebelum `./insert_data.sh`.
- `duplicate key` -> script sudah `TRUNCATE` dulu, jika masih error cek `games.csv` header jangan ikut di-insert (script skip `year`).
- FK error -> pastikan `teams` terisi dulu sebelum `games` (script sudah handle).
