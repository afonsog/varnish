FROM rawmind/rancher-base:0.0.2-1
MAINTAINER Gerónimo Afonso <geronimo.afonso@mikroways.net>
RUN apk add --no-cache varnish
#Agrego confd
#Add https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 /confd
RUN echo "confd -backend rancher -prefix /2015-12-19 -node rancher-metadata" > confd-rancher
RUN echo "confd -onetime -backend rancher -prefix /2015-12-19 -node rancher-metadata" > confd-onetime-rancher
RUN chmod +x confd-onetime-rancher confd-rancher
# Archivo de configuracion y template de confd
COPY confd /etc/confd/conf.d
COPY templates /etc/confd/templates
#
COPY ./default.vcl /etc/varnish/default.vcl
COPY ./varnish_reload /usr/bin/varnish_reload
COPY ./start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/varnish_reload /usr/bin/start.sh
EXPOSE 6082
#CMD ./confd-onetime-rancher && varnishd -F -a :80 -T localhost:6082 -s file,/tmp/varnish_storage.bin,1G -f /etc/varnish/default.vcl -p thread_pool_min=200 -p thread_pool_max=2000 -p thread_pools=8 -p listen_depth=4096 -p lru_interval=60 && ./confd-rancher
ENTRYPOINT ["/usr/bin/start.sh"]
