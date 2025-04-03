# space
ui_print " "

# var
UID=`id -u`
[ ! "$UID" ] && UID=0
FIRARCH=`grep_get_prop ro.bionic.arch`
SECARCH=`grep_get_prop ro.bionic.2nd_arch`
ABILIST=`grep_get_prop ro.product.cpu.abilist`
if [ ! "$ABILIST" ]; then
  ABILIST=`grep_get_prop ro.system.product.cpu.abilist`
fi
if [ "$FIRARCH" == arm64 ]\
&& ! echo "$ABILIST" | grep -q arm64-v8a; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,arm64-v8a"
  else
    ABILIST=arm64-v8a
  fi
fi
if [ "$FIRARCH" == x64 ]\
&& ! echo "$ABILIST" | grep -q x86_64; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,x86_64"
  else
    ABILIST=x86_64
  fi
fi
if [ "$SECARCH" == arm ]\
&& ! echo "$ABILIST" | grep -q armeabi; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,armeabi"
  else
    ABILIST=armeabi
  fi
fi
if [ "$SECARCH" == arm ]\
&& ! echo "$ABILIST" | grep -q armeabi-v7a; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,armeabi-v7a"
  else
    ABILIST=armeabi-v7a
  fi
fi
if [ "$SECARCH" == x86 ]\
&& ! echo "$ABILIST" | grep -q x86; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,x86"
  else
    ABILIST=x86
  fi
fi
ABILIST32=`grep_get_prop ro.product.cpu.abilist32`
if [ ! "$ABILIST32" ]; then
  ABILIST32=`grep_get_prop ro.system.product.cpu.abilist32`
fi
if [ "$SECARCH" == arm ]\
&& ! echo "$ABILIST32" | grep -q armeabi; then
  if [ "$ABILIST32" ]; then
    ABILIST32="$ABILIST32,armeabi"
  else
    ABILIST32=armeabi
  fi
fi
if [ "$SECARCH" == arm ]\
&& ! echo "$ABILIST32" | grep -q armeabi-v7a; then
  if [ "$ABILIST32" ]; then
    ABILIST32="$ABILIST32,armeabi-v7a"
  else
    ABILIST32=armeabi-v7a
  fi
fi
if [ "$SECARCH" == x86 ]\
&& ! echo "$ABILIST32" | grep -q x86; then
  if [ "$ABILIST32" ]; then
    ABILIST32="$ABILIST32,x86"
  else
    ABILIST32=x86
  fi
fi
if [ ! "$ABILIST32" ]; then
  [ -f /system/lib/libandroid.so ] && ABILIST32=true
fi

# log
if [ "$BOOTMODE" != true ]; then
  FILE=/data/media/"$UID"/$MODID\_recovery.log
  ui_print "- Log will be saved at $FILE"
  exec 2>$FILE
  ui_print " "
fi

# optionals
OPTIONALS=/data/media/"$UID"/optionals.prop
if [ ! -f $OPTIONALS ]; then
  touch $OPTIONALS
fi

# debug
if [ "`grep_prop debug.log $OPTIONALS`" == 1 ]; then
  ui_print "- The install log will contain detailed information"
  set -x
  ui_print " "
fi

# recovery
if [ "$BOOTMODE" != true ]; then
  MODPATH_UPDATE=`echo $MODPATH | sed 's|modules/|modules_update/|g'`
  rm -f $MODPATH/update
  rm -rf $MODPATH_UPDATE
fi

# run
. $MODPATH/function.sh

# info
MODVER=`grep_prop version $MODPATH/module.prop`
MODVERCODE=`grep_prop versionCode $MODPATH/module.prop`
ui_print " ID=$MODID"
ui_print " Version=$MODVER"
ui_print " VersionCode=$MODVERCODE"
if [ "$KSU" == true ]; then
  ui_print " KSUVersion=$KSU_VER"
  ui_print " KSUVersionCode=$KSU_VER_CODE"
  ui_print " KSUKernelVersionCode=$KSU_KERNEL_VER_CODE"
  sed -i 's|#k||g' $MODPATH/post-fs-data.sh
else
  ui_print " MagiskVersion=$MAGISK_VER"
  ui_print " MagiskVersionCode=$MAGISK_VER_CODE"
fi
ui_print " "

# dolby
if [ "`grep_prop misound.dolby $OPTIONALS`" == 0 ]; then
  DOLBY=false
else
  DOLBY=true
fi

# architecture
if [ "$ABILIST" ]; then
  ui_print "- $ABILIST architecture"
  ui_print " "
fi
NAME=arm64-v8a
NAME2=armeabi-v7a
if ! echo "$ABILIST" | grep -Eq "$NAME|$NAME2"; then
  if [ "$BOOTMODE" == true ]; then
    ui_print "! This ROM doesn't support $NAME"
    ui_print "  nor $NAME2 architecture"
  else
    ui_print "! This Recovery doesn't support $NAME"
    ui_print "  nor $NAME2 architecture"
    ui_print "  Try to install via Magisk app instead"
  fi
  ui_print "  Mi Sound EQ will not work"
  ui_print "  except this ROM has built-in misoundfx"
  ui_print " "
fi
if ! echo "$ABILIST" | grep -q $NAME; then
  rm -rf `find $MODPATH/system -type d -name *64*`
  if [ $DOLBY == true ]; then
    ui_print "! Unsupported Dolby Atmos"
    ui_print " "
  fi
  DOLBY=false
  if [ "$BOOTMODE" != true ]; then
    ui_print "! This Recovery doesn't support $NAME architecture"
    ui_print "  Try to install via Magisk app instead"
    ui_print " "
  fi
fi
if ! echo "$ABILIST" | grep -q $NAME2; then
  rm -rf $MODPATH/system*/lib\
   $MODPATH/system*/vendor/lib
  if [ "$BOOTMODE" != true ]; then
    ui_print "! This Recovery doesn't support $NAME2 architecture"
    ui_print "  Try to install via Magisk app instead"
    ui_print " "
  fi
fi

# sdk
NUM=26
if [ "$API" -lt $NUM ]; then
  ui_print "! Unsupported SDK $API."
  ui_print "  You have to upgrade your Android version"
  ui_print "  at least SDK $NUM to use this module."
  abort
else
  ui_print "- SDK $API"
  if [ $DOLBY == true ] && [ "$API" -lt 30 ]; then
    ui_print "  ! Unsupported Dolby Atmos."
    DOLBY=false
  fi
  ui_print " "
fi

# miuicore
if [ ! -d /data/adb/modules/MiuiCore ]; then
  ui_print "! Miui Core Magisk Module is not installed."
  ui_print "  MiSound app will not be working without"
  ui_print "  Miui Core Magisk Module except you are in Miui ROM!"
  ui_print " "
else
  rm -f /data/adb/modules/MiuiCore/remove
  rm -f /data/adb/modules/MiuiCore/disable
fi

# recovery
mount_partitions_in_recovery

# magisk
magisk_setup

# path
SYSTEM=`realpath $MIRROR/system`
VENDOR=`realpath $MIRROR/vendor`
PRODUCT=`realpath $MIRROR/product`
SYSTEM_EXT=`realpath $MIRROR/system_ext`
ODM=`realpath $MIRROR/odm`
MY_PRODUCT=`realpath $MIRROR/my_product`

# create
if [ $DOLBY == true ]; then
  mkdir -p $MODPATH/system_dolby/etc/vintf
  NAMES="vendor.dolby.hardware.dms@1.0-service
         vendor.dolby_sp.hardware.dmssp@2.0-service
         vendor.dolby_v3_6.hardware.dms360@2.0-service"
  for NAME in $NAMES; do
    if [ -f $VENDOR/bin/hw/$NAME ]; then
      touch $MODPATH/system_dolby/vendor/bin/hw/$NAME
    fi
  done
  if [ -d $ODM/bin/hw ] || [ -d $VENDOR/odm/bin/hw ]; then
    mkdir -p $MODPATH/system_dolby/vendor/odm/bin/hw
  fi
  NAMES="vendor.dolby.hardware.dms@1.0-service
         vendor.dolby.hardware.dms@2.0-service
         vendor.dolby_sp.hardware.dmssp@2.0-service
         vendor.dolby_v3_6.hardware.dms360@2.0-service"
  for NAME in $NAMES; do
    if [ -f $ODM/bin/hw/$NAME ]\
    || [ -f $VENDOR/odm/bin/hw/$NAME ]; then
      touch $MODPATH/system_dolby/vendor/odm/bin/hw/$NAME
    fi
  done
fi

# check
if [ $DOLBY == true ]\
&& [ "`grep_prop dolby.mod $OPTIONALS`" != 1 ]; then
  ui_print "- Checking in-built Dolby apps..."
  FILE=`find /system/app /system/priv-app /product/app\
        /product/priv-app /product/preinstall /system_ext/app\
        /system_ext/priv-app /vendor/app /vendor/euclid/product/app\
        -type f -name XiaomyDolby.apk -o -name DolbyManager.apk`
  if [ "$FILE" ]; then
    ui_print "  Detected"
    ui_print "$FILE"
    ui_print "  You need to use dolby.mod=1 to use the Dolby Atmos,"
    ui_print "  otherwise the Dolby Atmos will not work. Please check"
    ui_print "  Optionals at README."
  fi
  ui_print " "
fi

# check
if [ $DOLBY == true ]; then
  FILE=/bin/hw/vendor.dolby.media.c2@1.0-service
  if [ -f $SYSTEM$FILE ] || [ -f $VENDOR$FILE ]\
  || [ -f $ODM$FILE ] || [ -f $SYSTEM_EXT$FILE ]\
  || [ -f $PRODUCT$FILE ]; then
    ui_print "! Dolby Atmos maybe conflicting with your"
    ui_print "  $FILE"
    ui_print "  causes your internal storage mount failure"
    ui_print " "
  fi
fi

# .aml.sh
mv -f $MODPATH/aml.sh $MODPATH/.aml.sh

# function
check_function_2() {
if [ -f $MODPATH/system_support$DIR/$LIB ]; then
  ui_print "- Checking"
  ui_print "$NAME"
  ui_print "  function at"
  ui_print "$FILE"
  ui_print "  Please wait..."
  if ! grep -q $NAME $FILE; then
    ui_print "  Function not found."
    ui_print "  Replaces /system$DIR/$LIB systemlessly."
    mv -f $MODPATH/system_support$DIR/$LIB $MODPATH/system$DIR
    [ "$MES" ] && ui_print "$MES"
  fi
  ui_print " "
fi
}
check_function() {
if [ -d $MODPATH/system_support/vendor$DIR/hw ]; then
  ui_print "- Checking"
  ui_print "$NAME"
  ui_print "  function at"
  ui_print "$FILE"
  ui_print "  Please wait..."
  if grep -q $NAME $FILE; then
    ui_print " "
  else
    ui_print "  Function not found."
    ui_print "  Replaces /vendor$DIR/hw/*audio*.so systemlessly."
    mv -f $MODPATH/system_support/vendor$DIR/hw $MODPATH/system/vendor$DIR
    [ "$MES" ] && ui_print "$MES"
    ui_print " "
  fi
fi
}

# check
if [ $DOLBY == true ]; then
  ui_print "- Activating Dolby Atmos..."
  ui_print " "
  NAME=_ZN7android23sp_report_stack_pointerEv
  if [ "$IS64BIT" == true ]; then
    DIR=/lib64
    FILE=$VENDOR$DIR/hw/*audio*.so
    check_function
  fi
  if [ "$ABILIST32" ]; then
    DIR=/lib
    FILE=$VENDOR$DIR/hw/*audio*.so
    check_function
  fi
  NAME=_ZN7android8hardware23getOrCreateCachedBinderEPNS_4hidl4base4V1_05IBaseE
  DES=vendor.dolby.hardware.dms@2.0.so
  LIB=libhidlbase.so
  if [ "$IS64BIT" == true ]; then
    DIR=/lib64
    LISTS=`strings $MODPATH/system_dolby/vendor$DIR/$DES | grep ^lib | grep .so`
    FILE=`for LIST in $LISTS; do echo $SYSTEM$DIR/$LIST; done`
    check_function_2
  fi
  if [ "$ABILIST32" ]; then
    DIR=/lib
    LISTS=`strings $MODPATH/system_dolby/vendor$DIR/$DES | grep ^lib | grep .so`
    FILE=`for LIST in $LISTS; do echo $SYSTEM$DIR/$LIST; done`
    check_function_2
  fi
  MODNAME2='Mi Sound and Dolby Atmos Redmi K40'
  sed -i "s|$MODNAME|$MODNAME2|g" $MODPATH/module.prop
  MODNAME=$MODNAME2
  cp -rf $MODPATH/system_dolby/* $MODPATH/system
  sed -i 's|ro.vendor.audio.dolby.dax.support false|ro.vendor.audio.dolby.dax.support true|g' $MODPATH/service.sh
  if [ "`grep_prop dolby.rhode $OPTIONALS`" == 1 ]; then
    ui_print "- Using libswdap.so from Moto G52 (rhode)"
    cp -rf $MODPATH/system_rhode/* $MODPATH/system
    sed -i 's|resetprop -n ro.product.brand|#resetprop -n ro.product.brand|g' $MODPATH/service.sh
    sed -i 's|resetprop -n ro.product.device|#resetprop -n ro.product.device|g' $MODPATH/service.sh
    sed -i 's|resetprop -n ro.product.manufacturer|#resetprop -n ro.product.manufacturer|g' $MODPATH/service.sh
    sed -i 's|#ddap_proxy|dap|g' $MODPATH/.aml.sh
    ui_print " "
  else
    sed -i 's|#ddap_proxy|dap_proxy|g' $MODPATH/.aml.sh
  fi
  sed -i 's|#d||g' $MODPATH/.aml.sh
  sed -i 's|#d||g' $MODPATH/*.sh
fi

# check
FILE=$VENDOR/lib/soundfx/libmisoundfx.so
FILE2=$ODM/lib/soundfx/libmisoundfx.so
FILE3=$VENDOR/lib64/soundfx/libmisoundfx.so
FILE4=$ODM/lib64/soundfx/libmisoundfx.so
if [ -f $FILE ] || [ -f $FILE2 ] || [ -f $FILE3 ]\
|| [ -f $FILE4 ]; then
  ui_print "- Built-in misoundfx is detected."
  rm -f `find $MODPATH/system/vendor -type f -name *misound*`
  ui_print " "
else
  if [ ! -e /dev/socket/audio_hw_socket ]; then
    ui_print "! Unsupported audio_hw_socket."
    ui_print "  Mi Sound EQ will not be working with this device"
    if [ $DOLBY == true ]; then
      ui_print "  but you can still use the Dolby Atmos EQ."
    fi
    ui_print " "
  fi
  NAME=_ZN7android23sp_report_stack_pointerEv
  if [ "$IS64BIT" == true ]; then
    DIR=/lib64
    FILE=$VENDOR$DIR/hw/*audio*.so
    check_function
  fi
  if [ "$ABILIST32" ]; then
    DIR=/lib
    FILE=$VENDOR$DIR/hw/*audio*.so
    check_function
  fi
fi

# sepolicy
FILE=$MODPATH/sepolicy.rule
DES=$MODPATH/sepolicy.pfsd
if [ "`grep_prop sepolicy.sh $OPTIONALS`" == 1 ]\
&& [ -f $FILE ]; then
  mv -f $FILE $DES
fi

# mod ui
if [ "`grep_prop mod.ui $OPTIONALS`" == 1 ]; then
  APP=MiSound
  FILE=/data/media/"$UID"/$APP.apk
  DIR=`find $MODPATH/system -type d -name $APP`
  ui_print "- Using modified UI apk..."
  if [ -f $FILE ]; then
    cp -f $FILE $DIR
    chmod 0644 $DIR/$APP.apk
    ui_print "  Applied"
  else
    ui_print "  ! There is no $FILE file."
    ui_print "    Please place the apk to your internal storage first"
    ui_print "    and reflash!"
  fi
  ui_print " "
fi

# function
extract_lib() {
for APP in $APPS; do
  FILE=`find $MODPATH/system -type f -name $APP.apk`
  if [ -f `dirname $FILE`/extract ]; then
    ui_print "- Extracting..."
    DIR=`dirname $FILE`/lib/"$ARCHLIB"
    mkdir -p $DIR
    rm -rf $TMPDIR/*
    DES=lib/"$ABILIB"/*
    unzip -d $TMPDIR -o $FILE $DES
    cp -f $TMPDIR/$DES $DIR
    ui_print " "
  fi
done
}

# extract
APPS="`ls $MODPATH/system/priv-app`
      `ls $MODPATH/system/app`"
ARCHLIB=arm64
ABILIB=arm64-v8a
extract_lib
ARCHLIB=arm
if echo "$ABILIST" | grep -q armeabi-v7a; then
  ABILIB=armeabi-v7a
  extract_lib
elif echo "$ABILIST" | grep -q armeabi; then
  ABILIB=armeabi
  extract_lib
else
  ABILIB=armeabi-v7a
  extract_lib
fi
ARCHLIB=x64
ABILIB=x86_64
extract_lib
ARCHLIB=x86
ABILIB=x86
extract_lib
rm -f `find $MODPATH/system -type f -name extract`

# cleaning
ui_print "- Cleaning..."
if [ $DOLBY == true ]; then
  PKGS=`cat $MODPATH/package-dolby.txt`
  if [ "`grep_prop dolby.mod $OPTIONALS`" == 1 ]; then
    rm -f /data/vendor/dolby/dap_sqlite3.db
    sed -i 's|dax_sqlite3.db|dap_sqlite3.db|g' $MODPATH/uninstall.sh
  else
    rm -f /data/vendor/dolby/dax_sqlite3.db
  fi
else
  PKGS=`cat $MODPATH/package.txt`
fi
if [ "$BOOTMODE" == true ]; then
  for PKG in $PKGS; do
    FILE=`find /data/app -name *$PKG*`
    if [ "$FILE" ]; then
      RES=`pm uninstall $PKG 2>/dev/null`
    fi
  done
fi
rm -rf $MODPATH/system_dolby $MODPATH/system_rhode\
 $MODPATH/system_support $MODPATH/unused
remove_sepolicy_rule
ui_print " "

# function
conflict() {
for NAME in $NAMES; do
  DIR=/data/adb/modules_update/$NAME
  if [ -f $DIR/uninstall.sh ]; then
    sh $DIR/uninstall.sh
  fi
  rm -rf $DIR
  DIR=/data/adb/modules/$NAME
  rm -f $DIR/update
  touch $DIR/remove
  FILE=/data/adb/modules/$NAME/uninstall.sh
  if [ -f $FILE ]; then
    sh $FILE
    rm -f $FILE
  fi
  rm -rf /metadata/magisk/$NAME\
   /mnt/vendor/persist/magisk/$NAME\
   /persist/magisk/$NAME\
   /data/unencrypted/magisk/$NAME\
   /cache/magisk/$NAME\
   /cust/magisk/$NAME
done
}
conflict_disable() {
for NAME in $NAMES; do
  DIR=/data/adb/modules_update/$NAME
  touch $DIR/disable
  DIR=/data/adb/modules/$NAME
  touch $DIR/disable
done
}

# conflict
NAMES=diracmisoundfxRemover
conflict_disable
if [ $DOLBY == true ]; then
  if [ "`grep_prop dolby.mod $OPTIONALS`" == 1 ]; then
    NAMES="dolbyatmos DolbyAudio DolbyAtmos MotoDolby
           DolbyAtmos360 DolbyAtmosSP"
  else
    NAMES="dolbyatmos DolbyAudio DolbyAtmos MotoDolby
           DolbyAtmos360 DolbyAtmosSP dsplus Dolby"
  fi
  conflict
  NAMES=SoundEnhancement
  FILE=/data/adb/modules/$NAMES/module.prop
  if grep -q 'and Dolby Atmos' $FILE; then
    conflict
  fi
  NAMES=DolbyAtmosSpatialSound
  FILE=/data/adb/modules/$NAMES/module.prop
  if grep -q 'Dolby Atmos and' $FILE; then
    conflict
  fi
fi

# function
cleanup() {
if [ -f $DIR/uninstall.sh ]; then
  sh $DIR/uninstall.sh
fi
DIR=/data/adb/modules_update/$MODID
if [ -f $DIR/uninstall.sh ]; then
  sh $DIR/uninstall.sh
fi
}

# cleanup
DIR=/data/adb/modules/$MODID
FILE=$DIR/module.prop
PREVMODNAME=`grep_prop name $FILE`
if [ "`grep_prop data.cleanup $OPTIONALS`" == 1 ]; then
  sed -i 's|^data.cleanup=1|data.cleanup=0|g' $OPTIONALS
  ui_print "- Cleaning-up $MODID data..."
  cleanup
  ui_print " "
elif [ -d $DIR ]\
&& [ "$PREVMODNAME" != "$MODNAME" ]; then
  ui_print "- Different module name is detected"
  ui_print "  Cleaning-up $MODID data..."
  cleanup
  ui_print " "
fi

# function
permissive_2() {
sed -i 's|#2||g' $MODPATH/post-fs-data.sh
}
permissive() {
FILE=/sys/fs/selinux/enforce
SELINUX=`cat $FILE`
if [ "$SELINUX" == 1 ]; then
  if ! setenforce 0; then
    echo 0 > $FILE
  fi
  SELINUX=`cat $FILE`
  if [ "$SELINUX" == 1 ]; then
    ui_print "  Your device can't be turned to Permissive state."
    ui_print "  Using Magisk Permissive mode instead."
    permissive_2
  else
    if ! setenforce 1; then
      echo 1 > $FILE
    fi
    sed -i 's|#1||g' $MODPATH/post-fs-data.sh
  fi
else
  sed -i 's|#1||g' $MODPATH/post-fs-data.sh
fi
}
backup() {
if [ ! -f $FILE.orig ] && [ ! -f $FILE.bak ]; then
  ui_print "- Checking free space..."
  SIZE=`du $FILE | sed "s|$FILE||g"`
  SIZE=$(( $SIZE + 1 ))
  INFO=`df $FILE`
  FREE=`echo "$INFO" | awk 'NR==3{print $3}'`
  if [ ! "$FREE" ]; then
    FREE=`echo "$INFO" | awk 'NR==2{print $4}'`
  fi
  ui_print "$INFO"
  ui_print "  Free space = $FREE KiB"
  ui_print "  Free space required = $SIZE KiB"
  ui_print " "
  if [ "$FREE" -ge "$SIZE" ]; then
    cp -af $FILE $FILE.orig
    if [ -f $FILE.orig ]; then
      ui_print "- Created"
      ui_print "$FILE.orig"
      ui_print "  This file will not be restored automatically even you"
      ui_print "  have uninstalled this module."
    else
      ui_print "- Failed to create"
      ui_print "$FILE.orig"
      ui_print "  The partition is Read-Only"
    fi
    ui_print " "
  fi
fi
}
patch_manifest() {
if [ -f $FILE ]; then
  backup
  if [ -f $FILE.orig ] || [ -f $FILE.bak ]; then
    ui_print "- Patching"
    ui_print "$FILE"
    ui_print "  directly..."
    sed -i '/<manifest/a\
    <hal format="hidl">\
        <name>vendor.dolby.hardware.dms</name>\
        <transport>hwbinder</transport>\
        <fqname>@2.0::IDms/default</fqname>\
    </hal>' $FILE
    ui_print " "
  fi
fi
}
eim_dir_warning() {
ui_print "! It seems Magisk early init mount directory is not"
ui_print "  activated yet. Please reinstall Magisk via Magisk app"
ui_print "  (not via Recovery)."
ui_print " "
}
early_init_mount_dir() {
if echo $MAGISK_VER | grep -Eq 'delta|kitsune'\
&& [ "`grep_prop dolby.skip.early $OPTIONALS`" != 1 ]; then
  check_data
  get_flags > /dev/null 2>&1
  if [ "$BOOTMODE" == true ]; then
    if [ "$MAGISK_VER_CODE" -ge 26000 ]; then
      PREINITDEVICE=`grep_prop PREINITDEVICE $INTERNALDIR/config`
      if [ ! "$PREINITDEVICE" ]; then
        eim_dir_warning
      fi
    fi
    if [ -L $MIRROR/early-mount ]; then
      EIMDIR=`readlink $MIRROR/early-mount`
      [ "${EIMDIR:0:1}" != "/" ] && EIMDIR="$MIRROR/$EIMDIR"
    fi
  fi
  if [ ! "$EIMDIR" ]; then
    if ! $ISENCRYPTED; then
      EIMDIR=/data/adb/early-mount.d
    elif [ -d /data/unencrypted ]\
    && ! grep ' /data ' /proc/mounts | grep -q dm-\
    && grep ' /data ' /proc/mounts | grep -q ext4; then
      EIMDIR=/data/unencrypted/early-mount.d
    elif grep ' /cache ' /proc/mounts | grep -q ext4; then
      EIMDIR=/cache/early-mount.d
    elif grep ' /metadata ' /proc/mounts | grep -q ext4; then
      EIMDIR=/metadata/early-mount.d
    elif grep ' /persist ' /proc/mounts | grep -q ext4; then
      EIMDIR=/persist/early-mount.d
    elif grep ' /mnt/vendor/persist ' /proc/mounts | grep -q ext4; then
      EIMDIR=/mnt/vendor/persist/early-mount.d
    elif grep ' /cust ' /proc/mounts | grep -q ext4; then
      EIMDIR=/cust/early-mount.d
    fi
  fi
  if [ ! "$EIMDIR" ]\
  && [ "$MAGISK_VER_CODE" -ge 26000 ]; then
    if [ -d /data/unencrypted ]\
    && ! grep ' /data ' /proc/mounts | grep -q dm-\
    && grep ' /data ' /proc/mounts | grep -q f2fs; then
      EIMDIR=/data/unencrypted/early-mount.d
    elif grep ' /cache ' /proc/mounts | grep -q f2fs; then
      EIMDIR=/cache/early-mount.d
    elif grep ' /metadata ' /proc/mounts | grep -q f2fs; then
      EIMDIR=/metadata/early-mount.d
    elif grep ' /persist ' /proc/mounts | grep -q f2fs; then
      EIMDIR=/persist/early-mount.d
    elif grep ' /mnt/vendor/persist ' /proc/mounts | grep -q f2fs; then
      EIMDIR=/mnt/vendor/persist/early-mount.d
    elif grep ' /cust ' /proc/mounts | grep -q f2fs; then
      EIMDIR=/cust/early-mount.d
    fi
  fi
  if [ "$EIMDIR" ]; then
    if [ -d ${EIMDIR%/early-mount.d} ]; then
      EIM=true
      mkdir -p $EIMDIR
      ui_print "- Your early init mount directory is"
      ui_print "  $EIMDIR"
      ui_print "  Any file stored to this directory will not be deleted"
      ui_print "  even you have uninstalled this module."
    else
      EIM=false
      ui_print "- Unable to find early init mount directory ${EIMDIR%/early-mount.d}"
    fi
    ui_print " "
  else
    EIM=false
    ui_print "- Unable to find early init mount directory"
    ui_print " "
  fi
else
  EIM=false
fi
}
eim_cache_warning() {
if echo $EIMDIR | grep -q cache; then
  ui_print "  Please do not ever wipe your /cache"
  ui_print "  as long as this module is installed!"
  ui_print "  If your /cache is wiped for some reasons,"
  ui_print "  then you need to uninstall this module and reboot first,"
  ui_print "  then reinstall this module afterwards"
  ui_print "  to get this module working correctly."
fi
}
patch_manifest_eim() {
if [ $EIM == true ]; then
  SRC=$SYSTEM/etc/vintf/manifest.xml
  if [ -f $SRC ]; then
    DIR=$EIMDIR/system/etc/vintf
    DES=$DIR/manifest.xml
    mkdir -p $DIR
    if [ ! -f $DES ]; then
      cp -af $SRC $DIR
    fi
    if ! grep -A2 vendor.dolby.hardware.dms $DES | grep -q 2.0; then
      ui_print "- Patching"
      ui_print "$DES"
      sed -i '/<manifest/a\
    <hal format="hidl">\
        <name>vendor.dolby.hardware.dms</name>\
        <transport>hwbinder</transport>\
        <fqname>@2.0::IDms/default</fqname>\
    </hal>' $DES
      eim_cache_warning
      ui_print " "
    fi
  else
    EIM=false
  fi
fi
}

# permissive
if [ "`grep_prop permissive.mode $OPTIONALS`" == 1 ]; then
  ui_print "- Using device Permissive mode."
  rm -f $MODPATH/sepolicy.rule
  permissive
  ui_print " "
elif [ "`grep_prop permissive.mode $OPTIONALS`" == 2 ]; then
  ui_print "- Using Magisk Permissive mode."
  rm -f $MODPATH/sepolicy.rule
  permissive_2
  ui_print " "
fi

# remount
if [ $DOLBY == true ]; then
  remount_rw
fi

# early init mount dir
if [ $DOLBY == true ]; then
  early_init_mount_dir
fi

# patch manifest.xml
if [ $DOLBY == true ]; then
  FILE="$INTERNALDIR/mirror/*/etc/vintf/manifest.xml
        $INTERNALDIR/mirror/*/*/etc/vintf/manifest.xml
        /*/etc/vintf/manifest.xml /*/*/etc/vintf/manifest.xml
        $INTERNALDIR/mirror/*/etc/vintf/manifest/*.xml
        $INTERNALDIR/mirror/*/*/etc/vintf/manifest/*.xml
        /*/etc/vintf/manifest/*.xml /*/*/etc/vintf/manifest/*.xml"
  if [ "`grep_prop dolby.skip.vendor $OPTIONALS`" != 1 ]\
  && ! grep -A2 vendor.dolby.hardware.dms $FILE | grep -q 2.0; then
    FILE=$VENDOR/etc/vintf/manifest.xml
    patch_manifest
  fi
  if [ "`grep_prop dolby.skip.system $OPTIONALS`" != 1 ]\
  && ! grep -A2 vendor.dolby.hardware.dms $FILE | grep -q 2.0; then
    FILE=$SYSTEM/etc/vintf/manifest.xml
    patch_manifest
  fi
  if [ "`grep_prop dolby.skip.system_ext $OPTIONALS`" != 1 ]\
  && ! grep -A2 vendor.dolby.hardware.dms $FILE | grep -q 2.0; then
    FILE=$SYSTEM_EXT/etc/vintf/manifest.xml
    patch_manifest
  fi
  if ! grep -A2 vendor.dolby.hardware.dms $FILE | grep -q 2.0; then
    patch_manifest_eim
    if [ $EIM == false ]; then
      sed -i 's|#s||g' $MODPATH/service.sh
      ui_print "- Using systemless manifest.xml patch."
      ui_print "  On some ROMs, it causes bugs or even makes bootloop"
      ui_print "  because not allowed to restart hwservicemanager."
      ui_print "  You can fix this by using Magisk Delta/Kitsune Mask."
      ui_print " "
    fi
  fi
fi

# remount
if [ $DOLBY == true ]; then
  remount_ro
fi

# function
hide_oat() {
for APP in $APPS; do
  REPLACE="$REPLACE
  `find $MODPATH/system -type d -name $APP | sed "s|$MODPATH||g"`/oat"
done
}
replace_dir() {
if [ -d $DIR ] && [ ! -d $MODPATH$MODDIR ]; then
  REPLACE="$REPLACE $MODDIR"
fi
}
hide_app() {
for APP in $APPS; do
  DIR=$SYSTEM/app/$APP
  MODDIR=/system/app/$APP
  replace_dir
  DIR=$SYSTEM/priv-app/$APP
  MODDIR=/system/priv-app/$APP
  replace_dir
  DIR=$PRODUCT/app/$APP
  MODDIR=/system/product/app/$APP
  replace_dir
  DIR=$PRODUCT/priv-app/$APP
  MODDIR=/system/product/priv-app/$APP
  replace_dir
  DIR=$MY_PRODUCT/app/$APP
  MODDIR=/system/product/app/$APP
  replace_dir
  DIR=$MY_PRODUCT/priv-app/$APP
  MODDIR=/system/product/priv-app/$APP
  replace_dir
  DIR=$PRODUCT/preinstall/$APP
  MODDIR=/system/product/preinstall/$APP
  replace_dir
  DIR=$SYSTEM_EXT/app/$APP
  MODDIR=/system/system_ext/app/$APP
  replace_dir
  DIR=$SYSTEM_EXT/priv-app/$APP
  MODDIR=/system/system_ext/priv-app/$APP
  replace_dir
  DIR=$VENDOR/app/$APP
  MODDIR=/system/vendor/app/$APP
  replace_dir
  DIR=$VENDOR/euclid/product/app/$APP
  MODDIR=/system/vendor/euclid/product/app/$APP
  replace_dir
done
}

# hide
APPS="`ls $MODPATH/system/priv-app`
      `ls $MODPATH/system/app`"
hide_oat
APPS="$APPS MusicFX"
hide_app
if [ $DOLBY == true ]; then
  APPS="DaxUI MotoDolbyDax3 MotoDolbyV3 OPSoundTuner
        DolbyAtmos AudioEffectCenter DolbySound"
  hide_app
fi

# hide
if [ "`grep_prop hide.parts $OPTIONALS`" == 1 ]; then
  APPS="XiaomiParts ZenfoneParts ZenParts GalaxyParts
       KharaMeParts DeviceParts PocoParts LineageParts"
  ui_print "- Hides Parts app"
  hide_app
  ui_print " "
fi

# stream mode
FILE=$MODPATH/.aml.sh
PROP=`grep_prop stream.mode $OPTIONALS`
if echo "$PROP" | grep -q m; then
  ui_print "- Activating music stream..."
  sed -i 's|#m||g' $FILE
  sed -i 's|musicstream=|musicstream=true|g' $MODPATH/acdb.conf
  sed -i 's|music_stream false|music_stream true|g' $MODPATH/service.sh
  ui_print "  The sound effect will always be enabled"
  ui_print "  and cannot be disabled by on/off togglers"
  ui_print " "
else
  APPS=AudioFX
  hide_app
fi
if echo "$PROP" | grep -q r; then
  ui_print "- Activating ring stream..."
  sed -i 's|#r||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q a; then
  ui_print "- Activating alarm stream..."
  sed -i 's|#a||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q s; then
  ui_print "- Activating system stream..."
  sed -i 's|#s||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q v; then
  ui_print "- Activating voice_call stream..."
  sed -i 's|#v||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q n; then
  ui_print "- Activating notification stream..."
  sed -i 's|#n||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q b; then
  ui_print "- Activating bluetooth_sco stream..."
  sed -i 's|#b||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q f; then
  ui_print "- Activating dtmf stream..."
  sed -i 's|#f||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q e; then
  ui_print "- Activating enforced_audible stream..."
  sed -i 's|#e||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q y; then
  ui_print "- Activating accessibility stream..."
  sed -i 's|#y||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q t; then
  ui_print "- Activating tts stream..."
  sed -i 's|#t||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q i; then
  ui_print "- Activating assistant stream..."
  sed -i 's|#i||g' $FILE
  ui_print " "
fi
if echo "$PROP" | grep -q c; then
  ui_print "- Activating call_assistant stream..."
  sed -i 's|#c||g' $FILE
  ui_print " "
fi
if [ "`grep_prop dolby.game $OPTIONALS`" != 0 ]; then
  sed -i 's|#p||g' $FILE
  sed -i 's|#g||g' $FILE
  sed -i 's|#x||g' $FILE
else
  ui_print "- Does not use Dolby/Mi Sound Game patch & rerouting stream"
  ui_print " "
fi

# function
dolby_settings() {
FILE=$MODPATH/system/vendor/etc/dolby/dax-default.xml
PROP=`grep_prop dolby.bass $OPTIONALS`
if [ "$PROP" == true ]; then
  ui_print "- Changing all bass-enhancer-enable value to true"
  sed -i 's|bass-enhancer-enable value="false"|bass-enhancer-enable value="true"|g' $FILE
elif [ "$PROP" == false ]; then
  ui_print "- Changing all bass-enhancer-enable value to false"
  sed -i 's|bass-enhancer-enable value="true"|bass-enhancer-enable value="false"|g' $FILE
elif [ "$PROP" ] && [ "$PROP" != def ] && [ "$PROP" -gt 0 ]; then
  ui_print "- Changing all bass-enhancer-enable value to true"
  sed -i 's|bass-enhancer-enable value="false"|bass-enhancer-enable value="true"|g' $FILE
  ROWS=`grep bass-enhancer-boost $FILE | sed -e 's|<bass-enhancer-boost value="||g' -e 's|"/>||g' -e 's|" />||g'`
  if [ "$ROWS" ]; then
    ui_print "- Default bass-enhancer-boost value:"
    ui_print "$ROWS"
    ui_print "- Changing all bass-enhancer-boost value to $PROP"
    for ROW in $ROWS; do
      sed -i "s|bass-enhancer-boost value=\"$ROW\"|bass-enhancer-boost value=\"$PROP\"|g" $FILE
    done
  else
    ui_print "- This version does not support bass-enhancer-boost"
  fi
fi
if [ "`grep_prop dolby.virtualizer $OPTIONALS`" == 1 ]; then
  ui_print "- Changing all virtualizer-enable value to true"
  sed -i 's|virtualizer-enable value="false"|virtualizer-enable value="true"|g' $FILE
elif [ "`grep_prop dolby.virtualizer $OPTIONALS`" == 0 ]; then
  ui_print "- Changing all virtualizer-enable value to false"
  sed -i 's|virtualizer-enable value="true"|virtualizer-enable value="false"|g' $FILE
fi
if [ "`grep_prop dolby.volumeleveler $OPTIONALS`" == def ]; then
  ui_print "- Using default settings of volume-leveler"
elif [ "`grep_prop dolby.volumeleveler $OPTIONALS`" == 1 ]; then
  ui_print "- Changing all volume-leveler-enable value to true"
  sed -i 's|volume-leveler-enable value="false"|volume-leveler-enable value="true"|g' $FILE
else
  ui_print "- Changing all volume-leveler-enable value to false"
  sed -i 's|volume-leveler-enable value="true"|volume-leveler-enable value="false"|g' $FILE
fi
if [ "`grep_prop dolby.deepbass $OPTIONALS`" == 1 ]; then
  ui_print "- Using deeper bass GEQ frequency"
  sed -i 's|frequency="47"|frequency="0"|g' $FILE
  sed -i 's|frequency="141"|frequency="47"|g' $FILE
  sed -i 's|frequency="234"|frequency="141"|g' $FILE
  sed -i 's|frequency="328"|frequency="234"|g' $FILE
  sed -i 's|frequency="469"|frequency="328"|g' $FILE
  sed -i 's|frequency="656"|frequency="469"|g' $FILE
  sed -i 's|frequency="844"|frequency="656"|g' $FILE
  sed -i 's|frequency="1031"|frequency="844"|g' $FILE
  sed -i 's|frequency="1313"|frequency="1031"|g' $FILE
  sed -i 's|frequency="1688"|frequency="1313"|g' $FILE
  sed -i 's|frequency="2250"|frequency="1688"|g' $FILE
  sed -i 's|frequency="3000"|frequency="2250"|g' $FILE
  sed -i 's|frequency="3750"|frequency="3000"|g' $FILE
  sed -i 's|frequency="4688"|frequency="3750"|g' $FILE
  sed -i 's|frequency="5813"|frequency="4688"|g' $FILE
  sed -i 's|frequency="7125"|frequency="5813"|g' $FILE
  sed -i 's|frequency="9000"|frequency="7125"|g' $FILE
  sed -i 's|frequency="11250"|frequency="9000"|g' $FILE
  sed -i 's|frequency="13875"|frequency="11250"|g' $FILE
  sed -i 's|frequency="19688"|frequency="13875"|g' $FILE
fi
ui_print " "
}

# settings
if [ $DOLBY == true ]; then
  dolby_settings
fi

# function
file_check_apex_for_vendor() {
for FILE in $FILES; do
  DESS="/apex$FILE $SYSTEM/apex$FILE"
  for DES in $DESS; do
    if [ -f $DES ]; then
      ui_print "- Detected"
      ui_print "$DES"
      NAME=`basename $FILE`
      if echo $FILE | grep -q lib64; then
        rm -f $MODPATH/system/vendor/lib64/$NAME
      else
        rm -f $MODPATH/system/vendor/lib/$NAME
      fi
      ui_print " "
    fi
  done
done
}
file_check_system_for_vendor() {
for FILE in $FILES; do
  DESS="$SYSTEM$FILE $SYSTEM_EXT$FILE"
  for DES in $DESS; do
    if [ -f $DES ]; then
      ui_print "- Detected"
      ui_print "$DES"
      NAME=`basename $FILE`
      if echo $FILE | grep -q lib64; then
        rm -f $MODPATH/system/vendor/lib64/$NAME
      else
        rm -f $MODPATH/system/vendor/lib/$NAME
      fi
      ui_print " "
    fi
  done
done
}
file_check_system() {
for FILE in $FILES; do
  DESS="$SYSTEM$FILE $SYSTEM_EXT$FILE"
  for DES in $DESS; do
    if [ -f $DES ]; then
      ui_print "- Detected"
      ui_print "$DES"
      rm -f $MODPATH/system$FILE
      ui_print " "
    fi
  done
done
}
file_check_vendor() {
for FILE in $FILES; do
  DESS="$VENDOR$FILE $ODM$FILE"
  for DES in $DESS; do
    if [ -f $DES ]; then
      ui_print "- Detected"
      ui_print "$DES"
      rm -f $MODPATH/system/vendor$FILE
      ui_print " "
    fi
  done
done
}

# check
if [ "$IS64BIT" == true ]; then
  FILES=/lib64/libmigui.so
  file_check_system
fi
if [ "$ABILIST32" ]; then
  FILES=/lib/libmigui.so
  file_check_system
fi
if [ $DOLBY == true ]; then
  if [ "$IS64BIT" == true ]; then
    FILES=/*vndk*/lib64/libsqlite.so
    file_check_apex_for_vendor
    FILES=/lib64/vndk-*/libsqlite.so
    file_check_system_for_vendor
    FILES="/lib64/libsqlite.so
           /lib64/libqtigef.so
           /lib64/libdeccfg.so
           /lib64/libstagefrightdolby.so
           /lib64/libstagefright_soft_ddpdec.so
           /lib64/libstagefright_soft_ac4dec.so"
    file_check_vendor
  fi
  if [ "$ABILIST32" ]; then
    FILES="/lib/libqtigef.so
           /lib/libdeccfg.so
           /lib/libstagefrightdolby.so
           /lib/libstagefright_soft_ddpdec.so
           /lib/libstagefright_soft_ac4dec.so"
    file_check_vendor
  fi
  FILES="/etc/media_codecs_dolby_audio.xml
         /etc/acdbdata/adsp_avs_config.acdb"
  file_check_vendor
fi

# function
rename_file() {
if [ -f $FILE ]; then
  ui_print "- Renaming"
  ui_print "$FILE"
  ui_print "  to"
  ui_print "$MODFILE"
  mv -f $FILE $MODFILE
  ui_print " "
fi
}
change_name() {
if grep -q $NAME $FILE; then
  ui_print "- Changing $NAME to $NAME2 at"
  ui_print "$FILE"
  ui_print "  Please wait..."
  sed -i "s|$NAME|$NAME2|g" $FILE
  ui_print " "
fi
}

patch_file() {
# Change 9d4921da-8225-4f29-aefa-39537a04bcaa
# to a0c30891-8246-4aef-b8ad-d53e26da0253
NAME=$'\xda\x21\x49\x9d\x25\x82\x29\x4f\xfa\xae\x39\x53\x7a\x04\xbc\xaa'
NAME2=$'\x91\x08\xc3\xa0\x46\x82\xef\x4a\xad\xb8\xd5\x3e\x26\xda\x02\x53'
FILE=$MODPATH/system/vendor/lib*/soundfx/libhwdap.so
change_name
if grep -q libvndksupport.so /system/etc/*.txt; then
  NAME=libhidlbase.so
  NAME2=libhidldlbs.so
  if [ "$IS64BIT" == true ]; then
    FILE=$MODPATH/system/lib64/$NAME
    MODFILE=$MODPATH/system/vendor/lib64/$NAME2
    rename_file
  fi
  if [ "$ABILIST32" ]; then
    FILE=$MODPATH/system/lib/$NAME
    MODFILE=$MODPATH/system/vendor/lib/$NAME2
    rename_file
  fi
  if [ -f $MODPATH/system/vendor/lib64/$NAME2 ]\
  || [ -f $MODPATH/system/vendor/lib/$NAME2 ]; then
  FILE="$MODPATH/system/vendor/lib*/$NAME2
$MODPATH/system/vendor/lib*/vendor.dolby*.hardware.dms*@*.so"
    change_name
  fi
fi
NAME=libstagefright_foundation.so
NAME2=libstagefright_fdtn_dolby.so
if [ "$IS64BIT" == true ]; then
  FILE=$MODPATH/system/vendor/lib64/$NAME
  MODFILE=$MODPATH/system/vendor/lib64/$NAME2
  rename_file
fi
if [ "$ABILIST32" ]; then
  FILE=$MODPATH/system/vendor/lib/$NAME
  MODFILE=$MODPATH/system/vendor/lib/$NAME2
  rename_file
fi
FILE="$MODPATH/system/vendor/lib*/$NAME2
$MODPATH/system/vendor/lib*/libdlbdsservice*.so
$MODPATH/system/vendor/lib*/libstagefrightdolby.so
$MODPATH/system/vendor/lib*/libstagefright_soft_ddpdec*.so
$MODPATH/system/vendor/lib*/libstagefright_soft_ac4dec*.so"
change_name
if [ "`grep_prop dolby.mod $OPTIONALS`" == 1 ]; then
  NAME=dax-default.xml
  NAME2=dap-default.xml
  FILE=$MODPATH/system/vendor/etc/dolby/$NAME
  MODFILE=$MODPATH/system/vendor/etc/dolby/$NAME2
  rename_file
  FILE=$MODPATH/system/vendor/lib*/libdlbdsservice*.so
  change_name
  NAME=dax_sqlite3.db
  NAME2=dap_sqlite3.db
  change_name
  NAME=libswdap.so
  NAME2=libswdlb.so
  if [ "$IS64BIT" == true ]; then
    FILE=$MODPATH/system/vendor/lib64/soundfx/$NAME
    MODFILE=$MODPATH/system/vendor/lib64/soundfx/$NAME2
    rename_file
  fi
  if [ "$ABILIST32" ]; then
    FILE=$MODPATH/system/vendor/lib/soundfx/$NAME
    MODFILE=$MODPATH/system/vendor/lib/soundfx/$NAME2
    rename_file
  fi
  FILE="$MODPATH/system/vendor/lib*/soundfx/$NAME2
$MODPATH/.aml.sh"
  change_name
  NAME=libhwdap.so
  NAME2=libhwdlb.so
  if [ "$IS64BIT" == true ]; then
    FILE=$MODPATH/system/vendor/lib64/soundfx/$NAME
    MODFILE=$MODPATH/system/vendor/lib64/soundfx/$NAME2
    rename_file
  fi
  if [ "$ABILIST32" ]; then
    FILE=$MODPATH/system/vendor/lib/soundfx/$NAME
    MODFILE=$MODPATH/system/vendor/lib/soundfx/$NAME2
    rename_file
  fi
  FILE="$MODPATH/system/vendor/lib*/soundfx/$NAME2
$MODPATH/.aml.sh"
  change_name
  NAME=libdlbdsservice.so
  NAME2=libdapdsservice.so
  if [ "$IS64BIT" == true ]; then
    FILE=$MODPATH/system/vendor/lib64/$NAME
    MODFILE=$MODPATH/system/vendor/lib64/$NAME2
    rename_file
  fi
  FILE="$MODPATH/system/vendor/lib*/$NAME2
$MODPATH/system/vendor/lib*/vendor.dolby*.hardware.dms*@*-impl.so
$MODPATH/system/vendor/bin/hw/vendor.dolby*.hardware.dms*@*-service"
  change_name
  NAME=libdapparamstorage.so
  NAME2=libdaxparamstorage.so
  if [ "$IS64BIT" == true ]; then
    FILE=$MODPATH/system/vendor/lib64/$NAME
    MODFILE=$MODPATH/system/vendor/lib64/$NAME2
    rename_file
  fi
  if [ "$ABILIST32" ]; then
    FILE=$MODPATH/system/vendor/lib/$NAME
    MODFILE=$MODPATH/system/vendor/lib/$NAME2
    rename_file
  fi
  FILE="$MODPATH/system/vendor/lib*/$NAME2
$MODPATH/system/vendor/lib*/soundfx/lib*wdlb*.so
$MODPATH/system/vendor/lib*/soundfx/libswvqe*.so
$MODPATH/system/vendor/lib*/soundfx/libswgamedap*.so
$MODPATH/system/vendor/lib*/libdapdsservice*.so
$MODPATH/system/vendor/lib*/vendor.dolby*.hardware.dms*@*-impl.so
$MODPATH/system/vendor/bin/hw/vendor.dolby*.hardware.dms*@*-service"
  change_name
  NAME=vendor.dolby.hardware.dms@2.0.so
  NAME2=vendor.dlbds.hardware.dms@2.0.so
  if [ "$IS64BIT" == true ]; then
    FILE=$MODPATH/system/vendor/lib64/$NAME
    MODFILE=$MODPATH/system/vendor/lib64/$NAME2
    rename_file
  fi
  if [ "$ABILIST32" ]; then
    FILE=$MODPATH/system/vendor/lib/$NAME
    MODFILE=$MODPATH/system/vendor/lib/$NAME2
    rename_file
  fi
  FILE="$MODPATH/system/vendor/lib*/$NAME2
$MODPATH/system/vendor/lib*/soundfx/lib*wdlb*.so
$MODPATH/system/vendor/lib*/soundfx/libswvqe*.so
$MODPATH/system/vendor/lib*/soundfx/libswgamedap*.so
$MODPATH/system/vendor/lib*/libdapdsservice*.so
$MODPATH/system/vendor/lib*/vendor.dolby*.hardware.dms*@*-impl.so
$MODPATH/system/vendor/bin/hw/vendor.dolby*.hardware.dms*@*-service
$MODPATH/system/vendor/lib*/libdeccfg*.so
$MODPATH/system/vendor/lib*/libstagefright_soft_ddpdec*.so
$MODPATH/system/vendor/lib*/libstagefright_soft_ac4dec*.so"
  change_name
  NAME=vendor.dolby.hardware.dms@2.0-impl.so
  NAME2=vendor.dlbds.hardware.dms@2.0-impl.so
  if [ "$IS64BIT" == true ]; then
    FILE=$MODPATH/system/vendor/lib64/$NAME
    MODFILE=$MODPATH/system/vendor/lib64/$NAME2
    rename_file
  fi
  if [ "$ABILIST32" ]; then
    FILE=$MODPATH/system/vendor/lib/$NAME
    MODFILE=$MODPATH/system/vendor/lib/$NAME2
    rename_file
  fi
  FILE="$MODPATH/system/vendor/lib*/$NAME2
$MODPATH/system/vendor/bin/hw/vendor.dolby*.hardware.dms*@*-service"
  change_name
  sed -i 's|ro.dolby.mod_uuid false|ro.dolby.mod_uuid true|g' $MODPATH/service.sh
  NAME=$'\x39\x53\x7a\x04\xbc\xaa'
  NAME2=_ryuki
  FILE=$MODPATH/system/vendor/lib*/soundfx/libswdlb.so
  change_name
  NAME=$'\x45\x27\x99\x21\x85\x39'
  FILE=$MODPATH/system/vendor/lib*/soundfx/libswdlb.so
  change_name
  NAME=$'\xd5\x3e\x26\xda\x02\x53'
  FILE=$MODPATH/system/vendor/lib*/soundfx/libhwdlb.so
  change_name
  NAME=$'\xef\x93\x7f\x67\x55\x87'
  FILE=$MODPATH/system/vendor/lib*/soundfx/lib*wdlb.so
  change_name
  NAME=39537a04bcaa
  NAME2=5f7279756b69
  FILE=$MODPATH/.aml.sh
  change_name
  NAME=452799218539
  change_name
  NAME=d53e26da0253
  change_name
fi
}

# mod
if [ $DOLBY == true ]; then
  patch_file
fi

# harman kardon
FILE=$MODPATH/service.sh
if [ "`grep_prop misound.harmankardon $OPTIONALS`" == 0 ]; then
  ui_print "- Disables Harman Kardon"
  sed -i 's|#h||g' $FILE
  ui_print " "
fi

# fix sensor
if [ $DOLBY == true ]\
&& [ "`grep_prop dolby.fix.sensor $OPTIONALS`" == 1 ]; then
  ui_print "- Fixing sensors issue"
  ui_print "  This causes bootloop in some ROMs"
  sed -i 's|#x||g' $MODPATH/service.sh
  ui_print " "
fi

# audio rotation
FILE=$MODPATH/service.sh
if [ "`grep_prop audio.rotation $OPTIONALS`" == 1 ]; then
  ui_print "- Enables ro.audio.monitorRotation=true"
  sed -i '1i\
resetprop -n ro.audio.monitorRotation true\
resetprop -n ro.audio.monitorWindowRotation true' $FILE
  ui_print " "
fi

# raw
FILE=$MODPATH/.aml.sh
if [ "`grep_prop disable.raw $OPTIONALS`" == 0 ]; then
  ui_print "- Does not disable Ultra Low Latency (Raw) playback"
  ui_print " "
else
  sed -i 's|#u||g' $FILE
fi

# vendor_overlay
DIR=/product/vendor_overlay
if [ "`grep_prop fix.vendor_overlay $OPTIONALS`" == 1 ]\
&& [ $DOLBY == true ] && [ -d $DIR ]; then
  ui_print "- Fixing $DIR mount..."
  cp -rf $DIR/*/* $MODPATH/system/vendor
  ui_print " "
fi

# run
. $MODPATH/copy.sh
. $MODPATH/.aml.sh

# unmount
unmount_mirror














