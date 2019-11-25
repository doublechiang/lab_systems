#!/bin/bash
# provide the default environment string with pararmeter.
# ./start_server.sh (development|test) to start the server with developement|test env
# 
envvar="production"
if [ "$1" ]
    then envvar=$1
fi
APP_ENV=${envvar} ruby -I lib server.rb
