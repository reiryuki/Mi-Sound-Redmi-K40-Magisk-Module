(

mount /data
mount -o rw,remount /data
MODPATH=${0%/*}
AML=/data/adb/modules/aml
ACDB=/data/adb/modules/acdb

# debug
magiskpolicy --live "dontaudit system_server system_file file write"
magiskpolicy --live "allow     system_server system_file file write"
exec 2>$MODPATH/debug-pfsd.log
set -x

# run
FILE=$MODPATH/sepolicy.sh
if [ -f $FILE ]; then
  sh $FILE
fi

# etc
if [ -d /sbin/.magisk ]; then
  MAGISKTMP=/sbin/.magisk
else
  MAGISKTMP=`find /dev -mindepth 2 -maxdepth 2 -type d -name .magisk`
fi
ETC="/my_product/etc $MAGISKTMP/mirror/system/etc"
VETC=$MAGISKTMP/mirror/system/vendor/etc
VOETC="/odm/etc $MAGISKTMP/mirror/system/vendor/odm/etc"
MODETC=$MODPATH/system/etc
MODVETC=$MODPATH/system/vendor/etc
MODVOETC=$MODPATH/system/vendor/odm/etc

# conflict
if [ -d $AML ] && [ ! -f $AML/disable ]\
&& [ -d $ACDB ] && [ ! -f $ACDB/disable ]; then
  touch $ACDB/disable
fi

# directory
SKU=`ls $VETC/audio | grep sku_`
if [ "$SKU" ]; then
  for SKUS in $SKU; do
    mkdir -p $MODVETC/audio/$SKUS
  done
fi
PROP=`getprop ro.build.product`
if [ -d $VETC/audio/"$PROP" ]; then
  mkdir -p $MODVETC/audio/"$PROP"
fi

# audio files
NAME="*audio*effects*.conf -o -name *audio*effects*.xml -o -name *policy*.conf -o -name *policy*.xml"
rm -f `find $MODPATH/system -type f -name $NAME`
A=`find $ETC -maxdepth 1 -type f -name $NAME`
VA=`find $VETC -maxdepth 1 -type f -name $NAME`
VOA=`find $OETC -maxdepth 1 -type f -name $NAME`
VAA=`find $VETC/audio -maxdepth 1 -type f -name $NAME`
VBA=`find $VETC/audio/"$PROP" -maxdepth 1 -type f -name $NAME`
if [ "$A" ]; then
  cp -f $A $MODETC
fi
if [ "$VA" ]; then
  cp -f $VA $MODVETC
fi
if [ "$VOA" ]; then
  cp -f $VOA $MODOETC
fi
if [ "$VAA" ]; then
  cp -f $VAA $MODOETC/audio
fi
if [ "$VBA" ]; then
  cp -f $VBA $MODVETC/audio/"$PROP"
fi
if [ "$SKU" ]; then
  for SKUS in $SKU; do
    VSA=`find $VETC/audio/$SKUS -maxdepth 1 -type f -name $NAME`
    if [ "$VSA" ]; then
      cp -f $VSA $MODVETC/audio/$SKUS
    fi
  done
fi

# aml fix
DIR=$AML/system/vendor/odm/etc
if [ "$VOA" ] && [ -d $AML ] && [ ! -f $AML/disable ] && [ ! -d $DIR ]; then
  mkdir -p $DIR
  cp -f $VOA $DIR
fi
magiskpolicy --live "dontaudit vendor_configs_file labeledfs filesystem associate"
magiskpolicy --live "allow     vendor_configs_file labeledfs filesystem associate"
magiskpolicy --live "dontaudit init vendor_configs_file dir relabelfrom"
magiskpolicy --live "allow     init vendor_configs_file dir relabelfrom"
magiskpolicy --live "dontaudit init vendor_configs_file file relabelfrom"
magiskpolicy --live "allow     init vendor_configs_file file relabelfrom"
chcon -R u:object_r:vendor_configs_file:s0 $DIR

# function
media_codecs() {
NAME=media_codecs.xml
rm -f $MODVETC/$NAME
DIR=$AML/system/vendor/etc
if [ -d $AML ] && [ ! -f $AML/disable ]; then
  if [ ! -d $DIR ]; then
    mkdir -p $DIR
  fi
  cp -f $VETC/$NAME $DIR
else
  cp -f $VETC/$NAME $MODVETC
fi
}

# media codecs
#dmedia_codecs

# run
sh $MODPATH/.aml.sh

# function
dolby_data() {
DIR=/data/vendor/dolby
if [ ! -d $DIR ]; then
  mkdir -p $DIR
fi
chmod 0770 $DIR
chown 1013.1013 $DIR
magiskpolicy --live "dontaudit vendor_data_file labeledfs filesystem associate"
magiskpolicy --live "allow     vendor_data_file labeledfs filesystem associate"
magiskpolicy --live "dontaudit init vendor_data_file dir relabelfrom"
magiskpolicy --live "allow     init vendor_data_file dir relabelfrom"
magiskpolicy --live "dontaudit init vendor_data_file file relabelfrom"
magiskpolicy --live "allow     init vendor_data_file file relabelfrom"
chcon u:object_r:vendor_data_file:s0 $DIR
}

# directory
#ddolby_data

# run
sh $MODPATH/.aml.sh

# cleaning
FILE=$MODPATH/cleaner.sh
if [ -f $FILE ]; then
  sh $FILE
  rm -f $FILE
fi

# function
dolby_manifest() {
if ! grep -A2 vendor.dolby.hardware.dms $FILE | grep 2.0; then
  cp -f $M $MODM
  if [ -f $MODM ]; then
    sed -i '/<manifest/a\
    <hal format="hidl">\
        <name>vendor.dolby.hardware.dms</name>\
        <transport>hwbinder</transport>\
        <version>2.0</version>\
        <interface>\
            <name>IDms</name>\
            <instance>default</instance>\
        </interface>\
        <fqname>@2.0::IDms/default</fqname>\
    </hal>' $MODM
    mount -o bind $MODM /system/etc/vintf/$NAME
    killall hwservicemanager
  fi
fi
}

# manifest
NAME=manifest.xml
M=$ETC/vintf/$NAME
MODM=$MODETC/vintf/$NAME
rm -f $MODM
FILE=`find $MAGISKTMP/mirror/*/etc/vintf\
           $MAGISKTMP/mirror/*/*/etc/vintf\
           /*/etc/vintf /*/*/etc/vintf -type f -name *.xml`
#ddolby_manifest

) 2>/dev/null













