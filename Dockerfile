FROM tiredofit/nodejs:10-debian-latest
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Set defaults
ENV ASTERISK_VERSION=17.4.0 \
    FREEPBX_VERSION=15.0.16.55 \
    MARIAODBC_VERSION=3.1.7 \
    BCG729_VERSION=1.0.4 \
    SPANDSP_VERSION=20180108 \
    DB_EMBEDDED=TRUE \
    UCP_FIRST=TRUE

### Pin libxml2 packages to Debian repositories
RUN echo "Package: libxml2*" > /etc/apt/preferences.d/libxml2 && \
    echo "Pin: release o=Debian,n=buster" >> /etc/apt/preferences.d/libxml2 && \
    echo "Pin-Priority: 501" >> /etc/apt/preferences.d/libxml2

### Install dependencies
RUN set -x && \
    curl https://packages.sury.org/php/apt.gpg | apt-key add - && \
    echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/deb.sury.org.list && \
    curl https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add - && \
    echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main" > /etc/apt/sources.list.d/mongodb-org.list && \
    apt-get update  && \
    apt-get -o Dpkg::Options::="--force-confold" upgrade -y && \
    \
### Install development dependencies
    \
    ASTERISK_BUILD_DEPS='\
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
                        libsrtp2-dev \
                        libssl-dev \
                        libtiff-dev \
                        libtool-bin \
                        libvorbis-dev \
                        libxml2-dev \
                        linux-headers-amd64 \
                        python-dev \
                        subversion \
                        unixodbc-dev \
                        uuid-dev \
                        ' && \
    \
### Install runtime dependencies
    apt-get install --no-install-recommends -y \
                    $ASTERISK_BUILD_DEPS \
                    apache2 \
                    composer \
                    fail2ban \
                    flite \
                    ffmpeg \
                    git \
                    g++ \
                    iptables \
                    lame \
                    libiodbc2 \
                    libicu63 \
                    libicu-dev \
                    libsrtp2-1 \
                    locales \
                    locales-all \
                    mariadb-client \
                    mariadb-server \
                    mongodb-org \
                    mpg123 \
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
                    php5.6-intl \
                    php-pear \
                    pkg-config \
                    sipsak \
                    sngrep \
                    sox \
                    sqlite3 \
                    tcpdump \
                    tcpflow \
                    unixodbc \
                    uuid \
                    wget \
                    whois \
                    xmlstarlet \
                    && \
    \
### Install MariaDB ODBC connector
    cd /usr/src && \
    mkdir -p mariadb-connector && \
    curl -sSL  https://downloads.mariadb.com/Connectors/odbc/connector-odbc-${MARIAODBC_VERSION}/mariadb-connector-odbc-${MARIAODBC_VERSION}-ga-debian-x86_64.tar.gz | tar xvfz - -C /usr/src/mariadb-connector && \
    cp mariadb-connector/lib/libmaodbc.so /usr/lib/x86_64-linux-gnu/odbc/ && \
    \
### Add users
    addgroup --gid 2600 asterisk && \
    adduser --uid 2600 --gid 2600 --gecos "Asterisk User" --disabled-password asterisk && \
    \
### Build SpanDSP
    mkdir -p /usr/src/spandsp && \
    curl -kL http://sources.buildroot.net/spandsp/spandsp-${SPANDSP_VERSION}.tar.gz | tar xvfz - --strip 1 -C /usr/src/spandsp && \
    cd /usr/src/spandsp && \
    ./configure && \
    make && \
    make install && \
    \
### Build Asterisk
    cd /usr/src && \
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
    make install-headers && \
    make config && \
    ldconfig && \
    \
#### Add G729 codecs
    git clone https://github.com/BelledonneCommunications/bcg729 /usr/src/bcg729 && \
    cd /usr/src/bcg729 && \
    git checkout tags/$BCG729_VERSION && \
    ./autogen.sh && \
    ./configure --libdir=/lib && \
    make && \
    make install && \
    \
    mkdir -p /usr/src/asterisk-g72x && \
    curl https://bitbucket.org/arkadi/asterisk-g72x/get/master.tar.gz | tar xvfz - --strip 1 -C /usr/src/asterisk-g72x && \
    cd /usr/src/asterisk-g72x && \
    ./autogen.sh && \
    ./configure --with-bcg729 --enable-penryn && \
    make && \
    make install && \
    \
### Cleanup
    mkdir -p /var/run/fail2ban && \
    cd / && \
    rm -rf /usr/src/* /tmp/* /etc/cron* && \
    apt-get purge -y $ASTERISK_BUILD_DEPS libspandsp-dev && \
    apt-get -y autoremove && \
    apt-get clean && \
    apt-get install -y make && \
    rm -rf /var/lib/apt/lists/* && \
    \
### FreePBX hacks
    sed -i -e "s/memory_limit = 128M/memory_limit = 256M/g" /etc/php/5.6/apache2/php.ini && \
    sed -i 's/\(^upload_max_filesize = \).*/\120M/' /etc/php/5.6/apache2/php.ini && \
    a2disconf other-vhosts-access-log.conf && \
    a2enmod rewrite && \
    a2enmod headers && \
    rm -rf /var/log/* && \
    mkdir -p /var/log/asterisk && \
    mkdir -p /var/log/apache2 && \
    mkdir -p /var/log/httpd && \
    \
### Zabbix setup
    echo '%zabbix ALL=(asterisk) NOPASSWD:/usr/sbin/asterisk' >> /etc/sudoers && \
    \
### Setup for data persistence
    mkdir -p /assets/config/var/lib/ /assets/config/home/ && \
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
    mkdir -p /var/run/mongodb && \
    rm -rf /var/lib/mongodb && \
    ln -s /data/var/lib/mongodb /var/lib/mongodb && \
    ln -s /data/var/run/asterisk /var/run/asterisk && \
    rm -rf /var/spool/asterisk && \
    ln -s /data/var/spool/asterisk /var/spool/asterisk && \
    rm -rf /etc/asterisk && \
    ln -s /data/etc/asterisk /etc/asterisk

### Networking configuration
EXPOSE 80 443 4445 4569 5060/udp 5160/udp 5061 5161 8001 8003 8008 8009 18000-20000/udp

### Files add
ADD install /
