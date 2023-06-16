MODPATH=${0%/*}
API=`getprop ro.build.version.sdk`

# log
exec 2>$MODPATH/debug.log
set -x

# function
dolby_prop() {
resetprop ro.vendor.dolby.dax.version DAX3_3.6.1.6_r1
resetprop vendor.audio.dolby.ds2.enabled false
resetprop vendor.audio.dolby.ds2.hardbypass false
resetprop ro.vendor.audio.dolby.dax.support true
#resetprop ro.vendor.audio.dolby.fade_switch true
#resetprop vendor.dolby.dap.param.tee false
#resetprop vendor.dolby.mi.metadata.log false
#resetprop vendor.audio.gef.enable.traces false
#resetprop vendor.audio.gef.debug.flags false
}

# property
#ddolby_prop
resetprop ro.audio.hifi false
resetprop ro.vendor.audio.hifi false
resetprop ro.vendor.audio.ring.filter true
resetprop ro.vendor.audio.scenario.support true
resetprop ro.vendor.audio.sfx.earadj true
resetprop ro.vendor.audio.sfx.independentequalizer true
resetprop ro.vendor.audio.sfx.scenario true
resetprop ro.vendor.audio.sfx.spk.stereo true
resetprop ro.audio.soundfx.type mi
resetprop ro.vendor.audio.soundfx.type mi
resetprop ro.audio.soundfx.usb true
resetprop ro.vendor.audio.soundfx.usb true
#hresetprop ro.vendor.audio.sfx.harmankardon false
#resetprop ro.vendor.audio.sfx.audiovisual false
#resetprop ro.audio.soundfx.dirac false
#resetprop ro.vendor.audio.sfx.speaker true
#resetprop ro.vendor.audio.sfx.spk.movie true
#resetprop ro.vendor.audio.surround.headphone.only false
#resetprop ro.vendor.audio.scenario.headphone.only false
#resetprop ro.vendor.audio.feature.spatial true
#resetprop ro.vendor.audio.misound.bluetooth.enable true

# restart
if [ "$API" -ge 24 ]; then
  SERVER=audioserver
else
  SERVER=mediaserver
fi
PID=`pidof $SERVER`
if [ "$PID" ]; then
  killall $SERVER
fi

# function
dolby_service() {
# stop
NAMES="dms-hal-1-0 dms-hal-2-0 dms-v36-hal-2-0"
for NAME in $NAMES; do
  if [ "`getprop init.svc.$NAME`" == running ]\
  || [ "`getprop init.svc.$NAME`" == restarting ]; then
    stop $NAME
  fi
done
# mount
DIR=/odm/bin/hw
FILE=$DIR/vendor.dolby_v3_6.hardware.dms360@2.0-service
if [ "`realpath $DIR`" == $DIR ] && [ -f $FILE ]; then
  mount -o bind $MODPATH/system/vendor/$FILE $FILE
fi
# run
SERVICES=`realpath /vendor`/bin/hw/vendor.dolby.hardware.dms@2.0-service
for SERVICE in $SERVICES; do
  killall $SERVICE
  $SERVICE &
  PID=`pidof $SERVICE`
done
# restart
killall vendor.qti.hardware.vibrator.service
killall vendor.qti.hardware.vibrator.service.oneplus9
killall android.hardware.camera.provider@2.4-service_64
killall vendor.mediatek.hardware.mtkpower@1.0-service
killall android.hardware.usb@1.0-service
killall android.hardware.usb@1.0-service.basic
killall android.hardware.light-service.mt6768
killall android.hardware.lights-service.xiaomi_mithorium
killall vendor.samsung.hardware.light-service
killall android.hardware.sensors@1.0-service
killall android.hardware.sensors@2.0-service-mediatek
killall android.hardware.sensors@2.0-service.multihal
}

# dolby
#ddolby_service

# wait
sleep 20

# aml fix
AML=/data/adb/modules/aml
if [ -L $AML/system/vendor ]\
&& [ -d $AML/vendor ]; then
  DIR=$AML/vendor/odm/etc
else
  DIR=$AML/system/vendor/odm/etc
fi
if [ -d $DIR ] && [ ! -f $AML/disable ]; then
  chcon -R u:object_r:vendor_configs_file:s0 $DIR
fi
AUD=`grep AUD= $MODPATH/copy.sh | sed -e 's|AUD=||g' -e 's|"||g'`
if [ -L $AML/system/vendor ]\
&& [ -d $AML/vendor ]; then
  DIR=$AML/vendor
else
  DIR=$AML/system/vendor
fi
FILES=`find $DIR -type f -name $AUD`
if [ -d $AML ] && [ ! -f $AML/disable ]\
&& find $DIR -type f -name $AUD; then
  if ! grep '/odm' $AML/post-fs-data.sh && [ -d /odm ]\
  && [ "`realpath /odm/etc`" == /odm/etc ]; then
    for FILE in $FILES; do
      DES=/odm`echo $FILE | sed "s|$DIR||g"`
      if [ -f $DES ]; then
        umount $DES
        mount -o bind $FILE $DES
      fi
    done
  fi
  if ! grep '/my_product' $AML/post-fs-data.sh\
  && [ -d /my_product ]; then
    for FILE in $FILES; do
      DES=/my_product`echo $FILE | sed "s|$DIR||g"`
      if [ -f $DES ]; then
        umount $DES
        mount -o bind $FILE $DES
      fi
    done
  fi
fi

# wait
until [ "`getprop sys.boot_completed`" == "1" ]; do
  sleep 10
done

# function
grant_permission() {
pm grant $PKG android.permission.READ_EXTERNAL_STORAGE
pm grant $PKG android.permission.WRITE_EXTERNAL_STORAGE
if [ "$API" -ge 29 ]; then
  pm grant $PKG android.permission.ACCESS_MEDIA_LOCATION 2>/dev/null
  appops set $PKG ACCESS_MEDIA_LOCATION allow
fi
if [ "$API" -ge 33 ]; then
  pm grant $PKG android.permission.READ_MEDIA_AUDIO
  pm grant $PKG android.permission.READ_MEDIA_VIDEO
  pm grant $PKG android.permission.READ_MEDIA_IMAGES
  appops set $PKG ACCESS_RESTRICTED_SETTINGS allow
fi
appops set $PKG LEGACY_STORAGE allow
appops set $PKG READ_EXTERNAL_STORAGE allow
appops set $PKG WRITE_EXTERNAL_STORAGE allow
appops set $PKG READ_MEDIA_AUDIO allow
appops set $PKG READ_MEDIA_VIDEO allow
appops set $PKG READ_MEDIA_IMAGES allow
appops set $PKG WRITE_MEDIA_AUDIO allow
appops set $PKG WRITE_MEDIA_VIDEO allow
appops set $PKG WRITE_MEDIA_IMAGES allow
if [ "$API" -ge 30 ]; then
  appops set $PKG MANAGE_EXTERNAL_STORAGE allow
  appops set $PKG NO_ISOLATED_STORAGE allow
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi
if [ "$API" -ge 31 ]; then
  appops set $PKG MANAGE_MEDIA allow
fi
PKGOPS=`appops get $PKG`
UID=`dumpsys package $PKG 2>/dev/null | grep -m 1 userId= | sed 's/    userId=//'`
if [ "$UID" -gt 9999 ]; then
  appops set --uid "$UID" LEGACY_STORAGE allow
  if [ "$API" -ge 29 ]; then
    appops set --uid "$UID" ACCESS_MEDIA_LOCATION allow
  fi
  UIDOPS=`appops get --uid "$UID"`
fi
}

# grant
PKG=com.miui.misound
pm grant $PKG android.permission.READ_PHONE_STATE
pm grant $PKG android.permission.RECORD_AUDIO
appops set $PKG SYSTEM_ALERT_WINDOW allow
if [ "$API" -ge 31 ]; then
  pm grant $PKG android.permission.BLUETOOTH_CONNECT
fi
grant_permission

# grant
PKG=com.dolby.daxservice
if pm list packages | grep $PKG; then
  if [ "$API" -ge 31 ]; then
    pm grant $PKG android.permission.BLUETOOTH_CONNECT
  fi
  if [ "$API" -ge 30 ]; then
    appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
  fi
  PKGOPS=`appops get $PKG`
  UID=`dumpsys package $PKG 2>/dev/null | grep -m 1 userId= | sed 's/    userId=//'`
  if [ "$UID" -gt 9999 ]; then
    UIDOPS=`appops get --uid "$UID"`
  fi
fi

# function
stop_log() {
FILE=$MODPATH/debug.log
SIZE=`du $FILE | sed "s|$FILE||"`
if [ "$LOG" != stopped ] && [ "$SIZE" -gt 50 ]; then
  exec 2>/dev/null
  LOG=stopped
fi
}
check_audioserver() {
if [ "$NEXTPID" ]; then
  PID=$NEXTPID
else
  PID=`pidof $SERVER`
fi
sleep 15
stop_log
NEXTPID=`pidof $SERVER`
if [ "`getprop init.svc.$SERVER`" != stopped ]; then
  until [ "$PID" != "$NEXTPID" ]; do
    check_audioserver
  done
  killall $PROC
  check_audioserver
else
  start $SERVER
  check_audioserver
fi
}
check_service() {
for SERVICE in $SERVICES; do
  if ! pidof $SERVICE; then
    $SERVICE &
    PID=`pidof $SERVICE`
  fi
done
}

# check
#dcheck_service
PROC=com.miui.misound
#dPROC="com.miui.misound com.dolby.daxservice"
killall $PROC
check_audioserver










