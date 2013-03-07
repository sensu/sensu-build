#!/bin/bash
SENSU_HOME=/opt/sensu

if [ -f /etc/default/sensu ]; then
    . /etc/default/sensu
fi

# ensure the original path is exported for service scripts to use when choosing a ruby
export ORIGINAL_PATH=$PATH
export PATH=$SENSU_HOME/embedded/bin:$PATH
exec $SENSU_HOME/embedded/bin/runsvdir -P $SENSU_HOME/service 'log: .................................................................................................................................'
