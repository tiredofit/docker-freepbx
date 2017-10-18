FROM tiredofit/debian:stretch
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Set Environment Variables
    ENV PHP_MEMORY_LIMIT=256M

### Install Dependencies
   RUN apt-get update && \
       curl https://packages.sury.org/php/apt.gpg | apt-key add - && \
       echo 'deb https://packages.sury.org/php/ stretch main' > /etc/apt/sources.list.d/deb.sury.org.list && \
       apt-get update  && \
\
### Install Development Dependencies
       ASTERISK_BUILD_DEPS=' \
            autoconf \
            automake \
            bison \
            build-essential \
            doxygen \
            flex \
            libasound2-dev \
            libcurl4-openssl-dev \
            libical-dev \
            libiksemel-dev \
            libjansson-dev \
            libmariadbclient-dev \
            libncurses5-dev \
            libneon27-dev \
            libnewt-dev \
            libogg-dev \
            libresample1-dev \
            libspandsp-dev \
            libsqlite3-dev \
            libsrtp0-dev \
            libssl-dev \
            libtiff-dev \
            libtool-bin \
            libvorbis-dev \
            libxml2-dev \
            linux-headers-amd64 \
            pkg-config \
            python-dev \
            subversion \
            unixodbc-dev \
            uuid-dev \
            ' \
            && \
            \
### Install Runtime Dependencies
    apt-get install --no-install-recommends -y \
            $ASTERISK_BUILD_DEPS \
            fail2ban \
            flite \
            ffmpeg \
            git \
            g++ \
            iproute2 \
            lame \
            libicu-dev \
            libjansson4 \
            mariadb-client \
            mpg123 \
            net-tools \
            nginx \
            php5.6-cli \
            php5.6-curl \
            php5.6-fpm \
            php5.6-gd \
            php5.6-mbstring \
            php5.6-mysql \
            php5.6-xml \
            php-pear \
            procps \
            sox \
            sqlite3 \
            sudo \
            unixodbc \
            uuid \
            xmlstarlet \
            && \
\

### Install NodeJS
       curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add - && \
       echo 'deb https://deb.nodesource.com/node_6.x stretch main' > /etc/apt/sources.list.d/nodesource.list && \
       echo 'deb-src https://deb.nodesource.com/node_6.x stretch main' >> /etc/apt/sources.list.d/nodesource.list && \
       apt-get update && \
       apt-get install -y nodejs && \

### Install MySQL Connector
       cd /usr/src && \
       curl -sSL https://dev.mysql.com/get/Downloads/Connector-ODBC/5.3/mysql-connector-odbc-5.3.9-linux-debian9-x86-64bit.tar.gz | tar xvfz - -C /usr/src/ && \
       cp mysql-connector-odbc-5.3.9*/lib/libmyodbc5a.so /usr/lib/x86_64-linux-gnu/odbc/ && \
\
### Add Users
       addgroup --gid 2600 asterisk && \
       adduser --uid 2600 --gid 2600 --gecos "Asterisk User" --disabled-password asterisk && \
\
\
### Build SpanDSP
       mkdir -p /usr/src/spandsp && \
       curl -sSL https://www.soft-switch.org/downloads/spandsp/snapshots/spandsp-20170924.tar.gz | tar xvfz - --strip=1 -C /usr/src/spandsp && \
       cd /usr/src/spandsp && \
       ./configure && \
       make && \
       make install && \

### Build Asterisk
       cd /usr/src && \
       curl -sSL http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-14-current.tar.gz | tar xvfz - -C /usr/src/ && \
       cd /usr/src/asterisk-14*/ && \
       make distclean && \
       cd /usr/src/asterisk-14*/ && \
       contrib/scripts/get_mp3_source.sh && \
       ./configure --with-resample --with-pjproject-bundled && \
       make menuselect/menuselect menuselect-tree menuselect.makeopts && \
       menuselect/menuselect --enable format_mp3 menuselect.makeopts && \
       menuselect/menuselect --enable app_fax menuselect.makeopts && \
       menuselect/menuselect --enable codec_opus menuselect.makeopts && \
       menuselect/menuselect --enable codec_silk menuselect.makeopts && \
       menuselect/menuselect --enable BETTER_BACKTRACES menuselect.makeopts && \
       menuselect/menuselect --disable MOH-OPSOUND-WAV && \
       menuselect/menuselect --enable MOH-OPSOUND-GSM && \
       make && \
       make install && \
\
\
#### Add G729 Codecs
       curl -sSLo /usr/lib/asterisk/modules/codec_g729.so http://asterisk.hosting.lv/bin/codec_g729-ast140-gcc4-glibc-x86_64-core2-sse4.so && \

### Cleanup 
       mkdir -p /var/run/fail2ban && \
       cd / && \
       rm -rf /usr/src/* && \
       apt-get purge -y $ASTERISK_BUILD_DEPS && \
       apt-get -y autoremove && \
       apt-get clean && \
       apt-get install -y make && \
       rm -rf /var/lib/apt/lists/* && \
\
### FreePBX Hacks
       mkdir -p /var/log/httpd && \
       ln -s /www/logs/nginx/error.log /var/log/httpd/error_log && \
\
### Setup for Data Persistence
       mkdir -p /assets/config/var/lib/ /assets/config/home/ /www/logs/asterisk && \
       mv /home/asterisk /assets/config/home/ && \
       ln -s /data/home/asterisk /home/asterisk && \
       mv /var/lib/asterisk /assets/config/var/lib/ && \
       ln -s /data/var/lib/asterisk /var/lib/asterisk && \
       mkdir -p /assets/config/var/run/ && \
       mv /var/run/asterisk /assets/config/var/run/ && \
       ln -s /data/var/run/asterisk /var/run/asterisk && \
       rm -rf /var/spool/asterisk && \
       ln -s /data/var/spool/asterisk /var/spool/asterisk && \
       rm -rf /etc/asterisk && \
       ln -s /data/etc/asterisk /etc/asterisk && \
       rm -rf /var/log/asterisk && \
       ln -s /www/logs/asterisk /var/log/asterisk

### Files Add
   ADD install /

### Networking Configuration
EXPOSE 80 5060 18000-20000/udp

