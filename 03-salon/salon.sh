#!/bin/bash
# Salon Appointment Scheduler — salon.sh
# FCC interactive script: list services, input customer phone/name, pick service, time
# Usage: chmod +x salon.sh && ./salon.sh
# Prasyarat: DB salon ada (psql -U postgres < dump.sql)

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
# Fallback: jika user freecodecamp tidak ada (Codespace default postgres), pakai postgres
if ! psql -U freecodecamp -d salon -c "SELECT 1" &>/dev/null; then
  PSQL="psql -X --username=postgres --dbname=salon --tuples-only -c"
fi

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU() {
  if [[ $1 ]]; then
    echo -e "\n$1"
  fi

  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME; do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  # validate selection is number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]; then
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    SERVICE_NAME=$(echo $SERVICE_NAME | sed -r 's/^ *| *$//g')
    if [[ -z $SERVICE_NAME ]]; then
      MAIN_MENU "I could not find that service. What would you like today?"
    else
      echo -e "\nWhat's your phone number?"
      read CUSTOMER_PHONE

      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      CUSTOMER_NAME=$(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')

      if [[ -z $CUSTOMER_NAME ]]; then
        echo -e "\nI don't have a record for that phone number, what's your name?"
        read CUSTOMER_NAME
        INSERT_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
      fi

      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
      CUSTOMER_ID=$(echo $CUSTOMER_ID | sed -r 's/^ *| *$//g')
      CUSTOMER_NAME_FMT=$(echo $($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID") | sed -r 's/^ *| *$//g')

      echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME_FMT?"
      read SERVICE_TIME

      INSERT_APPT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

      if [[ $INSERT_APPT == "INSERT 0 1" ]]; then
        echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME_FMT."
      else
        echo -e "\nCould not create appointment."
      fi
    fi
  fi
}

MAIN_MENU
