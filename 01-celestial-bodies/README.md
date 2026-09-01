# 01 — Celestial Bodies Database

Build a Celestial Bodies Database (`universe`) — psql + bash.

## Struktur Folder

- `dump.sql` — schema + seed (galaxy/star/planet/moon + FK) siap `psql -U postgres < dump.sql`
- `solution.sh` — script all-in-one (restore + verifikasi + pg_dump)
- `instructions.md` — copy-paste command untuk Codespace
- `universe.sql` — hasil `pg_dump` (ter-generate setelah run, untuk submit jika diminta)

## Schema

- `galaxy(galaxy_id SERIAL PK, name UNIQUE NOT NULL, ...)`
- `star(star_id SERIAL PK, name UNIQUE NOT NULL, galaxy_id INT FK -> galaxy)`
- `planet(planet_id SERIAL PK, name UNIQUE NOT NULL, star_id INT FK -> star)`
- `moon(moon_id SERIAL PK, name UNIQUE NOT NULL, planet_id INT FK -> planet)`

Seed: 8 galaxies, 12 stars, 14 planets, 22 moons (melewati minimum FCC).

## Cara Run di GitHub Codespaces (CodeAlly)

> FCC: buka project -> "Start the project" -> akan buka VS Code di browser (Codespace). Kerjakan di terminal bawah.

**Opsi A — one-shot via solution.sh (direkomendasikan):**

```bash
cd 01-celestial-bodies
chmod +x solution.sh
./solution.sh
```

**Opsi B — manual psql:**

```bash
psql -U postgres < dump.sql
psql -U postgres -d universe -c "SELECT 'galaxy', count(*) FROM galaxy UNION ALL SELECT 'star', count(*) FROM star UNION ALL SELECT 'planet', count(*) FROM planet UNION ALL SELECT 'moon', count(*) FROM moon;"
```

Jika PostgreSQL belum jalan:

```bash
sudo service postgresql start
```

## Submit ke FCC

- Push `universe.sql`/`dump.sql` ke repo GitHub yang terhubung ke FCC (CodeAlly auto-push), atau copy token yang muncul setelah test pass di Codespace.
- Di FCC challenge -> paste Solution Link (URL repo atau token) -> Run Tests.

## Troubleshooting

- `FATAL: database "universe" does not exist` -> jalankan `psql -U postgres < dump.sql` lagi (script DROP+CREATE).
- `\c universe` failed -> pastikan `CREATE DATABASE universe` sukses, user `postgres` punya hak.
- Test FCC cek UNIQUE/NOT NULL/FK: jangan hapus constraint di dump.sql.

## Referensi FCC

- Build a Celestial Bodies Database — Relational Database (Beta) certification.
