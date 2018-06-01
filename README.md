
# hub.docker.com/r/tiredofit/freepbx

[![Build Status](https://img.shields.io/docker/build/tiredofit/freepbx.svg)](https://hub.docker.com/r/tiredofit/freepbx)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/freepbx.svg)](https://hub.docker.com/r/tiredofit/freepbx)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/freepbx.svg)](https://hub.docker.com/r/tiredofit/freepbx)
[![Docker Layers](https://images.microbadger.com/badges/image/tiredofit/freepbx.svg)](https://microbadger.com/images/tiredofit/freepbx)


# Introduction

This will build a container for [FreePBX](https://www.freepbx.org) - A Voice over IP Manager for Asterisk. Upon starting this image it will give you a turn-key PBX system for SIP calling. 

* Latest release Version 14
* Compiles and Installs Asterisk 14
* Choice of running embedded database or Modifies to support external MySQL Database and only require one DB.
* Supports Data Persistence
* Fail2Ban installed to block brute force attacks
* Debian Stretch Base w/ Apache2
* NodeJS 8.x
* Automatically Installs User Control Panel and displays at first page
* Option to Install [Flash Operator Panel 2](https://www.fop2.com/)
* Customizable FOP and Admin URLs

        
This Container uses [tiredofit/debian:stretch](https://hub.docker.com/r/tiredofit/debian) as a base.


[Changelog](CHANGELOG.md)

# Authors

- [Dave Conroy](https://github.com/tiredofit)

# Table of Contents

- [Introduction](#introduction)
    - [Changelog](CHANGELOG.md)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
    - [Data Volumes](#data-volumes)
    - [Environment Variables](#environmentvariables)   
    - [Networking](#networking)
- [Maintenance](#maintenance)
    - [Shell Access](#shell-access)
   - [References](#references)

# Prerequisites

This image assumes that you are using a reverse proxy such as 
[jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) and optionally the [Let's Encrypt Proxy 
Companion @ 
https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion) 
in order to serve your pages. However, it will run just fine on it's own if you map appropriate ports.

You will also need an external MySQL/MariaDB Container

# Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/freepbx) and is the recommended method of installation.


```bash
docker pull tiredofit/freepbx
```

# Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
* Make [networking ports](#networking) available for public access if necessary

*The first boot can take from 3 minutes - 30 minutes depending on your internet connection as there is a considerable amount of downloading to do!*

Login to the web server and enter in your admin username, admin password, and email address and start configuring the system!

# Configuration

### Data-Volumes

The container supports data persistence and during Dockerfile Build creates symbolic links for `/var/lib/asterisk`, `/var/spool/asterisk`, `/home/asterisk`, and `/etc/asterisk`. Upon startup configuration files are copied and generated to support portability.

The following directories are used for configuration and can be mapped for persistent storage.

| Directory    | Description                                                 |
|--------------|-------------------------------------------------------------|
|  `/certs`    | Drop your Certificates here for TLS w/PJSIP / UCP / HTTPd/ FOP |
|  `/www/freepbx` | FreePBX web files |
|  `/var/log/` | Apache, Asterisk and FreePBX Log Files |
|  `/data`      | Data Persistence for Asterisk and Freepbx and FOP
|  `/assets/custom` | *OPTIONAL* - If you would like to overwrite some files in the container, put them here following the same folder structure for anything underneath the /var/www/html directory |

### Environment Variables


Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/alpine), below is the complete list of available options that can be used to customize your installation.

| Parameter        | Description                            |
|------------------|----------------------------------------|
| `ADMIN_DIRECTORY` | What folder to access admin panel - Default `/admin` |
| `DB_EMBEDDED` | Allows you to use an internally provided MariaDB Server e.g. `TRUE` or `FALSE` |
| `DB_HOST` | Host or container name of MySQL Server e.g. `freepbx-db` |
| `DB_PORT` | MySQL Port - Default `3306` |
| `DB_NAME` | MySQL Database name e.g. `asterisk` |
| `DB_USER` | MySQL Username for above Database e.g. `asterisk` |
| `DB_PASS` | MySQL Password for above Database e.g. `password`|
| `ENABLE_FAIL2BAN` | Enable Fail2ban to block the bad guys - Default `TRUE`|
| `ENABLE_FOP` | Enable Flash Operator Panel - Default `TRUE` |
| `ENABLE_SSL` | Enable HTTPd to serve SSL requests - Default `FALSE`|
| `HTTP_PORT`  | HTTP Listening Port - Default `80` |
| `HTTPS_PORT`  | HTTPS Listening Port - Default `443` |
| `FOP_DIRECTORY` | What folder to access FOP - Default `/fop`
| `RTP_START` | What port to start RTP Transmissions - Default `18000` |
| `RTP_FINISH` | What port to start RTP Transmissions - Default `20000` |
| `UCP_FIRST` | Load UCP as web frontpage `TRUE/FALSE` - Default `TRUE` |
| `TLS_CERT` | TLS Certificate to drop in /certs for HTTPS if no reverse proxy |
| `TLS_KEY` | TLS Key to drop in /certs for HTTPS if no reverse proxy |
| `WEBROOT` | If you wish to install to a subfolder use this. Example: `/var/www/html/pbx` Default '/var/www/html'

*`ADMIN_DIRECTORY ` and `FOP_DIRECTORY` may not work correctly if `WEBROOT` is changed or `UCP_FIRST=FALSE`*

### Networking

The following ports are exposed.

| Port      | Description |
|-----------|-------------|
| `80`      | HTTP        |
| `443`     | HTTPS       |
| `4445`    | FOP         |
| `4569`    | IAX         |
| `5060`    | PJSIP       |
| `5160`    | SIP         |
| `8001`    | UCP         |
| `8003`    | UCP SSL     |
| `8008`    | UCP         |
| `8009`    | UCP SSL     |
| `18000-20000/udp` | RTP Ports |

# Maintenance

* There seems to be a problem with the CDR Module when updating where it refuses to update when using an external DB Server. If that happens, simply enter the container (as shown below) and execute `upgrade-cdr`, which will download the latest CDR module, apply a tweak, install, and reload the system for you.

# Known Bugs

* When installing Parking Lot or Feature Codes you sometimes get `SQLSTATE[22001]: String data, right truncated: 1406 Data too long for column 'helptext' at row 1`. To resolve login to your SQL server and issue this statement: `alter table featurecodes modify column helptext varchar(500);`
* If you find yourself needing to update the framework or core modules and experience issues, enter the container and run `upgrade-core` which will truncate the column and auto upgrade the core and framework modules.

#### Shell Access

For debugging and maintenance purposes you may want access the containers shell. 

```bash
docker exec -it (whatever your container name is e.g. freepbx) bash
```

# References

* https://freepbx.org/
