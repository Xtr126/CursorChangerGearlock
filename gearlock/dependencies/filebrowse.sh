startdir=/sdcard
filext='.png'
menutitle="Cursor $filext Selection Menu"


#------------------------------------------------------------------------------
function Filebrowser()
{

    if [ -z $2 ] ; then
        dir_list=($(ls -lhp  | awk -F ' ' ' { print $9 " " $5 } '))
    else
        cd "$2"
        dir_list=($(ls -lhp  | awk -F ' ' ' { print $9 " " $5 } '))
    fi
	HEIGHT=20
	WIDTH=60
	CHOICE_HEIGHT=23
    curdir=$(pwd)
    if [ "$curdir" == "/" ] ; then  # Check if you are at root folder
        selection=$(dialog --title "$1" \
							  --ok-label Select \
                              --cancel-label Cancel \
							  --menu "$curdir" \
							  $HEIGHT $WIDTH $CHOICE_HEIGHT \
                              "${dir_list[@]}" 3>&1 1>&2 2>&3)
    else   # Not Root Dir so show ../ BACK Selection in Menu
        selection=$(dialog --title "$1" \
							  --ok-label Select \
							  --cancel-label Cancel \
							  --extra-button --extra-label Back \
                              --menu "$curdir" \
							  $HEIGHT $WIDTH $CHOICE_HEIGHT \
                              "${dir_list[@]}" 3>&1 1>&2 2>&3)
    fi

    RET=$?
	if [ $RET = 3 ]; then
	Filebrowser "$1" "../"
	fi
    if [ $RET -eq 1 ]; then  # Check if User Selected Cancel
       return 1	
    elif [ $RET -eq 0 ]; then
       if [[ -d "$selection" ]]; then  # Check if Directory Selected
          Filebrowser "$1" "$selection"
       elif [[ -f "$selection" ]]; then  # Check if File Selected
          if [[ $selection == *$filext ]]; then   # Check if selected File has .jpg extension
            if (dialog --title "Confirm Selection" --yes-label "Confirm" --no-label "Retry" --yesno "Location : $curdir\nFileName:$selection" 7 45); then
                filename="$selection"
                filepath="$curdir"    # Return full filepath  and filename as selection variables
            else
                Filebrowser "$1" "$curdir"
            fi
          else   # Not correct extension so Inform User and restart
             dialog --title "ERROR: File Must have $filext Extension" --msgbox "$selection\nYou Must Select a $filext file" 7 45
             Filebrowser "$1" "$curdir"
          fi
       else
          # Could not detect a file or folder so Try Again
          dialog --title "ERROR: Selection Error" \
                 --msgbox "Error Changing to Path $selection" 7 45
				 Filebrowser "$1" "$curdir"
       fi
    fi
}


Filebrowser "$menutitle" "$startdir"

exitstatus=$?
if [ $exitstatus -eq 0 ]; then
    if [ "$selection" == "" ]; then
		Loader
    else
	
		let i=0 # define counting variable
		OPTIONS=() # define working array
		while read -r line; do # process file by file
		let i=$i+1
		OPTIONS+=("$line" $i)
		done < <( ls $filesdir/evolution/ )
		TITLE="Which type of cursor is this?"
		MENU="21 types of cursors available, choose what you want"
		CHOICE=$(dialog --clear --cancel-label "Exit" \
	                --title "$TITLE" \
	                --menu "$MENU" \
	                $HEIGHT $WIDTH $CHOICE_HEIGHT \
	                "${OPTIONS[@]}" 2>&1 >/dev/tty)
    	 if (dialog --yes-label "Add" --no-label "Try" --yesno \
		 	"Do you want to add the cursor to the cursor selection menu or try the cursor for now?" 7 45); then
		 	user_input=$(dialog --title "Enter name" --inputbox \
		 	"Enter the name to be displayed in cursor selection menu" 9 45 3>&2 2>&1 1>&3)
		 	mkdir $filesdir/"$user_input"
		 	cat $filepath/$filename > $filesdir/"$user_input"/$CHOICE
		 	Loader
		 else

			dialog --title "Applying cursor" --clear --msgbox \
			"Ready to patch /system/framework/framework-res.apk with new cursor from $filepath/$filename
			Press enter to start the process or press ctrl+c twice to cancel" 10 60
			# framework-res upgrade		
			(pv -n /system/framework/framework-res.apk > /sdcard/framework-res.apk) 2>&1 | \
			dialog --title "Preparing system framework" --gauge \
			"Making a copy of /system/framework/framework-res.apk" 8 60; sleep 1
			mkdir -p /sdcard/res/drawable-mdpi-v4/
			
			cd /sdcard/
			cat $filepath/$filename > /sdcard/res/drawable-mdpi-v4/$CHOICE
			
			7z a framework-res.apk res/ | \
			dialog --title "Cursor installation" --progressbox "Patching framework-res.apk with new cursor" 15 60; sleep 2
			
			(pv -n framework-res.apk > /system/framework/framework-res.apk) 2>&1 | \
			dialog --title "Cursor installation" --gauge "Installing patched system framework" 7 45; sleep 1
			
			chmod 644 /system/framework/framework-res.apk  
			
			stop; start
			Loader
		fi
	fi
fi
Loader
