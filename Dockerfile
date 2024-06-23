
FROM debian:buster


RUN apt-get update \
    && apt-get install -y --no-install-recommends gnupg dirmngr \
    && rm -rf /var/lib/apt/lists/*


RUN echo "deb http://repo.mysql.com/apt/debian buster mysql-5.7" > /etc/apt/sources.list.d/mysql.list


RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8C718D3B5072E1F5 \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B7B3B788A8D3785C


RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server \
    && rm -rf /var/lib/apt/lists/*


EXPOSE 3306

CMD ["mysqld"]
