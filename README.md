# WifiCity_captiveportal

Tired to enter your credential every time you connect to WifiCity, these scripts
are made for you.

The main goal of this repository is to offer a solution to connect automatically
on internet while the computer is connected at the CIUP wifi called WifiCity.

I made the Windows instruction more user-friendly, if you use linux you are
supposed to know how to edit a text file or change file mode bits.

I took the Mac scripts from [Mehechiger](https://github.com/Mehechiger/WifiCity_captiveportal) (thanks) to centralize the scripts.

## How to use

### Windows

Unfortunately it's not trivial to automate the connection in Windows, so the
more reliable solution I found is to manually start a script.

* Download
  [WifiCity_win.bat](https://raw.githubusercontent.com/lnwor/WifiCity_captiveportal/main/Windows/WifiCity_win.bat)
  and execute it.
* Insert Username and Password.
* From now on, you can execute the generated `login_WifiCity.bat` file to
connect to the captive portal without inserting or opening anything. You may put
it in the desktop to open it quickly or create some kind of shortcut.

**Note that Windows may warn you that this script could be dangerous.**\
Of course it's not, you can read the code, there's nothing malicious.

### Mac

* Open the Mac folder and download `login_wifi.sh` and `me.wificity.login.plist`
* Edit `login_wifi.sh` with your own credential, then put it somewhere, for
example in /usr/local/bin/. Be aware that if file is readable for the users of
your device, they can read your username and password of WifiCity, which is not
a major concern, but you're warned.
* Edit `me.wificity.login.plist` and replace `SOMEWHERE` with the location where
  you put `login_wifi.sh`.
* Put `me.wificity.login.plist` under ~/Library/LaunchAgents/
* Open terminal and execute 
```bash=
launchctl load -w ~/Library/LaunchAgents/me.wificity.login.plist
```

Then reboot and it will automatically execute your script when your network
connection changes.

### Linux

* Open the Linux folder and download `login_wifi.sh`
* Edit the file with your own credential
* Automate the execution of the script every time you connect to a wifi called
"WifiCity"

NetworkManager has the ability to start services when you connect to a network
and stop them when you disconnect (e.g. when using NFS, SMB and NTPd).

To activate the feature you need to enable and start the
`NetworkManager-dispatcher.service`.
```bash=
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl start NetworkManager-dispatcher.service
```

Once the service is active, scripts can be added to the
`/etc/NetworkManager/dispatcher.d` directory.

```bash=
#copy your script to that directory
cp ./WifiCity_captiveportal/Linux/10-login_citywifi /etc/NetworkManager/dispatcher.d/10-login_citywifi
```

Scripts must be owned by root, otherwise the dispatcher will not execute them.
For added security, set group ownership to root as well: 
```bash=
chown root:root /etc/NetworkManager/dispatcher.d/10-login_wifi.sh
chmod 755 /etc/NetworkManager/dispatcher.d/10-login_wifi.sh
```

Then reboot and it will automatically execute your script while connected to a network.

### Android

Execute the linux script with
[`Termux`](https://play.google.com/store/apps/details?id=com.termux&fbclid=IwAR0VU0hSW3z2qZTTrm0dH72awzus8Sy-hZXMOPSG6mdUe5M2cq5zRYW0Q8o)
and use this
[widget](https://play.google.com/store/apps/details?id=com.termux.widget&fbclid=IwAR0rr7g7ghvPZ8juKe1ses1xXTzq50hbIcUDUcbozzb87_pKllknFPW8TBQ)
to execute it from home screen. (I couldn't make this work, but you can try)
