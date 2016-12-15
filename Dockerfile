FROM alpine
MAINTAINER Gerónimo Afonso <geronimo.afonso@mikroways.net>
RUN apk add --no-cache varnish
#Agrego confd
Add https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd- /confd
RUN echo "./confd -backend rancher -prefix /2015-12-19 -node rancher-metadata" > confd-rancher
RUN echo "./confd -onetime -backend rancher -prefix /2015-12-19 -node rancher-metadata" > confd-onetime-rancher && chmod +x confd-onetime-rancher confd-rancher confd
# Archivo de configuracion y template de confd
COPY confd.d /etc/confd/confd.d
COPY templates /etc/confd/templates
#
COPY ./default.vcl /etc/varnish/default.vcl
COPY ./varnish_reload /usr/bin/varnish_reload
RUN chmod +x /usr/bin/varnish_reload
EXPOSE 6082
CMD ./confd-onetime-rancher && varnishd -F -a :80 -T localhost:6082 -s file,/tmp/varnish_storage.bin,1G -f /etc/varnish/default.vcl -p thread_pool_min=200 -p thread_pool_max=2000 -p thread_pools=8 -p listen_depth=4096 -p lru_interval=60 && ./confd-rancher
