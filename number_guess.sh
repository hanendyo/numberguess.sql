#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess --no-align --tuples-only -c"

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

# echo $RANDOM_NUMBER

typeset -i GAME_PLAYED_UPDATE=$GAME_PLAYED_RESULT
typeset -i BEST_GAME_UPDATE=0

echo "Guess the secret number between 1 and 1000:"

while [[ $GUESS != $RANDOM_NUMBER  ]]
do  
  BEST_GAME_UPDATE=BEST_GAME_UPDATE+1
  read GUESS
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  elif [[ $GUESS < $RANDOM_NUMBER ]]; 
  then
    echo "It's lower than that, guess again:"
  elif [[ $GUESS > $RANDOM_NUMBER ]]; 
  then
    echo "It's higher than that, guess again:"
  elif [[ $GUESS = $RANDOM_NUMBER ]]; 
  then
    GAME_PLAYED_UPDATE=GAME_PLAYED_UPDATE+1

    if [[ -z $BEST_GAME_RESULT ]]
    then
      BEST_GAME_RESULT=$BEST_GAME_UPDATE
    fi
    if [[ -z $GAME_PLAYED_RESULT ]]
    then
      GAME_PLAYED_RESULT=$GAME_PLAYED_UPDATE
    fi
    if [[ $BEST_GAME_UPDATE < $BEST_GAME_RESULT ]]
      then
        INSERT_GAME_RESULT=$($PSQL "UPDATE player SET game_played = $GAME_PLAYED_UPDATE, best_game = $BEST_GAME_UPDATE WHERE LOWER(username)=LOWER('$USERNAME')")
      elif [[ $BEST_GAME_UPDATE > $BEST_GAME_RESULT ]]
      then
        INSERT_GAME_RESULT=$($PSQL "UPDATE player SET game_played = $GAME_PLAYED_UPDATE, best_game = $BEST_GAME_RESULT WHERE LOWER(username)=LOWER('$USERNAME')")
      else
        INSERT_GAME_RESULT=$($PSQL "UPDATE player SET game_played = $GAME_PLAYED_UPDATE, best_game = $BEST_GAME_UPDATE WHERE LOWER(username)=LOWER('$USERNAME')")
      fi
      echo "You guessed it in $BEST_GAME_UPDATE tries. The secret number was $RANDOM_NUMBER. Nice job!"
    fi
  done
