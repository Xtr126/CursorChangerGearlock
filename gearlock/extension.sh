#!/gearlock/bin/bash

filesdir="$DEPDIR/cursorpack"

function cursor() {

		dialog --title "Applying cursor" --clear --msgbox "Ready to patch /system/framework/framework-res.apk with new cursor\nPress enter to start the process or press ctrl+c to cancel" 8 60
		# framework-res upgrade
		
		(pv -n /system/framework/framework-res.apk > /sdcard/framework-res.apk) 2>&1 | dialog --title "Preparing system framework" --gauge "Making a copy of /system/framework/framework-res.apk" 8 60; sleep 1
		
		Pcp; sleep 1
		cd /sdcard/
		7z a framework-res.apk res/ | dialog --title "Cursor installation" --progressbox "Patching framework-res.apk with new cursors" 15 60; sleep 2
		(pv -n framework-res.apk > /system/framework/framework-res.apk) 2>&1 | dialog --title "Cursor installation" --gauge "Installing patched system framework" 7 45; sleep 1
		chmod 644 /system/framework/framework-res.apk  
		stop; start
		Lightning
}

function Pcp() {
cd $filesdir/$cname/
DIRS=(*/*/*)
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

		dialog --title "Backup" --clear --msgbox "Saving current boot animation and cursor" 7 45
		# Backup boot animation
		cat $filesdir/cursor.backup > /system/framework/framework-res.apk
		chmod 644 /system/framework/framework-res.apk
		stop; start
		Lightning
		
}

function Backup() {

		dialog --title "Backup" --clear --msgbox "Saving current boot animation and cursor" 7 45
		# Backup cursor
		cat /system/framework/framework-res.apk > $filesdir/cursor.backup
		Lightning
		
}

function check() {

	if grep -iq 'darkmatter\|eng.electr.20201113.152513' "$SYSTEM_DIR/build.prop"; then
		Lightning
	  
	else
		dialog --title "Warning" --clear --msgbox "We have found you are not using DarkMatter or Bliss OS 11.13
		To change cursor we have to modify system ui app framework-res.apk, I have tested only on Bliss OS 11.13 and Phoenix OS darkmatter.
		Make a backup before proceeding." 10 55
		Lightning
	  
	fi

}


function Lightning() {
	HEIGHT=20
	WIDTH=60
	CHOICE_HEIGHT=23
	BACKTITLE=$(gecpc "By SupremeGamers" "_")
	TITLE="Scroll down to see all cursors"
	MENU="Made by Xtr in co-operation with DevPlayz,NM-AKSHAR,Lightning,Lolify/manky201"

	OPTIONS=(1 "Backup system-ui framework"
			 2 "blackish_beauty"
			 3 "blue"
			 4 "Diamond blue/red cursor"
			 5 "HUD Series multi-color cursor"
			 6 "gold"
			 7 "green"
			 8 "greenglow"
			 9 "greenneon"
			 10 "Restore Backup"
			 11 "Xenon green/blue cursor"
			 12 "neon_cyan"
			 13 "neon_cyan_trans"
			 14 "purple"
			 15 "purple_blue"
			 16 "purple_blue_trans"
			 17 "purpleicy"
			 18 "purpleneon"
			 19 "simple_black_trans"
			 20 "Exo 4.7 red cursor"
			 21 "vip_purple"
			 22 "Ice themed cursor"
			 23 "Small red"
			 24 "Small pink"
			 25 "Small blue")

	CHOICE=$(dialog --clear --cancel-label "Exit" \
	                --backtitle "$BACKTITLE" \
	                --title "$TITLE" \
	                --menu "$MENU" \
	                $HEIGHT $WIDTH $CHOICE_HEIGHT \
	                "${OPTIONS[@]}" \
	                2>&1 >/dev/tty)

    case $CHOICE in
  		1)Backup;;
  		2)cname=blackish_beauty; cursor;;
  		3)cname=blue; cursor;;
  		4)cname=cyber; cursor;;
  		5)cname=evolution; cursor;;
  		6)cname=gold; cursor;;
  		7)cname=green; cursor;;
  		8)cname=greenglow; cursor;;
  		9)cname=greenneon; cursor;;
  		10)Restore;;
  		11)cname=neon; cursor;;
  		12)cname=neon_cyan; cursor;;
  		13)cname=neon_cyan_trans; cursor;;
  		14)cname=purple; cursor;;
  		15)cname=purple_blue; cursor;;
  		16)cname=purple_blue_trans; cursor;;
  		17)cname=purpleicy; cursor;;
  		18)cname=purpleneon; cursor;;
  		19)cname=simple_black_trans; cursor;;
  		20)cname=stock; cursor;;
  		21)cname=vip_purple; cursor;;
	    22)cname=ice; cursor;;
		23)cname=red; cursor;;
		24)cname=pink; cursor;;
		25)cname=blue2; cursor;;
		*);;
	esac
}

function Loader() {

PCT=0
(
while test $PCT != 105
do
cat <<EOF
XXX
$PCT
Hold on while we prepare cursors
XXX
EOF
PCT=`expr $PCT + 5`
sleep 0.05
done
) |

dialog --title "Loading " "$@" --gauge "Hi, thanks" 7 45 0; sleep 0.5
check
}

Loader
