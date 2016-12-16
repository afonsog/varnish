FROM rawmind/rancher-base:0.0.2-1
MAINTAINER Gerónimo Afonso <geronimo.afonso@mikroways.net>
RUN apk add --no-cache varnish
#Agrego confd
#Add https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 /confd
RUN echo "confd -backend rancher -prefix /2015-12-19 -node rancher-metadata" > /usr/bin/confd-start.sh
#RUN echo "confd -onetime -backend rancher -prefix /2015-12-19 -node rancher-metadata" > confd-onetime-rancher
#RUN chmod +x confd-onetime-rancher confd-rancher
## Archivo de configuracion y template de confd

COPY confd /etc/confd/conf.d
COPY templates /etc/confd/templates
#
COPY ./default.vcl /etc/varnish/default.vcl
COPY ./varnish_reload /usr/bin/varnish_reload
COPY ./monit-confd.conf /etc/monit/conf.d/confd.conf 
COPY ./start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/varnish_reload /usr/bin/start.sh /usr/bin/confd-start.sh
EXPOSE 6082
ENTRYPOINT ["/usr/bin/start.sh"]
