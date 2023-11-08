#!/bin/bash

# VNC startup
mkdir -p $HOME/.vnc
echo "#!/bin/sh
startplasma-x11" > $HOME/.vnc/xstartup
chmod +x $HOME/.vnc/xstartup

# turn off screen lock
mkdir -p $HOME/.config
echo "[\$Version]
update_info=kscreenlocker.upd:0.1-autolock

[Daemon]
Autolock=false
LockOnResume=false" > $HOME/.config/kscreenlockerrc

# configure konsole
mkdir -p $HOME/.local/share/konsole
echo "[General]
Command=/bin/bash
Directory=/home/coder
Name=default
Parent=FALLBACK/" > $HOME/.local/share/konsole/default.profile

echo "[Desktop Entry]
DefaultProfile=default.profile
[General]
ConfigVersion=1" > $HOME/.config/konsolerc

# configure german keyboard
echo "[\$Version]
update_info=kxkb.upd:remove-empty-lists,kxkb.upd:add-back-resetoptions,kxkb_variants.upd:split-variants

[Layout]
DisplayNames=,,
LayoutList=de,de,us
Use=true
VariantList=,mac," > $HOME/.config/kxkbrc

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

