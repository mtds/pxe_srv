FROM debian:9

RUN apt-get update
RUN apt-get install -y ruby-sinatra
RUN apt-get clean
RUN mkdir /srv/pxesrv

ADD pxesrv /opt/pxesrv/pxesrv

EXPOSE 4567

CMD PXESRV_ROOT=/srv/pxesrv /opt/pxesrv/pxesrv -p 4567
