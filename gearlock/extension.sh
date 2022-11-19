#!/gearlock/bin/bash

filesdir="$DEPDIR/cursorpack"

apply_cursor() {
	dialog --title "Applying cursor" --clear --msgbox \
	"Ready to patch /system/framework/framework-res.apk with new cursor from $PWD
	Press enter to start the process or press ctrl+c twice to cancel" 10 60

	(pv -n /system/framework/framework-res.apk > /sdcard/framework-res.apk) 2>&1 | \
	dialog --title "Preparing system framework" --gauge \
	"Making a copy of /system/framework/framework-res.apk" 8 60

	DIRS=( $(ls) )
	DEST="/sdcard/res/drawable-mdpi-v4"

	[ ! -d $DEST ] && mkdir -p $DEST

	dialog --gauge "Loading cursor files" 8 55 < <(
		n=${#DIRS[*]};
		i=0
		for f in "${DIRS[@]}"; do
			# calculate progress
			PCT=$(( 100*(++i)/n ))
			# update dialog box
			echo "XXX
				  $PCT
				  Loading $f...
				  XXX"
			cp $f $DEST &>/dev/null
		done
	)

	cd /sdcard

	7z a framework-res.apk res/ | \
	dialog --title "Cursor installation" \
	       --progressbox "Patching framework-res.apk with new cursors" 15 60

	(pv -n framework-res.apk > /system/framework/framework-res.apk) 2>&1 | \
	dialog --title "Cursor installation" --gauge \
	"Installing patched system framework" 7 45

	chmod 644 /system/framework/framework-res.apk  
	load_cursor
	dialog_gauge_progress_bar
}

restore_cursor() {

	dialog --title "Restoring" --clear --msgbox "Restoring backup, make sure you had an backup" 7 45

	if [ ! -f /data/cursor.backup ]; then 
		dialog --msgbox "No backup found.\nChoose backup from the menu first!" 10 50 
		dialog_gauge_progress_bar
	fi

	cp /data/cursor.backup /system/framework/framework-res.apk
	chmod 644 /system/framework/framework-res.apk

	load_cursor
	dialog_gauge_progress_bar
}

load_cursor() {
  pkill com.android.systemui
}

backup_system_framework() {
	dialog --title "Backup" --clear --msgbox "Saving /system/framework/framework-res.apk as /data/cursor.backup" 7 45
	# Backup cursor
	cp -a /system/framework/framework-res.apk /data/cursor.backup
	dialog_gauge_progress_bar
}

check_os() {
	if ! grep -iq 'darkmatter\|ro.bliss.version=11' "$SYSTEM_DIR/build.prop"; then
		dialog --title "Warning" --clear --msgbox "We have found you are not using DarkMatter or Bliss OS 11.13
		To change cursor we have to modify system file framework-res.apk, I have tested only on Bliss OS 11.13 and Phoenix OS darkmatter.
		Consider making a backup before proceeding." 10 55
	fi

	[ ! -f /data/cursor.backup ] && \
	if (dialog --title "Warning: No backup found!" \
	           --yes-label "Yes" --no-label "No" \
	  --yesno "Do you want to save a backup of
	          /system/framework/framework-res.apk ?" 7 45); then
    backup_system_framework
  fi
	main_menu
}


main_menu() {
	HEIGHT=20
	WIDTH=60
	CHOICE_HEIGHT=23
	BACKTITLE=$(gecpc "By SupremeGamers" "_")
	EXTRA="Exit"
	CANCEL="Add Cursors"
	OKB="Select"
	TITLE="CursorChangerGearlock"
	MENU="Select a cursor to apply"
	let i=0 # define counting variable
	W=() # define working array
	while read -r line; do # process file by file
	let i=$i+1
	W+=($i "$line")
	done < <( ls $filesdir )
	CHOICE=$(dialog --clear --cancel-label "Exit" \
					--backtitle "$BACKTITLE" \
					--title "$TITLE" \
					--ok-label "$OKB" \
					--extra-button --extra-label "$EXTRA"\
					--cancel-label "$CANCEL" \
					--menu "$MENU" \
					$HEIGHT $WIDTH $CHOICE_HEIGHT \
					a "Backup current cursor" \
					b "Restore backup" \
					c "Remove cursors" \
					"${W[@]}" 3>&2 2>&1 1>&3);

	case $? in
		0)case $CHOICE in
			a) backup_system_framework;;
			b) restore_cursor;;
			c) dialog --msgbox "Open FX File manager, open system (root)
								Then go to
								$filesdir
								and remove cursors" 10 50; exit;;
			*)
				cd $filesdir
				cname="$(ls -1 $PWD | sed -n "$CHOICE p")"
				cd "$(readlink -f "$cname")"
				apply_cursor
			;;
		esac
		;;

		3) exit;;

	esac
	source $DEPDIR/filebrowse.sh
	dialog_gauge_progress_bar
}

dialog_gauge_progress_bar() {
	local counter=0
	local banner="$(figlet cursorpack)"
	(
		while test $counter != 105; do
			echo XXX
			echo $counter
			echo "$banner"
			echo ". . Xtr lightning MrMiy4mo NM_AKSHAR DevPlayz TukangM //"
			echo XXX
			let "counter = counter + 5"
			sleep 0.05
		done
	) | dialog --no-collapse --gauge "initializing.." 12 60 0; sleep 0.5
check_os
}

dialog_gauge_progress_bar