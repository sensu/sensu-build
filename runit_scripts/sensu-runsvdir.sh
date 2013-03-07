#!/bin/bash
SENSU_HOME=/opt/sensu

if [ -f /etc/default/sensu ]; then
    . /etc/default/sensu
fi

export PATH=$SENSU_HOME/embedded/bin:$PATH
exec $SENSU_HOME/embedded/bin/runsvdir -P $SENSU_HOME/service 'log: .................................................................................................................................'
