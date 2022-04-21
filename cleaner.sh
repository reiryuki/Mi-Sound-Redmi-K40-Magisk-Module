PKG="com.miui.misound com.dolby.daxservice"
for PKGS in $PKG; do
  rm -rf /data/user/*/$PKGS/cache
done


