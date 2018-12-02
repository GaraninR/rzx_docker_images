FROM garaninr/rzx_apache_php_7:0.1

LABEL MAINTAINER="@GaraninR"
LABEL GIT_REPO="https://github.com/GaraninR/rzx_docker_images"
LABEL DOCKERHUB_REPO="https://hub.docker.com/r/garaninr/rzx_mysql/"

ENV INSTALL_DIR /opt/install
RUN mkdir ${INSTALL_DIR}

COPY create_mysqldb.sql /opt/scripts
COPY rzx_mysql.sh /opt/scripts
COPY config.inc.php /tmp
COPY dockerfile.sh ${INSTALL_DIR}

RUN chmod -R 777 ${INSTALL_DIR} && ${INSTALL_DIR}/dockerfile.sh

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
