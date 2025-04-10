#!/bin/bash

# Configuration (change these)
WLAN="wlan0"           # Interface name of WLAN adapter (find it with 'ip a'...)
VPN_NAME="wg0"        # VPN Connection name (Name from Network Manager)
CON="temp_wifi|another_wifi"      # Connection names, separated multiple connection names with a pipe '|'

# Get parameters from the dispatcher (see 'man NetworkManager-dispatcher' for all the different states)
interface=$1 status=$2


if [ "$interface" = "$WLAN" ]; then
    # If the interface is the WLAN adapter, check the status
    case $status in
    up)
        # In case the interface got started, check if it is one of our defined WLAN Connections
        if nmcli con show --active | grep -Eqs "$CON"; then
            # Start the VPN Connection if it is not already running
            if ! nmcli con show --active | grep -qs "$VPN_NAME"; then
                 nmcli connection up id "$VPN_NAME"
            fi
        fi
    ;;
    down)
        # In case the interface got stopped, disable the VPN connection if it is active
        # In the case from switching from a defined WLAN to an undefined, this script is run twice
        #so it 'should' not start another VPN Connection
        if nmcli con show --active | grep -qs "$VPN_NAME"; then
            nmcli connection down id "$VPN_NAME"
        fi
    ;;
    esac
fi

# "Paranoid Mode" :-)
# Uncomment the following lines if you want to restart the VPN in case it
# gets deactivated while still connected to a WLAN defined above - basicall disables non-VPN WLANs
# Wireguard is a "device" so "down" has to be used, for other VPNs "vpn-down" has to be used (did not test)

#if [ "$interface" = "$VPN_NAME" ]; then
#   case $status in
#   down)
#       # Restart the VPN again in case on of the defined WLANs is still active
#       if nmcli con show --active | grep -Eqs "$CON"; then
#           nmcli connection up id "$VPN_NAME"
#       fi
#   ;;
#   esac
#fi
