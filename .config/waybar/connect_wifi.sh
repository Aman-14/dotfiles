#!/bin/bash

# List available WiFi networks and pass them to wofi for selection
SSID=$(nmcli device wifi list | awk 'NR>1 {print $2}' | wofi --dmenu --prompt "Select WiFi network")

# If a network was selected, prompt for the password and connect
if [ -n "$SSID" ]; then
    PASSWORD=$(wofi --dmenu --password --prompt "Enter password for $SSID")
    nmcli device wifi connect "$SSID" password "$PASSWORD"
fi
