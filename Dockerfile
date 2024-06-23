FROM debian:bookworm

# 设置时区为上海
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 安装依赖
RUN apt-get update && apt-get install -y \
    wget \
    gnupg

# 添加 MySQL 5.7 的源
RUN wget https://repo.mysql.com/mysql-apt-config_0.8.20-1_all.deb
RUN echo "mysql-apt-config mysql-apt-config/select-server select mysql-5.7" | debconf-set-selections
RUN dpkg -i mysql-apt-config_0.8.20-1_all.deb
RUN apt-get update

# 安装 MySQL 5.7
RUN apt-get install -y mysql-community-server

# 清理安装过程中的缓存
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 复制初始化 SQL 脚本到镜像中
COPY ./mysqlinit/init.sql /docker-entrypoint-initdb.d/

# 暴露 MySQL 默认端口
EXPOSE 3306

# 启动 MySQL 服务
CMD ["mysqld"]
