#!/bin/bash

# https://wiki.archlinux.org/index.php/NetworkManager#Captive_portals

# README : make sure these binaries are available on your distribution.
# curl sed

# Insert here your username and password
USERNAME=""
PASSWORD=""

login_wificity() {
    # wificity authentication server
    authserver="http://10.254.0.254:1000"
    
    # 204 http status code generation url to detect captive portal
    # can be any http address, eg. http://neverssl.com
    # but change the "$status" != "204" with correct status code
    # ref. https://github.com/NickSto/uptest/blob/master/captive-portals.md
    gen204="http://www.apple.com/library/test/success.html"
    
    # grabbing http response to detect captive portal
    gen204_resp=$(curl -si "$gen204")
    
    # parsing http status code
    status_code=$(sed -n '1s/^[^\s]\+ \([0-9]\+\)\(\s.*\)\?$/\1/p' <<< "$gen204_resp")
 
    # if http status code is not expected
    if [ "$status_code" != "204" ]; then
        # captive portal is detected
        # assuming wificity network
        # parsing magic code to generate the wificity authentication form
        #magic=$(sed -n 's/^Location.*?\([a-zA-Z0-9]*\).*$/\1/p' <<< "$gen204_resp")
        magic=$(sed -n 's/.*window\.location=.*?\([a-zA-Z0-9]*\).*$/\1/p' <<< "$gen204_resp")
        # generate the authentication form
        curl -so /dev/null "${authserver}/fgtauth?${magic}"
        # submit credentials with magic code to wificity server for authentication
        curl -so /dev/null "$authserver" --data "magic=${magic}&username=${USERNAME}&password=${PASSWORD}"
    fi
}

check_ssid() {
    # parse ssid
    ssid=$(sed -n 's/^Current Wi-Fi Network: \(.*\)/\1/p' <<< "$(networksetup -getairportnetwork en0)")

    if [ "$ssid" == "WifiCity" ] || [ "$ssid" == "FBL_Maison" ]; then
        echo 0
    fi
}

# quit if we're not connected to WifiCity
if [ "$(check_ssid)" != "0" ]; then
    exit 0
fi

login_wificity

# check if we've alreadly logged in to WifiCity, otherwise, display debug notifications
# if [ "$(check_loggedin)" != "0" ]; then
#     check_loggedin
#     osascript -e 'display notification "Failed to log in!" with title "WifiCity"'
#     # cf. https://stackoverflow.com/a/23923108
#     # osascript -e 'display notification "'"content: ${gen204_resp//\"/}"'" with title "DEBUG 1/3 gen204 response"'
#     # osascript -e 'display notification "'"content: ${status_code//\"/}"'" with title "DEBUG 2/3 status code (204 if already logged in)"'
#     # osascript -e 'display notification "'"content: ${magic//\"/}"'" with title "DEBUG 3/3 magic"'
# else
#     osascript -e 'display notification "Logged in!" with title "WifiCity"'
# fi
