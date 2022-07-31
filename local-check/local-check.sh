#! /usr/bin/bash
#
### Uptime Check:
### A simple script to monitor a home web server for connectivity
### interruptions. If the network is lost, reboot.
### Intended to be run on a regular schedule.
### https://github.com/jhirner/uptime-check
### Distrubuted under the GPL-3.0 license.
#

# Get the IP address
ip=$(curl --silent ifconfig.me)

# Get % of packets lost in 5 replicate pings.
# 'lossstr' is a string in the format of "0% packet loss", and
# 'losspct' is simply the numerical portion of lossstr.
lossstr=$(ping -c 5 $ip -O |  grep 'packet loss' | awk -F ',' '{print $(NF-1)}')
losspct=$(echo "$lossstr" | awk -F '%' '{print $1}')

if [ $losspct -lt 100 ]; then
     echo "Check PASSED. Public IP is $ip. Found $losspct %  packet loss."
else
     echo "Check FAILED. Found $losspct %  packet loss. Rebooting."
     /usr/sbin/reboot
fi
