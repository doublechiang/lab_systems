#!/bin/bash
# provide the default environment string with pararmeter.
# ./start_server.sh (production|test) to start the server with developement|test env
# 
#source "/usr/local/rvm/scripts/rvm"
param="production"
if [ "$1" ]; then 
    param=$1
fi

sd=${PWD}
cd "$(dirname "$0")"
pd=${PWD}

cmd="APP_ENV=${param} ruby -I ${pd} -I ${pd}/lib ${pd}/server.rb"
echo $cmd

# if gem 'rerun' is installed, and the parameter is 'test', then we will use rerun to run the sinatra
if [ -x "$(command -v rerun)" ] && [ "${param}" == "test" ]; then
    echo ${cmd}
    eval bundle exec rerun -d ${pd}/app/routes -d ${pd}/views/systems -d ${pd}/lib \'${cmd}\'
else
   eval bundle exec ${cmd}
fi 
