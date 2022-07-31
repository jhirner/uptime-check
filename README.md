# uptime-check
Monitor a home server's public connectivity.


## Motivation
I run a home web server. Although its uptime is not mission-critical, I still want to make sure it is up and running as much as possible. This repo aims to provide two complementary, quick-and-dirty bash scripts to monitor & imporove a home server's uptime.

The scripts are intended to be run repeatedly via a scheduler, such as cron or a systemd timer.


## `local-check.sh`
### Purpose
This script should be run directly on the home server via a scheduler. It finds the server's public IP and attempts to ping it. If the ping fails or if a public IP cannot be found, the server reboots itself.

When my home server goes down, it's almost always because of a wifi hiccup where the connection is briefly dropped and not reestablished correctly; rebooting is an easy fix.

### Installation
There are no external dependencies required (aside from curl and ping).
1. **Clone this repository** to a directory of your choice.
2. **Set `local-check.sh` to run on a schedule** using cron, systemd, or your favorite scheduler. A pair of template systemd service/timer files are included in this repository.


## `remote-check.sh`
### Purpose
This script should be on an *external* server -- ideally one with greater reliability, such as an AWS EC2 or Oracle Cloud Compute instance. It should also be executed regularly via a scheduler.

Given a user-defined list of URLs or IP addresses, the script attempts to establish a connection with each and reads the HTTP response headers. For any response codes other than 200 ("OK"), an email alert is sent to a user-specified address. The alert provides a breakdown of servers down (status code 404) vs. with other status codes.

The script relies on a free [SendGrid account](https://sendgrid.com/) to generate email messages via an API call; setting up an SMTP server is an alternative option, but this script is intended as a quick fix.

### Installation
1. **Create a free [SendGrid account](https://sendgrid.com/).** You will need to verify either a specific email address (such as *admin@yourdomain.com*) or the entire domain via updating your DNS records.
2. **Configure the script** by renaming `remote-check.config.example` to simply `remote-check.config`. Enter the URLs/IPs you wish to monitor, as well as to/from email addresses for the alerts. Be sure the 'from' address has been allowed in your SendGrid account. You'll also need to paste in your SendGrid API key, too.
3. **Clone this repository** to a directory of your choice.
4. **Set `remote-check.sh` to run on a schedule** using cron, systemd, or your favorite scheduler. A pair of template systemd service/timer files are included in this repository.
