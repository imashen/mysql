# 使用 Debian Bookworm slim base image for armv7
FROM debian:bookworm-slim

# 添加 mysql 用户和组
RUN groupadd -r mysql && useradd -r -g mysql mysql

# 安装编译 MySQL 所需的依赖包
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        curl \
        openssl \
        ncurses-devel \
        libncurses-dev \
        bison \
        perl \
        wget \
        ca-certificates \
        libssl-dev \
        libcurl4-openssl-dev \
        zlib1g-dev \
        libaio-dev \
        libevent-dev \
        libpam0g-dev \
        libnuma-dev \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*

# 下载并解压 MySQL 源代码
ENV MYSQL_VERSION=8.0.24
RUN mkdir /usr/src/mysql && \
    curl -SL "https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-$MYSQL_VERSION.tar.gz" \
    | tar -xzC /usr/src/mysql --strip-components=1

# 下载并解压 Boost 库
ENV BOOST_VERSION=1_73_0
RUN mkdir /usr/local/boost && \
    curl -SL "https://boostorg.jfrog.io/artifactory/main/release/1.73.0/source/boost_${BOOST_VERSION}.tar.gz" \
    | tar -xzC /usr/local/boost --strip-components=1

# 创建构建目录
RUN mkdir /usr/src/mysql/bld && \
    export OPENSSL_ROOT_DIR=/usr/local/openssl && \
    export OPENSSL_LIBRARIES=/usr/local/openssl

# 编译和安装 MySQL
WORKDIR /usr/src/mysql/bld
RUN cmake .. \
    -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
    -DWITH_BOOST=/usr/local/boost \
    -DDEFAULT_CHARSET=utf8mb4 \
    -DDEFAULT_COLLATION=utf8mb4_unicode_ci \
    -DOPENSSL_ROOT_DIR=/usr/lib/ssl \
    -DOPENSSL_LIBRARIES=/usr/lib/ssl \
    && make VERBOSE=1 \
    && make install

# 配置 MySQL
RUN mkdir -p /etc/mysql /var/lib/mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
    chmod 1777 /var/run/mysqld /var/lib/mysql

# 添加 MySQL 配置文件和启动脚本
COPY config/my.cnf /etc/mysql/my.cnf
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # 兼容性

# 定义 MySQL 数据卷
VOLUME /var/lib/mysql

# 暴露 MySQL 端口
EXPOSE 3306

# 设置入口点和默认命令
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld"]
