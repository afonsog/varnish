FROM alpine
MAINTAINER Gerónimo Afonso <geronimo.afonso@mikroways.net>
RUN apk add --no-cache varnish
COPY ./default.vcl /etc/varnish/default.vcl
COPY ./varnish_reload /usr/bin/varnish_reload
RUN chmod +x /usr/bin/varnish_reload /usr/bin/start.sh
EXPOSE 6082
CMD varnishd -F -a :80 -T localhost:6082 -s malloc,256m -f /etc/varnish/default.vcl
