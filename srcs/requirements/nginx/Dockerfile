FROM debian:trixie

RUN apt-get update && \
	apt-get install --no-install-recommends -y nginx openssl && \
	rm -rf /var/lib/apt/lists

RUN mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/CN=localhost"

COPY conf/nginx.conf /etc/nginx/nginx.conf
