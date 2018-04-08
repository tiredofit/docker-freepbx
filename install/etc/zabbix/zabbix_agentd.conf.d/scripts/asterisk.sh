#!/bin/bash
## Asterisk Zabbix Check Script
## Dave Conroy <dave at tiredofit dot ca> 2018-04-07

if [ ! -n "$1" ]; then
    echo "I'm ready for an argument!"
    exit 1
fi

function calls.active(){
    CALL=`sudo -u asterisk /usr/sbin/asterisk -rx "core show channels" |grep "active calls"|awk '{print$1}'`
    echo "$CALL"
}

function calls.processed(){
    CALL=`sudo -u asterisk /usr/sbin/asterisk -rx "core show channels" |grep "calls processed"|awk '{print$1}'`
    echo "$CALL"
}

function calls.longest(){
    CHANNEL="$(asterisk -rx 'core show channels concise' | cut -f12,1 -d'!' | sed 's/!/ /g' | sort -n -k 2 | tail -1)"
    CHANNEL_NAME=$(echo $CHANNEL |awk '{print$1}')
    CHANNEL_TIME=$(echo $CHANNEL |awk '{print$2}')
    CHANNEL_TIME=${CHANNEL_TIME:-"0"}

    if [ "$CHANNEL_TIME" -gt 7200 ]; then
    	asterisk -rx "channel request hangup $CHANNEL_NAME" >> /var/log/asterisk/full
        sleep 1

        if [ "`asterisk -rx 'core show channels concise' | grep $CHANNEL_NAME`" ]; then
            echo "$CHANNEL_NAME is $CHANNEL_TIME long"
        else
	    echo 1
        fi
    else
    	echo 1
    fi
}

function channels.active(){
    CHANNEL=`sudo -u asterisk /usr/sbin/asterisk -rx "core show channels" | grep "active channels" | awk '{print $1}'`
    echo "$CHANNEL"
}

function iax.peers(){
    TRUNK=`sudo -u asterisk /usr/sbin/asterisk -rx "iax2 show peers" | grep UNREACHABLE | awk '{print$1}'| grep [A-Za-z]`
    if [ -n "$TRUNK" ]; then
    	sudo -u asterisk /usr/sbin/asterisk -rx "module unload chan_iax2.so" >> /dev/null
        sudo -u asterisk /usr/sbin/asterisk -rx "module load chan_iax2.so"  >> /dev/null
        sleep 1
        echo $TRUNK
    else
        echo "1"
    fi
}


function iax.register.time(){
    MS=$(sudo -u asterisk /usr/sbin/asterisk -rx "iax2 show peers" | grep OK | grep -oP '\(\K[^\)]+' | sed 's/ms//g' | sort -n | awk '$1>199')
    LOG=$(for i in $(sudo -u asterisk /usr/sbin/asterisk -rx "iax2 show peers" | grep OK | grep -oP '\(\K[^\)]+' | sed 's/ms//g' | sort -n | awk '$1>199'); do sudo -u asterisk /usr/sbin/asterisk -rx "iax2 show peers" | grep OK | grep $i; done)
    DATE=$(date +"%Y-%m-%d %H:%M:%S")

    if [[ -n "$MS" ]]; then
        echo "0"
        echo $DATE  "The Problematic Extensions are : " $LOG>> /var/log/asterisk/monitor.log
    else
        echo "1"
    fi
}

function iax.trunk.down(){
    TRUNK=`sudo -u asterisk /usr/sbin/asterisk -rx "iax2 show peers" | grep UNREACHABLE | awk '{print$1}' | grep [A-Za-z]`
    if [ -n "$TRUNK" ]; then
    	echo $TRUNK
    else
        echo "1"
    fi
}

function status(){
    proc_status=`ps -AF | grep 'sudo -u asterisk /usr/sbin/asterisk'`
    if [ -n "$proc_status" ]; then
        echo "1"
    else
        echo "0"
    fi
}

function status.crashes(){
    if [ -n "`find /tmp/ -type f -mtime -1 -name 'core*'`" ]; then
        echo 1
    else
        echo 0
    fi
}

function status.reload(){
    reload_time=`sudo -u asterisk /usr/sbin/asterisk -rx "core show uptime seconds" | awk -F": " '/Last reload/{print$2}'`
    if [ -z "$reload_time" ];then
        echo "Asterisk has not been reloaded yet"
    else
        printf '%dd:%dh:%dm:%ds\n' $(($reload_time/86400)) $(($reload_time%86400/3600)) $(($reload_time%3600/60)) $(($reload_time%60))
    fi
}

function status.uptime(){
    uptime=`sudo -u asterisk /usr/sbin/asterisk -rx "core show uptime seconds" | awk -F": " '/System uptime/{print$2}'`
    if [ -z "$uptime" ];then
        echo "Asterisk is not up"
    else
        printf '%dd:%dh:%dm:%ds\n' $(($uptime/86400)) $(($uptime%86400/3600)) $(($uptime%3600/60)) $(($uptime%60))
    fi
}

function status.version(){
    version=`sudo -u asterisk /usr/sbin/asterisk -rx "core show version" |grep "Asterisk"|awk '{print$2}'`
    echo "$version"
}

function sip.trunk.down(){
    TRUNK=`sudo -u asterisk /usr/sbin/asterisk -rx "sip show peers" | grep UNREACHABLE | awk '{print$1}'| grep [A-Za-z]`
    if [ -n "$TRUNK" ]; then
    	echo $TRUNK
    else
        echo "1"
    fi
}



function sip.peers(){
    TRUNK=`sudo -u asterisk /usr/sbin/asterisk -rx "sip show peers" | grep UNREACHABLE | awk '{print$1}'| grep [A-Za-z]`
    if [ -n "$TRUNK" ]; then
    	sudo -u asterisk /usr/sbin/asterisk -rx "module unload chan_sip.so" >> /dev/null
        sudo -u asterisk /usr/sbin/asterisk -rx "module unload chan_pjsip.so" >> /dev/null
        sudo -u asterisk /usr/sbin/asterisk -rx "module load chan_sip.so"  >> /dev/null
        sudo -u asterisk /usr/sbin/asterisk -rx "module load chan_pjsip.so"  >> /dev/null
        sleep 1
        echo $TRUNK
    else
        echo "1"
    fi
}

function sip.register.time(){
    MS=$(sudo -u asterisk /usr/sbin/asterisk -rx "sip show peers" | grep OK | grep -oP '\(\K[^\)]+' | sed 's/ms//g' | sort -n | awk '$1>199')
    LOG=$(for i in $(sudo -u asterisk /usr/sbin/asterisk -rx "sip show peers" | grep OK | grep -oP '\(\K[^\)]+' | sed 's/ms//g' | sort -n | awk '$1>199'); do sudo -u asterisk /usr/sbin/asterisk -rx "sip show peers" | grep OK | grep $i; done)
    DATE=$(date +"%Y-%m-%d %H:%M:%S")

    if [[ -n "$MS" ]]; then
        echo "0"
        echo $DATE  "The Problematic Extensions are : " $LOG>> /var/log/asterisk/monitor.log
    else
        echo "1"
    fi
}

function wrong.password(){
    DATE=`date '+%Y-%m-%d %H:%M' -d  "1 hour ago"`
    PASS=`awk -v DT="$DATE" '$1 " " $2 >= DT'   /var/log/asterisk/full | grep "Wrong password"`

    if [[ -n "$PASS" ]]; then
        echo "0"
    else
        echo "1"
    fi
}

### Execute the argument
$1
