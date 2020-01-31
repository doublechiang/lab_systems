#!/bin/bash
# provide the default environment string with pararmeter.
# ./start_server.sh (development|test) to start the server with developement|test env
# 
param="production"
if [ "$1" ]; then 
    param=$1
fi

cmd="APP_ENV=${param} ruby -I lib server.rb"

# if gem 'rerun' is installed, and the parameter is 'test', then we will use rerun to run the sinatra
if [ -x "$(command -v rerun)" ] && [ "${param}" == "test" ]; then
    echo ${cmd}
    eval rerun -d ./lib -d ./app/routes -d ./views/systems \'${cmd}\'
else
   eval ${cmd}
fi 
