## 5.0.6 2020-08-15 <dave at tiredofit dot ca>

   ### Changed
      - Fix for FOP2 not starting up
      - Add debug statements to watson-transcription script
      - Repair issues with watson transcription


## 5.0.5 2020-08-14 <hobbit378@github>

   ### Fixed
      - Changed routines to limit socat to start if SMTP_HOST=localhost


## 5.0.4 2020-08-01 <dave at tiredofit dot ca>

   ### Added
      - Asterisk 17.6.0
      - Added capability of Voicemail transcription via IBM Watson (see /usr/sbin/watson-transcription)


## 5.0.3 2020-07-27 <dave at tiredofit dot ca>

   ### Changed
      - Set +x bit on 15-socat container initialization and runtime scripts


## 5.0.2 2020-07-13 <dave at tiredofit dot ca>

   ### Changed
      - Disable app_vooicemail_odbc and app_voicemail_imap causing problems with Voicemail working


## 5.0.1 2020-06-20 <rusxakep@github>

   ### Changed
      - Patch for version 5.0.0

## 5.0.0 2020-06-19 <rusxakep@github>

   ### Added
      - Asterisk 17.x support added
      - New Asterisk modules added to base image
      - G72x codec CPU-versioning support added
      - FreePBX 15.0.16.56 support added
      - USB dongle (huawei) module support added
      - MongoDB versioning support added
      - Sync build with latest base image features (00-container)
      - FreePBX keys added to avoid spam from gnupg in logs
      - FreePBX modules added (backup, filestore, fw_langpacks)
      - Fix MariaDB starting
      - Change external MariaDB ODBC drivers to internal (debian repository)
      - Some environment variables moved to \defaults to avoid rebuild image
      - socat as SMTP proxy added for new FreePBX modules  
      - Support for custom RTP ports added
    
   ### Changed
      - Cleaned up Documentation
      - ENABLE_CRON, ENABLE_SMTP now TRUE by default
      - Fix for incorrect privileges in doctrine FreePBX cache system
      - Extend featurecodes column in embedded database too
      - Fix '--x' execute bit in all asterisk modules
      - Fix MongoDB starting
      - Fix bash scripts (fix 'sed'-scripts, fix 'chown'-scripts with symlinks and so on ...)
      - Fix start/stop container scripts to avoid database corruption
      - Create additional agi-bin, backup, fax and outgoing directories
      - Fix XMPP service start/stop  
      - Change FOP2 Module to FALSE by default due to flash deprecation
      - RTP_START and RTP_FINISH values in embedded database
      - Fix issues with cron running as root
    

## 4.0.6 2020-06-08 <dave at tiredofit dot ca>

   ### Added
      - Support changes to tiredofit/debian base image


## 4.0.5.1 2020-05-08 <dave at tiredofit dot ca>

   ### Changed
      - Patchup for 4.0.5


## 4.0.4 2020-05-07 <dave at tiredofit dot ca>

   ### Added
      - Update Console command to advise how to access admin panel upon container has finished initializing


## 4.0.3 2020-03-29 <jwhostet@github>

   ### Changed
      - Fix Apache for duplicate Listen statement if using `ENABLE_SSL=TRUE`


## 4.0.2 2020-03-25 <dave at tiredofit dot ca>

   ### Added
      - Added sngrep, sipsak, tcpflow, tcpdump to image for troubleshooting SIP issues on request

## 4.0.1 2020-03-16 <dave at tiredofit dot ca>

   ### Changed
      - Fixup for internal mailing via msmtp


## 4.0.0 2020-03-11 <dave at tiredofit dot ca>

   ## Added
      - Option to Install Additional Modules on First Container Start

   ## Changed
      - Switch to Debian Buster
      - Asterisk 17.2.0
      - Freepbx Framework 15.0.16.45 
      - Reworked package install in Dockerfile
      - Reduced errors being shown re MongoDB/XMPP Module
      - Changed verbosity when installing modules
      - Other code optimizations
      - MariaDB ODBC Connector 2.0.19

## 3.9.5 2020-03-03 <dave at tiredofit dot ca>

   ### Changed
      - Fixed issues with SMTP configuration
      - Created temporary log directory for Flash Operator Panel installation
      
## 3.9.4 2020-02-10 <dave at tiredofit dot ca>

   ### Added
      - Move more defaults into functions files
      - Fix error with Cron starting before it Freepbx installs causing errors with persistent storage


## 3.9.3 2020-02-01 <dave at tiredofit dot ca>

   ### Changed
      - Spelling mistake fix for Log display
      - Fixed wrong function being called for checking is DB was available for External DB Container installs
      - Reworked CDR Hack for Single DB (external DB Container) installation (Thanks barhom@github)


## 3.9.2 2020-01-28 <dave at tiredofit dot ca>

   ### Added
      - Freepbx Framework 15.0.16.42

   ### Changed
      - Fix to allow UCP to build properly


## 3.9.1 2020-01-27 <dave at tiredofit dot ca>

   ### Changed
      - Fix spelling mistake in container startup script


## 3.9.0 2020-01-12 <dave at tiredofit dot ca>

   ### Added
      - Update to support new tiredofit/debian base images
      - Asterisk 16.7.0
      - FreePBX Framework 15.0.16.39


## 3.8.3 2019-11-29 <dave at tiredofit dot ca>

   ### Added
      - Asterisk 16.6.2
      - FreePBX 15.0.16.28

   ### Changed
      - Changed source location to continue building g72x codecs


## 3.8.2 2019-10-28 <dave at tiredofit dot ca>

* Asterisk 16.61
* FreePBX 15.0.16.21


## 3.8.1 2019-10-28 <ferow2k@github> 

* Add php56-intl

## 3.8 2019-09-13 <dave at tiredofit dot ca> + <ivanfillipov@github>

* Pinned LibXML2 to older version due to an upstream change and Asterisk can no longer detect 
* Updated Asterisk to 16.5.1
* Updated Freepbx to 15.0.16.15
* Changed Download Location of SpanDSP
* Downgrade Node to 10

## 3.7.2 2019-07-07 <dave at tiredofit dot ca>

* Repair broken upgrade command

## 3.7.1 2019-07-04 <dave at tiredofit dot ca>

* Freepbx 15.0.16.6

## 3.7 2019-06-07 <dave at tiredofit dot ca>

* Asterisk 16.4.0
* Freepbx 15.0.16.2
* Hack to solve issue #83 re /data/home/asterisk not being created

## 3.6 2019-05-10 <dave at tiredofit dot ca>

* Reintroduce Fax Capabilities and SpanDSP
* New way of importing GPG Keys
* Force Specific FreePBX Version to be installed (Presently 15.0.15.3)
* Rework hack for seperate DB Host upon install
* Add /var/spool/cron to the persistent data (Issue #56)

## 3.5.1 2019-05-06 <dave at tiredofit dot ca>

* NodeJS 12

## 3.5 2019-05-06 <dave at tiredofit dot ca>

* Asterisk 16.3.0
* Remove unneccessary ADD command

## 3.4 2019-05-02 <sylhero at github>

* Fix for UCP failing
* Added more Languages
* Change Module Load Order

## 3.3.1 2019-02-27 <dave at tiredofit dot ca>

* Downgrade MariaDB Connector to fix CDR Issues

## 3.3 2019-02-21 <dave at tiredofit dot ca>

* Embarassing fix for breaking first install
* Asterisk 16.2.0

## 3.2.1 2019-02-20 <dave at tiredofit dot ca>

* Fixup for restarting the container after first install
* Minor DB Fixes
* Removal of SpanDSP temporarily and app_fax due to problems with source site (soft-switch.org)

## 3.2 2019-02-06 <dave at tiredofit dot ca>

* Added MongoDB to support `ENABLE_XMPP` environment variable/installing XMPP module from inside FreePBX.
* A few more sanity checks to ensure installation completes

## 3.1 2019-02-06 <dave at tiredofit dot ca>

* Added Fax Support

## 3.0 2019-02-06 <dave at tiredofit dot ca>

This is a breaking release due to major version changes.
If attempting to run from a previous release and system detects Asterisk 14 and FreePBX instructions will be given on how to let container operate. New installations only in the 3.x series.

* Asterisk 16
* Freepbx 15
* NodeJS 11
* Multilanguage Support
* Many bugfixes
* Better Debug verbosity when `DEBUG_MODE=TRUE`

## 2.13 - 2019-01-31 <dave at tiredofit dot ca>

* Add Asterisk Version in startup step to prepare for upcoming image shift to Asterisk 16 and FreePBX 15

## 2.12 - 2018-12-27 <dave at tiredofit dot ca>

* Sort Defaults in Startup Script (cosmetic)
* Add cache dir upon first startup
* Fix internal ports exposure
* Change GPG Keyserver
* Change PHP Packages Source Location
* Update MariaDB Connector
* Fix Database Sanity Tests
* Reorder Module Download
* Add Warning for Self Signed Certificate
* Stop using edge versions on initial bootup, problems have been resolved which caused this on upstream

## 2.11 - 2018-11-20 <github:si458>

* Refinements to environment variables being TRUE/true or FALSE/false
* Fixup PHP Memory Limit issue due to poor regex

## 2.10 - 2018-09-26 <github:joycebabu>

* Refix for internal database being deleted on 2nd startup

## 2.9 2018-10-18 <dave at tiredofit dot ca> 

* Remove /etc/cron.* folders to avoid calling anacron even if isnt installed
* Repair Logrotate for Apache Log files

## 2.8 - 2018-10-16 <dave at tiredofit dot ca>

* Fix for changed Asterisk Download link

## 2.7 - 2018-08-15 <dave at tiredofit dot ca>

* Update for changed MSMTP in Base Image

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

