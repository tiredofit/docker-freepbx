# hub.docker.com/r/tiredofit/freepbx

[![Build Status](https://img.shields.io/docker/cloud/build/tiredofit/freepbx.svg)](https://hub.docker.com/r/tiredofit/freepbx)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/freepbx.svg)](https://hub.docker.com/r/tiredofit/freepbx)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/freepbx.svg)](https://hub.docker.com/r/tiredofit/freepbx)
[![Docker Layers](https://images.microbadger.com/badges/image/tiredofit/freepbx.svg)](https://microbadger.com/images/tiredofit/freepbx)


## Introduction

This will build a container for [FreePBX](https://www.freepbx.org) - A Voice over IP manager for Asterisk.
Upon starting this image it will give you a turn-key PBX system for SIP calling.

* Latest release FreePBX 15
* Latest release Asterisk 17
* Choice of running embedded database or modifies to support external MariaDB Database and only require one DB.
* Supports data persistence
* Fail2Ban installed to block brute force attacks
* Debian Buster base w/ Apache2
* NodeJS 10.x
* Automatically installs User Control Panel and displays at first page
* Option to Install [Flash Operator Panel 2](https://www.fop2.com/)
* Customizable FOP and Admin URLs

This container uses [tiredofit/debian:buster](https://hub.docker.com/r/tiredofit/debian) as a base.

**If you are presently running this image when it utilized FreePBX 14 and
Asterisk 14 and can no longer use your image, please see [this post](https://github.com/tiredofit/docker-freepbx/issues/51)**


[Changelog](CHANGELOG.md)

## Authors

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents

- [Introduction](#introduction)
- [Authors](#authors)
- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Quick Start](#quick-start)
- [Configuration](#configuration)
  - [Data-Volumes](#data-volumes)
  - [Environment Variables](#environment-variables)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [References](#references)

## Prerequisites

This image assumes that you are using a reverse proxy such as
[jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) and optionally the [Let's Encrypt Proxy
Companion @ https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)
in order to serve your pages. However, it will run just fine on it's own if you map appropriate ports.

You will also need an external MySQL/MariaDB container, although it can use an internally provided service (not recommended).

## Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/freepbx) and is the recommended method of installation.


```bash
docker pull tiredofit/freepbx:(imagetag)
```
The following image tags are available:

* `15` - Asterisk 17, Freepbx 15 - Debian Buster (latest build)
* `14` - Asterisk 14, Freepbx 14 - Debian Stretch (latest build)
* `latest` - Asterisk 17, Freepbx 15 - Debian Buster (Same as `15`)

You can also visit the image tags section on Docker hub to pull a version that follows the CHANGELOG.


### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/).
See the example's folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
* Make [networking ports](#networking) available for public access if necessary

*The first boot can take from 3 minutes - 30 minutes depending on your internet connection as there is a considerable amount of downloading to do!*

Login to the web server's admin URL (default /admin) and enter in your admin username, admin password, and email address and start configuring the system!

## Configuration

### Data-Volumes

The container supports data persistence and during Dockerfile build creates symbolic links for
`/var/lib/asterisk`, `/var/spool/asterisk`, `/home/asterisk`, and `/etc/asterisk`.
Upon startup configuration files are copied and generated to support portability.

The following directories are used for configure and can be mapped for persistent storage.

| Directory                                                                                             | Description                                                              |
| ----------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| `/certs`                                                                                              | Drop your certificates here for TLS w/PJSIP / UCP / HTTPd/ FOP           |
| `/var/www/html`                                                                                       | FreePBX web files                                                        |
| `/var/log/`                                                                                           | Apache, Asterisk and FreePBX Log Files                                   |
| `/data`                                                                                               | Data persistence for Asterisk and FreePBX and FOP                        |
| `/assets/custom`                                                                                      | *OPTIONAL* - If you would like to overwrite some files in the container, |
| put them here following the same folder structure for anything underneath the /var/www/html directory |

### Environment Variables


Along with the environment variables from the [Base image](https://hub.docker.com/r/tiredofit/debian),
below is the complete list of available options that can be used to customize your installation.

| Parameter                    | Description                                                                        | Default         |
| ---------------------------- | ---------------------------------------------------------------------------------- | --------------- |
| `ADMIN_DIRECTORY`            | What folder to access admin panel                                                  | `/admin`        |
| `DB_EMBEDDED`                | Allows you to use an internally provided MariaDB Server e.g. `TRUE` or `FALSE`     |                 |
| `DB_HOST`                    | Host or container name of MySQL Server e.g. `freepbx-db`                           |                 |
| `DB_PORT`                    | MySQL Port                                                                         | `3306`          |
| `DB_NAME`                    | MySQL Database name e.g. `asterisk`                                                |                 |
| `DB_USER`                    | MySQL Username for above database e.g. `asterisk`                                  |                 |
| `DB_PASS`                    | MySQL Password for above database e.g. `password`                                  |                 |
| `ENABLE_FAIL2BAN`            | Enable Fail2ban to block the "bad guys"                                            | `TRUE`          |
| `ENABLE_FOP`                 | Enable Flash Operator Panel                                                        | `FALSE`         |
| `ENABLE_SSL`                 | Enable HTTPd to serve SSL requests                                                 | `FALSE`         |
| `ENABLE_XMPP`                | Enable XMPP Module with MongoDB                                                    | `FALSE`         |
| `ENABLE_VM_TRANSCRIBE`       | Enable Voicemail Transcription with IBM Watson                                     | `FALSE`         |
| `FOP_DIRECTORY`              | What folder to access FOP                                                          | `/fop`          |
| `HTTP_PORT`                  | HTTP listening port                                                                | `80`            |
| `HTTPS_PORT`                 | HTTPS listening port                                                               | `443`           |
| `INSTALL_ADDITIONAL_MODULES` | Comma separated list of modules to additionally install on first container startup |                 |
| `RTP_START`                  | What port to start RTP transmissions                                               | `18000`         |
| `RTP_FINISH`                 | What port to start RTP transmissions                                               | `20000`         |
| `UCP_FIRST`                  | Load UCP as web frontpage `TRUE` or `FALSE`                                        | `TRUE`          |
| `TLS_CERT`                   | TLS certificate to drop in /certs for HTTPS if no reverse proxy                    |                 |
| `TLS_KEY`                    | TLS Key to drop in /certs for HTTPS if no reverse proxy                            |                 |
| `WEBROOT`                    | If you wish to install to a subfolder use this. Example: `/var/www/html/pbx`       | `/var/www/html` |
| `VM_TRANSCRIBE_APIKEY`       | API Key from Watson See [tutorial](http://nerdvittles.com/?page_id=25616)          |                 |
| `VM_TRANSCRIBE_MODEL`        | Watson Voice Model - See [here](https://cloud.ibm.com/docs/speech-to-text?topic=speech-to-text-models) for list | `en-GB_NarrowbandModel`

*`ADMIN_DIRECTORY ` and `FOP_DIRECTORY` may not work correctly if `WEBROOT` is changed or `UCP_FIRST=FALSE`*

If setting `ENABLE_VM_TRANSCRIBE=TRUE` you will need to change the `mailcmd` in Freepbx voicemail settings to `/usr/bin/watson-transcription` and set the API Key.

### Networking

The following ports are exposed.

| Port              | Description |
| ----------------- | ----------- |
| `80`              | HTTP        |
| `443`             | HTTPS       |
| `4445`            | FOP         |
| `4569`            | IAX         |
| `5060`            | PJSIP       |
| `5160`            | SIP         |
| `8001`            | UCP         |
| `8003`            | UCP SSL     |
| `8008`            | UCP         |
| `8009`            | UCP SSL     |
| `18000-20000/udp` | RTP ports   |


### Fail2Ban

* For fail2ban rules to kickin, the `security` log level needs to be enable for asterisk `full` log file. This can be done from the Settings > Log File Settings > Log files.

## Maintenance

* There seems to be a problem with the CDR Module when updating where it refuses to update when using an external DB Server.
If that happens, simply enter the container (as shown below) and execute `upgrade-cdr`, which will download the latest CDR module,
apply a tweak, install, and reload the system for you.

# Known Bugs

* When installing Parking Lot or Feature Codes you sometimes get `SQLSTATE[22001]: String data, right truncated:
1406 Data too long for column 'helptext' at row 1`. To resolve login to your SQL server and issue this statement:
`alter table featurecodes modify column helptext varchar(500);`
* If you find yourself needing to update the framework or core modules and experience issues, enter the container and
run `upgrade-core` which will truncate the column and auto upgrade the core and framework modules.

### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is e.g. freepbx) bash
```

## References

* https://freepbx.org/
