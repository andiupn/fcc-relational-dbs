# Instructions — 04 Periodic Table (Codespace Copy-Paste)

## 1) Restore FIXED dump

```bash
sudo service postgresql start
cd projects/freecodecamp-fullstack/relational/04-periodic-table
psql -U postgres < dump.sql
psql -U postgres -d periodic_table -c "SELECT * FROM types; SELECT atomic_number, symbol, name FROM elements ORDER BY atomic_number; SELECT atomic_number, atomic_mass, type_id FROM properties ORDER BY atomic_number LIMIT 5;"
```

## 2) Jika FCC test pakai user freecodecamp

```bash
sudo -u postgres psql -c "CREATE USER freecodecamp WITH SUPERUSER;" 2>&1 || true
psql -U postgres -d periodic_table -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO freecodecamp;"
psql -U postgres -d periodic_table -c "GRANT USAGE, SELECT ON SEQUENCE types_type_id_seq TO freecodecamp;"
```

## 3) Test element.sh

```bash
chmod +x element.sh
./element.sh 1
./element.sh He
./element.sh Lithium
./element.sh 6
./element.sh C
./element.sh Carbon
# Harus keluar format FCC:
# The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.

# Edge:
./element.sh
# Please provide an element as an argument.
./element.sh 999
# I could not find that element in the database.
./element.sh FooBar
# I could not find that element in the database.
```

## 4) One-shot (solution.sh)

```bash
chmod +x solution.sh
./solution.sh
```

## 5) Jika ingin tunjukkan riwayat fix manual (untuk FCC step yang minta ALTER)

Dump sudah fixed, tapi jika reviewer minta lihat command fix, ini history yang di-apply di dump:

```sql
-- add column type, rename, constraints (sudah di dump, contoh manual):
ALTER TABLE properties ADD COLUMN IF NOT EXISTS type_id INT REFERENCES types(type_id);
UPDATE properties SET type_id = (SELECT type_id FROM types WHERE type='nonmetal') WHERE atomic_number IN (1,2,6,7,8,9,10);
-- etc. Cek dump.sql untuk seed lengkap.
```

## 6) Export & push

```bash
pg_dump -U postgres -d periodic_table --no-owner --no-privileges -f periodic_table.sql
git add dump.sql periodic_table.sql element.sh
git commit -m "periodic_table: fixed schema + element.sh ready"
git push
```

## 7) Submit FCC

Paste URL repo / token di challenge Periodic Table.
