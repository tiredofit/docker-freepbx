# hub.docker.com/tiredofit/freepbx

# Introduction

This will build a container for [FreePBX](https://www.freepbx.org) - A Voice over IP Manager for Asterisk. Upon starting this image it will give you a turn-key PBX system for SIP calling. 

* Latest release Version 14
* Compiles and Installs Asterisk 14
* Modifies to support external MySQL Database and only require one DB.
* Supports Data Persistence
* Fail2Ban installed to block brute force attacks
* Debian Stretch Base w/ Nginx and PHP-FPM
        
This Container uses [tiredofit/debian:stretch](https://hub.docker.com/r/tiredofit/debian) as a base.


[Changelog](CHANGELOG.md)

# Authors

- [Dave Conroy] [https://github.com/tiredofit]

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

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/tiredofit/nginx) and is the recommended method of installation.


```bash
docker pull hub.docker.com/tiredofit/freepbx
```

# Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
* Make [networking ports](#networking) available for public access if necessary

** The first boot can take from 3 minutes - 30 minutes depending on your internet connection as there is a considerable amount of downloading to do!

Login to the web server and enter in your admin username, admin password, and email address and start configuring the system!

# Configuration

### Data-Volumes

The container supports data persistence and during Dockerfile Build creates symbolic links for `/var/lib/asterisk`, `/var/spool/asterisk`, `/home/asterisk`, and `/etc/asterisk`. Upon startup configuration files are copied and generated to support portability.

The following directories are used for configuration and can be mapped for persistent storage.

| Directory    | Description                                                 |
|--------------|-------------------------------------------------------------|
|  `/certs`    | Drop your Certificates here for TLS w/PJSIP |
|  `/www/freepbx` | FreePBX web files |
|  `/var/log/asterisk` | Asterisk and FreePBX Log Files |
|  `/data`      | Data Persistence for Asterisk and Freepbx 
      

### Environment Variables


Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/alpine), below is the complete list of available options that can be used to customize your installation.

| Parameter        | Description                            |
|------------------|----------------------------------------|
| `DB_HOST` | Host or container name of MySQL Server e.g. `freepbx-db` |
| `DB_PORT` | MySQL Port - Default `3306` |
| `DB_NAME` | MySQL Database name e.g. `asterisk` |
| `DB_USER` | MySQL Username for above Database e.g. `asterisk` |
| `DB_PASS` | MySQL Password for above Database e.g. `password`|
| `RTP_START` | What port to start RTP Transmissions - Default `18000` |
| `RTP_FINISH` | What port to start RTP Transmissions - Default `20000` |


### Networking

The following ports are exposed.

| Port      | Description |
|-----------|-------------|
| `80`      | HTTP        |
| `5060`    | PJSIP         |
| `5160`    | SIP         |
| 18000-2000/udp | RTP Ports |

# Maintenance

* There seems to be a problem with the CDR Module when updating where it refuses to update. If that happens, simply enter the container (as shown below) and execute `upgrade-cdr`, which will download the latest CDR module, apply a tweak, install, and reload the system for you.


#### Shell Access

For debugging and maintenance purposes you may want access the containers shell. 

```bash
docker exec -it (whatever your container name is e.g. freepbx) bash
```

# References

* https://freepbx.org/




