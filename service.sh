MODPATH=${0%/*}

# log
LOGFILE=$MODPATH/debug.log
exec 2>$LOGFILE
set -x

# var
API=`getprop ro.build.version.sdk`

# function
dolby_prop() {
resetprop -n ro.product.brand Redmi
resetprop -n ro.product.device alioth
resetprop -n ro.product.manufacturer Xiaomi
resetprop -n ro.vendor.dolby.dax.version DAX3_3.6.1.6_r1
resetprop -n vendor.audio.dolby.ds2.enabled false
resetprop -n vendor.audio.dolby.ds2.hardbypass false
resetprop -n ro.vendor.audio.dolby.dax.support true
resetprop -n ro.vendor.audio.dolby.fade_switch true
resetprop -n ro.dolby.mod_uuid false
#resetprop -n vendor.dolby.dap.param.tee false
#resetprop -n vendor.dolby.mi.metadata.log false
#resetprop -n vendor.audio.gef.enable.traces false
#resetprop -n vendor.audio.gef.debug.flags false
NAME=persist.vendor.audio.calfile
NAME2=adsp_avs_config.acdb
VAL=/vendor/etc/acdbdata/$NAME2
FILE=`find $MODPATH -type f -name $NAME2`
ROW=`getprop | grep $NAME | grep $NAME2`
if [ "$FILE" ] && [ ! "$ROW" ] ; then
  NUM=`getprop | grep $NAME | sed 's|]: .*||g' | sed "s|\[$NAME||g" | tr '\n' ' ' | tr ' ' '\n' | sort -n | tail -1`
  [ "$NUM" ] && NUM=`expr "$NUM" + 1` || NUM=0
  PROP=$NAME$NUM
  resetprop -p --delete $PROP
  resetprop -n $PROP $VAL
fi
}

# property
resetprop -n ro.audio.ignore_effects false
#ddolby_prop
resetprop -n ro.audio.hifi false
resetprop -n ro.vendor.audio.hifi false
resetprop -n ro.vendor.audio.ring.filter true
resetprop -n ro.vendor.audio.scenario.support true
resetprop -n ro.vendor.audio.sfx.earadj true
resetprop -n ro.vendor.audio.sfx.independentequalizer true
resetprop -n ro.vendor.audio.sfx.scenario true
resetprop -n ro.vendor.audio.sfx.spk.stereo true
resetprop -n ro.audio.soundfx.type mi
resetprop -n ro.vendor.audio.soundfx.type mi
resetprop -n ro.audio.soundfx.usb true
resetprop -n ro.vendor.audio.soundfx.usb true
resetprop -n ro.vendor.audio.misound.bluetooth.enable true
resetprop -n ro.vendor.audio.sfx.speaker true
resetprop -n ro.vendor.audio.sfx.spk.movie true
resetprop -n ro.vendor.audio.surround.headphone.only false
resetprop -n ro.vendor.audio.scenario.headphone.only false
resetprop -n ro.vendor.audio.feature.spatial true
#hresetprop -n ro.vendor.audio.sfx.harmankardon false
#resetprop -n ro.vendor.audio.sfx.audiovisual false
#resetprop -n ro.audio.soundfx.dirac false

# restart
if [ "$API" -ge 24 ]; then
  SERVER=audioserver
else
  SERVER=mediaserver
fi
killall $SERVER\
 android.hardware.audio@4.0-service-mediatek

# function
dolby_service() {
# stop
NAMES="dms-hal-1-0 dms-hal-2-0 dms-v36-hal-2-0 dms-sp-hal-2-0"
for NAME in $NAMES; do
  if [ "`getprop init.svc.$NAME`" == running ]\
  || [ "`getprop init.svc.$NAME`" == restarting ]; then
    stop $NAME
  fi
done
# mount
DIR=/odm/bin/hw
FILES="$DIR/vendor.dolby_v3_6.hardware.dms360@2.0-service
       $DIR/vendor.dolby.hardware.dms@2.0-service
       $DIR/vendor.dolby_sp.hardware.dmssp@2.0-service"
if [ "`realpath $DIR`" == $DIR ]; then
  for FILE in $FILES; do
    if [ -f $FILE ]; then
      if [ -L $MODPATH/system/vendor ]\
      && [ -d $MODPATH/vendor ]; then
        mount -o bind $MODPATH/vendor$FILE $FILE
      else
        mount -o bind $MODPATH/system/vendor$FILE $FILE
      fi
    fi
  done
fi
# run
SERVICES=`realpath /vendor`/bin/hw/vendor.dolby.hardware.dms@2.0-service
for SERVICE in $SERVICES; do
  killall $SERVICE
  if ! stat -c %a $SERVICE | grep -E '755|775|777|757'\
  || [ "`stat -c %u.%g $SERVICE`" != 0.2000 ]; then
    mount -o remount,rw $SERVICE
    chmod 0755 $SERVICE
    chown 0.2000 $SERVICE
  fi
  $SERVICE &
  PID=`pidof $SERVICE`
done
# restart
killall vendor.qti.hardware.vibrator.service\
 vendor.qti.hardware.vibrator.service.oneplus9\
 vendor.qti.hardware.vibrator.service.oplus\
 android.hardware.camera.provider@2.4-service_64\
 vendor.mediatek.hardware.mtkpower@1.0-service\
 android.hardware.usb@1.0-service\
 android.hardware.usb@1.0-service.basic\
 android.hardware.light-service.mt6768\
 android.hardware.lights-service.xiaomi_mithorium\
 vendor.samsung.hardware.light-service\
 android.hardware.health-service.qti
#skillall vendor.qti.hardware.display.allocator-service\
#s vendor.qti.hardware.display.composer-service
if [ "$API" -le 33 ]; then
  killall android.hardware.sensors@1.0-service\
   android.hardware.sensors@2.0-service\
   android.hardware.sensors@2.0-service-mediatek\
   android.hardware.sensors@2.0-service.multihal
fi
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
until [ "`getprop sys.boot_completed`" == 1 ]; do
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
if [ "$API" -ge 34 ]; then
  appops set "$PKG" READ_MEDIA_VISUAL_USER_SELECTED allow
fi
PKGOPS=`appops get $PKG`
UID=`dumpsys package $PKG 2>/dev/null | grep -m 1 Id= | sed -e 's|    userId=||g' -e 's|    appId=||g'`
if [ "$UID" ] && [ "$UID" -gt 9999 ]; then
  appops set --uid "$UID" LEGACY_STORAGE allow
  appops set --uid "$UID" READ_EXTERNAL_STORAGE allow
  appops set --uid "$UID" WRITE_EXTERNAL_STORAGE allow
  if [ "$API" -ge 29 ]; then
    appops set --uid "$UID" ACCESS_MEDIA_LOCATION allow
  fi
  if [ "$API" -ge 34 ]; then
    appops set --uid "$UID" READ_MEDIA_VISUAL_USER_SELECTED allow
  fi
  UIDOPS=`appops get --uid "$UID"`
fi
}

# grant
PKG=com.miui.misound
pm grant $PKG android.permission.READ_PHONE_STATE
pm grant $PKG android.permission.RECORD_AUDIO
appops set $PKG SYSTEM_ALERT_WINDOW allow
if [ "$API" -ge 33 ]; then
  pm grant $PKG android.permission.POST_NOTIFICATIONS
fi
if [ "$API" -ge 31 ]; then
  pm grant $PKG android.permission.BLUETOOTH_CONNECT
fi
grant_permission

# grant
PKG=com.dolby.daxservice
if appops get $PKG > /dev/null 2>&1; then
  if [ "$API" -ge 31 ]; then
    pm grant $PKG android.permission.BLUETOOTH_CONNECT
  fi
  if [ "$API" -ge 30 ]; then
    appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
  fi
  PKGOPS=`appops get $PKG`
  UID=`dumpsys package $PKG 2>/dev/null | grep -m 1 Id= | sed -e 's|    userId=||g' -e 's|    appId=||g'`
  if [ "$UID" ] && [ "$UID" -gt 9999 ]; then
    UIDOPS=`appops get --uid "$UID"`
  fi
fi

# audio flinger
DMAF=`dumpsys media.audio_flinger`

# function
stop_log() {
SIZE=`du $LOGFILE | sed "s|$LOGFILE||g"`
if [ "$LOG" != stopped ] && [ "$SIZE" -gt 75 ]; then
  exec 2>/dev/null
  set +x
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
  [ "$PID" != "$NEXTPID" ] && killall $PROC
else
  start $SERVER
fi
check_audioserver
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










