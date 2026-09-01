# Instructions — 01 Celestial Bodies (Codespace Copy-Paste)

> Buka Codespace via FCC -> "Start the project" (VS Code browser). Paste block di bawah satu per satu di terminal Codespace.

## 1) Start PostgreSQL (jika belum jalan)

```bash
sudo service postgresql start
psql -U postgres -c "SELECT version();"
```

## 2) Clone / buka folder (jika repo belum di Codespace)

Jika Codespace sudah berisi repo ini:

```bash
cd projects/freecodecamp-fullstack/relational/01-celestial-bodies
ls -lh dump.sql solution.sh
```

Jika belum clone:

```bash
git clone https://github.com/<username>/opencode.ai.git
cd opencode.ai/projects/freecodecamp-fullstack/relational/01-celestial-bodies
```

## 3) Restore DB (pilih salah satu)

**Cepat (solution.sh):**

```bash
chmod +x solution.sh
./solution.sh
```

**Manual:**

```bash
psql -U postgres < dump.sql
psql -U postgres -d universe -c "SELECT 'galaxy' AS t, count(*) FROM galaxy UNION ALL SELECT 'star', count(*) FROM star UNION ALL SELECT 'planet', count(*) FROM planet UNION ALL SELECT 'moon', count(*) FROM moon;"
```

## 4) Verifikasi FCC constraints

```bash
psql -U postgres -d universe -c "\d galaxy"
psql -U postgres -d universe -c "\d star"
psql -U postgres -d universe -c "\d planet"
psql -U postgres -d universe -c "\d moon"
# Pastikan: PRIMARY KEY, UNIQUE, NOT NULL, FOREIGN KEY terlihat
```

## 5) Export untuk submit (jika FCC minta file sql)

```bash
pg_dump -U postgres -d universe --no-owner --no-privileges -f universe.sql
ls -lh universe.sql
cat universe.sql | head -n 50
```

## 6) Git push (CodeAlly auto-detect)

```bash
git status
git add dump.sql universe.sql solution.sh
git commit -m "celestial: universe DB ready"
git push
```

## 7) Submit di FCC

- Kembali ke freecodecamp.org -> challenge Celestial -> paste URL repo (atau token dari terminal jika muncul) -> Run Tests -> Complete.

## Catatan

- Jika test gagal karena row count: jangan kurangi seed di dump.sql (sudah >= minimum).
- Jika `\c universe` error: cek `psql -U postgres -l` pastikan universe ada.
