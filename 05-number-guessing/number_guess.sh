#!/bin/bash
# Number Guessing Game — number_guess.sh (FCC)
# Usage: chmod +x number_guess.sh && ./number_guess.sh
# DB: number_guess (users + games)

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
if ! psql -U freecodecamp -d number_guess -c "SELECT 1" &>/dev/null; then
  PSQL="psql --username=postgres --dbname=number_guess -t --no-align -c"
fi

# Generate secret 1-1000
SECRET=$(( RANDOM % 1000 + 1 ))
TRIES=0

echo "Enter your username:"
read USERNAME

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
USER_ID=$(echo $USER_ID | xargs)

if [[ -z $USER_ID ]]; then
  # new user
  INSERT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
  USER_ID=$(echo $USER_ID | xargs)
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID")
  GAMES_PLAYED=$(echo $GAMES_PLAYED | xargs)
  BEST_GAME=$(echo $BEST_GAME | xargs)
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

echo "Guess the secret number between 1 and 1000:"

while true; do
  read GUESS

  # must be integer
  if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi

  TRIES=$((TRIES + 1))

  if [[ $GUESS -eq $SECRET ]]; then
    break
  elif [[ $GUESS -gt $SECRET ]]; then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi
done

# save game
$($PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $TRIES)" ) > /dev/null

echo "You guessed it in $TRIES tries. The secret number was $SECRET. Nice job!"
