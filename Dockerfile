FROM debian:buster
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        wget \
        build-essential \
        cmake \
        libncurses5-dev \
        bison \
        perl \
        libssl-dev \
        curl \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /usr/local/src

RUN wget --no-check-certificate https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.40.tar.gz

RUN tar -zxvf mysql-5.7.40.tar.gz

WORKDIR /usr/local/src/mysql-5.7.40

RUN cmake . -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/usr/local/boost \
    && make \
    && make install
    
RUN groupadd mysql \
    && useradd -r -g mysql -s /bin/false mysql \
    && mkdir -p /var/lib/mysql /etc/mysql/conf.d \
    && chown -R mysql:mysql /var/lib/mysql

RUN cd /usr/local/src/mysql-5.7.40 \
    && scripts/mysql_install_db --user=mysql --datadir=/var/lib/mysql \
    && cp support-files/my-default.cnf /etc/mysql/my.cnf \
    && bin/mysqld_safe --user=mysql & \
    && sleep 10 \
    && mysql -e "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION; FLUSH PRIVILEGES;"

RUN rm -rf /usr/local/src/mysql-5.7.40 /usr/local/src/mysql-5.7.40.tar.gz

EXPOSE 3306

CMD ["mysqld_safe"]
