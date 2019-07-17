FROM node:12-stretch
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Set Defaults
   ENV DB_EMBEDDED=TRUE \
       ENABLE_CRON=TRUE \
       ENABLE_SMTP=TRUE \
       ASTERISK_VERSION=16.4.0 \
       BCG729_VERSION=1.0.4 \
       SPANDSP_VERSION=20180108 \
       FREEPBX_VERSION=15.0.16.6 \
       UCP_FIRST=TRUE

### Install Dependencies
   RUN set -x && \
       apt-get update && \
       apt-get install -y wget apt-transport-https ca-certificates && \
       curl https://packages.sury.org/php/apt.gpg | apt-key add - && \
       echo 'deb https://packages.sury.org/php/ stretch main' > /etc/apt/sources.list.d/deb.sury.org.list && \
       apt-get update  && \
       apt-get install -y debconf locales locales-all cron && \
       apt-get -o Dpkg::Options::="--force-confold" upgrade -y && \
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
            libedit-dev \
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
            apache2 \
            composer \
            fail2ban \
            flite \
            ffmpeg \
            git \
            g++ \
            iproute2 \
            iptables \
            lame \
            libiodbc2 \
            libicu-dev \
            libsrtp0 \
            locales-all \
            mariadb-client \
            mariadb-server \
            mpg123 \
            net-tools \
            php5.6 \
            php5.6-cli \
            php5.6-curl \
            php5.6-gd \
            php5.6-ldap \
            php5.6-mbstring \
            php5.6-mysql \
            php5.6-sqlite \
            php5.6-xml \
            php5.6-zip \
            php-pear \
            procps \
            sox \
            sqlite3 \
            sudo \
            unixodbc \
            uuid \
            wget \
            whois \
            xmlstarlet

### Install MySQL Connector
RUN printf "Package: *\nPin: release n=stretch\nPin-Priority: 900\nPackage: *\nPin: release n=jessie\nPin-Priority: 100" >> /etc/apt/preferences.d/jessie \
        && echo "deb http://mirrordirector.raspbian.org/raspbian/ jessie main contrib" >> /etc/apt/sources.list \
        && curl -s http://archive.raspbian.org/raspbian.public.key | apt-key add - \
        && apt-get update \
        && apt-get -y --allow-unauthenticated install libmyodbc \
        && sed '$d' /etc/apt/sources.list \
        && rm /etc/apt/preferences.d/jessie

### Add Users
RUN addgroup --gid 2600 asterisk && \
       adduser --uid 2600 --gid 2600 --gecos "Asterisk User" --disabled-password asterisk

### Build SpanDSP
RUN mkdir -p /usr/src/spandsp && \
       curl -kL https://www.soft-switch.org/downloads/spandsp/snapshots/spandsp-${SPANDSP_VERSION}.tar.gz | tar xvfz - --strip 1 -C /usr/src/spandsp && \
       cd /usr/src/spandsp && \
       ./configure && \
       make && \
       make install
      
### Build Asterisk
RUN cd /usr/src && \
       mkdir -p asterisk && \
       curl -sSL http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-${ASTERISK_VERSION}.tar.gz | tar xvfz - --strip 1 -C /usr/src/asterisk && \
       cd /usr/src/asterisk/ && \
       make distclean && \
       contrib/scripts/get_mp3_source.sh && \
       ./configure --with-resample --with-pjproject-bundled --with-jansson-bundled --with-ssl=ssl --with-srtp && \
       make menuselect/menuselect menuselect-tree menuselect.makeopts && \
       menuselect/menuselect --disable BUILD_NATIVE \
                             --enable app_confbridge \
                             --enable app_fax \
                             --enable app_macro \
                             --enable codec_opus \
                             --enable codec_silk \
                             --enable format_mp3 \
                             --enable BETTER_BACKTRACES \
                             --disable MOH-OPSOUND-WAV \
                             --enable MOH-OPSOUND-GSM \
       make && \
       make install && \
       make config && \
       ldconfig
       
#### Add G729 Codecs
RUN git clone https://github.com/BelledonneCommunications/bcg729 /usr/src/bcg729 && \
       cd /usr/src/bcg729 && \
       git checkout tags/$BCG729_VERSION && \
       ./autogen.sh && \
       ./configure --libdir=/lib && \
       make && \
       make install && \
       \
       mkdir -p /usr/src/asterisk-g72x && \
       curl https://bitbucket.org/arkadi/asterisk-g72x/get/default.tar.gz | tar xvfz - --strip 1 -C /usr/src/asterisk-g72x && \
       cd /usr/src/asterisk-g72x && \
       ./autogen.sh && \
       ./configure CFLAGS='-march=armv7' --with-bcg729 --with-asterisk160 --enable-penryn&& \
       make && \
       make install

### Install chan_dongle
RUN cd /usr/src && \
        git clone https://github.com/wdoekes/asterisk-chan-dongle.git && \
        cd asterisk-chan-dongle && \
        ./bootstrap && \
        ./configure --with-astversion=14.7.5 && \
        make && \
        make install && \
        cp etc/dongle.conf /etc/asterisk/

### Cleanup 
RUN mkdir -p /var/run/fail2ban && \
       cd / && \
       rm -rf /usr/src/* /tmp/* /etc/cron* && \
       apt-get purge -y $ASTERISK_BUILD_DEPS libspandsp-dev && \
       apt-get -y autoremove && \
       apt-get clean && \
       apt-get install -y make && \
       rm -rf /var/lib/apt/lists/*
       
### FreePBX Hacks
RUN sed -i -e "s/memory_limit = 128M/memory_limit = 256M/g" /etc/php/5.6/apache2/php.ini && \
       sed -i 's/\(^upload_max_filesize = \).*/\120M/' /etc/php/5.6/apache2/php.ini && \
       a2disconf other-vhosts-access-log.conf && \
       a2enmod rewrite && \
       a2enmod headers && \
       rm -rf /var/log/* && \
       mkdir -p /var/log/asterisk && \
       mkdir -p /var/log/apache2 && \
       mkdir -p /var/log/httpd

### Setup for Data Persistence
RUN mkdir -p /assets/config/var/lib/ /assets/config/home/ && \
       mv /home/asterisk /assets/config/home/ && \
       ln -s /data/home/asterisk /home/asterisk && \
       mv /var/lib/asterisk /assets/config/var/lib/ && \
       ln -s /data/var/lib/asterisk /var/lib/asterisk && \
       ln -s /data/usr/local/fop2 /usr/local/fop2 && \
       mkdir -p /assets/config/var/run/ && \
       mv /var/run/asterisk /assets/config/var/run/ && \
       mv /var/lib/mysql /assets/config/var/lib/ && \
       mkdir -p /assets/config/var/spool && \
       mv /var/spool/cron /assets/config/var/spool/ && \
       ln -s /data/var/spool/cron /var/spool/cron && \
       ln -s /data/var/run/asterisk /var/run/asterisk && \
       rm -rf /var/spool/asterisk && \
       ln -s /data/var/spool/asterisk /var/spool/asterisk && \
       rm -rf /etc/asterisk && \
       ln -s /data/etc/asterisk /etc/asterisk

### Networking Configuration
   EXPOSE 80 443 4445 4569 5060/udp 5160/udp 5061 5161 8001 8003 8008 8009 18000-20000/udp

### Files Add
   ADD install /
