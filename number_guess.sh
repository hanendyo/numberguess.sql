#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guessing --no-align --tuples-only -c"

echo "Enter your username:"
read USERNAME

USERNAME_RESULT=$($PSQL "SELECT username FROM player WHERE LOWER(username)=LOWER('$USERNAME')")
GAME_PLAYED_RESULT=$($PSQL "SELECT game_played FROM player WHERE LOWER(username)=LOWER('$USERNAME')")
BEST_GAME_RESULT=$($PSQL "SELECT best_game FROM player WHERE LOWER(username)=LOWER('$USERNAME')")
GAME_RESULT=$($PSQL "SELECT game_played, best_game FROM player WHERE LOWER(username)=LOWER('$USERNAME')")
PLAYER_ID=$($PSQL "SELECT player_id FROM player WHERE LOWER(username)=LOWER('$USERNAME')")
RANDOM_NUMBER=$(( RANDOM % 900 + 100))

if [[ -z $USERNAME_RESULT ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_USERNAME=$($PSQL "INSERT INTO player(username) VALUES('$USERNAME')")
else
  echo $GAME_RESULT | while IFS=' | ' read GAME_PLAYED BEST_GAME
  do
    echo "Welcome back, $USERNAME_RESULT! You have played $GAME_PLAYED_RESULT games, and your best game took $BEST_GAME_RESULT guesses."
  done
fi
