#!/bin/sh
# The next section, if this boot goes well is essentially turning this very 
# basic system into something comfortable to use; this part can be scripted

# Select your timezone
tzsetup

# Set the hostname
hostname fusion809-vbox
echo "hostname=fusion809-vbox" >> /etc/rc.conf

# Install sendmail
cd /etc/mail
make install
service sendmail onerestart

# This system will not have internet; to fix this one runs:
dhclient em0
