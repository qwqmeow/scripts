#!/bin/bash
# extract reflect src ip from ddos cap file to ddos bot
if [ -z "$1" ]; then
    echo
    echo usage: $0 file.cap
    echo
    echo e.g. $0 ddos.cap
    echo
    echo extract src ip from cap file
    echo only support ntp protocol now
    exit
fi

file=$1
filename=$(basename $file .cap)
textfile=$filename.txt
echo -e "[*] $file loaded."

# read cap file to text: tshark or tcpdump
tshark -r $file > $textfile
echo -e "[*] read content to $textfile".
echo -e "[*] analyzing ..."

# last line
lastline=$(tail -1 $textfile)

# determine type of attack


totalpacket=$(echo $lastline | awk '{print $1}')
totaltime=$(echo $lastline | awk '{print $2}')

ntplen='482' #bytes

packetsort=$(cat $textfile | awk '{print $6}' | sort | uniq -c |sort -rn)

protocolpacket=$(echo $packetsort | head -n 1 | awk '{print $1}')
protocolpercentage=$(echo "scale=2; $protocolpacket/$totalpacket*100" | bc)
protocolname=$(echo $packetsort | head -n 1 | awk '{print $2}')

protocolavgpps=`echo "sclae=2; $protocolpacket/$totaltime" | bc`
protocolpeakrate=`echo "scale=2; $protocolavgpps*$ntplen/1024/1024" | bc`


echo -e "[*] total packet: $totalpacket"
echo -e "[*] $protocolname packet: $protocolpacket"
echo -e "[*] total time: $totaltime seconds"
echo -e "[*] its likely to be a $protocolname attack, $protocolname packet percentage is $protocolpercentage%"
echo -e "[*] $protocolname average pps: $protocolavgpps p/s"
echo -e "[*] $protocolname estimated peakrate: $protocolpeakrate Gbps"

if [ "${protocolname}"="NTP" ]; then
    atleastpps='10' # filter 
    supposedtotalpacket=`echo "$atleastpps*$totaltime" | bc`
    supposedtotalpacket=$(echo $((${supposedtotalpacket//.*/+1}))) #向上取整
    echo -e "[*] when pps at least $atleastpps,total packet per ip supposed to be $supposedtotalpacket"
    ntpipsort=`cat $textfile | grep -v ntp|awk '{print $3}' | sort | uniq -c |sort -rn`
    # http://bbs.chinaunix.net/forum.php?mod=redirect&goto=findpost&ptid=4181127&pid=24424602

    # -n str　not null 
    # -z str　null str 
    line=$(echo "$ntpipsort" | awk '{print $1}' | grep -n -w $supposedtotalpacket|head -1| awk -F':' '{print $1}')
    [ -n "$line" ] && echo -e "[*] supposedtotalpacket: $supposedtotalpacket, line found:$line"
    [ -z "$line" ] && echo -e "[*] supposedtotalpacket: $supposedtotalpacket, line not found"

    while [ -z "$line" ];do # line is null
        supposedtotalpacket=`echo "$supposedtotalpacket+1"|bc`
        echo -e "[*] supposed total packet: $supposedtotalpacket ..."
        line=$(echo "$ntpipsort" | awk '{print $1}' | grep -n -w $supposedtotalpacket|head -1| awk -F':' '{print $1}')
        [ -n "$line" ] && echo -e "[*] line found: $line"
    done

    # get iplist by line
    echo -e "[*] get ip list by head line: $line"
    echo "$ntpipsort" | head -n $line | awk '{print $2}' >> ntpip.txt
    echo -e "[*] ntpip output to ntpip.txt"

    

fi

echo -e "[*] clean textfile..."
rm -f $textfile