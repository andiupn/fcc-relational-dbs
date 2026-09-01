# STATUS — Relational Databases V8 (5 Projects)

Generated: 2026-08-31 | Root: `projects/freecodecamp-fullstack/relational/`

## Ringkas

5 folder, tiap folder punya `dump.sql` + `.sh` + `README.md` + `instructions.md` — siap restore di GitHub Codespaces via `psql -U postgres < dump.sql`. Semua `.sh` sudah `#!/bin/bash` dan lolos `bash -n` + `chmod +x`.

```
relational/
├── 01-celestial-bodies/  (universe: galaxy/star/planet/moon + FK, 8/12/14/22 rows)
│   ├── dump.sql
│   ├── solution.sh
│   ├── README.md
│   └── instructions.md
├── 02-worldcup/          (worldcup: teams/games + games.csv + insert_data.sh + queries.sh)
│   ├── dump.sql
│   ├── games.csv          (30 rows)
│   ├── insert_data.sh
│   ├── queries.sh         (12 queries FCC)
│   ├── solution.sh
│   ├── README.md
│   └── instructions.md
├── 03-salon/             (salon: customers/services/appointments + salon.sh interaktif)
│   ├── dump.sql
│   ├── salon.sh
│   ├── solution.sh
│   ├── README.md
│   └── instructions.md
├── 04-periodic-table/    (periodic_table: types/elements/properties + element.sh)
│   ├── dump.sql           (FIXED: 3 types, 10 elements H-Ne)
│   ├── element.sh
│   ├── solution.sh
│   ├── README.md
│   └── instructions.md
├── 05-number-guessing/   (number_guess: users/games + number_guess.sh)
│   ├── dump.sql
│   ├── number_guess.sh
│   ├── solution.sh
│   ├── README.md
│   └── instructions.md
├── README.md
└── STATUS.md (file ini)
```

Validasi: `bash -n` 10/10 OK, `chmod +x` done.

## Langkah Codespaces per Project (copy-paste)

> Syarat: Akun GitHub + 60 jam free Codespaces/bulan. Buka FCC challenge -> "Start the project" -> VS Code browser terbuka.

### Prasyarat umum (sekali per Codespace)

```bash
sudo service postgresql start
psql -U postgres -c "SELECT version();"
sudo -u postgres psql -c "CREATE USER freecodecamp WITH SUPERUSER;" 2>&1 || echo "exists"
```

### 01 Celestial Bodies (`universe`)

```bash
cd projects/freecodecamp-fullstack/relational/01-celestial-bodies
chmod +x solution.sh && ./solution.sh
# atau manual: psql -U postgres < dump.sql
psql -U postgres -d universe -c "SELECT 'galaxy',count(*) FROM galaxy UNION ALL SELECT 'star',count(*) FROM star UNION ALL SELECT 'planet',count(*) FROM planet UNION ALL SELECT 'moon',count(*) FROM moon;"
pg_dump -U postgres -d universe --no-owner --no-privileges -f universe.sql
git add dump.sql universe.sql && git commit -m "celestial: done" && git push
# Submit: paste URL repo / token di FCC -> Run Tests
```

### 02 World Cup (`worldcup`)

```bash
cd projects/freecodecamp-fullstack/relational/02-worldcup
chmod +x solution.sh insert_data.sh queries.sh && ./solution.sh
# manual alternative:
psql -U postgres < dump.sql
./insert_data.sh        # TRUNCATE + re-import games.csv
./queries.sh            # 12 outputs FCC
# jika FCC pakai worldcuptest:
psql -U postgres -c "DROP DATABASE IF EXISTS worldcuptest; CREATE DATABASE worldcuptest;"
psql -U postgres -d worldcuptest -f dump.sql
./insert_data.sh test && ./queries.sh test
pg_dump -U postgres -d worldcup --no-owner --no-privileges -f worldcup.sql
git add dump.sql worldcup.sql games.csv insert_data.sh queries.sh && git commit -m "worldcup: done" && git push
```

### 03 Salon (`salon`)

```bash
cd projects/freecodecamp-fullstack/relational/03-salon
psql -U postgres < dump.sql
chmod +x salon.sh && ./salon.sh
# contoh input: 1 -> 555-1234 -> Andi -> 10:30
# test existing: ./salon.sh -> 2 -> 555-1234 -> 11:00 (tidak tanya name)
# verify: psql -U postgres -d salon -c "SELECT c.name, s.name, a.time FROM appointments a JOIN customers c USING(customer_id) JOIN services s USING(service_id) ORDER BY a.appointment_id DESC LIMIT 3;"
pg_dump -U postgres -d salon --no-owner --no-privileges -f salon.sql
git add dump.sql salon.sql salon.sh && git commit -m "salon: done" && git push
```

### 04 Periodic Table (`periodic_table`)

```bash
cd projects/freecodecamp-fullstack/relational/04-periodic-table
psql -U postgres < dump.sql
chmod +x element.sh && ./element.sh 1 && ./element.sh H && ./element.sh Hydrogen && ./element.sh 5
# edge: ./element.sh (no arg) -> Please provide... | ./element.sh 999 -> I could not find...
./element.sh B && ./element.sh Boron
psql -U postgres -d periodic_table -c "SELECT * FROM types;"
chmod +x solution.sh && ./solution.sh
pg_dump -U postgres -d periodic_table --no-owner --no-privileges -f periodic_table.sql
git add dump.sql periodic_table.sql element.sh && git commit -m "periodic_table: done" && git push
```

### 05 Number Guessing (`number_guess`)

```bash
cd projects/freecodecamp-fullstack/relational/05-number-guessing
psql -U postgres < dump.sql
chmod +x number_guess.sh && ./number_guess.sh
# Enter your username: andi -> Welcome first time -> Guess 500 -> ... -> You guessed it...
# second run same username -> Welcome back...
chmod +x solution.sh && ./solution.sh
pg_dump -U postgres -d number_guess --no-owner --no-privileges -f number_guess.sql
git add dump.sql number_guess.sql number_guess.sh && git commit -m "number_guess: done" && git push
```

## Catatan Penting

- Jangan tulis di luar `projects/freecodecamp-fullstack/relational/` (disjoint — sudah dipatuhi).
- Semua dump bisa di-restore via `psql -U postgres < dump.sql` (DROP+CREATE) atau `createdb <db> && psql -U postgres -d <db> -f dump.sql`.
- Jika `psql -U freecodecamp` gagal, semua `.sh` auto-fallback ke `postgres` (CodeAlly vs Codespaces).
- Submit FCC: tiap project butuh trigger test di Codespace; setelah pass, FCC generate token/URL repo -> paste di freecodecamp.org challenge.
- Jika test FCC cek row count / constraint: dump sudah >= minimum (celestial 22 moons, worldcup 30 games, salon 5 services, periodic 10 elements, number_guess 2 users).
