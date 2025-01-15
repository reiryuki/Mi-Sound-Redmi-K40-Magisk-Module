mount -o rw,remount /data
[ ! "$MODPATH" ] && MODPATH=${0%/*}
[ ! "$MODID" ] && MODID=`basename "$MODPATH"`
UID=`id -u`
[ ! "$UID" ] && UID=0

# log
exec 2>/data/adb/$MODID\_uninstall.log
set -x

# run
. $MODPATH/function.sh

# cleaning
remove_cache
PKGS=`cat $MODPATH/package.txt`
#dPKGS=`cat $MODPATH/package-dolby.txt`
for PKG in $PKGS; do
  rm -rf /data/user*/"$UID"/$PKG
done
remove_sepolicy_rule
#drm -f /data/vendor/dolby/dax_sqlite3.db
resetprop -p --delete persist.sys.button_jack_profile
resetprop -p --delete persist.sys.button_jack_switch
resetprop -p --delete persist.audio.button_jack.profile
resetprop -p --delete persist.audio.button_jack.switch
resetprop -p --delete persist.vendor.audio.button_jack.profile
resetprop -p --delete persist.vendor.audio.button_jack.switch
resetprop -p --delete persist.vendor.audio.misound.disable
resetprop -p --delete persist.vendor.audio.sfx.hd.music.state
resetprop -p --delete persist.vendor.audio.sfx.hd.type
resetprop -p --delete persist.vendor.audio.sfx.hd.eq
resetprop -p --delete persist.vendor.audio.ears.compensation.example
resetprop -p --delete persist.vendor.audio.ears.compensation.state
resetprop -p --delete persist.vendor.audio.ears.compensation.eq.left
resetprop -p --delete persist.vendor.audio.ears.compensation.eq.right
resetprop -p --delete persist.vendor.audio.scenario
resetprop -p --delete persist.vendor.audio.scenario.restore










