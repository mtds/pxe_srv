FROM debian:9

RUN apt-get update
RUN apt-get install -y ruby-sinatra
RUN apt-get clean

ADD pxesrv /opt/pxesrv/pxesrv

EXPOSE 4567

CMD PXESRV_ROOT=/srv/pxesrv /opt/pxesrv/pxesrv
