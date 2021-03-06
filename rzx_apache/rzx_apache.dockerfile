FROM garaninr/rzx_base:0.1

LABEL MAINTAINER="@GaraninR"
LABEL GIT_REPO="https://github.com/GaraninR/rzx_docker_images"
LABEL DOCKERHUB_REPO="https://hub.docker.com/r/garaninr/rzx_apache/"

ENV INSTALL_DIR /opt/install
RUN mkdir ${INSTALL_DIR}

COPY dockerfile.sh ${INSTALL_DIR}
COPY default-server.conf ${INSTALL_DIR}
RUN chmod -R 777 ${INSTALL_DIR} && ${INSTALL_DIR}/dockerfile.sh

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
