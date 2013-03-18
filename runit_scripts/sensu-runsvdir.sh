#!/bin/bash

# ensure the original path is exported for service scripts to use when choosing a ruby
export ORIGINAL_PATH=$PATH
export PATH=/opt/sensu/embedded/bin:$PATH
exec /opt/sensu/embedded/bin/runsvdir -P /opt/sensu/service 'log: .................................................................................................................................'
