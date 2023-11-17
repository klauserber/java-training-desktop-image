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

# turn off compositing
echo "[$Version]
update_info=kwin.upd:replace-scalein-with-scale,kwin.upd:port-minimizeanimation-effect-to-js,kwin.upd:port-scale-effect-to-js,kwin.upd:port-dimscreen-effect-to-js,kwin.upd:auto-bordersize,kwin.upd:animation-speed,kwin.upd:desktop-grid-click-behavior,kwin.upd:no-swap-encourage,kwin.upd:make-translucency-effect-disabled-by-default,kwin.upd:remove-flip-switch-effect,kwin.upd:remove-cover-switch-effect,kwin.upd:remove-cubeslide-effect,kwin.upd:remove-xrender-backend,kwin.upd:enable-scale-effect-by-default,kwin.upd:overview-group-plugin-id,kwin.upd:animation-speed-cleanup,kwin.upd:replace-cascaded-zerocornered

[Compositing]
Enabled=false

[Desktops]
Id_1=a95b74c1-55fc-45f3-8e2c-c787de6911b3
Number=1
Rows=1

[Tiling]
padding=4" > $HOME/.config/kwinrc

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

