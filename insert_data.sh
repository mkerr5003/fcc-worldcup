#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

tail -n +2 games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  TEAM_INSERT_1=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER') ON CONFLICT (name) DO NOTHING")
  TEAM_INSERT_2=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT') ON CONFLICT (name) DO NOTHING")

done

tail -n +2 games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  GAME_INSERT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
done
