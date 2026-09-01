# 03 — Salon Appointment Scheduler

Bash + psql interactive `salon.sh` — salon DB.

## File

- `dump.sql` — CREATE DATABASE salon + 3 tabel (customers, services, appointments) + 5 services seed
- `salon.sh` — script interaktif FCC (list services -> phone -> name jika baru -> time -> insert)
- `solution.sh` — setup + dry-run salon.sh + pg_dump
- `instructions.md` — copy-paste Codespace

## Schema

```sql
customers(customer_id SERIAL PK, phone VARCHAR UNIQUE NOT NULL, name VARCHAR NOT NULL)
services(service_id SERIAL PK, name VARCHAR UNIQUE NOT NULL)
appointments(appointment_id SERIAL PK, customer_id INT FK, service_id INT FK, time VARCHAR NOT NULL)
```

Seed services: `cut, color, perm, style, trim`.

## Cara Run di Codespace

```bash
cd 03-salon
psql -U postgres < dump.sql
chmod +x salon.sh
./salon.sh
# Ikuti prompt: pilih 1-5, masukkan phone, name (jika baru), time
```

One-shot verify:

```bash
chmod +x solution.sh && ./solution.sh
# Akan simulate: 1 + 555-9999 + Test User + 09:30
```

## PSQL User

- CodeAlly default: `freecodecamp` (script auto-fallback ke `postgres` jika user tidak ada)
- Lokal/Codespace: `postgres` — `salon.sh` sudah handle fallback otomatis.

Jika FCC test pakai `freecodecamp`:

```bash
sudo -u postgres psql -c "CREATE USER freecodecamp WITH SUPERUSER;"
sudo -u postgres psql -c "ALTER USER freecodecamp PASSWORD 'freecodecamp';"
```

## Submit

Push `salon.sql`/`dump.sql` + `salon.sh` ke repo FCC, atau pakai token Codespace.

## Troubleshooting

- `salon.sh: command not found` -> `chmod +x salon.sh`.
- `FATAL: role "freecodecamp" does not exist` -> script sudah fallback ke postgres; atau buat user freecodecamp (command di atas).
- `I could not find that service` -> input harus angka 1-5 sesuai `SELECT * FROM services`.
