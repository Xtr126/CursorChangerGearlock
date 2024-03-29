
#######################################################################################################
#####=============================== Package/Extension Information ===============================#####

NAME="Cursor pack" #Package/Extension Name

CODENAME="cursor-changer" #An Unique codename

TYPE="Package" #Specify (Package / Extension)

AUTHOR="Xtr" #Your name as the Developer/Owner/Packer

VERSION="1.2" #Specify the Version of this package/extension

SHORTDESC="A gearlock package to help modify the system cursor/mouse pointer" #Provide a short description about this package/extension

C_EXTNAME="CursorPack" #For Specifing a custom name for your extension script ($NAME is used if not defined)

#####=============================== Package/Extension Information ===============================#####
#######################################################################################################




#------------------------------------------------------------------------------------------------------




#######################################################################################################
######=============================== Package/Extension Functions ===============================######

REQSYNC="yes" #(Deafult - yes) To make sure all your files are properly written in disk

REQREBOOT="no" #(Deafult - no) Use if your package/extension modifies any major system file

GEN_UNINS="yes" #(Deafult - no) If you want GearLock to generate an uninstallation script itself

SHOW_PROG="yes" #(Default - yes) Whether to show extraction progress while loading the pkg/extension

DEF_HEADER="yes" #(Default -yes) Whether to use the default header which print's the info during zygote

######=============================== Package/Extension Functions ===============================######
#######################################################################################################




#------------------------------------------------------------------------------------------------------




#######################################################################################################
######======================================= CustomHeader ======================================######
                        #Do not edit this part unless you know what you're doing#
                #Set `DEF_HEADER` to `no' if you want to specify a custom zygote header#
       #Then you can use `geco` or `cat` to print your custom header below for the zygote stage#





######========================================== Header =========================================######
#######################################################################################################
