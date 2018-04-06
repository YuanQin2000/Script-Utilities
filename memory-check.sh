#!/bin/bash

function check_status_file()
{
    timestamp=$(date +%Y%m%d%H%M%S)
    mem_usage=$(sudo cat $1 | grep -E 'VmPeak|VmSize|VmLck|VmPin|VmHWM|VmRSS|VmData|VmStk|VmExe|VmLib|VmPTE|VmPMD|VmSwap')
    extract_str=$(echo "$mem_usage" | awk '{print $2}')
    fmt_data=$(echo $extract_str | sed 's/ /,/g')
    echo "$timestamp,$fmt_data" >> $2
}

function check_memory()
{
    status_file="/proc/$1/status"

    if [ ! -f $status_file ]; then
        echo "Process $1 doesn't exist"
        return
    fi

    timestamp=$(date +%Y%m%d%H%M%S)
    log_file="$timestamp-pid$1".csv

    # VmPeak => Max-Used
    # VmSize => Currented Used
    # VmLck => Locked PHY Memory
    # VmPin => Pinned PHY Memory(?)
    # VmHWM => Max Allocated PHY Memory
    # VmRSS => Current Allocated PHY Memory
    # VmData => Data Segment Size
    # VmStk => Stack Segment Size
    # VmExe => Text Segment Size
    # VmLib => Loaded Library Size
    # VmPTE => PHY Page Table Size
    # VmPMD => ??
    # VmSwap => Swap Size
    echo "Timestamp,Max-Used,Current-Used,Locked-PHY,Pinned-PHY,Max-Allocated-PHY, Current-Allocated-PHY,Data-Segment,Stack,Text,Loaded-Library,PHY-Page-Table,VmPMD,Swap" > $log_file
    while true
    do
        check_status_file $status_file $log_file
        sleep 4
    done
}

if [ $# -lt 1 ]; then
    echo "Usage: $0 <pid>"
    exit -1
fi

pid=$1
if [ "$pid" -le 0 ] 2>/dev/null ; then
    echo "pid must be a positive number"
    exit -1
fi
echo "To check process $pid"
check_memory $pid

