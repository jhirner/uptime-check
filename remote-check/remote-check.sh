#! /usr/bin/bash
#
### Uptime Check Remote:
### A simple script to monitor the status of a remote web server.
### Intended to be run on a regular schedule.
### https://github.com/jhirner/uptime-check
### Distrubuted under the GPL-3.0 license.
#

# Load the config
source remote-check.config

servs_down=()
servs_unk=()
servs_up=()

for addr in ${monitor_addrs[@]}
do
     # Connect to the remote server & get the HTTP response code
     status=$(curl --connect-timeout 5 --location --head --silent $addr | # fetch the reply header
              grep HTTP |            # get the line with HTTP code
              awk '{print $2}' |     # get the HTTP status code itself
              tail -n1)              # if redirected, >1 status code may be
                                     # present. Get the last.

     # Based on status code, append to array of servers up, down, or other.
     if [[ $status == 404 ]]; then
          servs_down+=($addr)
     elif [[ $status == "" ]]; then
          servs_down+=($addr)
     elif [[ $status == 200 ]]; then
          servs_up+=($addr)
     else
          servs_unk+=($addr "code" $status ";")
     fi
done

# Provide status information for logging purposes
echo "Servers up:   " ${servs_up[@]}
echo "Servers down: " ${servs_down[@]}
echo "Other status: " ${servs_unk[@]}

if [[ ${#servs_down[@]} -gt 0 || ${#servs_unk[@]} -gt 0 ]]; then
     curl --request POST \
     --url https://api.sendgrid.com/v3/mail/send \
     --header "Authorization: Bearer $sendgrid_key" \
     --header 'Content-Type: application/json' \
     --data '{"personalizations": [{"to": [{"email": "'$alert_to'"}]}],"from": {"email": "'$alert_from'"},"subject": "Connectivity alert","content": [{"type": "text/plain", "value": "One or more servers did not respond with OK. There could be a connectivity problem."}]}'

fi
