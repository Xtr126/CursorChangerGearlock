filesdir="$DEPDIR/bootanimationchanger"
backupdir="$STATDIR/${filesdir##*/}/backup"
rm -f /system/media/bootanimation-after-first-boot.zip
rsync -a "$backupdir/" /system/media
chmod -f 644 /system/media/bootanimation-after-first-boot.zip

