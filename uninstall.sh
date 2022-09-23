mount -o rw,remount /data
MODPATH=${0%/*}
MODID=`echo "$MODPATH" | sed -n -e 's/\/data\/adb\/modules\///p'`
APP="`ls $MODPATH/system/app` `ls $MODPATH/system/priv-app`"
PKG=com.miui.misound
#dPKG="com.miui.misound com.dolby.daxservice"

# boot mode
if [ ! "$BOOTMODE" ]; then
  [ -z $BOOTMODE ] && ps | grep zygote | grep -qv grep && BOOTMODE=true
  [ -z $BOOTMODE ] && ps -A | grep zygote | grep -qv grep && BOOTMODE=true
  [ -z $BOOTMODE ] && BOOTMODE=false
fi

# function
remove_eim_manifest() {
if [ "$BOOTMODE" != true ]; then
  rm -rf `find /metadata/early-mount.d\
  /mnt/vendor/persist/early-mount.d /persist/early-mount.d\
  /data/unencrypted/early-mount.d /cache/early-mount.d\
  /data/adb/modules/early-mount.d -type f -name manifest.xml`
fi
}

# cleaning
for PKGS in $PKG; do
  rm -rf /data/user/*/$PKGS
done
for APPS in $APP; do
  rm -f `find /data/system/package_cache -type f -name *$APPS*`
  rm -f `find /data/dalvik-cache /data/resource-cache -type f -name *$APPS*.apk`
done
rm -rf /metadata/magisk/"$MODID"
rm -rf /mnt/vendor/persist/magisk/"$MODID"
rm -rf /persist/magisk/"$MODID"
rm -rf /data/unencrypted/magisk/"$MODID"
rm -rf /cache/magisk/"$MODID"
#drm -rf /data/vendor/dolby
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
#dremove_eim_manifest

# magisk
if [ ! "$MAGISKTMP" ]; then
  if [ -d /sbin/.magisk ]; then
    MAGISKTMP=/sbin/.magisk
  else
    MAGISKTMP=`find /dev -mindepth 2 -maxdepth 2 -type d -name .magisk`
  fi
fi

# function
grep_cmdline() {
REGEX="s/^$1=//p"
cat /proc/cmdline | tr '[:space:]' '\n' | sed -n "$REGEX"
}
set_read_write() {
for NAMES in $NAME; do
  blockdev --setrw $DIR$NAMES
done
}

# slot
if [ ! "$SLOT" ]; then
  SLOT=`grep_cmdline androidboot.slot_suffix`
  if [ -z $SLOT ]; then
    SLOT=`grep_cmdline androidboot.slot`
    [ -z $SLOT ] || SLOT=_${SLOT}
  fi
fi

# function
remount_rw() {
DIR=/dev/block/bootdevice/by-name
NAME="/vendor$SLOT /cust$SLOT /system$SLOT /system_ext$SLOT"
set_read_write
DIR=/dev/block/mapper
set_read_write
DIR=$MAGISKTMP/block
NAME="/vendor /system_root /system /system_ext"
set_read_write
mount -o rw,remount $MAGISKTMP/mirror/system
mount -o rw,remount $MAGISKTMP/mirror/system_root
mount -o rw,remount $MAGISKTMP/mirror/system_ext
mount -o rw,remount $MAGISKTMP/mirror/vendor
mount -o rw,remount /system
mount -o rw,remount /
mount -o rw,remount /system_root
mount -o rw,remount /system_ext
mount -o rw,remount /vendor
}

# remount
#dremount_rw

# function
restore() {
for FILES in $FILE; do
  if [ -f $FILES.orig ]; then
    mv -f $FILES.orig $FILES
  fi
  if [ -f $FILES.bak ]; then
    mv -f $FILES.bak $FILES
  fi
done
}

# restore
FILE="$MAGISKTMP/mirror/*/etc/vintf/manifest.xml
      $MAGISKTMP/mirror/*/*/etc/vintf/manifest.xml
      /*/etc/vintf/manifest.xml /*/*/etc/vintf/manifest.xml
      $MAGISKTMP/mirror/*/etc/selinux/*_hwservice_contexts
      $MAGISKTMP/mirror/*/*/etc/selinux/*_hwservice_contexts
      /*/etc/selinux/*_hwservice_contexts /*/*/etc/selinux/*_hwservice_contexts
      $MAGISKTMP/mirror/*/etc/selinux/*_file_contexts
      $MAGISKTMP/mirror/*/*/etc/selinux/*_file_contexts
      /*/etc/selinux/*_file_contexts /*/*/etc/selinux/*_file_contexts"
#drestore

# function
remount_ro() {
if [ "$BOOTMODE" == true ]; then
  mount -o ro,remount $MAGISKTMP/mirror/system
  mount -o ro,remount $MAGISKTMP/mirror/system_root
  mount -o ro,remount $MAGISKTMP/mirror/system_ext
  mount -o ro,remount $MAGISKTMP/mirror/vendor
  mount -o ro,remount /system
  mount -o ro,remount /
  mount -o ro,remount /system_root
  mount -o ro,remount /system_ext
  mount -o ro,remount /vendor
fi
}

# remount
#dremount_ro


