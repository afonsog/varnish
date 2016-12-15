#!/bin/ash
#/confd-onetime-rancher
#varnishd -a :80 -T localhost:6082 -s file,/tmp/varnish_storage.bin,1G -f /etc/varnish/default.vcl -p thread_pool_min=200 -p thread_pool_max=2000 -p thread_pools=8 -p listen_depth=4096 -p lru_interval=60
varnishd -a :80 -T localhost:6082 -s malloc,256m -f /etc/varnish/default.vcl
/confd-rancher
#CMD ./confd-onetime-rancher && varnishd -F -a :80 -T localhost:6082 -s file,/tmp/varnish_storage.bin,1G -f /etc/varnish/default.vcl -p thread_pool_min=200 -p thread_pool_max=2000 -p thread_pools=8 -p listen_depth=4096 -p lru_interval=60 && ./confd-rancher
