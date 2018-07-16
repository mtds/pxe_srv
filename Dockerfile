FROM debian:9

RUN apt-get update
RUN apt-get install -y ruby-sinatra
RUN apt-get clean

ADD pxesrv.rb /opt/pxesrv/pxesrv.rb 
ADD pxesrv.yml /etc/pxesrv.yml 

EXPOSE 4567

CMD PXESRV_CONF=/etc/pxesrv.yml ruby /opt/pxesrv/pxesrv.rb
