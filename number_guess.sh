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