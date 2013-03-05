#!/bin/bash
if [ -f /etc/default/sensu ]; then
    . /etc/default/sensu
fi

sensu_home=${SENSU_HOME-/opt/sensu}
service_dir=${SENSU_SERVICE_DIR-/etc/sensu/services}

export PATH=$sensu_home/embedded/bin:$PATH
exec $sensu_home/embedded/bin/runsvdir -P $service_dir 'log: .................................................................................................................................'
