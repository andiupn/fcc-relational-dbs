#!/bin/bash
# Periodic Table — element.sh
# Usage: ./element.sh <atomic_number | symbol | name>
# Contoh: ./element.sh 1 | ./element.sh H | ./element.sh Hydrogen
# Output FCC format: "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if ! psql -U freecodecamp -d periodic_table -c "SELECT 1" &>/dev/null; then
  PSQL="psql --username=postgres --dbname=periodic_table -t --no-align -c"
fi

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

INPUT=$1

# Determine query type: number vs string
if [[ $INPUT =~ ^[0-9]+$ ]]; then
  WHERE="e.atomic_number = $INPUT"
else
  WHERE="e.symbol = '$INPUT' OR e.name = '$INPUT'"
fi

RESULT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type FROM elements e JOIN properties p USING(atomic_number) JOIN types t USING(type_id) WHERE $WHERE")

if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

echo "$RESULT" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME MASS MELTING BOILING TYPE; do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
done
