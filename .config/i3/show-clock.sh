#!/bin/sh

dunstify -a "Relógio" -t 3000 -r 93021 \
  "$(date '+%H:%M')" "$(date '+%d/%m/%Y')"
