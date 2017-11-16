#!/bin/sh
UUID=`system_profiler SPHardwareDataType | awk '/UUID/ {print $3;}'`
USERID=`stat -f '%Su' /dev/console`
cp /Applications/Justin/com.apple.screensaver.plist /Users/$USERID/Library/Preferences/ByHost/com.apple.screensaver.$UUID.plist
chown $USERID /Users/$USERID/Library/Preferences/ByHost/com.apple.screensaver.$UUID.plist
chmod 600 /Users/$USERID/Library/Preferences/ByHost/com.apple.screensaver.$UUID.plist

killall cfprefsd

