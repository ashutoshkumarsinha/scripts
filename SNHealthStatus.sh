#!/usr/bin/sh
##############################################################
# Nokia Networks (c) 2014, All rights reserved               #
#                                                            #
# CSCF Health Check Script v1.0                              #
#                                                            #
# Author:  Ashutosh Kumar Sinha                              #
#                                                            #
# History: Ashutosh Kumar Sinha  11.25.2014 - First Issue    #
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
UNAME=`whoami`
DATE_DISP=`date +'%m-%d-%y'`

# Configuration parameters
HOME_DIR="/tmp"
M_MEM="90"
C_CPU="60"
COUNTD="10"
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
DRAW_LINE="${brown}--------------------------------------------------------------------------------------------------------------------------${NC}"
MESSAGE1="\tPlease collect the health status report from ${MAGENTA}${HOME_DIR}/${FILE_NAME}${NC}"
ABORT1="\t${RED}Script execution cancelled....${NC}"
ABORT2="${GRAY}This script should be executed as root user. You are trying to execute it as ${UNAME} user.${NC}"
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
	IMPICOUNT=`su - rtp99 -c "reganalyser.sh -l IMPI --role scscf | egrep 'Active IMPIs' | sed 's/[^0-9]*//g'"`
	echo -ne '						[############              ] (49%)\r'
	VER=`su - rtp99 -c 'AdvCfgTool.sh -noattach -e LISTCNFINST ims/common/vers' | grep Aps | cut -d '=' -f2 | sort -u`
	echo -ne '						[#############             ] (52%)\r'
	VER2=`cat /opt/SMAW/INTP/descriptors/installstate* | grep IMSPversc | cut -d ' ' -f2 | sort -u` 
	echo -ne '						[##############            ] (55%)\r'
	TOTAL_MEMORY=`free | grep Mem | awk '{print $2/1024/1024}'`
	echo -ne '						[###############           ] (59%)\r'
	FREE_MEMORY=`free |grep "buffers/cache"| awk '{print $4/1024/1024}'`
	echo -ne '						[################          ] (63%)\r'
	USED_MEMORY=`free |grep "buffers/cache"| awk '{print $3/1024/1024}'`
	echo -ne '						[#################         ] (68%)\r'
	MEMORY_UTIL=$(echo "$USED_MEMORY/$TOTAL_MEMORY*100.0" | bc -l)
	echo -ne '						[##################        ] (71%)\r'
	MEMORY_FREE=$(echo "$FREE_MEMORY/$TOTAL_MEMORY*100.0" | bc -l)
	echo -ne '						[###################       ] (75%)\r'
	M=`printf "%.0f" $(echo "$USED_MEMORY/$TOTAL_MEMORY*100.0" | bc -l)`
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
printf "${GREY}Protocol%12sSource IP%19sDestination IP%14sStatus%6sProcess Name${NC}\n"
echo -e $DRAW_LINE
netstat -anpT | egrep '50[6789][01]' | egrep 'IMS_P_IpDp_Co|IMS_P_IpDp_Gm' | egrep 'tcp|udp' | sort
echo -e $DRAW_LINE
echo
echo -e "                                          ${BLUE}${H2}${NC}"
echo -e $DRAW_LINE
printf "${GREY}Protocol%12sSource IP%19sDestination IP%14sStatus%6sProcess Name${NC}\n"
echo -e $DRAW_LINE
netstat -anpT | egrep '386[89]' | egrep 'IMS_DID0|IMS_FEE_' | sort
echo -e $DRAW_LINE
fi
}

# Displays FEE port status
function feeStatus() {
echo
echo -e "                                            ${BLUE}${H3}${NC}"
echo -e $DRAW_LINE
printf "${GREY}Protocol%12sSource IP%19sDestination IP%14sStatus%6sProcess Name${NC}\n"
echo -e $DRAW_LINE
netstat -anpT | egrep '608[678]' | egrep 'IMS_FEE_'
echo -e $DRAW_LINE
}

# Displays BGF port Status
function bgwStatus() {
echo
echo -e "                                            ${BLUE}${H4}${NC}"
echo -e $DRAW_LINE
printf "${GREY}Protocol%12sSource IP%19sDestination IP%14sStatus${NC}\n"
echo -e $DRAW_LINE
netstat -anpT | grep 2944 | grep 'sctp'
echo -e $DRAW_LINE
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
	if [ $UNAME != "root" ]; then
		echo -e $ABORT1
		echo -e $ABORT2
		exit
	else
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
		echo -e $MESSAGE1
		echo -e $DRAW_LINE
		echo
		echo
	fi
}

mainFunc