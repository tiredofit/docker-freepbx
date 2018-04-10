FROM tiredofit/nodejs:8-debian-latest
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Set Defaults
   ENV DB_EMBEDDED=TRUE \
       ENABLE_CRON=TRUE

### Install Dependencies
   RUN apt-get update && \
       curl https://packages.sury.org/php/apt.gpg | apt-key add - && \
       echo 'deb https://packages.sury.org/php/ stretch main' > /etc/apt/sources.list.d/deb.sury.org.list && \
       apt-get update  && \

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
            libicu-dev \
            libjansson4 \
            libsrtp0 \
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
            php5.6-xml \
            php5.6-zip \
            php-pear \
            procps \
            sox \
            sqlite3 \
            sudo \
            unixodbc \
            uuid \
            whois \
            xmlstarlet \
            && \

### Install MySQL Connector
       cd /usr/src && \
       curl -sSL https://downloads.mariadb.com/Connectors/odbc/connector-odbc-3.0.2/mariadb-connector-odbc-3.0.2-ga-debian-x86_64.tar.gz | tar xvfz - -C /usr/src/ && \
       cp mariadb-connector-odbc-3.0.2*/lib/libmaodbc.so /usr/lib/x86_64-linux-gnu/odbc/ && \

### Add Users
       addgroup --gid 2600 asterisk && \
       adduser --uid 2600 --gid 2600 --gecos "Asterisk User" --disabled-password asterisk && \

### Build Asterisk
       cd /usr/src && \
       curl -sSL http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-14-current.tar.gz | tar xvfz - -C /usr/src/ && \
       cd /usr/src/asterisk-14*/ && \
       make distclean && \
       contrib/scripts/get_mp3_source.sh && \
       ./configure --with-resample --with-pjproject-bundled && \
       make menuselect/menuselect menuselect-tree menuselect.makeopts && \
       menuselect/menuselect --disable BUILD_NATIVE \
                             --enable format_mp3 \
                             --enable app_fax \
                             --enable app_confbridge \
                             --enable codec_opus \
                             --enable codec_silk \
                             --enable BETTER_BACKTRACES \
                             --disable MOH-OPSOUND-WAV \
                             --enable MOH-OPSOUND-GSM \
       make && \
       make install && \

#### Add G729 Codecs
       curl -sSLo /usr/lib/asterisk/modules/codec_g729.so http://asterisk.hosting.lv/bin/codec_g729-ast140-gcc4-glibc-x86_64-core2-sse4.so && \

### Cleanup 
       mkdir -p /var/run/fail2ban && \
       cd / && \
       rm -rf /usr/src/* /tmp/* && \
       apt-get purge -y $ASTERISK_BUILD_DEPS && \
       apt-get -y autoremove && \
       apt-get clean && \
       apt-get install -y make && \
       rm -rf /var/lib/apt/lists/* && \

### FreePBX Hacks
       sed -i -e "s/memory_limit = 128M /memory_limit = 256M/g" /etc/php/5.6/apache2/php.ini && \
       a2disconf other-vhosts-access-log.conf && \
       a2enmod rewrite && \
       rm -rf /var/log/* && \
       mkdir -p /var/log/asterisk && \
       mkdir -p /var/log/apache2 && \
       mkdir -p /var/log/httpd && \

### Zabbix Setup
       echo '%zabbix ALL=(asterisk) NOPASSWD:/usr/sbin/asterisk' >> /etc/sudoers && \

### Setup for Data Persistence
       mkdir -p /assets/config/var/lib/ /assets/config/home/ && \
       mv /home/asterisk /assets/config/home/ && \
       ln -s /data/home/asterisk /home/asterisk && \
       mv /var/lib/asterisk /assets/config/var/lib/ && \
       ln -s /data/var/lib/asterisk /var/lib/asterisk && \
       mkdir -p /assets/config/var/run/ && \
       mv /var/run/asterisk /assets/config/var/run/ && \
       mv /var/lib/mysql /assets/config/var/lib/ && \
       ln -s /data/var/run/asterisk /var/run/asterisk && \
       rm -rf /var/spool/asterisk && \
       ln -s /data/var/spool/asterisk /var/spool/asterisk && \
       rm -rf /etc/asterisk && \
       ln -s /data/etc/asterisk /etc/asterisk

### Files Add
   ADD install /

### Networking Configuration
EXPOSE 80 443 4569 5060 5160 8001 8003 8008 8009 18000-20000/udp
