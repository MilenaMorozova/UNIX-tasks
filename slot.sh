#!/bin/bash

function render_slot {
  # $1, $2, $3 - numbers
  # $4 - game status
  clear
  if [[ "$#" = "0" ]]; then

    echo -e "
    ||==========================||
    ||        **PLAY?**         ||
    ||__________________________||
    |  || - || || - || || - ||   |
    |============================|"
  elif [[ "$#" = "1" ]]; then
    echo -e "
    ||==========================||
    ||        **@@@@@**         ||
    ||__________________________||
    |  || $1 || || - || || - ||   |
    |============================|"
  elif [[ "$#" = "2"  ]]; then
    #statements
    echo -e "
    ||==========================||
    ||        **@@@@@**         ||
    ||__________________________||
    |  || $1 || || $2 || || - ||   |
    |============================|"
  elif [[ "$#" = "4" ]]; then
    echo -e "
    ||==========================||
    ||        **$4**         ||
    ||__________________________||
    |  || $1 || || $2 || || $3 ||   |
    |============================|"
  fi
}

# output info about game
render_slot
echo "For start the game input 'start'
For end the game input 'quit'"

good_image="https://upload.wikimedia.org/wikipedia/ru/archive/e/ed/20100210210141%21Scrooge2.jpg"
bad_image="https://pm1.narvii.com/6564/597226f0757f00b18328d396d54e58b201776ed0_hq.jpg"

name_good_image="happy.jpg"
name_bad_image="sad.jpg"

function load_and_show_image {
  # $1 - image_name
  # $2 link_to_image
  if [[ ! -f "$1" ]]; then
    wget -O $1 $2
  fi
  fim -a $1
}

function winning_comb {
    number=$(($RANDOM % 10))

    sleep 1
    render_slot $number
    sleep 1
    render_slot $number $number
    sleep 1
    render_slot $number $number $number "WIIIN"
    sleep 2
    load_and_show_image $name_good_image $good_image
}

function losing_comb {
  number_1=$(($RANDOM % 10))
  number_2=$(($RANDOM % 10))
  number_3=$(($RANDOM % 10))

  if [[ "$number_1" = "$number_2" ]]; then

    while [[ "$number_1" = "$number_3" ]]; do
      number_3=$(($RANDOM % 10))
    done
  fi
  sleep 1
  render_slot $number_1
  sleep 1
  render_slot $number_1 $number_2
  sleep 1
  render_slot $number_1 $number_2 $number_3 "LOOSE"
  sleep 2

  load_and_show_image $name_bad_image $bad_image

}

# mainloop
number_of_victories=0

while true; do
  read command
  if [[ "$command" = "start" ]]; then
    if [[ "$(($RANDOM % 100))" -lt "20" && number_of_victories -lt "2" ]]; then
      winning_comb
      ((number_of_victories++))
    else
      losing_comb
      number_of_victories=0
    fi

  elif [[ "$command" = "quit" ]]; then
    echo "I hope to see you soon :)"
    exit 0
  fi
done
