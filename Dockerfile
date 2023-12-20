FROM alpine:3.19

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
	apk update && \
	apk add --no-cache \
		git \
		make \
		libffi-dev \
		openssl-dev \
		gcc \
		libc-dev \
		bash \
		gettext \
		curl \
		wget \
		zip \
		file \
		diffutils \
		lftp \
    	tzdata \
		curlftpfs && \
    rm -rf /var/cache/apk/*

RUN mkdir /app && \
    rm -fr /etc/periodic

COPY sync.sh docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["sync.sh"]
