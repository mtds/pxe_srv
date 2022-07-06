FROM fedora:36

RUN dnf -y update
RUN dnf -y install rubygem-sinatra
RUN dnf -y clean all
RUN mkdir /srv/pxesrv

ADD pxesrv /opt/pxesrv/pxesrv

EXPOSE 4567

CMD PXESRV_ROOT=/srv/pxesrv /opt/pxesrv/pxesrv -p 4567
