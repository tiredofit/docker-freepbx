#! /bin/bash
#
# Name: zapache
#
# Checks Apache activity.
#
# Author: Alejandro Michavila
# Modified for Scoreboard Values: Murat Koc, murat@profelis.com.tr
# Modified for using also as external script: Murat Koc, murat@profelis.com.tr
# Modified for outputting usage or ZBX_NOTSUPPORTED: Alejandro Michavila
# Modified to do cacheing for performance, dmitry.frolov@gmail.com
#
# Version: 1.5
#
 
zapachever="1.5"
rval=0
value=""
cache_seconds="60"
[ "$TMPDIR" ] || TMPDIR=/tmp
 
function usage()
{
	echo "zapache version: $zapachever"
	echo "usage:"
	echo "  $0 [<url>] TotalAccesses                 - Check total accesses."
	echo "  $0 [<url>] TotalKBytes                   - Check total KBytes."
	echo "  $0 [<url>] CPULoad                       - Check CPU load."
	echo "  $0 [<url>] Uptime                        - Check uptime."
	echo "  $0 [<url>] ReqPerSec                     - Check requests per second."
	echo "  $0 [<url>] BytesPerSec                   - Check Bytes per second."
	echo "  $0 [<url>] BytesPerReq                   - Check Bytes per request."
	echo "  $0 [<url>] BusyWorkers                   - Check busy workers."
	echo "  $0 [<url>] IdleWorkers                   - Check idle workers."
	echo "  $0 [<url>] version                       - Version of this script."
	echo "  $0 [<url>] ping                          - Check if Apache is up."
	echo "  $0 [<url>] WaitingForConnection          - Check Waiting for Connection processess."
	echo "  $0 [<url>] StartingUp                    - Check Starting Up processess."
	echo "  $0 [<url>] ReadingRequest                - Check Reading Request processess."
	echo "  $0 [<url>] SendingReply                  - Check Sending Reply processess."
	echo "  $0 [<url>] KeepAlive                     - Check KeepAlive Processess."
	echo "  $0 [<url>] DNSLookup                     - Check DNSLookup Processess."
	echo "  $0 [<url>] ClosingConnection             - Check Closing Connection Processess."
	echo "  $0 [<url>] Logging                       - Check Logging Processess."
	echo "  $0 [<url>] GracefullyFinishing           - Check Gracefully Finishing Processess."
	echo "  $0 [<url>] IdleCleanupOfWorker           - Check Idle Cleanup of Worker Processess."
	echo "  $0 [<url>] OpenSlotWithNoCurrentProcess  - Check Open Slots with No Current Process."
}

########
# Main #
########

if [[ $# ==  1 ]];then
	#Agent Mode
	STATUS_URL="http://localhost:73/server-status?auto"
	CASE_VALUE="$1"
elif [[ $# == 2 ]];then
	#External Script Mode
	STATUS_URL="$1"
	case "$STATUS_URL" in
		http://*|https://*) ;;
		*) STATUS_URL="http://$STATUS_URL/server-status?auto";;
	esac
	CASE_VALUE="$2"
else
	#No Parameter
	usage
	exit 0
fi

case "$CASE_VALUE" in
'version')
	echo "$zapachever"
	exit 0;;
esac

umask 077

# $UID is bash-specific
cache_prefix="zapache-$UID-${STATUS_URL//[^a-zA-Z0-9_-]/_}"
cache="$TMPDIR/$cache_prefix.cache"
cache_timestamp_check="$TMPDIR/$cache_prefix.ts"
# This assumes touch from coreutils
touch -d "@$((`date +%s` - ($cache_seconds - 1)))" "$cache_timestamp_check"

if [ "$cache" -ot "$cache_timestamp_check" ]; then
	curl="`which curl`"
	if [ "$curl" ]; then
		fetch_url() { $curl --insecure --silent --location -H "Cache-Control: no-cache" "$@"; }
	else
		wget="`which wget`"
		if [ "$wget" ]; then
			fetch_url() { $wget --no-check-certificate --quiet --header "Cache-Control: no-cache" -O - "$@"; }
		else
			echo "ZBX_NOTSUPPORTED"
			exit 1
		fi
	fi

	fetch_url "$STATUS_URL" > "$cache"
	rval=$?
	if [ $rval != 0 ]; then
		echo "ZBX_NOTSUPPORTED"
		exit 1
	fi
fi

case "$CASE_VALUE" in
'ping')
	if [ ! -s "$cache" -o "$cache" -ot "$cache_timestamp_check" ]; then
		echo "0"
	else
		echo "1"
	fi
	exit 0;;
esac

if ! [ -s "$cache" ]; then
	echo "ZBX_NOTSUPPORTED"
	exit 1
fi
 
case "$CASE_VALUE" in
'TotalAccesses')
	value="`awk '/^Total Accesses:/ {print $3}' < \"$cache\"`"
	rval=$?;;
'TotalKBytes')
	value="`awk '/^Total kBytes:/ {print $3}' < \"$cache\"`"
	rval=$?;;
'CPULoad')
	value="`awk '/^CPULoad:/ {print $2}' < \"$cache\"`"
	rval=$?;;
'Uptime')
	value="`awk '/^Uptime:/ {print $2}' < \"$cache\"`"
	rval=$?;;
'ReqPerSec')
	value="`awk '/^ReqPerSec:/ {print $2}' < \"$cache\"`"
	rval=$?;;
'BytesPerSec')
	value="`awk '/^BytesPerSec:/ {print $2}' < \"$cache\"`"
	rval=$?;;
'BytesPerReq')
	value="`awk '/^BytesPerReq:/ {print $2}' < \"$cache\"`"
	rval=$?;;
'BusyWorkers')
	value="`awk '/^BusyWorkers:/ {print $2}' < \"$cache\"`"
	rval=$?;;
'IdleWorkers')
	value="`awk '/^IdleWorkers:/ {print $2}' < \"$cache\"`"
	rval=$?;;
'WaitingForConnection')
	value="`awk '/^Scoreboard:/ {print split($2,notused,"_")-1}' < \"$cache\"`"
	rval=$?;;
'StartingUp')
	value="`awk '/^Scoreboard:/ {print split($2,notused,"S")-1}' < \"$cache\"`"
	rval=$?;;
'ReadingRequest')
	value="`awk '/^Scoreboard:/ {print split($2,notused,"R")-1}' < \"$cache\"`"
	rval=$?;;
'SendingReply')
	value="`awk '/^Scoreboard:/ {print split($2,notused,"W")-1}' < \"$cache\"`"
	rval=$?;;
'KeepAlive')
	value="`awk '/^Scoreboard:/ {print split($2,notused,"K")-1}' < \"$cache\"`"
	rval=$?;;
'DNSLookup')
	value="`awk '/^Scoreboard:/ {print split($2,notused,"D")-1}' < \"$cache\"`"
	rval=$?;;
'ClosingConnection')
	value="`awk '/^Scoreboard:/ {print split($2,notused,"C")-1}' < \"$cache\"`"
	rval=$?;;
'Logging')
	value="`awk '/^Scoreboard:/ {print split($2,notused,"L")-1}' < \"$cache\"`"
	rval=$?;;
'GracefullyFinishing')
	value="`awk '/^Scoreboard:/ {print split($2,notused,"G")-1}' < \"$cache\"`"
	rval=$?;;
'IdleCleanupOfWorker')
	value="`awk '/^Scoreboard:/ {print split($2,notused,"I")-1}' < \"$cache\"`"
	rval=$?;;
'OpenSlotWithNoCurrentProcess')
	value="`awk '/^Scoreboard:/ {print split($2,notused,".")-1}' < \"$cache\"`"
	rval=$?;;
*)
	usage
	exit 1;;
esac

if [ "$rval" -eq 0 -a -z "$value" ]; then
    case "$CASE_VALUE" in
        # Theese metrics are output only if non-zero
        'CPULoad' | 'ReqPerSec' | 'BytesPerSec' | 'BytesPerReq')
            value=0
            ;;
        *)
            rval=1
            ;;
    esac
fi
 
if [ "$rval" -ne 0 ]; then
	echo "ZBX_NOTSUPPORTED"
fi
 
echo "$value"
exit $rval
 
#
# end zapache

