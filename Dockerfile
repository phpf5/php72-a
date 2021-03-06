FROM php:7.2-apache

MAINTAINER "Mou" <mou@soshow.org>

#定义时区参数
ENV TZ=Asia/Shanghai

#设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone

#设置php.ini
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
RUN sed -i 's|;date.timezone =|date.timezone = "Asia/Shanghai"|g' /usr/local/etc/php/php.ini
RUN sed -i 's|memory_limit = 128M|memory_limit = 256M|g' /usr/local/etc/php/php.ini
RUN sed -i 's|max_execution_time = 30|max_execution_time = 300|g' /usr/local/etc/php/php.ini
RUN sed -i 's|upload_max_filesize = 2M|upload_max_filesize = 256M|g' /usr/local/etc/php/php.ini
RUN sed -i 's|post_max_size = 8M|post_max_size = 256M|g' /usr/local/etc/php/php.ini

# 更新阿里云的wheezy版本包源
#RUN echo "deb http://mirrors.aliyun.com/debian wheezy main contrib non-free" > /etc/apt/sources.list && \
#    echo "deb-src http://mirrors.aliyun.com/debian wheezy main contrib non-free" >> /etc/apt/sources.list  && \
#    echo "deb http://mirrors.aliyun.com/debian wheezy-updates main contrib non-free" >> /etc/apt/sources.list && \
#    echo "deb-src http://mirrors.aliyun.com/debian wheezy-updates main contrib non-free" >> /etc/apt/sources.list && \
#    echo "deb http://mirrors.aliyun.com/debian-security wheezy/updates main contrib non-free" >> /etc/apt/sources.list && \
#    echo "deb-src http://mirrors.aliyun.com/debian-security wheezy/updates main contrib non-free" >> /etc/apt/sources.list

# 更新中科大版本包源
RUN curl -o /etc/apt/sources.list https://mirrors.ustc.edu.cn/repogen/conf/debian-http-4-stretch
RUN apt-get update -y
RUN apt-get install -y libfreetype6-dev libjpeg-dev libpng-dev

# 安装任务调度
RUN apt-get install cron -y

# 安装PHP扩展
RUN pecl install redis -y && docker-php-ext-enable redis && \
docker-php-ext-configure gd --with-freetype-dir=/usr/include/freetype2/freetype --with-jpeg-dir=/usr/include && \
docker-php-ext-install gd mysqli pdo pdo_mysql zip

#pecl install memcached-2.2.0 -y && docker-php-ext-enable memcached