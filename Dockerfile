FROM alpine
MAINTAINER Gerónimo Afonso <geronimo.afonso@mikroways.net>
RUN apk add --no-cache varnish
COPY ./default.vcl /etc/varnish/default.vcl
COPY ./varnish_reload /usr/bin/varnish_reload
RUN chmod +x /usr/bin/varnish_reload
EXPOSE 6082
CMD varnishd -F -a :80 -T localhost:6082 -s file,/tmp/varnish_storage.bin,1G -f /etc/varnish/default.vcl -p thread_pool_min=200 -p thread_pool_max=2000 -p thread_pools=8 -p listen_depth=4096 -p lru_interval=60 
#CMD varnishd -a :80 -T localhost:6082 -s deprecated_persistent,/tmp/lacache,1G -f /etc/varnish/default.vcl && varnishlog
#DAEMON_OPTS="-a :80 \
#             -T localhost:6082 \
#             -f /etc/varnish/default.vcl \
#             -S /etc/varnish/secret \
#             -s malloc,4096m"
