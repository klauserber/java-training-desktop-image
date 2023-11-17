#!/bin/bash

# VNC startup
mkdir -p $HOME/.vnc
echo "#!/bin/sh
exec xfce4-session" > $HOME/.vnc/xstartup
chmod +x $HOME/.vnc/xstartup

# configure german keyboard
mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
echo "<?xml version="1.0" encoding="UTF-8"?>
<channel name="keyboard-layout" version="1.0">
  <property name="Default" type="empty">
    <property name="XkbDisable" type="bool" value="false"/>
    <property name="XkbLayout" type="string" value="de,de,us"/>
    <property name="XkbVariant" type="string" value="e1,mac,"/>
  </property>
</channel>" > $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/keyboard-layout.xml

# copy desktop shortcuts
mkdir -p $HOME/Desktop
cp -r /desktop/* $HOME/Desktop/
sudo chown -R coder:coder $HOME/Desktop

# remove Chrome Lockfiles
rm -rf $HOME/.config/google-chrome/Singleton*

# create vnc user
echo -e "nopasswordneeded\nnopasswordneeded\n" | vncpasswd -u coder -w -r

# start vnc server
/usr/bin/vncserver -websocketPort 6901 -disableBasicAuth

