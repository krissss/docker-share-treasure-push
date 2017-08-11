FROM daocloud.io/ubuntu:16.04

MAINTAINER kriss

# 切换 apt 镜像源
RUN ["sed", "-i", "s/archive.ubuntu.com/mirrors.163.com/g", "/etc/apt/sources.list"]

# APT 自动安装 PHP 相关的依赖包,如需其他依赖包在此添加
RUN apt-get update && apt-get install -y \
        # PHP 及扩展
        php-cli \
        # workman 需要
        libevent-dev \
        # pecl
        php-pear \
        php-dev \
    # 原 pecl 安装 event 扩展
    #&& pecl install event \
    # 源码安装 event 扩展，避免需要输入
    && pecl download event-2.3.0 \
    && tar -zxvf event-2.3.0.tgz \
    && cd event-2.3.0 \
    && phpize \
    && ./configure \
     --with-php-config=/usr/bin/php-config7.0 \
     --enable-event-debug=no \
     --enable-event-sockets=yes \
     --with-event-libevent-dir=/usr \
     --with-event-pthreads=no --with-event-extra \
     --with-event-openssl=no \
     --with-openssl-dir=no \
    && make && make install \
    && echo extension=event.so > /etc/php/7.0/cli/conf.d/event.ini \
    # 清理文件
    && cd ../ && rm -rf event-2.3.0 && rm event-2.3.0.tgz \

    # 用完包管理器后安排打扫卫生可以显著的减少镜像大小
    && apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 系统内核调优
# docker ubuntu:16.04 容器中不可用
#COPY ./system/sysctl.conf /etc/sysctl.conf
#RUN sysctl -p

# PHP 配置
COPY ./php/ /etc/php/7.0/

COPY . /app
WORKDIR /app

# 阿里云可填：[hostname]:1238
ENV REGISTER_ADDRESS='127.0.0.1:1238'
ENV WORKER_COUNT=2
ENV GATEWAY_COUNT=2
# 阿里云可填：[hostname]
ENV LAN_IP='127.0.0.1'
# 0 关闭，1 开启
ENV CHECK_ORIGIN=0
ENV HTTP_ORIGIN='http://127.0.0.1'
# 0 是从服务器，1 是主服务器
ENV IS_REGISTER_NODE=1

EXPOSE 1238
EXPOSE 7272

CMD ["php", "start.php", "start"]