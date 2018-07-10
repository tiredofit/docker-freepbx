## 2.6 - 2018-07-02 <dave at tiredofit dot ca>

* Fix logrotate for Apache

## 2.5 - 2018-07-02 <dave at tiredofit dot ca>

* MSMTP Cleanup courtesy of @joeyberkovitz

## 2.41 - 2018-06-06 <dave at tiredofit dot ca>

Still fixing 2.4 release

## 2.4 - 2018-06-06 <dave at tiredofit dot ca>

* Update for HTTP_PORT/HTTPS_PORT Variable

## 2.3 - 2018-06-06 <dave at tiredofit dot ca>

* Custom Files Modification to support adding custom files outside of webroot - Follow general linux filesystem

## 2.22 - 2018-06-01 <dave at tiredofit dot ca>

* Final Fop2 Fix to change fop2.cfg to look to 127.0.0.1 instead of localhost

## 2.21 - 2018-06-01 <dave at tiredofit dot ca>

* Add logrotate and output FOP log to /var/log/fop/

## 2.2 - 2018-06-01 <dave at tiredofit dot ca>

* Fix for FOP Installation

## 2.1 - 2018-06-01 <dave at tiredofit dot ca>

* Added `HTTP_PORT` Variable
* Added `HTTPS_PORT` Variable

## 2.0 - 2018-05-31 <dave at tiredofit dot ca>

* Flash Operator Panel 2 integrated (no need to re-install, will detect if you are upgrading)
* Customizable admin URL
* Customizable FOP URL

## 1.11 - 2018-05-31 <dave at tiredofit dot ca>

* Fail2ban Logrotate Fixup

## 1.10 - 2018-05-30 <dave at tiredofit dot ca>

* Additional Tweaks for CDR and CEL to be recorded without issues.

## 1.9 - 2018-05-30 <dave at tiredofit dot ca>

* Add UCP_FIRST env var to display the UCP first instead of the FreePBX Admin screen

## 1.8 - 2018-05-07 <dave at tiredofit dot ca>

* Tweak to ODBC Driver to allow for CDR to be recorded.

## 1.7 - 2018-05-07 <dave at tiredofit dot ca>

* Compile Jansson
* Compile BCG729
* Compile G729 Codecs instead of relying on prebuilt binary

## 1.6 - 2018-04-17 <dave at tiredofit dot ca>

* Add custom file support - Drop your files in /assets/custom following the /var/www/html directory structure and they will get overwritten (Use with care, modules may not work after this after upgrading)

## 1.53 - 2018-04-14 <dave at tiredofit dot ca>

* Tweak for Asterisk Logging

## 1.52 - 2018-04-14 <dave at tiredofit dot ca>

* Update PHP to support SMTP sending

## 1.51 - 2018-04-10 <dave at tiredofit dot ca>

* Add php5.6-ldap for LDAP Lookups

## 1.5 - 2018-04-08 <dave at tiredofit dot ca>

* Add libsrtp for TLS RTP

## 1.42 - 2018-04-08 <dave at tiredofit dot ca>

* Apache Cleanup

## 1.41 - 2018-04-08 <dave at tiredofit dot ca>

* Apache2 Fixup for Extended Status

## 1.4 - 2018-04-08 <dave at tiredofit dot ca>

* Add Zabbix Monitoring for Asterisk and Apache
* Shuffle Log Locations around a bit (just map /var/log as a directory now for seperated service folders)
* Tweak Fail2ban Scripts to properly block PJSIP
* Add Fail2ban script to block FreePBX authentication failures (Admin and UCP)
* Add ability to disable Fail2ban on Startup

## 1.32 - 2018-04-06 <dave at tiredofit dot ca>

* Set X-Real-IP in Apache2 logs, fix log location

## 1.31 - 2018-04-06 <dave at tiredofit dot ca>

* Sanity test for Apache logdir if following example/docker-compose.yml

## 1.3 - 2018-04-06 <dave at tiredofit dot ca>

* SSL Support for Apache Included - Map /certs volume somewhere, drop your keys in and set ENV Var `TLS_CERT` and `TLS_KEY` and set `ENABLE_SSL=TRUE`
* Add logrotate for fail2ban and apache
* Added some error checking to exit when bad stuff happens

## 1.22 2018-04-05 <dave at tiredofit dot ca>

* Fix /etc/amportal.conf permissions after initial install courtesy of github.com/flaviut

## 1.21 2018-04-01 <dave at tiredofit dot ca>

* Be more verbose when Webroot environment variable is being changed
* Disable Indexing if custom webroot enabled

## 1.2 2018-04-01 <dave at tiredofit dot ca>

* Updated Asterisk Compilation options courtesy of github.com/flaviut

## 1.1 2018-03-31 <dave at tiredofit dot ca>

* Cleanup some of the Embedded DB Routines
* Expose more ports
* Fix RTP Port Range Modification in Database
* Update docker-compose.yml example
* Added WEBROOT variable for adding subfolder based install

## 1.0 2018-03-15 <dave at tiredofit dot ca>

* Production Ready
* Fixes Previous Download and installation steps as reported by Github users
* Installs all latest applications from --edge to avoid any signature failures
* Compiles and installs app_confbridge

## 0.82 2018-01-09 <mattcvinvent@github.com>

* Added DB_PORT verification to SQL strings

## 0.81 2017-12-14 <dave at tiredofit dot ca>

* Tweak for DB_EMBEDDED acting strange

## 0.8 2017-12-14 <dave at tiredofit dot ca>

* Support both embedded and external MariaDB servers via DB_EMBEDDED environment variable

## 0.7 2017-12-14 <dave at tiredofit dot ca>

* Debian Stretch
* Asterisk 14
* NodeJS 8.x
* Apache2 (Potentially will revert to Nginx again later)
* Seperate MariaDB database support as per original 0.2 build
* FreePBX 14
* UCP installed as part of freepbx initial install


## 0.7test 2017-12-12 <dave at tiredofit dot ca>

* Test Single Container Mode proving that UCP works with Apache (Didn't work with Nginx)
* Next release will decide which way forward (Split DB or Not)

## 0.6 2017-11-18 <dave at tiredofit dot ca>

* Fix Fail2ban to properly load Asterisk Jails

## 0.51 2017-11-17 <dave at tiredofit dot ca>

* Fix Logrotate

## 0.5 2017-10-30 <dave at tiredofit dot ca>

* Remove BUILDNATIVE compiler flag for compatibility

## 0.4 2017-10-17 <dave at tiredofit dot ca>

* Composer - UCP Currently Broken

## 0.3 2017-10-17 <dave at tiredofit dot ca>

* Added NodeJS for UCP
* Added SpanDSP and Libtiff for Fax
* Fixed some install routines

## 0.2 2017-10-01 <dave at tiredofit dot ca>

* Ability to utilize same FreePBX Configuration Database for CDR Records
* Ability to dynamically set the RTP Ports upon startup
* Overall cleanup and size optimizations

## 0.1 2017-10-01 <dave at tiredofit dot ca>

* Initial Relase
* Asterisk 14
* FreePBX 14
* Nginx
* Fail2ban
* PHP-FPM 5.6
* Debian Stretch
* Requires External DB Server

