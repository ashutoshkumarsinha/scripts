#!/usr/bin/sh
##############################################################
# Nokia Networks (c) 2014, All rights reserved               #
#                                                            #
# Config Display Script v1.0                                 #
#                                                            #
# Author:  Ashutosh Kumar Sinha                              #
#                                                            #
# History: Ashutosh Kumar       12.12.2014 - First Issue     #
#                                                            #
##############################################################

# Parameter Initialization
function intialization() {

	# Colour definition
	RED='\e[1;31m';
	GREEN='\e[1;32m';
	BLUE='\e[1;34m';
	GRAY='\e[1;37m';
	BROWN='\e[1;33m';
	MAGENTA='\e[1;35m';
	NC='\e[0m';

	# Constant definition
	HNAME=`hostname`;
	UNAME=`whoami`;
	COUNTD="10";
	DATE_DISP=`date +'%m-%d-%y'`;
	A_OPT="1";
	B_OPT="2";
	C_OPT="3";
	D_OPT="4";
	E_OPT="5";
	F_OPT="6";
	G_OPT="7";
	Q_OPT="8";

	# Configuration parameters
	HOME_DIR="/tmp";
	F1="diameterconnections";
	F2="diameterrealms";
	F3="tableofscscf";
	F4="aspool";
	F5="asresource";
	F6="iproutes";
	F7="dynamiciproutes";
	F8="name";
	H1="DIAMETER CONNECTIONS TABLE";
	H2="DIAMETER REALMS TABLE";
	H3="TABLE OF S-CSCF CAPABILITIES";
	H4="AS POOL TABLE";
	H5="AS RESOURCES TABLE";
	H6="IP CLUSTER ROUTING TABLE";
	H7="DYNAMIC IP CLUSTER ROUTING TABLE";
	H8="TABLE"
	DRAW_LINE1="${brown}-------------------------------------------------------------------------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE2="${brown}------------------------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE3="${brown}-------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE4="${brown}-------------------------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE5="${brown}---------------------------------------------------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE6="${brown}------------------------------------------------------------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE7="${brown}-----------------------------------------------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE8="${brown}-----------------------------------------------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE11="%10s -------------------------------------------------------------------------------- \n";
	DRAW_LINE12="%10s ----------------------- CSCF Config Table Display Script ----------------------- \n";
	TEXT1="%14s Please select the appropriate option from below: \n";
	TEXT2="%17s A. Display Diameter Config \n";
	TEXT3="%17s B. Display IP Routing Config \n";
	TEXT4="%17s C. Display Table of S-CSCF Capabilities \n";
	TEXT5="%17s D. Display Application Server Config \n";
	TEXT6="%17s E. Display  \n";
	TEXT7="%17s F. Display  \n";
	TEXT8="%17s G. Display  \n";
	TEXT9="%17s Q. Quit \n";
	ABORT1="\t${RED}Script execution cancelled....${NC} \n";
	ABORT2="${GRAY}This script should be executed as root user. You are trying to execute it as ${UNAME} user.${NC} \n";
	MESSAGE1=" Press any key to continue...";
}

# Command Execution
function execCommands() {
	while [  $COUNTD -gt 1 ]; do
        echo -e "\n"
        let COUNTD=COUNTD-1
    done
	echo -e  '							Gathering data...';
	echo -ne '						[##                        ] (3%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/common/diameterdisp  Connections"  | cut -d. -f2- > $HOME_DIR/$F1;
	echo -ne '						[#####                     ] (17%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/common/diameterdisp Realms"  | cut -d. -f2- > $HOME_DIR/$F2;
	echo -ne '						[########                  ] (38%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/icscf System.TableOfScscfs"  | cut -d. -f2- | cut -d. -f2- > $HOME_DIR/$F3;
	echo -ne '						[#############             ] (52%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/scscf ResourceManagement.ASPool " | cut -d. -f3- > $HOME_DIR/$F4;
	echo -ne '						[################          ] (63%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/scscf ResourceManagement.ASResource" | cut -d. -f3- > $HOME_DIR/$F5;
	echo -ne '						[##################        ] (71%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST platform/cframe IP_CLUSTER_ROUTING" | cut -d. -f2- > $HOME_DIR/$F6;
	echo -ne '						[#####################     ] (83%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST platform/cframe IP_DYNAMIC_ROUTING" | cut -d. -f2- > $HOME_DIR/$F7;
	echo -ne '						[#######################   ] (92%)\r'
	#su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/scscf " | cut -d. -f2- > $HOME_DIR/$F8;
	echo -ne '						[##########################] (100%)\r'
	echo -ne '\n'
}

# Displays Diameter Connections Table
function diaConTable() {
	echo
	echo -e "\t\t\t\t\t\t\t\t ${BLUE}${H1}${NC}"
	flag="true";

	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE1";
			printf "%-17s %-25s \t\t %-30s %-17s %-29s %-17s %-17s \t\n" "CONNECTION ID" "SOURCE HOSTNAME" "SOURCE ADDRESS" "SOURCE REALM" "DESTINATION ADDRESS" "CONNECTION TYPE" "CONNECTION KIND";
			echo -e "$DRAW_LINE1";
		fi
		test=`echo $line | cut -d= -f1`;
 		if [ "$test" == "ConnectionID" ]; then ConnectionID=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "LogicalName" ]; then LogicalName=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "SourceAddress" ]; then SourceAddress=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "SourceHostname" ]; then SourceHostname=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "SourceRealm" ]; then SourceRealm=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "PreferredAddressType" ]; then PreferredAddressType=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "DestinationAddress" ]; then DestinationAddress=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "Port" ]; then Port=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "ConnectionType" ]; then ConnectionType=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "ConnectionKind" ]; then ConnectionKind=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "Watchdog" ]; then Watchdog=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "Reconnect" ]; then Reconnect=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "SourceSecAddress" ]; then SourceSecAddress=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "SourceSecAddress" ]; then
			printf "%-17s %-25s \t %-30s %-17s %-29s %-17s %-17s \t\n" $ConnectionID $SourceHostname $SourceAddress $SourceRealm $DestinationAddress $ConnectionType $ConnectionKind;
		fi
	done < $HOME_DIR/$F1;
	echo -e "$DRAW_LINE1";
	echo
	echo
}

# Displays Diameter Realm Table
function diaRealmsTable() {
	echo
	echo -e "\t\t\t\t\t\t ${BLUE}${H2}${NC}"
	flag="true";

	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE2";
			printf "%-20s %-25s %-17s %-30s %-17s %-17s \t\n" "REALM ID" "REALM" "INTERFACE ID" "SERVER" "PRIORITY" "WEIGHT";
			echo -e "$DRAW_LINE2";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "RealmID" ]; then RealmID=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "Realm" ]; then Realm=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "InterfaceID" ]; then InterfaceID=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "Server" ]; then Server=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "Priority" ]; then Priority=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "Weight" ]; then Weight=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "Weight" ]; then
			printf "%-20s %-25s %-17s %-30s %-17s %-17s \t\n" $RealmID $Realm $InterfaceID $Server $Priority $Weight;
		fi
	done < $HOME_DIR/$F2;
	echo -e "$DRAW_LINE2";
	echo
	echo
	read -e -p "$MESSAGE1" OPT2
	displayMenu
}

# Displays Table of S-CSCF Capabilities
function tableOfSCSCF() {
	echo
	echo -e "\t\t\t\t\t ${BLUE}${H3}${NC}"
	flag="true";
	while read line;
	do
	if [ "$flag" == "true" ]; then
		flag="false";
		echo -e "$DRAW_LINE3";
		printf "%-52s %-15s %-15s %-16s \t\n" "SCSCF NAME" "PRIORITY" "WEIGHT" "SCSCF CAPABILITIES";
		echo -e "$DRAW_LINE3";
	fi
	test=`echo $line | cut -d= -f1`;
	if [ "$test" == "ScscfName" ]; then ScscfName=`echo $line | cut -d= -f2-`; fi
	if [ "$test" == "ScscfCapabilities" ]; then ScscfCapabilities=`echo $line | cut -d= -f2-`; fi
	if [ "$test" == "ScscfPriority" ]; then ScscfPriority=`echo $line | cut -d= -f2-`; fi
	if [ "$test" == "ScscfWeight" ]; then ScscfWeight=`echo $line | cut -d= -f2-`; fi
	if [ "$test" == "ScscfWeight" ]; then
		printf "%-52s %-15s %-15s %s " $ScscfName  $ScscfPriority $ScscfWeight;
		echo -e $ScscfCapabilities
	fi
	done < $HOME_DIR/$F3;
	echo -e "$DRAW_LINE3";
	echo
	echo
	read -e -p "$MESSAGE1" OPT2
	displayMenu
}

# Displays AS Pool Table
function asPoolTable() {
	echo
	echo -e "\t\t\t\t\t\t ${BLUE}${H4}${NC}"
	flag="true";
	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE4";
			printf "%-20s %-15s %-20s %-20s %-23s %-20s \t\n" "POOL NAME" "POOL TYPE" "FAILURE RESP TYPE" "FAILURE THRESHOLD" "INACTIVE REVOKE TIMER" "FAILBACK BEHAVIOUR";
			echo -e "$DRAW_LINE4";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "PoolName" ]; then Name=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "PoolType" ]; then Type=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "FailResponseType" ]; then FailResp=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "FailureThreshold" ]; then FailThr=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "InactiveRevokeTimer" ]; then InactTime=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "FailbackBehavior" ]; then FailbackBehavior=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "FailbackBehavior" ]; then
			printf "%-20s %-15s %-20s %-20s %-23s %-20s \t\n" $Name $Type $FailResp $FailThr $InactTime $FailbackBehavior;
		fi
	done < $HOME_DIR/$F4;
	echo -e "$DRAW_LINE4";
	echo
	echo
}

# Displays AS Resource Table
function asResourceTable() {
	echo
	echo -e "\t\t\t\t\t\t\t\t ${BLUE}${H5}${NC}"
	flag="true";
	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE5";
			printf "%-15s %-80s %-20s %-20s %-20s \t\n" "POOL NAME" "ADDRESS" "PRIORITY" "WEIGHT" "STATE";
			echo -e "$DRAW_LINE5";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "PoolName" ]; then PoolName=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "Address" ]; then Address=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "Priority" ]; then Priority=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "Weight" ]; then Weight=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "State" ]; then State=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "State" ]; then
			printf "%-15s %-80s %-20s %-20s %-20s \t\n" $PoolName $Address $Priority $Weight $State;
		fi
	done < $HOME_DIR/$F5;
	echo -e "$DRAW_LINE5";
	echo
	echo
	read -e -p "$MESSAGE1" OPT2
	displayMenu
}

# Displays IP Cluster Routing Table
function ipClusterRoutingTable() {
	echo
	echo -e "\t\t\t\t\t\t ${BLUE}${H6}${NC}"
	flag="true";
	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE6";
			printf "%-35s %-15s %-35s %-20s %-40s \t\n" "DESTINATION" "NETMASK" "GATEWAY" "DEVICE" "DESCRIPTION";
			echo -e "$DRAW_LINE6";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "DESTINATION" ]; then Destination=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "NETMASK" ]; then Netmask=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "GATEWAY" ]; then Gateway=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "DEVICE" ]; then Device=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "DESCRIPTION" ]; then Description=`echo $line | cut -d= -f2`; fi
		if [ "$test" == "DESCRIPTION" ]; then
			printf "%-35s %-15s %-35s %-20s" $Destination $Netmask $Gateway $Device;
			echo -e $Description;
		fi
	done < $HOME_DIR/$F6;
	echo -e "$DRAW_LINE6";
	echo
	echo
}

# Displays Dynamic IP Cluster Routing Table
function DynIpClusterRoutingTable() {
	echo
	echo -e "\t\t\t\t\t\t ${BLUE}${H7}${NC}"
	flag="true";
	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE7";
			printf "%-15s %-10s %-15s %-15s %-15s %-15s %-40s \t\n" "DESTINATION" "NODE ID" "NETMASK" "SOURCE" "GATEWAY" "DEVICE" "DESCRIPTION";
			echo -e "$DRAW_LINE7";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "DESTINATION" ]; then Destination=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "NODE_ID" ]; then Node=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "NETMASK" ]; then Netmask=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "SOURCE" ]; then Source=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "GATEWAY" ]; then Gateway=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "DEVICE" ]; then Device=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "DESCRIPTION" ]; then Description=`echo $line | cut -d= -f2`; fi
		if [ "$test" == "DESCRIPTION" ]; then
				printf "%-15s %-10s %-15s %-15s %-15s %-15s " $Destination $Node $Netmask $Source $Gateway $Device;
				echo -e $Description;
		fi
		done < $HOME_DIR/$F7;
		echo -e "$DRAW_LINE7";
		echo
		echo
		read -e -p "$MESSAGE1" OPT2
		displayMenu
}

# Cleanup
function cleanup() {
	cd $HOME_DIR
	rm -f $F1;
	rm -f $F2;
	rm -f $F3;
	rm -f $F4;
	rm -f $F5;
	rm -f $F6;
	rm -f $F7;
	rm -f $F8;
}

# Display Menu
function displayMenu() {
		clear
		echo
		printf "$DRAW_LINE11";
		printf "$DRAW_LINE12";
		printf "$DRAW_LINE11";
		echo
		echo
		printf "$TEXT1";
		printf "$TEXT2";
		printf "$TEXT3";
		printf "$TEXT4";
		printf "$TEXT5";
		printf "$TEXT6";
		printf "$TEXT7";
		printf "$TEXT8";
		printf "$TEXT9";
		echo
		read -e -p "		  Enter option [A|B|C|D|E|F|G|Q]: " OPTI

		finish="-1"
		while [ "$finish" = '-1' ]
		do
			finish="1"
				case $OPTI in
					a | A ) OPTI="1";;
					b | B ) OPTI="2";;
					c | C ) OPTI="3";;
					d | D ) OPTI="4";;
					e | E ) OPTI="5";;
					f | F ) OPTI="6";;
					g | G ) OPTI="7";;
					q | Q ) OPTI="8";;
					*) finish="-1";
					read -e -p "		  Invalid response; Please reenter option [A|B|C|D|E|F|G|Q]: " OPTI;;
		        esac
		done

		if [ "$OPTI" = "$A_OPT" ]; then
			clear
			diaConTable
			diaRealmsTable
		elif [ "$OPTI" = "$B_OPT" ]; then
			clear
			ipClusterRoutingTable
			DynIpClusterRoutingTable
		elif [ "$OPTI" = "$C_OPT" ]; then
			clear
			tableOfSCSCF
		elif [ "$OPTI" = "$D_OPT" ]; then
			clear
			asPoolTable
			asResourceTable
		elif [ "$OPTI" = "$E_OPT" ]; then
			clear

		elif [ "$OPTI" = "$F_OPT" ]; then
			clear

		elif [ "$OPTI" = "$G_OPT" ]; then
			clear

		elif [ "$OPTI" = "$Q_OPT" ]; then
			cleanup
			clear
			exit
		fi
}

# Main Function
function mainFunc() {
    clear
    cleanup
	intialization
	if [ $UNAME != "root" ]; then
		clear
		printf $ABORT1;
		printf $ABORT2;
		exit
	else
		clear
		execCommands
		displayMenu
	fi
}

mainFunc
