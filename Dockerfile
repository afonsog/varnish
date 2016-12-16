FROM rawmind/rancher-base:0.0.2-1
MAINTAINER Gerónimo Afonso <geronimo.afonso@mikroways.net>
RUN apk add --no-cache varnish
#Agrego confd
RUN echo "confd -backend rancher -prefix /2015-12-19 -node rancher-metadata" > confd-rancher
RUN echo "confd -onetime -backend rancher -prefix /2015-12-19 -node rancher-metadata" > confd-onetime-rancher
RUN chmod +x confd-onetime-rancher confd-rancher
# Archivo de configuracion y template de confd
COPY confd /etc/confd/conf.d
COPY templates /etc/confd/templates
#
ADD ./monit-confd.conf /etc/monit/conf.d/
COPY ./default.vcl /etc/varnish/default.vcl
COPY ./varnish_reload /usr/bin/varnish_reload
COPY ./start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/varnish_reload /usr/bin/start.sh
EXPOSE 6082
ENTRYPOINT ["/usr/bin/start.sh"]
