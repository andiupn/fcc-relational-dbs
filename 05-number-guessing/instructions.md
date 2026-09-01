# Instructions — 05 Number Guessing (Codespace Copy-Paste)

## 1) Setup DB

```bash
sudo service postgresql start
cd projects/freecodecamp-fullstack/relational/05-number-guessing
psql -U postgres < dump.sql
psql -U postgres -d number_guess -c "SELECT * FROM users; SELECT * FROM games;"
```

## 2) (Opsional) freecodecamp user

```bash
sudo -u postgres psql -c "CREATE USER freecodecamp WITH SUPERUSER;" 2>&1 || true
```

## 3) Play game

```bash
chmod +x number_guess.sh
./number_guess.sh
```

Flow FCC yang dites:

- Username baru -> `Welcome, <name>! It looks like this is your first time here.`
- Username lama -> `Welcome back, <name>! You have played <n> games, and your best game took <m> guesses.`
- `Guess the secret number between 1 and 1000:`
- Input bukan integer -> `That is not an integer, guess again:`
- Tebakan > secret -> `It's lower than that, guess again:`
- Tebakan < secret -> `It's higher than that, guess again:`
- Benar -> `You guessed it in <tries> tries. The secret number was <secret>. Nice job!` + INSERT ke games

Tip test cepat (auto-guess via brute force tidak disarankan manual; mainkan 2-3 tebakan saja untuk cek insert):

```bash
# manual 2 kali main untuk cek Welcome back
./number_guess.sh
# andi -> 500 -> 250 -> ... sampai benar
./number_guess.sh
# andi (lagi) -> harus "Welcome back"
```

## 4) One-shot verify (tanpa main)

```bash
chmod +x solution.sh
./solution.sh
psql -U postgres -d number_guess -c "SELECT u.username, count(*) AS games_played, min(g.guesses) AS best FROM users u LEFT JOIN games g USING(user_id) GROUP BY u.username, u.user_id ORDER BY u.username;"
```

## 5) Export & push

```bash
pg_dump -U postgres -d number_guess --no-owner --no-privileges -f number_guess.sql
git add dump.sql number_guess.sql number_guess.sh
git commit -m "number_guess: game ready"
git push
```

## 6) Submit FCC

Paste URL repo / token di challenge Number Guessing.
