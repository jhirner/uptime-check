# uptime-check
Reboots home server if network connectivity is lost.

# Motivation
I run a home web server. Although its uptime is not mission-critical, I still want to make sure it is up and running as much as possible. When it goes down, it's almost always because of a wifi hiccup where the connection is dropped and not reestablished correctly; rebooting is an easy fix.

This script aims to provide a quick-and-dirty way to improve uptime by pinging the server's public IP. At a threshhold packet loss (100%), the server is rebooted.

The script is intended to be run repeatedly via a scheduler.

# Installation
1. **Clone this repository** to a directory of your choice.
2. **Set it to run on a schedule** using cron, systemd, or your favorite scheduler. A pair of sample systemd service/timer files are included in this repository.
