#!/bin/sh
#made by denellum 09-11-2017#
#v1.0#

#==============================================#
#DEFINABLE VARIABLES#
#(You most likely will need to change these)#
#==============================================#

#The ABSOLUTE path to your bin directory#
SERVERpath="/home/warcraft/server/bin/"
#the ABSOLUTE path to your TrinityCore directory
TCpath="/home/warcraft/TrinityCore/"
#What you called your screen sessions#
SCREENworld="worldserver"
SCREENauth="authserver"

#==============================================#
#STATIC VARIABLES#
#(Only change these if you know what you're doing)#
#(The stuff in the quotes)#
#==============================================#

#Variable for starting a screen with the screen defined name#
STARTscreenworld="screen -dmS $SCREENworld"
STARTscreenauth="screen -dmS $SCREENauth"
#Variable for sending a screen command to the defined screen#
SCREENcommandworld="screen -S $SCREENworld -p 0 -X stuff"
SCREENcommandauth="screen -S $SCREENauth -p 0 -X stuff"
#Variable to start auth & world
AUTHstart="./authserver"
WORLDstart="./worldserver"
#Variable for a screen command to press enter#
SCREENenter="$(printf \\r)"
#Variables for Logs
AUTHlog="/home/warcraft/server/bin/Auth.log"
WORLDlog="/home/warcraft/server/bin/Server.log"
#Misc Variables 
WORLDupdate=""


while [ "$1" != "" ]; do
    case $1 in
        #Starts the Auth server on the defined screen#
        -startAUTH )
			$STARTscreenauth
			sleep 5
                        $SCREENcommandauth "cd $SERVERpath$SCREENenter"
			sleep 5
                        $SCREENcommandauth "$AUTHstart$SCREENenter"
                        sleep 20
                        tail -n1 $AUTHlog
                        ;;
        #Starts the World server on the defined screen#
        -startWORLD )
			$STARTscreenworld
			sleep 5
                        $SCREENcommandworld "cd $SERVERpath$SCREENenter"
			sleep 5
                        $SCREENcommandworld "$WORLDstart$SCREENenter"
                        sleep 30
                        tail -n1 $WORLDlog
                        ;;
        #Starts the World server on the defined screen#
        -updateWORLD )
			
			sleep 5
                        $SCREENcommandworld "server shutdown 300 ($(date +%Y%m%d-%H%M))$SCREENenter"
			sleep 330
							cd ~/TrinityCore/
							sleep 5
							# For 3.3.5 Branch
							git pull origin 3.3.5
							sleep 5
							cd build/
							sleep 5
							cmake ../ -DCMAKE_INSTALL_PREFIX=/home/$USER/server -DTOOLS=0 -DWITH_WARNINGS=1
							sleep 5
							make
							sleep 5
							make -j $(nproc) install
			sleep 5
                        $SCREENcommandworld "$WORLDstart$SCREENenter"
                        sleep 20
                        tail -n1 $WORLDlog
                        ;;

        #Lists all the commands in this script#
        -help )
                        echo "Valid commands :";
                        echo "-start ~ starts the world with predefined settings.";
                        exit
                        ;;
	#If you ran a command that wasn't here... lets give you help#
        * )
                        echo "try -help"
                        exit 1
        esac
        shift
done
