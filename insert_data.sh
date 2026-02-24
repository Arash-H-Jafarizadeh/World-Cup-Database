#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOL OPO_GOL
do
  if [[ $YEAR != "year" ]]
    then

    # if winner team is not inserted yet
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")
    if [[ -z $WIN_ID ]]
      then
        # insert winner data
        INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
          then
          echo Inserted into teams, $WINNER
        fi
    fi

    # if opponent team is not inserted yet
    OPO_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")
    if [[ -z $OPO_ID ]]
      then
        # insert opponent data
        INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
          then
          echo Inserted into teams, $OPPONENT
        fi
    fi


    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year=$YEAR AND round='$ROUND' AND winner_goals=$WIN_GOL AND opponent_goals=$OPO_GOL AND winner_id=$WIN_ID;")
    if [[ -z $GAME_ID ]]
      then
      # insert game data
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WIN_GOL, $OPO_GOL, $WIN_ID, $OPO_ID)")
    fi
  
  fi
done