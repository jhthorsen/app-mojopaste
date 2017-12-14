#!/bin/bash

CMD="docker run"

if [ "$1" = "-d" ]; then
  CMD="$CMD -d --restart always"
else
  CMD="$CMD -ti --rm"
fi

CMD="$CMD --name mojopaste"
CMD="$CMD -v $PWD:/usr/src/app"
CMD="$CMD -p 5555:8080"
CMD="$CMD mojopaste_v1"
# NOTE: Start by deamon
# CMD="$CMD sh -c 'cd /usr/src/app && exec mojopaste daemon --listen http://*:8080'"
# NOTE start by hypnotoad
CMD="$CMD sh -c 'cd /usr/src/app && exec hypnotoad -f /usr/local/bin/mojopaste'"

eval $CMD
