(

MODPATH=${0%/*}
API=`getprop ro.build.version.sdk`
AML=/data/adb/modules/aml

# debug
exec 2>$MODPATH/debug.log
set -x

# property
resetprop ro.vendor.audio.ring.filter true
resetprop ro.vendor.audio.sfx.earadj true
resetprop ro.vendor.audio.soundfx.type mi
resetprop ro.vendor.audio.soundfx.usb true
#resetprop ro.vendor.audio.sfx.audiovisual false
resetprop ro.vendor.audio.sfx.scenario true
resetprop ro.vendor.audio.hifi false
resetprop ro.vendor.audio.sfx.independentequalizer true
#dresetprop ro.vendor.dolby.dax.version DAX3_3.6.0.12_r1
#dresetprop vendor.audio.dolby.ds2.enabled false
#dresetprop vendor.audio.dolby.ds2.hardbypass false
#dresetprop ro.vendor.audio.dolby.dax.support true
#d#11resetprop ro.vendor.product.device.db OP_DEVICE
#d#11resetprop ro.vendor.product.manufacturer.db OP_PHONE
#d#10resetprop vendor.product.device OP_PHONE
#d#10resetprop vendor.product.manufacturer OPD
#resetprop vendor.dolby.dap.param.tee false
#resetprop vendor.dolby.mi.metadata.log false
#resetprop vendor.audio.gef.enable.traces false
#resetprop vendor.audio.gef.debug.flags false

# notes
#ro.audio.hifi
#ro.audio.soundfx.dirac
#ro.audio.soundfx.type
#ro.audio.soundfx.usb
#ro.board.platform
#ro.boot.hwversion
#ro.build.description
#ro.build.freeme.label
#ro.build.product
#ro.build.version.sdk
#ro.carrier.name
#ro.miui.cust_variant
#ro.miui.notch
#ro.miui.region
#ro.miui.restrict_imei
#ro.miui.ui.version.code
#ro.miui.xms.version
#ro.product.locale.region
#ro.product.manufacturer
#ro.product.mod_device
#ro.product.model
#ro.product.model.real
#ro.product.name
#ro.ssui.product
#ro.vendor.audio.sfx.harmankardon
#ro.vendor.audio.sfx.speaker
#ro.vendor.audio.sfx.spk.movie
#ro.vendor.audio.sfx.spk.stereo

# restart
killall audioserver

# function
stop_service() {
if getprop | grep "init.svc.$NAME\]: \[running"; then
  stop $NAME
fi
}
run_service() {
killall $FILE
$FILE &
PID=`pidof $FILE`
}

# stop
NAME=dms-hal-1-0
#dstop_service
NAME=dms-hal-2-0
#dstop_service
NAME=dms-v36-hal-2-0
#dstop_service
NAME=vendor-ozoaudio-media-c2-hal-1-0
#dstop_service

# run
FILE=/vendor/bin/hw/vendor.dolby.hardware.dms@2.0-service
#drun_service
FILE=/vendor/bin/hw/vendor.ozoaudio.media.c2@1.0-service
run_service

# wait
sleep 20

# mount
NAME="*audio*effects*.conf -o -name *audio*effects*.xml -o -name *policy*.conf -o -name *policy*.xml"
if [ ! -d $AML ] || [ -f $AML/disable ]; then
  DIR=$MODPATH/system/vendor
else
  DIR=$AML/system/vendor
fi
FILE=`find $DIR/etc -maxdepth 1 -type f -name $NAME`
if [ `realpath /odm/etc` == /odm/etc ] && [ "$FILE" ]; then
  for i in $FILE; do
    j="/odm$(echo $i | sed "s|$DIR||")"
    if [ -f $j ]; then
      umount $j
      mount -o bind $i $j
    fi
  done
fi
if [ -d /my_product/etc ] && [ "$FILE" ]; then
  for i in $FILE; do
    j="/my_product$(echo $i | sed "s|$DIR||")"
    if [ -f $j ]; then
      umount $j
      mount -o bind $i $j
    fi
  done
fi
if ( [ `realpath /odm/etc` == /odm/etc ] && [ "$FILE" ] )\
|| ( [ -d /my_product/etc ] && [ "$FILE" ] ); then
  killall audioserver
  FILE=/vendor/bin/hw/vendor.dolby.hardware.dms@2.0-service
  #drun_service
  FILE=/vendor/bin/hw/vendor.ozoaudio.media.c2@1.0-service
  run_service
fi

# aml fix
DIR=$AML/system/vendor/odm/etc
if [ -d $DIR ] && [ ! -f $AML/disable ]; then
  chcon -R u:object_r:vendor_configs_file:s0 $DIR
fi

# wait
sleep 40

# socket
#FILE=/dev/socket/audio_hw_socket
#if [ ! -e $FILE ]; then
#  rm -f /data/media/0/has_audio_hw_socket
#  touch /data/media/0/no_audio_hw_socket
#else
#  rm -f /data/media/0/no_audio_hw_socket
#  touch /data/media/0/has_audio_hw_socket
#fi
#chmod 0666 $FILE
#chown 1000.1000 $FILE
#chcon u:object_r:audio_socket:s0 $FILE

# grant
PKG=com.miui.misound
pm grant $PKG android.permission.READ_PHONE_STATE
pm grant $PKG android.permission.RECORD_AUDIO
if [ "$API" -ge 30 ]; then
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi

# grant
PKG=com.dolby.daxservice
if [ "$API" -ge 30 ]; then
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi

) 2>/dev/null



