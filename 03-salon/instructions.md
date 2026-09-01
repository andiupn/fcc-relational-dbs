# Instructions — 03 Salon (Codespace Copy-Paste)

## 1) Setup DB

```bash
sudo service postgresql start
cd projects/freecodecamp-fullstack/relational/03-salon
psql -U postgres < dump.sql
psql -U postgres -d salon -c "SELECT service_id, name FROM services ORDER BY service_id;"
```

## 2) (Opsional) Buat user freecodecamp jika FCC test pakai itu

```bash
sudo -u postgres psql -c "CREATE USER freecodecamp WITH SUPERUSER;" 2>&1 || echo "user exists or cannot create"
sudo -u postgres psql -c "ALTER USER freecodecamp PASSWORD 'freecodecamp';"
psql -U freecodecamp -d salon -c "SELECT 1" && echo "freecodecamp OK" || echo "will fallback to postgres"
```

## 3) Jalankan salon.sh interaktif

```bash
chmod +x salon.sh
./salon.sh
```

Contoh interaksi (ketik sesuai prompt):

```
1              -> pilih cut
555-1234       -> phone (baru)
Andi           -> name
10:30          -> time
# Output: I have put you down for a cut at 10:30, Andi.
```

Test case kedua (customer existing):

```bash
./salon.sh
# 2
# 555-1234  (sudah ada, tidak tanya name lagi)
# 11:00
```

## 4) One-shot auto test (tanpa interaksi manual)

```bash
chmod +x solution.sh
./solution.sh
# atau simulate manual:
printf "1\n555-9999\nTest User\n09:30\n" | ./salon.sh
psql -U postgres -d salon -c "SELECT c.name, c.phone, s.name, a.time FROM appointments a JOIN customers c USING(customer_id) JOIN services s USING(service_id) ORDER BY appointment_id DESC LIMIT 5;"
```

## 5) Verifikasi FCC checks

```bash
psql -U postgres -d salon -c "\d customers"   # phone UNIQUE, customer_id PK
psql -U postgres -d salon -c "\d services"    # service_id PK, name UNIQUE
psql -U postgres -d salon -c "\d appointments" # FKs + time
psql -U postgres -d salon -c "SELECT count(*) FROM services;"  # >=5
```

## 6) Export & push

```bash
pg_dump -U postgres -d salon --no-owner --no-privileges -f salon.sql
git add dump.sql salon.sql salon.sh
git commit -m "salon: scheduler ready"
git push
```

## 7) Submit FCC

- Paste URL repo / token di FCC Salon challenge.
