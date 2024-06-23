FROM debian:bullseye

# Add MySQL APT repo URL
RUN echo "deb http://repo.mysql.com/apt/debian/ buster mysql-5.7" > /etc/apt/sources.list.d/mysql.list

# Add MySQL GPG key
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8C718D3B5072E1F5

# Install MySQL
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server=5.7.* \
    && rm -rf /var/lib/apt/lists/*

# Expose MySQL port
EXPOSE 3306

CMD ["mysqld"]
