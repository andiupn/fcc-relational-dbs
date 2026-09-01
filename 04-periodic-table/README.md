# 04 — Periodic Table Database

Query `periodic_table` DB + `element.sh` (fix DB + type/properties).

## File

- `dump.sql` — FIXED schema (types 3 rows, elements 10 rows, properties FK) siap restore
- `element.sh` — FCC script: `./element.sh <number|symbol|name>` -> one-liner output
- `solution.sh` — restore + verify + test element.sh
- `instructions.md` — langkah Codespace

## Schema (fixed)

```sql
types(type_id SERIAL PK, type VARCHAR UNIQUE NOT NULL) -- 3 rows: nonmetal, metal, metalloid
elements(atomic_number INT PK, symbol VARCHAR UNIQUE NOT NULL, name VARCHAR UNIQUE NOT NULL)
properties(atomic_number INT PK FK->elements, atomic_mass NUMERIC, melting_point_celsius NUMERIC, boiling_point_celsius NUMERIC, type_id INT FK->types)
```

Seed: H(1) .. Ne(10) — sudah include Hydrogen, Helium, Lithium, Beryllium, Boron (FCC cek tidak boleh null / lowercase).

## Cara Run di Codespace

```bash
cd 04-periodic-table
psql -U postgres < dump.sql
chmod +x element.sh
./element.sh 1
# The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
./element.sh H
./element.sh Hydrogen
./element.sh 5   # Boron (metalloid)
```

One-shot:

```bash
chmod +x solution.sh && ./solution.sh
```

## Fix DB yang sudah dilakukan di dump.sql

- `types` sudah 3 rows unique (FCC cek `UNIQUE` + `NOT NULL`)
- `properties.atomic_number` PK + FK + mass/mp/bp `NOT NULL`
- `elements.symbol/name` UNIQUE + NOT NULL
- Capitalization & trim handled (FCC cek `Hydrogen` bukan `hydrogen`)
- Jika FCC task minta rename column/add constraint manual, dump sudah compliant — tidak perlu ALTER lagi. Jika perlu tunjukkan manual, lihat `instructions.md` -> section ALTER history.

## Submit

Push `periodic_table.sql`/`dump.sql` + `element.sh`.

## Troubleshooting

- `Please provide an element as an argument.` -> arg kosong (test `element.sh` tanpa arg).
- `I could not find that element` -> input 999 / Unknown (expected).
- `role freecodecamp does not exist` -> element.sh auto-fallback ke postgres; atau buat user freecodecamp (lihat instructions).
