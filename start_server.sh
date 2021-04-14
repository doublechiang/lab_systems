#!/bin/bash
# provide the default environment string with pararmeter.
# ./start_server.sh (production|test|development) to start the server with developement|test env
# 
#source "/usr/local/rvm/scripts/rvm"
param="production"
if [ "$1" ]; then 
    param=$1
fi

sd=${PWD}
cd "$(dirname "$0")"
pd=${PWD}

# cmd="APP_ENV=${param} bundle exec ruby -I ${pd} -I ${pd}/lib ${pd}/controllers/systems.rb"
cmd="APP_ENV=${param} bundle exec rackup config.ru -I ${pd} -p 4567"
#echo $cmd

# if gem 'rerun' is installed, and the parameter is 'test', then we will use rerun to run the sinatra
if [ -x "$(command -v rerun)" ] && [ "${param}" == "development" ]; then
    echo ${cmd}
    eval rerun -d ${pd}/controllers -d ${pd}/views/systems -d ${pd}/views/inventories -d ${pd}/lib -d . \'${cmd}\'
else
   mkdir -p log
   eval ${cmd} > log/production.log 2>&1
fi 
