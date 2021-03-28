#!/gearlock/bin/bash
filesdir="$DEPDIR/cursorpack"

function Cursor() {
		
		dialog --title "Applying cursor" --clear --msgbox "Ready to patch /system/framework/framework-res.apk with new cursor from $PWD \nPress enter to start the process or press ctrl+c twice to cancel" 10 60
		# framework-res upgrade		
		(pv -n /system/framework/framework-res.apk > /sdcard/framework-res.apk) 2>&1 | dialog --title "Preparing system framework" --gauge "Making a copy of /system/framework/framework-res.apk" 8 60; sleep 1
		Pcp; sleep 1
		cd /sdcard/
		7z a framework-res.apk res/ | dialog --title "Cursor installation" --progressbox "Patching framework-res.apk with new cursors" 15 60; sleep 2
		(pv -n framework-res.apk > /system/framework/framework-res.apk) 2>&1 | dialog --title "Cursor installation" --gauge "Installing patched system framework" 7 45; sleep 1
		chmod 644 /system/framework/framework-res.apk  
		stop; start
		Loader
}

function Pcp() {
DIRS=(*)
DEST="/sdcard/res/drawable-mdpi-v4/"
[ ! -d $DEST ] && mkdir -p $DEST

dialog --gauge "Loading cursor files" 8 55 < <(
   n=${#DIRS[*]}; 
   i=0

   for f in "${DIRS[@]}"
   do
      # calculate progress
      PCT=$(( 100*(++i)/n ))

      # update dialog box 
cat <<EOF
XXX
$PCT
Loading $f...
XXX
EOF
  # copy file $f to $DEST 
  cp $f ${DEST} &>/dev/null
   done
)
}

function Restore() {

		dialog --title "Restoring" --clear --msgbox "Restoring backup, make sure you had an backup" 7 45
		# Backup boot animation
		[ ! -f $filesdir/cursor.backup ] && dialog --msgbox "Lol you suck, you dont have an backup, you could have broke your system in old versions of the cursor pack if you tried to restore backup without having a backup.\nChoose backup from the menu first!" 10 50 && Loader
		
				cat $filesdir/cursor.backup > /system/framework/framework-res.apk
				chmod 644 /system/framework/framework-res.apk
				stop; start
			Loader
		
		
}

function Backup() {

		dialog --title "Backup" --clear --msgbox "Saving current boot animation and cursor" 7 45
		# Backup cursor
		cat /system/framework/framework-res.apk > $filesdir/cursor.backup
		Loader
		
}

function check() {

	if grep -iq 'darkmatter\|eng.electr.20201113.152513' "$SYSTEM_DIR/build.prop"; then
		Lightning
	  
	else
		dialog --title "Warning" --clear --msgbox "We have found you are not using DarkMatter or Bliss OS 11.13
		To change cursor we have to modify system ui app framework-res.apk, I have tested only on Bliss OS 11.13 and Phoenix OS darkmatter.
		Consider making a backup before proceeding." 10 55
		Lightning
	  
	fi

}


function Lightning() {
	HEIGHT=20
	WIDTH=60
	CHOICE_HEIGHT=23
	BACKTITLE=$(gecpc "By SupremeGamers" "_")
	EXTRA="Exit"
	CANCEL="Add/Update"
	OKB="Choose"
	TITLE="Scroll down to see all cursors"
	MENU="Made by Xtr, some cursors given by 
	DevPlayz,NM-AKSHAR,Lightning"
    W=($(ls $filesdir | grep -v 'cursor.backup' | nl)) 
	CHOICE=$(dialog --clear --cancel-label "Exit" \
	                --backtitle "$BACKTITLE" \
	                --title "$TITLE" \
					--ok-label "$OKB" \
					--extra-button --extra-label "$EXTRA"\
					--cancel-label "$CANCEL" \
	                --menu "$MENU" \
	                $HEIGHT $WIDTH $CHOICE_HEIGHT \
					"${W[@]}" 3>&2 2>&1 1>&3); Return=$?
	if [ $Return = 0 ]; then 
        cd $filesdir
		cname="$(ls -1 $PWD | grep -v 'cursor.backup' | sed -n "$CHOICE p")"
		if echo "$cname" | grep -iq restore; then
		Restore
		elif echo "$cname" | grep -iq backup; then
		Backup
		else
		cd "$(readlink -f "$cname")"
		Cursor
        fi
	elif [ $Return = 3 ]; then
    exit
	fi
	dialog --title "Add nice cursors" --yes-label "Add cursors" --no-label "Update from internet"  --yesno "You can add cursors from local file or fetch latest cursor list from github Xtr126/CursorChangerGearlock
	Only png format supported. Must be connected to the internet for update to work. Consider supporting the development by giving me nice cursors if you have some"  10 60 
}

function Loader() {

PCT=0
(
while test $PCT != 105
do
cat <<EOF
XXX
$PCT
┌──────────────────────────────────────────┐
│ ┏━━‎╻ ╻‎╻━╻ ┏━━ ┏━┓‎╻━╻ ‎ ┏━┓ ╻━╻ ┏━━ ╻
│ ┃ ‎ ┃ ┃‎┃━┃ ┗━━ ┃ ┃‎┃━┃ ‎ ┃━┛ ┃━┃ ┃ ‎ ┃/
│ ┗━━‎╹━╹‎┃ \ ━━╹ ┗━┛‎┃ \\ ‎ ┃ ‎ ┃ ┃ ┗━━ ┃⟍⟍
└──────────────────────────────────────────┘
. . . . . . . Made by: Xtr126 //
XXX
EOF
PCT=`expr $PCT + 5`
sleep 0.05
done
) |

dialog "$@" --gauge "Hi, thanks" 11 50 0; sleep 0.5
check
}

Loader
