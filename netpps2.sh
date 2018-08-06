#!/bin/bash
# https://consolechars.wordpress.com/2015/07/21/pps-packet-per-second-how-to-check-in-linux-server/
echo "Renturn , Enter close aplication\n\n"
 
p1=$1
flag=$(date +"%d-%m-%y %H:%M:%S")
fork_for_interface(){
        while true
        do
        Rx1=`multithreaded `
        Tx1=`cat /sys/class/net/$line/statistics/tx_packets`
        sleep $INTERVAL
        Rx2=`cat /sys/class/net/$line/statistics/rx_packets`
        Tx2=`cat /sys/class/net/$line/statistics/tx_packets`
        TXPPS=`expr $Tx2 - $Tx1`
        RXPPS=`expr $Rx2 - $Rx1`
        if [ "$p1" = "verbose" ];
         then
                echo "$(date +"%d-%m-%y %H:%M:%S") ,TX $1: $TXPPS pkts/s RX $line: $RXPPS pkts/s" ;
        fi
        echo "$(date +"%d-%m-%y %H:%M:%S"), $TXPPS,$RXPPS" >> $line.csv
        done
}
INTERVAL="1"  # update interval in seconds
IFS=" "
IF=$1
interfaces=$(ls /sys/class/net/)
PIDLIST=()
K=0
while read -r line; do
        fork_for_interface &
        PIDLIST[$K]=$!
        touch $line.csv
        K=$K+1;
done <<<"$interfaces"
echo "List chlidren precces "
for i in "${PIDLIST[@]}"
        do
        echo $i
        echo
done
unset IFS
while true; do
read key
        if [ $? -eq 0 ] && [ -z "$key" ]
        then
            for i in "${PIDLIST[@]}"; do echo "closing PID $i "; kill -9 $i; done
        break
        fi
done