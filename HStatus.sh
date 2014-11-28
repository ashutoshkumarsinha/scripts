#!/usr/bin/sh
##############################################################
# Nokia Networks (c) 2014, All rights reserved               #
#                                                            #
# CSCF Health Check Script v3.0                              #
#                                                            #
# Author:  Ashutosh Kumar Sinha                              #
#                                                            #
# History: Ashutosh Kumar       11.10.2014 - First Issue     #
#          Ashutosh Kumar       11.17.2014 - Second Issue    #
#          Ashutosh Kumar       11.20.2014 - Third Issue     #
#                                                            #
##############################################################

# Parameter Initialization
function intialization() {

# Colour definition
RED='\e[1;31m'
GREEN='\e[1;32m'
BLUE='\e[1;34m'
GRAY='\e[1;37m'
BROWN='\e[1;33m'
MAGENTA='\e[1;35m'
NC='\e[0m'

# Constant definition
HNAME=`hostname`
DATE_DISP=`date +'%m-%d-%y'`
COUNTD="10"

# Configuration parameters
HOME_DIR="/tmp"
M_MEM="90"
C_CPU="60"
H0="General Status"
H1="SIP Connection Status"
H2="Diameter Connection Status"
H3="FEE Connection Status"
H4="BGW Connection Status"
H5="NTP Status"
H6="Memory Information"
H7="Disk Information"
H8="Cluster Status"
H9="CPU Status"
FILE_NAME="${HNAME}_Health_Status_Report_${DATE_DISP}.txt"
PORT_DESCRIPTION="${GREY}Protocol            Source IP                   Destination IP              Status      Process Name ${NC}"
PORT_DESCRIPTION1="${GREY}Protocol            Source IP                   Destination IP              Status      ${NC}"
DRAW_LINE="${brown}--------------------------------------------------------------------------------------------------------------------------${NC}"
}

# Command manipulation
function maniCommands() {
	while [  $COUNTD -gt 1 ]; do
             echo -e "\n"
             let COUNTD=COUNTD-1 
    done
	echo -e  '							Generating report...'
	echo -ne '						[##                        ] (3%)\r'
	ANODE=`su - rtp99 -c "IcmAdminTool.pl  PrintRoutingTable | grep 'ActiveNode=' | cut -d '=' -f2 | cut -d ',' -f1"`
	if [ "$HNAME" != "$ANODE" ]; then
		NODESTATUS="Secondary"
	else 
		NODESTATUS="Primary"
	fi
	echo -ne '						[#####                     ] (17%)\r'
	COUNT=`/etc/init.d/rtp status | grep 'RTP_SS_RUNNING' | wc -l`
	echo -ne '						[#######                   ] (33%)\r'
	NE3S=`ps -ef|grep -i ne3s| grep Agent | wc -l`
	echo -ne '						[########                  ] (38%)\r'
	IFSTATUS=`ip link | egrep 'eth0|eth1|eth4|eth5|bond0'| grep DOWN | wc -l`
	echo -ne '						[##########                ] (42%)\r'
	if [[ $(netstat -anpT | grep '506' | grep 'IMS_P_IpDp_Gm' | egrep 'tcp|udp' | sort) ]]; then
		IMPICOUNT=`su - rtp99 -c "reganalyser.sh -l IMPI --role pcscf | egrep 'Active IMPIs' | sed 's/[^0-9]*//g'"`
	else
		IMPICOUNT=`su - rtp99 -c "reganalyser.sh -l IMPI --role scscf | egrep 'Active IMPIs' | sed 's/[^0-9]*//g'"`
	fi
	echo -ne '						[############              ] (49%)\r'
	VER=`su - rtp99 -c 'AdvCfgTool.sh -noattach -e LISTCNFINST ims/common/vers' | grep Aps | cut -d '=' -f2 | sort -u`
	echo -ne '						[#############             ] (52%)\r'
	VER2=`cat /opt/SMAW/INTP/descriptors/installstate* | grep IMSPversc | cut -d ' ' -f2 | sort -u` 
	echo -ne '						[##############            ] (55%)\r'
	TOTAL_MEMORY=`free | grep Mem | awk '{print $2/1024/1024}'`
	echo -ne '						[###############           ] (59%)\r'
	FREE_MEMORY=`free | grep Mem | awk '{print $4/1024/1024}'`
	echo -ne '						[################          ] (63%)\r'
	USED_MEMORY=`free | grep Mem | awk '{print $3/1024/1024}'`
	echo -ne '						[#################         ] (68%)\r'
	MEMORY_UTIL=`free | grep Mem | awk '{print $3/$2 * 100.0}'`
	echo -ne '						[##################        ] (71%)\r'
	M=`printf "%.0f" $(free | grep Mem | awk '{print $3/$2 * 100.0}'| bc)`
	echo -ne '						[###################       ] (75%)\r'
	MEMORY_FREE=`free | grep Mem | awk '{print $4/$2 * 100.0}'`
	echo -ne '						[####################      ] (79%)\r'
	CPU_MODEL=`cat /proc/cpuinfo | grep 'model name' | cut -d ':' -f2 | sort -u`
	echo -ne '						[#####################     ] (83%)\r'
	CPU_CORE=`cat /proc/cpuinfo | grep 'processor' | cut -d ':' -f2 | wc -l`
	echo -ne '						[######################    ] (87%)\r'
	CPU_CACHE=`cat /proc/cpuinfo | grep 'cache size' | cut -d ':' -f2 | sort -u`
	echo -ne '						[#######################   ] (92%)\r'
	CPU_UTIL=`top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f\n", prefix, 100 - v }'`
	echo -ne '						[########################  ] (96%)\r'
	C=`printf "%.0f" $(echo $CPU_UTIL| bc)`
	echo -ne '						[##########################] (100%)\r'
	echo -ne '\n'
}

# Displays Generic Status like Host name, CSCF APS version, RTP status and registered subscriber count
function genStatus() {
echo
echo -e "                                               ${BLUE}${H0}${NC}"
echo -e $DRAW_LINE
echo
echo -e "	Host: "${HNAME} \(${GREEN}${NODESTATUS}${NC} node\)"							Date: ${DATE_DISP}"
echo
echo -e "	CSCF Version: ${VER2}"                                              
echo
echo -e "	APS Version: ${VER}" 
echo
if [ $COUNT -eq 10 ]; then   echo -e "	RTP is ${GREEN}UP${NC}"; else echo -e "	RTP is ${RED}DOWN${NC}"; fi
echo
if [ $NE3S -eq 7 ]; then   echo -e "	NetACT Agents are ${GREEN}UP${NC}"; else echo -e "	NetACT Agents are ${RED}DOWN${NC}"; fi
echo 
if [ $IFSTATUS -eq 0 ]; then   echo -e "	Interfaces are ${GREEN}UP${NC}"; else echo -e "	One (or more) Interface is ${RED}DOWN${NC}"; fi
if [ "$NODESTATUS" != "Secondary" ]; then
echo
if [ -z "$IMPICOUNT" ]; then   echo -e "	Currently, There are "${RED}NO ${NC}"Subscribers REGISTERED "; else echo -e "	There are "${GREEN}$IMPICOUNT ${NC}"Subscribers REGISTERED "; fi
fi
echo 
echo -e $DRAW_LINE
}

# Displays SIP & Diameter port status
function sipDiaStatus() {
if [ "$NODESTATUS" != "Secondary" ]; then
echo
echo -e "                                            ${BLUE}${H1}${NC}"
echo -e $DRAW_LINE
echo -e $PORT_DESCRIPTION
echo -e $DRAW_LINE
netstat -anpT | egrep '50[6789][01]' | egrep 'IMS_P_IpDp_Co|IMS_P_IpDp_Gm' | egrep 'tcp|udp' | sort
echo -e $DRAW_LINE
echo
echo -e "                                          ${BLUE}${H2}${NC}"
echo -e $DRAW_LINE
echo -e $PORT_DESCRIPTION
echo -e $DRAW_LINE
netstat -anpT | egrep '386[89]' | egrep 'IMS_DID0|IMS_FEE_' | sort
echo -e $DRAW_LINE
fi
}

# Displays FEE port status
function feeStatus() {
if [[ $(netstat -anpT | egrep '50[89][01]' | egrep 'IMS_P_IpDp_Co' | egrep 'tcp|udp' | sort) ]]; then
echo
echo -e "                                            ${BLUE}${H3}${NC}"
echo -e $DRAW_LINE
echo -e $PORT_DESCRIPTION
echo -e $DRAW_LINE
netstat -anpT | egrep '608[678]' | egrep 'IMS_FEE_'
echo -e $DRAW_LINE
fi
}

# Displays BGW port Status
function bgwStatus() {
if [[ $(netstat -anpT | egrep '5060' | egrep 'IMS_P_IpDp_Gm' | egrep 'tcp|udp' | sort) ]]; then
echo
echo -e "                                            ${BLUE}${H4}${NC}"
echo -e $DRAW_LINE
echo -e $PORT_DESCRIPTION1
echo -e $DRAW_LINE
netstat -anpT | grep 2944 | grep 'sctp'
echo -e $DRAW_LINE
fi
}

# Displays NTP Status
function ntpStatus() {
echo
echo -e "                                                    ${BLUE}${H5}${NC}"
echo -e $DRAW_LINE
ntpq -p
echo -e $DRAW_LINE
echo
}

# Displays Memory utilization status
function ramStatus() {
	echo -e "                                              ${BLUE}${H6}${NC}"
	echo -e $DRAW_LINE
	echo -e "	Total Memory: "${TOTAL_MEMORY}" (in GB)"
	echo -e "	Memory Used: "${USED_MEMORY}" (in GB)"
	echo -e "	Memory Free: "${FREE_MEMORY}" (in GB)"

	if (($M > $M_MEM)); then
		echo -e "	Memory Utilization:" ${RED}$(printf %.$2f ${MEMORY_UTIL})${NC}" (in %)"
	else
		echo -e "	Memory Utilization:" ${GREEN}$(printf %.$2f ${MEMORY_UTIL})${NC}" (in %)"
	fi
	echo -e "	Free Memory:" $(printf %.$2f ${MEMORY_FREE})" (in %)"
	echo -e $DRAW_LINE
}
 
# Displays CPU utilization status
function cpuStatus() {
	echo -e "                                              	${BLUE}${H9}${NC}"
	echo -e $DRAW_LINE
	echo -e "	CPU Model: ${CPU_MODEL}"
	echo -e "	Number of Cores: ${CPU_CORE}"
	echo -e "	Cache Size: ${CPU_CACHE}"
	
	if (($C > $C_CPU)); then
		echo -e "	CPU Utilization: "${RED}${CPU_UTIL}${NC}" (in %)"
	else
		echo -e "	CPU Utilization: "${GREEN}${CPU_UTIL}${NC}" (in %)"
	fi
	echo -e $DRAW_LINE
}

# Displays disk usage status
function diskStatus() {
	echo
	echo -e "                                                  ${BLUE}${H7}${NC}"
	echo -e $DRAW_LINE
	df -h | egrep 'root|TspCore|dump|Filesystem' 
	echo -e $DRAW_LINE
}

# Displays cluster status
function clusterStatus() {
	echo
	echo -e "                                                   ${BLUE}${H8}${NC}"
	echo -e $DRAW_LINE
	ClmMonShow | egrep 'UP|Running \(pid|ADDR'
	echo -e $DRAW_LINE
	echo
}
 
# Main function
function mainFunc() {
    clear
	intialization
	maniCommands
	clear
	genStatus > $HOME_DIR/$FILE_NAME
	sipDiaStatus >> $HOME_DIR/$FILE_NAME
	feeStatus >> $HOME_DIR/$FILE_NAME
	bgwStatus >> $HOME_DIR/$FILE_NAME
	ntpStatus >> $HOME_DIR/$FILE_NAME
	cpuStatus >> $HOME_DIR/$FILE_NAME
	ramStatus >> $HOME_DIR/$FILE_NAME
	diskStatus >> $HOME_DIR/$FILE_NAME
	clusterStatus >> $HOME_DIR/$FILE_NAME
	clear
	cat $HOME_DIR/$FILE_NAME
	echo
	echo
	echo -e $DRAW_LINE
	echo -e "	Please collect the health status report from ${MAGENTA}${HOME_DIR}/${FILE_NAME}${NC}"
	echo -e $DRAW_LINE
	echo
	echo
}

mainFunc




#echo -n "."
#CurrFullyRegUsersCount=`su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNTVAL ims/cscf/scscf CurrFullyRegUsersCntr | egrep 'CurrFullyRegUsersCntr=' | sed 's/[^0-9]*//g'"`
#echo -n "."
#AuthFailSumCount=`su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNTVAL ims/cscf/scscf AuthSuccSumCtr | egrep 'AuthSuccSumCtr=' | sed 's/[^0-9]*//g'"`
#echo -n "."
#AuthSuccSumCount=`su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNTVAL ims/cscf/scscf AuthFailSumCtr | egrep 'AuthFailSumCtr=' | sed 's/[^0-9]*//g'"`
#aa=$((AuthFailSumCount+AuthSuccSumCount))
#bb=$((100*$AuthFailSumCount))
#if [ $aa -ne 0 ]; then AuthFailRate=$((bb/aa)); else AuthFailRate=0; fi
#echo -e "                                      ${blue}Authentication Failure Rate (S-CSCF)${NC}"
#echo -e "${brown}==========================================================================================================================${NC}"
#echo -e "${gray}Current Fully		Total Auth		Total Auth		Auth Failure ${NC}"
#echo -e "${gray}Registered Subs		Success			Failure			Rate (%)${NC}"
#echo -e "${brown}==========================================================================================================================${NC}"
#echo -e $CurrFullyRegUsersCount"			"$AuthSuccSumCount"			"$AuthFailSumCount"			${red}"$AuthFailRate "${NC}	"	
#echo -e "${brown}==========================================================================================================================${NC}"
#echo
 netstat -anpT|grep 2944 | grep 'sctp'
tethereal -i bond0.1456
tethereal -i bond0.1457
 ping -I bond0.1456 10.253.119.41
 ping -I bond0.1457 10.253.119.45
 
imscode=`su - rtp99 -c 'AdvCfgTool.sh -noattach -e LISTCNFINST ims/common/vers' | grep Aps | cut -d '=' -f2|cut -d '.' -f1`
imscode1=$imscode".SPT"

ver1=`$ver | cut -d '.' -f1`
ver2=$ver1".SPT"

root@w0575cnicfp1a1> /opt/ims_smt/ims_smt.py --list-full | grep $ver2
INFO: Log file for this operation is present at: /opt/ims_smt/log/20141031_212855
INFO: Running version 6.351
INFO: Running on w0575cnicfp1a1 from /opt/ims_smt
IMSCL1010340.SPT.001     SP       Installed      Yes        N/A
IMSCL1010340.SPT.002     SP       Installed      Yes        N/A
IMSCL1010340.SPT.003     SP       Installed      Yes        N/A
INFO: "Partly-Done" status means "Waiting for RTP restart & post-script execution


 /opt/ims_smt/ims_smt.py --list-full | grep -i "IMSCL1010340.SPT." | grep -v "^INFO:" 
 
IMSCL1010340.SPT.003

AdvCfgTool.sh -e "MOD ims/cscf/pcscf System.AccessNetworks \"where Range='::/0' \" AccessRealm='0' CoreRealm='0' SBC='0'"
su - rtp99 -c '/opt/SMAW/INTP/bin/AdvTraceTool.sh restartProcess IMS_COMMON_PROXY* IMS_G_SRV* IMS_SRV_INM * '



echo -n "."
SipSessSetupSuccCount=`su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNTVAL ims/cscf/pcscf SipSessSetupSuccCntr| egrep 'SipSessSetupSuccCntr=' | sed 's/[^0-9]*//g'"`
echo -n "."
SipCount=`su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNTVAL ims/cscf/pcscf SipCntr3| egrep 'SipCntr3=' | sed 's/[^0-9]*//g'"`
echo -n "."
if [ $SipCount != 0 ]; then ee=$((SipSessSetupSuccCount/SipCount)); else ee=0; fi
CallFailureRate=$((100 *(1-($ee)))) 

echo -e "                                      ${blue}Call Failure Rate (P-CSCF)${NC}"
echo -e "${brown}======================================================================================================================${NC}"
echo -e "${gray}Successful INVITE               Total Call              Call Failure ${NC}"
echo -e "${gray}Dialogs                         Attempts                Rate (%)${NC}"
echo -e "${brown}======================================================================================================================${NC}"
echo -e $SipSessSetupSuccCount"                               "$SipCount"                ${red}"$CallFailureRate	"${NC}"
echo -e "${brown}======================================================================================================================${NC}"
echo

root@w0575cnicfp1a1> ./status.sh
Tue Nov 25 22:42:32 UTC 2014














                                                        Generating report...
                                                [##########################] (100%)

                                               General Status
--------------------------------------------------------------------------------------------------------------------------

        Host: w0575cnicfp1a1 (Primary node)                                                     Date: 11-25-14

        CSCF Version: 10103.40000

        APS Version: IMSCL1010340.000

        RTP is UP

        NetACT Agents are UP

        Interfaces are UP

        There are 40 Subscribers REGISTERED

--------------------------------------------------------------------------------------------------------------------------

                                            SIP Connection Status
--------------------------------------------------------------------------------------------------------------------------
Protocol Source IP Destination IP Status Process Name
--------------------------------------------------------------------------------------------------------------------------
tcp        0      0 ::ffff:10.253.145.8:43193   ::ffff:10.253.147.197:5070  ESTABLISHED 21110/IMS_P_IpDp_Co
tcp        0      0 ::ffff:10.253.145.8:43544   ::ffff:10.253.4.172:5060    ESTABLISHED 21110/IMS_P_IpDp_Co
tcp        0      0 ::ffff:10.253.145.8:43586   ::ffff:10.253.4.172:5060    ESTABLISHED 21110/IMS_P_IpDp_Co
tcp        0      0 ::ffff:10.253.145.8:5080    :::*                        LISTEN      21110/IMS_P_IpDp_Co
tcp        0      0 ::ffff:10.253.145.8:5081    :::*                        LISTEN      21110/IMS_P_IpDp_Co
tcp        0      0 ::ffff:10.253.145.8:5090    ::ffff:10.253.145.4:43808   ESTABLISHED 21110/IMS_P_IpDp_Co
tcp        0      0 ::ffff:10.253.145.8:5090    ::ffff:10.253.147.197:47518 ESTABLISHED 21110/IMS_P_IpDp_Co
tcp        0      0 ::ffff:10.253.145.8:5090    :::*                        LISTEN      21110/IMS_P_IpDp_Co
tcp        0      0 ::ffff:10.253.145.8:5091    :::*                        LISTEN      21110/IMS_P_IpDp_Co
udp        0      0 ::ffff:10.253.145.8:5080    :::*                                    21110/IMS_P_IpDp_Co
udp        0      0 ::ffff:10.253.145.8:5081    :::*                                    21110/IMS_P_IpDp_Co
udp        0      0 ::ffff:10.253.145.8:5090    :::*                                    21110/IMS_P_IpDp_Co
udp        0      0 ::ffff:10.253.145.8:5091    :::*                                    21110/IMS_P_IpDp_Co
--------------------------------------------------------------------------------------------------------------------------

                                          Diameter Connection Status
--------------------------------------------------------------------------------------------------------------------------
Protocol Source IP Destination IP Status Process Name
--------------------------------------------------------------------------------------------------------------------------
sctp       0      0 10.253.145.8:51392          10.253.33.196:3868          ESTABLISHED 21235/IMS_DID01
sctp       0      0 10.253.145.8:51393          10.253.39.100:3868          ESTABLISHED 21235/IMS_DID01
tcp        0      0 ::ffff:10.253.145.8:3869    :::*                        LISTEN      17802/IMS_FEE_3_257
--------------------------------------------------------------------------------------------------------------------------

                                            FEE Connection Status
--------------------------------------------------------------------------------------------------------------------------
Protocol Source IP Destination IP Status Process Name
--------------------------------------------------------------------------------------------------------------------------
tcp        0      0 ::ffff:10.253.145.8:6086    :::*                        LISTEN      17797/IMS_FEE_1_257
tcp        0      0 ::ffff:10.253.145.8:6087    :::*                        LISTEN      17800/IMS_FEE_2_257
tcp        0      0 ::ffff:10.253.145.8:6088    :::*                        LISTEN      17802/IMS_FEE_3_257
udp        0      0 ::ffff:10.253.145.8:6086    :::*                                    17797/IMS_FEE_1_257
udp        0      0 ::ffff:10.253.145.8:6087    :::*                                    17800/IMS_FEE_2_257
udp        0      0 ::ffff:10.253.145.8:6088    :::*                                    17802/IMS_FEE_3_257
--------------------------------------------------------------------------------------------------------------------------

                                                    NTP Status
--------------------------------------------------------------------------------------------------------------------------
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
 LOCAL(0)        .LOCL.           6 l    2   64  377    0.000    0.000   0.000
*10.200.203.254  172.25.155.225   2 u  517 1024  377    0.198   -0.511   0.045
+172.25.155.225  .GPS.            1 u  401 1024  377    2.726   -0.669   0.179
+172.25.166.66   .GPS.            1 u  451 1024  377    8.848   -0.767   0.445
--------------------------------------------------------------------------------------------------------------------------

                                                CPU Status
--------------------------------------------------------------------------------------------------------------------------
        CPU Model:  Intel(R) Xeon(R) CPU           L5638  @ 2.00GHz
        Number of Cores: 6
        Cache Size:  12288 KB
        CPU Utilization: 2.3 (in %)
--------------------------------------------------------------------------------------------------------------------------
                                              Memory Information
--------------------------------------------------------------------------------------------------------------------------
        Total Memory: 47.1293 (in GB)
        Memory Used: 45.8987 (in GB)
        Memory Free: 1.23054 (in GB)
        Memory Utilization: 97 (in %)
        Free Memory: 3 (in %)
--------------------------------------------------------------------------------------------------------------------------

                                                  Disk Information
--------------------------------------------------------------------------------------------------------------------------
Filesystem                       Size  Used Avail Use% Mounted on
/dev/mapper/vg00-root            6.0G  3.4G  2.3G  61% /
/dev/mapper/vg00-TspCore         7.9G  146M  7.4G   2% /TspCore
/dev/mapper/vg00-dump            7.9G  929M  6.6G  13% /dump
--------------------------------------------------------------------------------------------------------------------------

                                                   Cluster Status
--------------------------------------------------------------------------------------------------------------------------
      NODE NODENAME        REV                                       IP ADDR LAST HEARD    STATUS      TSP   SPLIT-BRAIN
         0 Q-Server          0                                10.253.148.125     1s ago        UP      N/A   -
     [*] 1 w0575cnicfp1a1    0                                  10.253.148.8      never        UP      N/A   -
         2 w0575cnicfp1a2    0                                 10.253.148.10        now        UP      N/A   -
   ClmMond process                               : Running (pid 16146)
--------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------
        Please collect the health status report from /tmp/w0575cnicfp1a1_Health_Status_Report_11-25-14.txt
--------------------------------------------------------------------------------------------------------------------------


root@w0575cnicfp1a1>
