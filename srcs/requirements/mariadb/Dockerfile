FROM debian:trixie

RUN apt-get update && \
	apt-get install --no-install-recommends -y mariadb-server && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && \
	chown mysql:mysql /run/mysqld

COPY tools/init-db.sh /usr/local/bin/init-db.sh
RUN chmod +x /usr/local/bin/init-db.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/init-db.sh"]
