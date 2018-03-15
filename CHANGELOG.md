## 1.0 2018-03-15 <dave at tiredofit dot ca>

* Production Ready
* Fixes Previous Download and installation steps as reported by Github users
* Installs all latest applications from --edge to avoid any signature failures
* Compiles and installs app_confbridge

## 0.82 2018-01-09 <mattcvinvent@github>

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

