PXESRV_ROOT=$PXESRV_PATH/public
PXESRV_LOG=/tmp/pxesrv.log
PXESRV_DOCKER_CONTAINER=pxesrv

export PXESRV_ROOT \
       PXESRV_LOG \
       PXESRV_DOCKER_CONTAINER

pxesrv-docker-container() {
        # build the container image
        docker build -t $PXESRV_DOCKER_CONTAINER $PXESRV_PATH
        # start the container instance
        docker run --detach \
                   --tty \
                   --interactive \
                   --name $PXESRV_DOCKER_CONTAINER \
                   --publish 4567:4567 \
                   --volume $PXESRV_ROOT:/srv/pxesrv \
               $PXESRV_DOCKER_CONTAINER
}

pxesrv-docker-container-clean() {
        docker container stop $PXESRV_DOCKER_CONTAINER
        docker container rm $PXESRV_DOCKER_CONTAINER
        docker image rm $PXESRV_DOCKER_CONTAINER
}
