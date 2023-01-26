#!/bin/bash

status=$(playerctl status)

if [[ $status == 'Paused' ]]; then
  echo $(playerctl metadata --format ' {{ title }} - {{ artist }}')
else
  echo $(playerctl metadata --format ' {{ title }} - {{ artist }}')
fi
