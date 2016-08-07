FROM alpine:3.4

MAINTAINER nimmis <kjell.havneskold@gmail.com>

COPY root/. /

RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && apk upgrade && \
    apk add ca-certificates rsyslog logrotate runit@testing && \
    # Install utils and init process
    /install/docker-utils/install.sh && \
    # Install backup support
    /install/backup/install.sh all && \
    rm -Rf /install && \
    # Fix syslog config for containers
    sed  -i "s|\*.emerg|\#\*.emerg|" /etc/rsyslog.conf && \
    rm -rf /var/cache/apk/*

# Expose backup volume
VOLUME /backup

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["/boot.sh"]

