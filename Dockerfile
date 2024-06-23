FROM debian:bookworm
RUN echo 'Asia/Shanghai' >/etc/timezone
MAINTAINER i@imashen.cn

RUN apt -y install epel-release 
RUN apt install initscripts -y

RUN apt -y install wget


RUN wget --no-check-certificate https://repo.mysql.com/mysql57-community-release-sles12.rpm

RUN rpm -ivh mysql57-community-release-el7-7.noarch.rpm

RUN rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022

RUN apt -y install mysql-community-server
RUN chown -R root:root /var/lib/mysql

COPY ./mysqlinit/init.sql /usr/local/mysql/init.sql

EXPOSE 3306

CMD ["/usr/sbin/init"]

