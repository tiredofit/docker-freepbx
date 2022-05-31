# github.com/tiredofit/docker-freepbx

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-freepbx?style=flat-square)](https://github.com/tiredofit/docker-freepbx/releases/latest)
[![Build Status](https://img.shields.io/github/workflow/status/tiredofit/docker-freepbx/build?style=flat-square)](https://github.com/tiredofit/docker-freepbx/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/alpine.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/alpine/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/alpine.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/alpine/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

* * *

## Introduction

Dockerfile to build a [FreePBX](https://www.freepbx.org) - A Voice over IP manager for Asterisk.
Upon starting this image it will give you a turn-key PBX system for SIP calling.

* Latest release FreePBX 15
* Latest release Asterisk 17
* Choice of running embedded database or modifies to support external MariaDB Database and only require one DB.
* Supports data persistence
* Fail2Ban installed to block brute force attacks
* Debian Buster base w/ Apache2
* NodeJS 13.x
* Automatically installs User Control Panel and displays at first page
* Option to Install [Flash Operator Panel 2](https://www.fop2.com/)
* Customizable FOP and Admin URLs

**If you are presently running this image when it utilized FreePBX 14 and
Asterisk 14 and can no longer use your image, please see [this post](https://github.com/tiredofit/docker-freepbx/issues/51)**


[Changelog](CHANGELOG.md)

## Maintainer

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents

- [Introduction](#introduction)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
  - [Networking](#networking)
  - [Fail2Ban](#fail2ban)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)
-
## Prerequisites and Assumptions
*  Assumes you are using some sort of SSL terminating reverse proxy such as:
   *  [Traefik](https://github.com/tiredofit/docker-traefik)
   *  [Nginx](https://github.com/jc21/nginx-proxy-manager)
   *  [Caddy](https://github.com/caddyserver/caddy)
* You must have access to create records on your DNS server to be able to setup the demo installation before configuration.


You will also need an external MySQL/MariaDB container, although it can use an internally provided service (not recommended).

## Installation

### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/freepbx) and is the recommended method of installation.

```bash
docker pull tiredofit/freepbx:(imagetag)
```

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):


| Version | Container OS | FreePBX Version | Tag      |
| ------- | ------------ | --------------- | -------- |
| latest  | Debian       | 15.x            | `latest` |
| 15      | Debian       | 15.x            | `15`     |
| 14      | Debian       | 14.x            | `14`     |


## Configuration

### Quick Start


 The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image. A Sample `docker-compose.yml` is provided that will work right out of the box for most people without any fancy optimizations.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
* Make [networking ports](#networking) available for public access if necessary

*The first boot can take from 3 minutes - 30 minutes depending on your internet connection as there is a considerable amount of downloading to do!*

Login to the web server's admin URL (default /admin) and enter in your admin username, admin password, and email address and start configuring the system!

### Persistent Storage

The container supports data persistence and during Dockerfile build creates symbolic links for
`/var/lib/asterisk`, `/var/spool/asterisk`, `/home/asterisk`, and `/etc/asterisk`.
Upon startup configuration files are copied and generated to support portability.

The following directories should be mapped for persistent storage in order to utilize the container effectively.


| Directory        | Description                                                                                           |
| ---------------- | ----------------------------------------------------------------------------------------------------- |
| `/certs`         | Drop your certificates here for TLS w/PJSIP / UCP / HTTPd/ FOP                                        |
| `/var/www/html`  | FreePBX web files                                                                                     |
| `/var/log/`      | Apache, Asterisk and FreePBX Log Files                                                                |
| `/data`          | Data persistence for Asterisk and FreePBX and FOP                                                     |
| `/assets/custom` | *OPTIONAL* - If you would like to overwrite some files in the container,                              |
|                  | put them here following the same folder structure for anything underneath the /var/www/html directory |
### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/debian) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`, `nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-debian/) | Customized Image based on Debian Linux |

Along with the environment variables from the [Base image](https://hub.docker.com/r/tiredofit/debian),
below is the complete list of available options that can be used to customize your installation.

| Parameter                    | Description                                                                                                     | Default                 |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `ADMIN_DIRECTORY`            | What folder to access admin panel                                                                               | `/admin`                |
| `DB_EMBEDDED`                | Allows you to use an internally provided MariaDB Server e.g. `TRUE` or `FALSE`                                  |                         |
| `DB_HOST`                    | Host or container name of MySQL Server e.g. `freepbx-db`                                                        |                         |
| `DB_PORT`                    | MySQL Port                                                                                                      | `3306`                  |
| `DB_NAME`                    | MySQL Database name e.g. `asterisk`                                                                             |                         |
| `DB_USER`                    | MySQL Username for above database e.g. `asterisk`                                                               |                         |
| `DB_PASS`                    | MySQL Password for above database e.g. `password`                                                               |                         |
| `ENABLE_FAIL2BAN`            | Enable Fail2ban to block the "bad guys"                                                                         | `TRUE`                  |
| `ENABLE_FOP`                 | Enable Flash Operator Panel                                                                                     | `FALSE`                 |
| `ENABLE_SSL`                 | Enable HTTPd to serve SSL requests                                                                              | `FALSE`                 |
| `ENABLE_XMPP`                | Enable XMPP Module with MongoDB                                                                                 | `FALSE`                 |
| `ENABLE_VM_TRANSCRIBE`       | Enable Voicemail Transcription with IBM Watson                                                                  | `FALSE`                 |
| `FOP_DIRECTORY`              | What folder to access FOP                                                                                       | `/fop`                  |
| `HTTP_PORT`                  | HTTP listening port                                                                                             | `80`                    |
| `HTTPS_PORT`                 | HTTPS listening port                                                                                            | `443`                   |
| `INSTALL_ADDITIONAL_MODULES` | Comma separated list of modules to additionally install on first container startup                              |                         |
| `RTP_START`                  | What port to start RTP transmissions                                                                            | `18000`                 |
| `RTP_FINISH`                 | What port to start RTP transmissions                                                                            | `20000`                 |
| `UCP_FIRST`                  | Load UCP as web frontpage `TRUE` or `FALSE`                                                                     | `TRUE`                  |
| `TLS_CERT`                   | TLS certificate to drop in /certs for HTTPS if no reverse proxy                                                 |                         |
| `TLS_KEY`                    | TLS Key to drop in /certs for HTTPS if no reverse proxy                                                         |                         |
| `WEBROOT`                    | If you wish to install to a subfolder use this. Example: `/var/www/html/pbx`                                    | `/var/www/html`         |
| `VM_TRANSCRIBE_APIKEY`       | API Key from Watson See [tutorial](http://nerdvittles.com/?page_id=25616)                                       |                         |
| `VM_TRANSCRIBE_MODEL`        | Watson Voice Model - See [here](https://cloud.ibm.com/docs/speech-to-text?topic=speech-to-text-models) for list | `en-GB_NarrowbandModel` |

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

## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) personalized support.
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.
## References


* https://freepbx.org/
