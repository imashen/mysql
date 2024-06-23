# MySQL 5.7 ARMv7 架构 Dockerfile
FROM debian:buster

# 安装必要的工具以添加 GPG 密钥
RUN apt-get update \
    && apt-get install -y --no-install-recommends gnupg dirmngr \
    && rm -rf /var/lib/apt/lists/*

# 添加 MySQL APT 仓库 URL
RUN echo "deb http://repo.mysql.com/apt/debian buster mysql-5.7" > /etc/apt/sources.list.d/mysql.list

# 安全地添加 MySQL GPG 密钥
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5072E1F5

# 安装 MySQL 服务器
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server=5.7.* \
    && rm -rf /var/lib/apt/lists/*

# 暴露 MySQL 端口
EXPOSE 3306

CMD ["mysqld"]
