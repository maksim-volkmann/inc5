FROM debian:stable

# Install necessary packages
RUN apt-get update && apt-get install -y mariadb-server && apt-get clean

# Copy custom config file
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/mariadb.sh /usr/local/bin/mariadb.sh
RUN chmod +x /usr/local/bin/mariadb.sh
# RUN /usr/local/bin/mariadb.sh

# Prepare run directory and set ownership
RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mariadb.sh"]

# CMD ["tail", "-f", "/dev/null"]
