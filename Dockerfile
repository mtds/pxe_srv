FROM debian:9

RUN apt-get update
RUN apt-get install -y ruby-sinatra
RUN apt-get clean

ADD pxesrv /opt/pxesrv/pxesrv
ADD pxesrv.yml /etc/pxesrv.yml 

EXPOSE 4567

CMD PXESRV_CONF=/etc/pxesrv.yml /opt/pxesrv/pxesrv
