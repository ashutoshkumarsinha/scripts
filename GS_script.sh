#!/usr/bin/sh
#################################################################
#                                                               #
# Nokia Solutions & Networks (c) 2013, All rights reserved      #
#                                                               #
# Graceful Shutdown Script v3.0                                 #
#                                                               #
# Author:  Ashutosh Kumar                                       #
#                                                               #
# History: Ashutosh Kumar	08.01.2013 - First Issue            #
#          Ashutosh Kumar	08.13.2013 - Second Issue           #
#          Ashutosh Kumar	09.22.2013 - Third Issue            #
#                                                               #
#################################################################

# Kickoff immediately function
function gskApply () {
clear
rm -f /tmp/GS_script.log
echo
echo "----------------------------------------------------------------------------------"
echo "	Applying Graceful Shutdown & Kickoff on ${hname}"
echo "----------------------------------------------------------------------------------"
echo
echo "Set Re-Registration Expiry timer to 7200" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "AdvCfgTool.sh -a SET ims/cscf/scscf System.GSReregExpire='7200'" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log
echo "Set Graceful Shutdown Response Message Code to 503" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "AdvCfgTool.sh -a SET ims/cscf/pcscf System.GSRespMsgCode='503'" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log
echo "I-CSCF Graceful Shutdown" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "AdvCfgTool.sh -a SET ims/cscf/icscf System.OpStateIcscf='1'" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log
echo "P-CSCF Graceful Shutdown" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "AdvCfgTool.sh -a SET ims/cscf/cscfb System.OpStatePcscf='2'" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log
echo "S-CSCF Graceful Shutdown" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "AdvCfgTool.sh -a SET ims/cscf/cscfb System.OpStateScscf='3'" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log
echo "Stopping load balancer agent" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "execRTPenv RtpInlabAgent -stop" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log

GSRE=`egrep -c 'Successfully set System.GSReregExpire' /tmp/GS_script.log`
if [ "$GSRE" = "1" ]; then
	echo "Successfully set Re-Registration Expiry timer to 7200"
else
	echo "Failed to set Re-Registration Expiry timer to 7200"
fi

GSRM=`egrep -c 'Successfully set System.GSRespMsgCode' /tmp/GS_script.log`
if [ "$GSRM" = "1" ]; then
	echo "Successfully set Graceful Shutdown Response Message Code to 503"
else
	echo "Failed to set Graceful Shutdown Response Message Code to 503"
fi

OSP=`egrep -c 'Successfully set System.OpStatePcscf' /tmp/GS_script.log`
if [ "$OSP" = "1" ]; then
	echo "P-CSCF Graceful Shutdown done successfully"
else
	echo "P-CSCF Graceful Shutdown failed"
fi

OSI=`egrep -c 'Successfully set System.OpStateIcscf' /tmp/GS_script.log`
if [ "$OSI" = "1" ]; then
	echo "I-CSCF Graceful Shutdown done successfully"
else
	echo "I-CSCF Graceful Shutdown failed"
fi

OSS=`egrep -c 'Successfully set System.OpStateScscf' /tmp/GS_script.log`
if [ "$OSS" = "1" ]; then
	echo "S-CSCF Graceful Shutdown done successfully"
else
	echo "S-CSCF Graceful Shutdown failed"
fi
egrep 'stopped' /tmp/GS_script.log
echo
echo "Log has been written to /tmp/GS_script.log"
echo
echo "----------------------------------------------------------------------------------"
echo
}

# Graceful shutdown function
function gsApply () {
clear
rm -f /tmp/GS_script.log
echo
echo "----------------------------------------------------------------------------------"
echo "	Applying Graceful Shutdown on ${hname}"
echo "----------------------------------------------------------------------------------"
echo
echo "Set Re-Registration Expiry timer to 7200" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "AdvCfgTool.sh -a SET ims/cscf/scscf System.GSReregExpire='7200'" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log
echo "Set Graceful Shutdown Response Message Code to 503" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "AdvCfgTool.sh -a SET ims/cscf/pcscf System.GSRespMsgCode='503'" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log
echo "I-CSCF Graceful Shutdown" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "AdvCfgTool.sh -a SET ims/cscf/icscf System.OpStateIcscf='1'" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log
echo "P-CSCF Graceful Shutdown" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "AdvCfgTool.sh -a SET ims/cscf/cscfb System.OpStatePcscf='1'" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log
echo "S-CSCF Graceful Shutdown" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "AdvCfgTool.sh -a SET ims/cscf/cscfb System.OpStateScscf='2'" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log
echo "Stopping load balancer agent" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "execRTPenv RtpInlabAgent -stop" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log

GSRE=`egrep -c 'Successfully set System.GSReregExpire' /tmp/GS_script.log`
if [ "$GSRE" = "1" ]; then
	echo "Successfully set Re-Registration Expiry timer to 7200"
else
	echo "Failed to set Re-Registration Expiry timer to 7200"
fi

GSRM=`egrep -c 'Successfully set System.GSRespMsgCode' /tmp/GS_script.log`
if [ "$GSRM" = "1" ]; then
	echo "Successfully set Graceful Shutdown Response Message Code to 503"
else
	echo "Failed to set Graceful Shutdown Response Message Code to 503"
fi

OSP=`egrep -c 'Successfully set System.OpStatePcscf' /tmp/GS_script.log`
if [ "$OSP" = "1" ]; then
	echo "P-CSCF Graceful Shutdown done successfully"
else
	echo "P-CSCF Graceful Shutdown failed"
fi

OSI=`egrep -c 'Successfully set System.OpStateIcscf' /tmp/GS_script.log`
if [ "$OSI" = "1" ]; then
	echo "I-CSCF Graceful Shutdown done successfully"
else
	echo "I-CSCF Graceful Shutdown failed"
fi

OSS=`egrep -c 'Successfully set System.OpStateScscf' /tmp/GS_script.log`
if [ "$OSS" = "1" ]; then
	echo "S-CSCF Graceful Shutdown done successfully"
else
	echo "S-CSCF Graceful Shutdown failed"
fi
egrep 'stopped' /tmp/GS_script.log
echo
echo "Log has been written to /tmp/GS_script.log"
echo
echo "----------------------------------------------------------------------------------"
echo
}

# Graceful shutdown backout function
function bApply () {
clear
rm -f /tmp/GS_script.log
echo
echo "----------------------------------------------------------------------------------"
echo "	Graceful Shutdown Backout on ${hname}"
echo "----------------------------------------------------------------------------------"
echo
echo "Set Re-Registration Expiry timer to 600" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "AdvCfgTool.sh -a SET ims/cscf/scscf System.GSReregExpire='600'" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log
echo "Set Graceful Shutdown Response Message Code to 480" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "AdvCfgTool.sh -a SET ims/cscf/pcscf System.GSRespMsgCode='480'" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log
echo "I-CSCF Graceful Shutdown" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "AdvCfgTool.sh -a SET ims/cscf/icscf System.OpStateIcscf='0'" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log
echo "P-CSCF Graceful Shutdown" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "AdvCfgTool.sh -a SET ims/cscf/cscfb System.OpStatePcscf='0'" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log
echo "S-CSCF Graceful Shutdown" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "AdvCfgTool.sh -a SET ims/cscf/cscfb System.OpStateScscf='0'" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log
echo "Starting load balancer agent" >> /tmp/GS_script.log
echo "----------------------------------------------------------------------------------" >> /tmp/GS_script.log
su - rtp99 -c "execRTPenv RtpInlabAgent -start" >> /tmp/GS_script.log
echo " " >> /tmp/GS_script.log

GSRE=`egrep -c 'Successfully set System.GSReregExpire' /tmp/GS_script.log`
if [ "$GSRE" = "1" ]; then
	echo "Successfully set Re-Registration Expiry timer to 600"
else
	echo "Failed to set Re-Registration Expiry timer to 600"
fi

GSRM=`egrep -c 'Successfully set System.GSRespMsgCode' /tmp/GS_script.log`
if [ "$GSRM" = "1" ]; then
	echo "Successfully set Graceful Shutdown Response Message Code to 480"
else
	echo "Failed to set Graceful Shutdown Response Message Code to 480"
fi

OSP=`egrep -c 'Successfully set System.OpStatePcscf' /tmp/GS_script.log`
if [ "$OSP" = "1" ]; then
	echo "P-CSCF Graceful Shutdown backed-out successfully"
else
	echo "P-CSCF Graceful Shutdown back-out failed"
fi

OSI=`egrep -c 'Successfully set System.OpStateIcscf' /tmp/GS_script.log`
if [ "$OSI" = "1" ]; then
	echo "I-CSCF Graceful Shutdown backed-out successfully"
else
	echo "I-CSCF Graceful Shutdown back-out failed"
fi

OSS=`egrep -c 'Successfully set System.OpStateScscf' /tmp/GS_script.log`
if [ "$OSS" = "1" ]; then
	echo "S-CSCF Graceful Shutdown backed-out successfully"
else
	echo "S-CSCF Graceful Shutdown back-out failed"
fi
egrep 'started|running' /tmp/GS_script.log
echo
echo "Log has been written to /tmp/GS_script.log"
echo
echo "----------------------------------------------------------------------------------"
echo
}

# Main function for calling Graceful Shutdown Apply and Backout function
function mainGS () {
clear
A_GS="1" 
B_GS="2"
K_GS="3"
Q_GS="4"

echo
echo "------------------------------------------------------------------------"
echo "----------------------- Graceful Shutdown Script -----------------------"
echo "------------------------------------------------------------------------"
echo
echo
echo "	Please select the appropriate option from below:"
echo "	   1. [A]pply Graceful Shutdown"
echo "	   2. [B]ackout Graceful Shutdown"
echo "	   3. [K]ickout Subscribers Immediately"
echo "	   4. [Q]uit"
echo
read -e -p "	Enter option [A|B|K|Q]: " OPTI

hname=`hostname`
finish="-1"
while [ "$finish" = '-1' ]
	do
		finish="1"
		case $OPTI in
			a | A ) OPTI="1";;
			b | B ) OPTI="2";;
			k | K ) OPTI="3";;
			q | Q ) OPTI="4";;
			*) finish="-1";
			read -e -p "	Invalid response; Please reenter option [A|B|K|Q]: " OPTI;;
        esac
    done

if [ "$OPTI" = "$A_GS" ]; then
	gsApply 
elif [ "$OPTI" = "$B_GS" ]; then
	bApply 
elif [ "$OPTI" = "$K_GS" ]; then
	gskApply
elif [ "$OPTI" = "$Q_GS" ]; then
	clear
	exit
fi
}

mainGS
