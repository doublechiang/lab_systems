#!/bin/bash
TOUCH=".inventory_touched"
loc=`dirname $0`
if [ ! -f $TOUCH ]; then
    $loc/deploy.sh &
    touch $TOUCH
fi

