MODPATH=${0%/*}

# destination
LIBPATH="\/vendor\/lib\/soundfx"
MODAEC=`find $MODPATH/system -type f -name *audio*effects*.conf`
MODAEX=`find $MODPATH/system -type f -name *audio*effects*.xml`
MODAP=`find $MODPATH/system -type f -name *policy*.conf -o -name *policy*.xml`
MODMC=$MODPATH/system/vendor/etc/media_codecs.xml

# function
remove_conf() {
for RMVS in $RMV; do
  sed -i "s/$RMVS/removed/g" $MODAEC
done
sed -i 's/path \/vendor\/lib\/soundfx\/removed//g' $MODAEC
sed -i 's/path \/system\/lib\/soundfx\/removed//g' $MODAEC
sed -i 's/path \/vendor\/lib\/removed//g' $MODAEC
sed -i 's/path \/system\/lib\/removed//g' $MODAEC
sed -i 's/library removed//g' $MODAEC
sed -i 's/uuid removed//g' $MODAEC
sed -i "/^        removed {/ {;N s/        removed {\n        }//}" $MODAEC
}
remove_xml() {
for RMVS in $RMV; do
  sed -i "s/\"$RMVS\"/\"removed\"/g" $MODAEX
done
sed -i 's/<library name="removed" path="removed"\/>//g' $MODAEX
sed -i 's/<effect name="removed" library="removed" uuid="removed"\/>//g' $MODAEX
sed -i 's/<libsw library="removed" uuid="removed"\/>//g' $MODAEX
sed -i 's/<libhw library="removed" uuid="removed"\/>//g' $MODAEX
sed -i 's/<apply effect="removed"\/>//g' $MODAEX
sed -i 's/<library name="removed" path="removed" \/>//g' $MODAEX
sed -i 's/<effect name="removed" library="removed" uuid="removed" \/>//g' $MODAEX
sed -i 's/<libsw library="removed" uuid="removed" \/>//g' $MODAEX
sed -i 's/<libhw library="removed" uuid="removed" \/>//g' $MODAEX
sed -i 's/<apply effect="removed" \/>//g' $MODAEX
}

# setup audio effects conf
if [ "$MODAEC" ]; then
  sed -i "/^        ring_helper {/ {;N s/        ring_helper {\n        }//}" $MODAEC
  sed -i "/^        alarm_helper {/ {;N s/        alarm_helper {\n        }//}" $MODAEC
  sed -i "/^        music_helper {/ {;N s/        music_helper {\n        }//}" $MODAEC
  sed -i "/^        voice_helper {/ {;N s/        voice_helper {\n        }//}" $MODAEC
  sed -i "/^        notification_helper {/ {;N s/        notification_helper {\n        }//}" $MODAEC
  sed -i "/^        ma_ring_helper {/ {;N s/        ma_ring_helper {\n        }//}" $MODAEC
  sed -i "/^        ma_alarm_helper {/ {;N s/        ma_alarm_helper {\n        }//}" $MODAEC
  sed -i "/^        ma_music_helper {/ {;N s/        ma_music_helper {\n        }//}" $MODAEC
  sed -i "/^        ma_voice_helper {/ {;N s/        ma_voice_helper {\n        }//}" $MODAEC
  sed -i "/^        ma_system_helper {/ {;N s/        ma_system_helper {\n        }//}" $MODAEC
  sed -i "/^        ma_notification_helper {/ {;N s/        ma_notification_helper {\n        }//}" $MODAEC
  sed -i "/^        sa3d {/ {;N s/        sa3d {\n        }//}" $MODAEC
  sed -i "/^        fens {/ {;N s/        fens {\n        }//}" $MODAEC
  sed -i "/^        lmfv {/ {;N s/        lmfv {\n        }//}" $MODAEC
  sed -i "/^        dirac {/ {;N s/        dirac {\n        }//}" $MODAEC
  sed -i "/^        dtsaudio {/ {;N s/        dtsaudio {\n        }//}" $MODAEC
  if ! grep -Eq '^output_session_processing {' $MODAEC; then
    sed -i -e '$a\
output_session_processing {\
    music {\
    }\
    ring {\
    }\
    alarm {\
    }\
    voice_call {\
    }\
    notification {\
    }\
}\' $MODAEC
  else
    if ! grep -Eq '^    notification {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    notification {\n    }" $MODAEC
    fi
    if ! grep -Eq '^    voice_call {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    voice_call {\n    }" $MODAEC
    fi
    if ! grep -Eq '^    alarm {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    alarm {\n    }" $MODAEC
    fi
    if ! grep -Eq '^    ring {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    ring {\n    }" $MODAEC
    fi
    if ! grep -Eq '^    music {' $MODAEC; then
      sed -i "/^output_session_processing {/a\    music {\n    }" $MODAEC
    fi
  fi
  if ! grep -Eq '^pre_processing {' $MODAEC; then
    sed -i -e '$a\
pre_processing {\
  mic {\
  }\
  camcorder {\
  }\
  voice_recognition {\
  }\
  voice_communication {\
  }\
}\' $MODAEC
  else
    if ! grep -Eq '^  voice_communication {' $MODAEC; then
      sed -i "/^pre_processing {/a\  voice_communication {\n  }" $MODAEC
    fi
    if ! grep -Eq '^  voice_recognition {' $MODAEC; then
      sed -i "/^pre_processing {/a\  voice_recognition {\n  }" $MODAEC
    fi
    if ! grep -Eq '^  camcorder {' $MODAEC; then
      sed -i "/^pre_processing {/a\  camcorder {\n  }" $MODAEC
    fi
    if ! grep -Eq '^  mic {' $MODAEC; then
      sed -i "/^pre_processing {/a\  mic {\n  }" $MODAEC
    fi
  fi
fi

# setup audio effects xml
if [ "$MODAEX" ]; then
  sed -i 's/<apply effect="ring_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="alarm_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="music_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="voice_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="notification_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="ma_ring_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="ma_alarm_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="ma_music_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="ma_voice_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="ma_system_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="ma_notification_helper"\/>//g' $MODAEX
  sed -i 's/<apply effect="sa3d"\/>//g' $MODAEX
  sed -i 's/<apply effect="fens"\/>//g' $MODAEX
  sed -i 's/<apply effect="lmfv"\/>//g' $MODAEX
  sed -i 's/<apply effect="dirac"\/>//g' $MODAEX
  sed -i 's/<apply effect="dtsaudio"\/>//g' $MODAEX
  if ! grep -Eq '<postprocess>' $MODAEX || grep -Eq '<!-- Audio post processor' $MODAEX; then
    sed -i '/<\/effects>/a\
    <postprocess>\
        <stream type="music">\
        <\/stream>\
        <stream type="ring">\
        <\/stream>\
        <stream type="alarm">\
        <\/stream>\
        <stream type="voice_call">\
        <\/stream>\
        <stream type="notification">\
        <\/stream>\
    <\/postprocess>' $MODAEX
  else
    if ! grep -Eq '<stream type="notification">' $MODAEX || grep -Eq '<!-- YunMang.Xiao@PSW.MM.Dolby' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"notification\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -Eq '<stream type="voice_call">' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"voice_call\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -Eq '<stream type="alarm">' $MODAEX || grep -Eq '<!-- YunMang.Xiao@PSW.MM.Dolby' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"alarm\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -Eq '<stream type="ring">' $MODAEX || grep -Eq '<!-- YunMang.Xiao@PSW.MM.Dolby' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"ring\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -Eq '<stream type="music">' $MODAEX || grep -Eq '<!-- YunMang.Xiao@PSW.MM.Dolby' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"music\">\n        <\/stream>" $MODAEX
    fi
  fi
  if ! grep -Eq '<postprocess>' $MODAEX || grep -Eq '<!-- Audio post processor' $MODAEX; then
    sed -i '/<\/effects>/a\
    <postprocess>\
        <stream type="music">\
        <\/stream>\
        <stream type="ring">\
        <\/stream>\
        <stream type="alarm">\
        <\/stream>\
        <stream type="voice_call">\
        <\/stream>\
        <stream type="notification">\
        <\/stream>\
    <\/postprocess>' $MODAEX
  else
    if ! grep -Eq '<stream type="notification">' $MODAEX || grep -Eq '<!-- YunMang.Xiao@PSW.MM.Dolby' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"notification\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -Eq '<stream type="voice_call">' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"voice_call\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -Eq '<stream type="alarm">' $MODAEX || grep -Eq '<!-- YunMang.Xiao@PSW.MM.Dolby' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"alarm\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -Eq '<stream type="ring">' $MODAEX || grep -Eq '<!-- YunMang.Xiao@PSW.MM.Dolby' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"ring\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -Eq '<stream type="music">' $MODAEX || grep -Eq '<!-- YunMang.Xiao@PSW.MM.Dolby' $MODAEX; then
      sed -i "/<postprocess>/a\        <stream type=\"music\">\n        <\/stream>" $MODAEX
    fi
  fi
  if ! grep -Eq '<preprocess>' $MODAEX; then
    sed -i '/<\/effects>/a\
    <preprocess>\
        <stream type="mic">\
        <\/stream>\
        <stream type="camcorder">\
        <\/stream>\
        <stream type="voice_recognition">\
        <\/stream>\
        <stream type="voice_communication">\
        <\/stream>\
    <\/preprocess>' $MODAEX
  else
    if ! grep -Eq '<stream type="voice_communication">' $MODAEX; then
      sed -i "/<preprocess>/a\        <stream type=\"voice_communication\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -Eq '<stream type="voice_recognition">' $MODAEX; then
      sed -i "/<preprocess>/a\        <stream type=\"voice_recognition\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -Eq '<stream type="camcorder">' $MODAEX; then
      sed -i "/<preprocess>/a\        <stream type=\"camcorder\">\n        <\/stream>" $MODAEX
    fi
    if ! grep -Eq '<stream type="mic">' $MODAEX; then
      sed -i "/<preprocess>/a\        <stream type=\"mic\">\n        <\/stream>" $MODAEX
    fi
  fi
fi

## function
misoundfx() {

# store
LIB=libmisoundfx.so
LIBNAME=misoundfx
NAME=misoundfx
UUID=5b8e36a5-144a-4c38-b1d7-0002a5d5c51b
RMV="$LIB $LIBNAME $NAME $UUID"

# patch audio effects conf
if [ "$MODAEC" ]; then
  remove_conf
  sed -i "/^libraries {/a\  $LIBNAME {\n    path $LIBPATH\/$LIB\n  }" $MODAEC
  sed -i "/^effects {/a\  $NAME {\n    library $LIBNAME\n    uuid $UUID\n  }" $MODAEC
#m  sed -i "/^    music {/a\        $NAME {\n        }" $MODAEC
#r  sed -i "/^    ring {/a\        $NAME {\n        }" $MODAEC
#a  sed -i "/^    alarm {/a\        $NAME {\n        }" $MODAEC
#v  sed -i "/^    voice_call {/a\        $NAME {\n        }" $MODAEC
#n  sed -i "/^    notification {/a\        $NAME {\n        }" $MODAEC
fi

# patch effects xml
if [ "$MODAEX" ]; then
  remove_xml
  sed -i "/<libraries>/a\        <library name=\"$LIBNAME\" path=\"$LIB\"\/>" $MODAEX
  sed -i "/<effects>/a\        <effect name=\"$NAME\" library=\"$LIBNAME\" uuid=\"$UUID\"\/>" $MODAEX
#m  sed -i "/<stream type=\"music\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#r  sed -i "/<stream type=\"ring\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#a  sed -i "/<stream type=\"alarm\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#v  sed -i "/<stream type=\"voice_call\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#n  sed -i "/<stream type=\"notification\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
fi

}

# misoundfx
misoundfx

## function
drmod() {

# store
LIB=libdrmod.so
LIBNAME=drmod
NAME=drmod
UUID=e069d9e0-8329-11df-9168-0002a5d5c51b
RMV="$LIB $LIBNAME $NAME $UUID"

# patch audio effects conf
if [ "$MODAEC" ]; then
  remove_conf
  sed -i "/^libraries {/a\  $LIBNAME {\n    path $LIBPATH\/$LIB\n  }" $MODAEC
  sed -i "/^effects {/a\  $NAME {\n    library $LIBNAME\n    uuid $UUID\n  }" $MODAEC
  if ! grep -Eq '^global_processing {' $MODAEC; then
    sed -i -e '$a\
global_processing {\
}\' $MODAEC
  fi
  sed -i '/^global_processing {/a\
  drmod {\
    bl@lakala {\
      param {\
        int 6\
      }\
      value {\
        string *com.lakala.android\
      }\
    }\
    bl@jawboneup {\
      param {\
        int 6\
      }\
      value {\
        string *com.jawbone.up\
      }\
    }\
    bl@hojyremote {\
      param {\
        int 6\
      }\
      value {\
        string *com.hojy.hremote\
      }\
    }\
  }' $MODAEC
#m  sed -i "/^    music {/a\        $NAME {\n        }" $MODAEC
#r  sed -i "/^    ring {/a\        $NAME {\n        }" $MODAEC
#a  sed -i "/^    alarm {/a\        $NAME {\n        }" $MODAEC
#v  sed -i "/^    voice_call {/a\        $NAME {\n        }" $MODAEC
#n  sed -i "/^    notification {/a\        $NAME {\n        }" $MODAEC
fi

# patch effects xml
if [ "$MODAEX" ]; then
  remove_xml
  sed -i "/<libraries>/a\        <library name=\"$LIBNAME\" path=\"$LIB\"\/>" $MODAEX
  sed -i "/<effects>/a\        <effect name=\"$NAME\" library=\"$LIBNAME\" uuid=\"$UUID\"\/>" $MODAEX
#m  sed -i "/<stream type=\"music\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#r  sed -i "/<stream type=\"ring\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#a  sed -i "/<stream type=\"alarm\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#v  sed -i "/<stream type=\"voice_call\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#n  sed -i "/<stream type=\"notification\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
fi

}

# store
LIB=libozoprocessing.so
LIBNAME=ozo_processing
NAME=ozo
UUID=7e384a3b-7850-4a64-a097-884250d8a737
RMV="$LIB $LIBNAME $NAME $UUID"

# patch audio effects conf
if [ "$MODAEC" ]; then
  remove_conf
  sed -i "/^libraries {/a\  $LIBNAME {\n    path $LIBPATH\/$LIB\n  }" $MODAEC
  sed -i "/^effects {/a\  $NAME {\n    library $LIBNAME\n    uuid $UUID\n  }" $MODAEC
#c  sed -i "/^  camcorder {/a\    $NAME {\n    }" $MODAEC
#c  sed -i "/^  mic {/a\    $NAME {\n    }" $MODAEC
#c  sed -i "/^  voice_recognition {/a\    $NAME {\n    }" $MODAEC
fi

# patch audio effects xml
if [ "$MODAEX" ]; then
  remove_xml
  sed -i "/<libraries>/a\        <library name=\"$LIBNAME\" path=\"$LIB\"\/>" $MODAEX
  sed -i "/<effects>/a\        <effect name=\"$NAME\" library=\"$LIBNAME\" uuid=\"$UUID\"\/>" $MODAEX
#c  sed -i "/<stream type=\"camcorder\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#c  sed -i "/<stream type=\"mic\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#c  sed -i "/<stream type=\"voice_recognition\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
fi

## function
dap() {

# store
LIB=libswdap.so
LIBHW=libhwdap.so
LIBNAME=dap_sw
LIBNAMEHW=dap_hw
NAME=dap
UUID=6ab06da4-c516-4611-8166-452799218539
UUIDHW=a0c30891-8246-4aef-b8ad-d53e26da0253
UUIDPROXY=9d4921da-8225-4f29-aefa-39537a04bcaa
RMV="$LIB $LIBHW $LIBNAME $LIBNAMEHW $NAME $UUID $UUIDHW $UUIDPROXY"

# patch audio effects conf
if [ "$MODAEC" ]; then
  remove_conf
  sed -i "/^libraries {/a\  proxy {\n    path $LIBPATH\/libeffectproxy.so\n  }" $MODAEC
  sed -i "/^libraries {/a\  $LIBNAMEHW {\n    path $LIBPATH\/$LIBHW\n  }" $MODAEC
  sed -i "/^libraries {/a\  $LIBNAME {\n    path $LIBPATH\/$LIB\n  }" $MODAEC
  sed -i "/^effects {/a\  $NAME {\n    library proxy\n    uuid $UUIDPROXY\n  }" $MODAEC
  sed -i "/^    uuid $UUIDPROXY/a\    libhw {\n      library $LIBNAMEHW\n      uuid $UUIDHW\n    }" $MODAEC
  sed -i "/^    uuid $UUIDPROXY/a\    libsw {\n      library $LIBNAME\n      uuid $UUID\n    }" $MODAEC
#m  sed -i "/^    music {/a\        $NAME {\n        }" $MODAEC
#r  sed -i "/^    ring {/a\        $NAME {\n        }" $MODAEC
#a  sed -i "/^    alarm {/a\        $NAME {\n        }" $MODAEC
#v  sed -i "/^    voice_call {/a\        $NAME {\n        }" $MODAEC
#n  sed -i "/^    notification {/a\        $NAME {\n        }" $MODAEC
fi

# patch audio effects xml
if [ "$MODAEX" ]; then
  remove_xml
  sed -i "/<libraries>/a\        <library name=\"proxy\" path=\"libeffectproxy.so\"\/>" $MODAEX
  sed -i "/<libraries>/a\        <library name=\"$LIBNAMEHW\" path=\"$LIBHW\"\/>" $MODAEX
  sed -i "/<libraries>/a\        <library name=\"$LIBNAME\" path=\"$LIB\"\/>" $MODAEX
  sed -i "/<effects>/a\        <\/effectProxy>" $MODAEX
  sed -i "/<effects>/a\            <libhw library=\"$LIBNAMEHW\" uuid=\"$UUIDHW\"\/>" $MODAEX
  sed -i "/<effects>/a\            <libsw library=\"$LIBNAME\" uuid=\"$UUID\"\/>" $MODAEX
  sed -i "/<effects>/a\        <effectProxy name=\"$NAME\" library=\"proxy\" uuid=\"$UUIDPROXY\">" $MODAEX
#m  sed -i "/<stream type=\"music\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#r  sed -i "/<stream type=\"ring\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#a  sed -i "/<stream type=\"alarm\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#v  sed -i "/<stream type=\"voice_call\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#n  sed -i "/<stream type=\"notification\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
fi

}

# dap
#ddap

## function
vqe() {

# store
LIB=libswvqe.so
LIBNAME=vqe
NAME=vqe
UUID=64a0f614-7fa4-48b8-b081-d59dc954616f
RMV="$LIB $LIBNAME $NAME $UUID"

# patch audio effects conf
if [ "$MODAEC" ]; then
  remove_conf
  sed -i "/^libraries {/a\  $LIBNAME {\n    path $LIBPATH\/$LIB\n  }" $MODAEC
  sed -i "/^effects {/a\  $NAME {\n    library $LIBNAME\n    uuid $UUID\n  }" $MODAEC
fi

# patch audio effects xml
if [ "$MODAEX" ]; then
  remove_xml
  sed -i "/<libraries>/a\        <library name=\"$LIBNAME\" path=\"$LIB\"\/>" $MODAEX
  sed -i "/<effects>/a\        <effect name=\"$NAME\" library=\"$LIBNAME\" uuid=\"$UUID\"\/>" $MODAEX
fi

}

# vqe
#dvqe

# function
gamedap() {

# store
LIB=libswgamedap.so
LIBNAME=gamedap
NAME=gamedap
UUID=3783c334-d3a0-4d13-874f-0032e5fb80e2
RMV="$LIB $LIBNAME $NAME $UUID"

# patch audio effects conf
if [ "$MODAEC" ]; then
  remove_conf
  sed -i "/^libraries {/a\  $LIBNAME {\n    path $LIBPATH\/$LIB\n  }" $MODAEC
  sed -i "/^effects {/a\  $NAME {\n    library $LIBNAME\n    uuid $UUID\n  }" $MODAEC
#m  sed -i "/^    music {/a\        $NAME {\n        }" $MODAEC
#r  sed -i "/^    ring {/a\        $NAME {\n        }" $MODAEC
#a  sed -i "/^    alarm {/a\        $NAME {\n        }" $MODAEC
#v  sed -i "/^    voice_call {/a\        $NAME {\n        }" $MODAEC
#n  sed -i "/^    notification {/a\        $NAME {\n        }" $MODAEC
fi

# patch audio effects xml
if [ "$MODAEX" ]; then
  remove_xml
  sed -i "/<libraries>/a\        <library name=\"$LIBNAME\" path=\"$LIB\"\/>" $MODAEX
  sed -i "/<effects>/a\        <effect name=\"$NAME\" library=\"$LIBNAME\" uuid=\"$UUID\"\/>" $MODAEX
#m  sed -i "/<stream type=\"music\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#r  sed -i "/<stream type=\"ring\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#a  sed -i "/<stream type=\"alarm\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#v  sed -i "/<stream type=\"voice_call\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
#n  sed -i "/<stream type=\"notification\">/a\            <apply effect=\"$NAME\"\/>" $MODAEX
fi

}

# patch media codecs
#dif [ -f $MODMC ]; then
#d  sed -i '/<MediaCodecs>/a\
#d    <Include href="media_codecs_dolby_audio.xml"/>' $MODMC
#dfi

# patch audio policy
#uif [ "$MODAP" ]; then
#u  sed -i 's/RAW/NONE/g' $MODAP
#u  sed -i 's/,raw//g' $MODAP
#ufi






