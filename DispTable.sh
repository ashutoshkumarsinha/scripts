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
	F8="sharedifc";
	F9="mwconn";
	F10="bgw";
	F11="profile";
	F12="realmtobgw";
	F13="dscppolicing";
	F14="realm";
	F15="gqfeatureselection";
	F16="pdflist";
	F17="pdfpcrf";
	F18="codecbandwidthlist";
	F19="acessnetwork";
	F20="ipinterface";
	
	H1="DIAMETER CONNECTIONS TABLE";
	H2="DIAMETER REALMS TABLE";
	H3="TABLE OF S-CSCF CAPABILITIES";
	H4="AS POOL TABLE";
	H5="AS RESOURCES TABLE";
	H6="IP CLUSTER ROUTING TABLE";
	H7="DYNAMIC IP CLUSTER ROUTING TABLE";
	H8="SHARED iFC TABLE";
	H9="Mw INTERFACE CONNECTIVITY TABLE";
	H10="REALM TABLE";
	H11="BGW TABLE";
	H12="PROFILE TABLE";
	H13="REALM TO BGW TABLE";
	H14="DSCP POLICING TABLE";
	H15="Gq FEATURE SELECTION TABLE";
	H16="PDF LIST";
	H17="PDF PCRF TABLE";
	H18="CODEC BANDWIDTH LIST";
	H19="ACCESS NETWORK TABLE";
	H20="INTERFACE Source IP Address"
	DRAW_LINE1="${brown}-------------------------------------------------------------------------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE2="${brown}------------------------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE3="${brown}-------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE4="${brown}-------------------------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE5="${brown}---------------------------------------------------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE6="${brown}------------------------------------------------------------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE7="${brown}-----------------------------------------------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE8="${brown}-----------------------------------------------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE9="${brown}----------------------------------${NC}";
	DRAW_LINE10="${brown}-----------------${NC}";
	DRAW_LINE13="${brown}------------------------------------------------------------------------------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE14="${brown}-------------------------------------------------------------------------------------${NC}";
	DRAW_LINE15="${brown}-----------------------------------------------------------------------${NC}";
	DRAW_LINE16="${brown}-------------------------------------------------------------------------${NC}";
	DRAW_LINE17="${brown}----------------------${NC}";
	DRAW_LINE18="${brown}---------------------------------------------------------------------------------------------------------------------------------------------------------------${NC}";
	DRAW_LINE11="%10s -------------------------------------------------------------------------------- \n";
	DRAW_LINE12="%10s ----------------------- CSCF Config Table Display Script ----------------------- \n";
	TEXT1="%14s Please select the appropriate option from below: \n";
	TEXT2="%17s A. Display Diameter Config \n";
	TEXT3="%17s B. Display IP Routing Config \n";
	TEXT4="%17s C. Display Table of S-CSCF Capabilities \n";
	TEXT5="%17s D. Display Application Server Config \n";
	TEXT6="%17s E. Display BGW Config \n";
	TEXT7="%17s F. Display PCRF Config \n";
	TEXT8="%17s G. Display Interface Source IP address Config \n";
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
	echo -ne '						[#                         ] (3%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/common/diameterdisp  Connections"  | cut -d. -f2- > $HOME_DIR/$F1;
	echo -ne '						[##                        ] (6%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/common/diameterdisp Realms"  | cut -d. -f2- > $HOME_DIR/$F2;
	echo -ne '						[###                       ] (10%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/icscf System.TableOfScscfs"  | cut -d. -f2- | cut -d. -f2- > $HOME_DIR/$F3;
	echo -ne '						[####                      ] (13%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/scscf ResourceManagement.ASPool " | cut -d. -f3- > $HOME_DIR/$F4;
	echo -ne '						[#####                     ] (17%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/scscf ResourceManagement.ASResource" | cut -d. -f3- > $HOME_DIR/$F5;
	echo -ne '						[######                    ] (21%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST platform/cframe IP_CLUSTER_ROUTING" | cut -d. -f2- > $HOME_DIR/$F6;
	echo -ne '						[#######                   ] (26%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST platform/cframe IP_DYNAMIC_ROUTING" | cut -d. -f2- > $HOME_DIR/$F7;
	echo -ne '						[########                  ] (32%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/scscf ServiceProfile.SharediFCList" | cut -d. -f2- | cut -d. -f2- > $HOME_DIR/$F8;
	echo -ne '						[#########                 ] (37%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/bgcf System.Connectivity" | cut -d. -f2- | cut -d. -f2- > $HOME_DIR/$F9;
	echo -ne '						[##########                ] (42%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/icscf System.Connectivity" | cut -d. -f2- | cut -d. -f2->> $HOME_DIR/$F9;
	echo -ne '						[###########               ] (47%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/scscf System.Connectivity" | cut -d. -f2- | cut -d. -f2- >> $HOME_DIR/$F9;
	echo -ne '						[############              ] (53%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/bc PDFSupport.BGWTable" | cut -d. -f2- | cut -d. -f2- >> $HOME_DIR/$F10;
	echo -ne '						[#############             ] (59%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/bc PDFSupport.H248Profiles" | cut -d. -f2- | cut -d. -f2- >> $HOME_DIR/$F11;
	echo -ne '						[##############            ] (64%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/bc PDFSupport.RealmToBGW" | cut -d. -f2- | cut -d. -f2- >> $HOME_DIR/$F12;
	echo -ne '						[###############           ] (68%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/bc PDFSupport.DSCPPolicing" | cut -d. -f2- | cut -d. -f2- >> $HOME_DIR/$F13;
	echo -ne '						[################          ] (70%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/bc PDFSupport.Realms" | cut -d. -f2- | cut -d. -f2- >> $HOME_DIR/$F14;
	echo -ne '						[#################         ] (73%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/pcscf PDFSupport.GqFeatureSelection" | cut -d. -f2- | cut -d. -f2- >> $HOME_DIR/$F15;
	echo -ne '						[##################        ] (77%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/pcscf PDFSupport.PDFList" | cut -d. -f2- | cut -d. -f2- >> $HOME_DIR/$F16;
	echo -ne '						[###################       ] (80%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/pcscf PDFSupport.PdfPcrf" | cut -d. -f2- | cut -d. -f2- >> $HOME_DIR/$F17;
	echo -ne '						[####################      ] (83%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/pcscf PDFSupport.CodecBandwidthList" | cut -d. -f2- | cut -d. -f2- >> $HOME_DIR/$F18;
	echo -ne '						[#####################     ] (87%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/cscf/pcscf System.AccessNetworks" | cut -d. -f2- | cut -d. -f2- >> $HOME_DIR/$F19;
	echo -ne '						[######################    ] (90%)\r'
	su - rtp99 -c "AdvCfgTool.sh -noattach -e LISTCNFINST ims/common/imslb  System.IPAddresses"   | cut -d. -f2- | cut -d. -f2- > $HOME_DIR/$F20;

	echo -ne '						[#######################   ] (92%)\r'
	echo -ne '						[########################  ] (95%)\r'
	echo -ne '						[######################### ] (97%)\r'
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
	echo -e "\t\t\t\t ${BLUE}${H3}${NC}"
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
}

# Displays Mw Interface System Connectivity Table
function mwSysConnTable() {
	echo
	echo -e "\t\t\t\t ${BLUE}${H9}${NC}"
	flag="true";
	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE3";
			printf "%-17s %-25s %-25s %-20s \t\n" "INTERFACE NAME" "HOSTNAME" "GENERIC HOSTNAME" "DOMAIN NAME";
			echo -e "$DRAW_LINE3";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "ConnectivityName" ]; then ConnectivityName=`echo $line | cut -d= -f2-`; fi
			if [ "$test" == "HostName" ]; then HostName=`echo $line | cut -d= -f2-`; fi
				if [ "$test" == "GenericHostName" ]; then GenericHostName=`echo $line | cut -d= -f2-`; fi
					if [ "$test" == "DomainName" ]; then DomainName=`echo $line | cut -d= -f2-`; fi
						if [ "$test" == "DomainName" ]; then
							printf "%-17s %-25s %-25s %-20s \t\n" $ConnectivityName  $HostName $GenericHostName $DomainName;
						fi
					done < $HOME_DIR/$F9;
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
			printf "%-15s %-20s %-20s %-20s %-80s \t\n" "POOL NAME" "PRIORITY" "WEIGHT" "STATE" "ADDRESS";
			echo -e "$DRAW_LINE5";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "PoolName" ]; then PoolName=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "Address" ]; then Address=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "Priority" ]; then Priority=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "Weight" ]; then Weight=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "State" ]; then State=`echo $line | cut -d= -f2-`; fi
		if [ "$test" == "State" ]; then
			printf "%-15s %-20s %-20s %-20s %-80s \t\n" $PoolName $Priority $Weight $State $Address;
		fi
	done < $HOME_DIR/$F5;
	echo -e "$DRAW_LINE5";
	echo
	echo
	read -e -p "$MESSAGE1" OPT2
	displayMenu
}

# Displays Shared iFC Table
function sharedIFCTable() {
	echo
	echo -e "\t\t\t\t\t\t\t\t ${BLUE}${H8}${NC}"
	flag="true";
	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE8";
			printf "%-10s %-11s %-19s %-18s %-19s %-25s %-13s \t\n" "SiFC ID" "PRIORITY" "DEFAULT HANDLING" "INCLUDE REG REQ" "INCLUDE REG RESP" "SERVICE INFO" "AS ADDRESS";
			echo -e "$DRAW_LINE8";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "SharediFCID" ]; then SharediFCID=`echo $line | cut -d= -f2-`; fi
			if [ "$test" == "Priority" ]; then Priority=`echo $line | cut -d= -f2-`; fi
				if [ "$test" == "ApplServerAddress" ]; then ApplServerAddress=`echo $line | cut -d= -f2-`; fi
					if [ "$test" == "TriggerPoints" ]; then TriggerPoints=`echo $line | cut -d= -f2-`; fi
						if [ "$test" == "DefaultHandling" ]; then DefaultHandling=`echo $line | cut -d= -f2-`; fi
							if [ "$test" == "ServiceInformation" ]; then ServiceInformation=`echo $line | cut -d= -f2-`; fi
								if [ "$test" == "IncludeRegisterRequest" ]; then IncludeRegisterRequest=`echo $line | cut -d= -f2-`; fi
									if [ "$test" == "IncludeRegisterResponse" ]; then IncludeRegisterResponse=`echo $line | cut -d= -f2-`; fi
										if [ "$test" == "IncludeRegisterResponse" ]; then
								printf "%-10s %-11s %-19s %-18s %-19s %-25s %-13s \t\n" $SharediFCID $Priority $DefaultHandling $IncludeRegisterRequest $IncludeRegisterResponse $ServiceInformation $ApplServerAddress;
							fi
						done < $HOME_DIR/$F8;
						echo -e "$DRAW_LINE8";
						echo
						echo
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

# Displays Realm Table
function realmTable() {
	echo
	echo -e "\t\t\t\t\t\t\t\t ${BLUE}${H10}${NC}"
	flag="true";
	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE13";
			printf "%-11s %-17s %-17s %-24s %-24s %-20s %-15s %-15s %-11s %-15s \t\n" "REALM ID" "REALM NAME" "INTERFACE NAME" "SOURCE ADDR FILTERING" "SOURCE PORT FILTERING" "RATE LIMITATION" "DSCP CONTROL" "REALM TYPE" "GROUP ID" "IP REALM ID";
			echo -e "$DRAW_LINE13";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "RealmId" ]; then RealmId=`echo $line | cut -d= -f2-`; fi
			if [ "$test" == "RealmName" ]; then RealmName=`echo $line | cut -d= -f2-`; fi
				if [ "$test" == "InterfaceName" ]; then InterfaceName=`echo $line | cut -d= -f2-`; fi
					if [ "$test" == "SourceAddressFiltering" ]; then SourceAddressFiltering=`echo $line | cut -d= -f2-`; fi
						if [ "$test" == "SourcePortFiltering" ]; then SourcePortFiltering=`echo $line | cut -d= -f2-`; fi
							if [ "$test" == "RateLimitation" ]; then RateLimitation=`echo $line | cut -d= -f2-`; fi
								if [ "$test" == "DSCPControl" ]; then DSCPControl=`echo $line | cut -d= -f2-`; fi
									if [ "$test" == "RealmType" ]; then RealmType=`echo $line | cut -d= -f2-`; fi
										if [ "$test" == "GroupId" ]; then GroupId=`echo $line | cut -d= -f2-`; fi
											if [ "$test" == "IPRealmID" ]; then IPRealmID=`echo $line | cut -d= -f2-`; fi
												if [ "$test" == "IPRealmID" ]; then
													printf "%-11s %-17s %-17s %-24s %-24s %-20s %-15s %-15s %-11s %-15s \t\n" $RealmId $RealmName $InterfaceName $SourceAddressFiltering $SourcePortFiltering $RateLimitation $DSCPControl $RealmType $GroupId $IPRealmID;
												fi
											done < $HOME_DIR/$F14;
											echo -e "$DRAW_LINE13";
											echo
											echo
}

# Displays BGW Table
function bgwTable() {
	echo
	echo -e "\t\t\t\t\t\t\t\t ${BLUE}${H11}${NC}"
	flag="true";
	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE5";
			printf "%-18s %-10s %-16s %-11s %-17s %-12s %-21s %-9s %-50s \t\n" "IP ADDR" "PORT" "LISTENER PORT" "PROTOCOL" "MEGACO VERSION" "PROFILE ID" "MULTIHOMING IP ADDR" "WEIGHT" "HOSTNAME";
			echo -e "$DRAW_LINE5";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "IPAddress" ]; then IPAddress=`echo $line | cut -d= -f2-`; fi
			if [ "$test" == "Port" ]; then Port=`echo $line | cut -d= -f2-`; fi
				if [ "$test" == "ListenerPort" ]; then ListenerPort=`echo $line | cut -d= -f2-`; fi
					if [ "$test" == "TransportProtocol" ]; then TransportProtocol=`echo $line | cut -d= -f2-`; fi
						if [ "$test" == "HostName" ]; then HostName=`echo $line | cut -d= -f2-`; fi
							if [ "$test" == "MegacoVersion" ]; then MegacoVersion=`echo $line | cut -d= -f2-`; fi
								if [ "$test" == "ProfileId" ]; then ProfileId=`echo $line | cut -d= -f2-`; fi
									if [ "$test" == "IPAddressMultihoming" ]; then IPAddressMultihoming=`echo $line | cut -d= -f2-`; fi
										if [ "$test" == "Weight" ]; then Weight=`echo $line | cut -d= -f2-`; fi
											if [ "$test" == "Weight" ]; then
												printf "%-18s %-10s %-16s %-11s %-17s %-12s %-21s %-9s %-50s \t\n" $IPAddress $Port $ListenerPort $TransportProtocol $MegacoVersion $ProfileId $IPAddressMultihoming $Weight $HostName;
											fi
										done < $HOME_DIR/$F10;
										echo -e "$DRAW_LINE5";
										echo
										echo
}

# Displays H248 Profile Table
function profileTable() {
	echo
	echo -e "\t\t\t\t\t\t\t\t ${BLUE}${H12}${NC}"
	flag="true";
	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE5";
			printf "%-13s %-15s %-10s %-19s %-50s %-19s \t\n" "PROFILE ID" "PROFILE NAME" "VERSION" "MEDIA RELAY MODE" "MANDATORY PACKAGE" "OPTIONAL PACKAGE";
			echo -e "$DRAW_LINE5";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "ProfileId" ]; then ProfileId=`echo $line | cut -d= -f2-`; fi
			if [ "$test" == "ProfileName" ]; then ProfileName=`echo $line | cut -d= -f2-`; fi
				if [ "$test" == "Version" ]; then Version=`echo $line | cut -d= -f2-`; fi
					if [ "$test" == "MandatoryPackages" ]; then MandatoryPackages=`echo $line | cut -d= -f2-`; fi
						if [ "$test" == "OptionalPackages" ]; then OptionalPackages=`echo $line | cut -d= -f2-`; fi
							if [ "$test" == "MediaRelayMode" ]; then MediaRelayMode=`echo $line | cut -d= -f2-`; fi
								if [ "$test" == "MediaRelayMode" ]; then
									printf "%-13s %-15s %-10s %-19s %-50s %-19s \t\n" $ProfileId $ProfileName $Version $MediaRelayMode $MandatoryPackages $OptionalPackages;
								fi
							done < $HOME_DIR/$F11;
							echo -e "$DRAW_LINE5";
							echo
							echo
}

# Displays Realm to BGW Table
function realmToBgwTable() {
	echo
	echo -e "${BLUE}${H13}${NC}"
	flag="true";
	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE10";
			printf "%-10s %-10s \t\n" "Realm ID" "BGW ID";
			echo -e "$DRAW_LINE10";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "RealmId" ]; then RealmId=`echo $line | cut -d= -f2-`; fi
			if [ "$test" == "BGWId" ]; then BGWId=`echo $line | cut -d= -f2-`; fi
				if [ "$test" == "BGWId" ]; then
					printf "%-10s %-10s \t\n" $RealmId $BGWId;
				fi
			done < $HOME_DIR/$F12;
			echo -e "$DRAW_LINE10";
			echo
			echo
}

# Displays DSCP Policing Table
function dscpPolicingTable() {
	echo
	echo -e "\t ${BLUE}${H14}${NC}"
	flag="true";
	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE9";
			printf "%-10s %-12s %-13s \t\n" "Realm ID" "MEDIA TYPE" "DSCP VALUE";
			echo -e "$DRAW_LINE9";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "RealmId" ]; then RealmId=`echo $line | cut -d= -f2-`; fi
			if [ "$test" == "MediaType" ]; then MediaType=`echo $line | cut -d= -f2-`; fi
				if [ "$test" == "DSCPValue" ]; then DSCPValue=`echo $line | cut -d= -f2-`; fi
					if [ "$test" == "DSCPValue" ]; then
						printf "%-10s %-12s %-13s \t\n" $RealmId $MediaType $DSCPValue;
					fi
				done < $HOME_DIR/$F13;
				echo -e "$DRAW_LINE9";
				echo
				echo
				read -e -p "$MESSAGE1" OPT2
				displayMenu
}

# Displays Gq Feature Selection Table
function gqFeatureSelectionTable() {
	echo
	echo -e "${BLUE}${H15}${NC}"
	flag="true";
	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE17";
			printf "%-15s %-11s \t\n" "ACCESS TYPE" "GATING";
			echo -e "$DRAW_LINE17";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "AccessType" ]; then RealmId=`echo $line | cut -d= -f2-`; fi
			if [ "$test" == "Gating" ]; then BGWId=`echo $line | cut -d= -f2-`; fi
				if [ "$test" == "Gating" ]; then
					printf "%-15s %-11s \t\n" $AccessType $Gating;
				fi
			done < $HOME_DIR/$F15;
			echo -e "$DRAW_LINE17";
			echo
			echo
}

# Displays PDF LIST
function pdfList() {
	echo
	echo -e "\t\t\t\t ${BLUE}${H16}${NC}"
	flag="true";
	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE14";
			printf "%-40s %-25s %-11s %-9s \t\n" "DOMAIN NAME" "REALM NAME" "STATUS" "PDF ID";
			echo -e "$DRAW_LINE14";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "domainName" ]; then domainName=`echo $line | cut -d= -f2-`; fi
			if [ "$test" == "realmName" ]; then realmName=`echo $line | cut -d= -f2-`; fi
				if [ "$test" == "status" ]; then status=`echo $line | cut -d= -f2-`; fi
					if [ "$test" == "PDFId" ]; then PDFId=`echo $line | cut -d= -f2-`; fi
						if [ "$test" == "PDFId" ]; then
							printf "%-40s %-25s %-11s %-9s \t\n" $domainName $realmName $status $PDFId;
						fi
					done < $HOME_DIR/$F16;
					echo -e "$DRAW_LINE14";
					echo
					echo
					read -e -p "$MESSAGE1" OPT2
					displayMenu
}

# Displays PDF PCRF Table
function pdfPcrfTable() {
	echo
	echo -e "\t\t\t ${BLUE}${H17}${NC}"
	flag="true";
	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE16";
			printf "%-9s %-30s %-25s %-11s \t\n" "PDF ID" "DOMAIN NAME" "REALM NAME" "STATUS";
			echo -e "$DRAW_LINE16";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "PDFId" ]; then PDFId=`echo $line | cut -d= -f2-`; fi
			if [ "$test" == "domainName" ]; then domainName=`echo $line | cut -d= -f2-`; fi
				if [ "$test" == "realmName" ]; then realmName=`echo $line | cut -d= -f2-`; fi
					if [ "$test" == "status" ]; then status=`echo $line | cut -d= -f2-`; fi
						if [ "$test" == "status" ]; then
							printf "%-9s %-30s %-25s %-11s \t\n"  $PDFId $domainName $realmName $status;
						fi
					done < $HOME_DIR/$F17;
					echo -e "$DRAW_LINE16";
					echo
					echo
}

# Displays Codec Bandwidth List
function codecBandwidthList() {
	echo
	echo -e "\t\t\t ${BLUE}${H18}${NC}"
	flag="true";
	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE15";
			printf "%-15s %-15s %-15s %-13s %-12s \t\n" "CODEC NAME" "MEDIA TYPE" "PAYLOAD TYPE" "CLOCK RATE" "BANDWIDTH";
			echo -e "$DRAW_LINE15";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "codec_name" ]; then codec_name=`echo $line | cut -d= -f2-`; fi
			if [ "$test" == "media_type" ]; then media_type=`echo $line | cut -d= -f2-`; fi
				if [ "$test" == "payload_type" ]; then payload_type=`echo $line | cut -d= -f2-`; fi
					if [ "$test" == "clockrate" ]; then clockrate=`echo $line | cut -d= -f2-`; fi
						if [ "$test" == "bandwidth" ]; then bandwidth=`echo $line | cut -d= -f2-`; fi
							if [ "$test" == "bandwidth" ]; then
								printf "%-15s %-15s %-15s %-13s %-12s \t\n"  $codec_name $media_type $payload_type $clockrate $bandwidth;
							fi
						done < $HOME_DIR/$F18;
						echo -e "$DRAW_LINE15";
						echo
						echo
}

# Displays Access Network Table
function accessNetworkTable() {
	echo
	echo -e "\t\t\t\t\t\t\t ${BLUE}${H19}${NC}"
	flag="true";
	while read line;
	do
		if [ "$flag" == "true" ]; then
			flag="false";
			echo -e "$DRAW_LINE18";
			printf "%-30s %-10s %-12s %-13s %-17s %-14s %-17s %-12s %-15s %-13s \t\n" "RANGE" "NETWORK" "TLS MODE" "Gq VARIANT" "PCRF SIGNALING" "PRIMARY PDF" "SECONDARY PDF" "GATING" "ACCESS REALM" "CORE REALM";
			echo -e "$DRAW_LINE18";
		fi
		test=`echo $line | cut -d= -f1`;
		if [ "$test" == "Range" ]; then Range=`echo $line | cut -d= -f2-`; fi
			if [ "$test" == "Network" ]; then Network=`echo $line | cut -d= -f2-`; fi
				if [ "$test" == "TLS_Mode" ]; then TLS_Mode=`echo $line | cut -d= -f2-`; fi
					if [ "$test" == "GqVariant" ]; then GqVariant=`echo $line | cut -d= -f2-`; fi
						if [ "$test" == "PCRF_Signaling" ]; then PCRF_Signaling=`echo $line | cut -d= -f2-`; fi
							if [ "$test" == "Primary_PDF" ]; then Primary_PDF=`echo $line | cut -d= -f2-`; fi
								if [ "$test" == "Secondary_PDF" ]; then Secondary_PDF=`echo $line | cut -d= -f2-`; fi
									if [ "$test" == "Gating" ]; then Gating=`echo $line | cut -d= -f2-`; fi
										if [ "$test" == "AccessRealm" ]; then AccessRealm=`echo $line | cut -d= -f2-`; fi
											if [ "$test" == "CoreRealm" ]; then CoreRealm=`echo $line | cut -d= -f2-`; fi
												if [ "$test" == "CoreRealm" ]; then
													printf "%-30s %-10s %-12s %-13s %-17s %-14s %-17s %-12s %-15s %-13s \t\n"  $Range $Network $TLS_Mode $GqVariant $PCRF_Signaling $Primary_PDF $Secondary_PDF $Gating $AccessRealm $CoreRealm;
												fi
											done < $HOME_DIR/$F19;
											echo -e "$DRAW_LINE18";
											echo
											echo
}

# Displays Source IP for Interfaces
function interfaceSourceIP() {
	echo
	flag="true";
	while read line;
	do
	if [ "$flag" == "true" ]; then
		flag="false";
		echo -e "$DRAW_LINE3";
		printf "%-52s %-15s \t\n" "Interface Name" "Source IP";
		echo -e "$DRAW_LINE3";
	fi
	test=`echo $line | cut -d= -f1`;
	if [ "$test" == "DispatcherType" ]; then DispatcherType=`echo $line | cut -d= -f2-`; fi
	if [ "$test" == "Address" ]; then Address=`echo $line | cut -d= -f2-`; fi
	if [ "$test" == "Address" ]; then
	printf "%-52s %-15s \t\n" $DispatcherType  $Address;
	fi
	done < $HOME_DIR/$F20;
	echo -e "$DRAW_LINE3";
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
	rm -f $F9;
	rm -f $F10;
	rm -f $F11;
	rm -f $F12;
	rm -f $F13;
	rm -f $F14;
	rm -f $F15;
	rm -f $F16;
	rm -f $F17;
	rm -f $F18;
	rm -f $F19;
	rm -f $F20;
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
			mwSysConnTable
		elif [ "$OPTI" = "$D_OPT" ]; then
			clear
			sharedIFCTable
			asPoolTable
			asResourceTable
		elif [ "$OPTI" = "$E_OPT" ]; then
			clear
			realmTable
			bgwTable
			profileTable
			realmToBgwTable
			dscpPolicingTable
		elif [ "$OPTI" = "$F_OPT" ]; then
			clear
			accessNetworkTable
			gqFeatureSelectionTable
			pdfPcrfTable
			codecBandwidthList
			pdfList
		elif [ "$OPTI" = "$G_OPT" ]; then
			clear
			interfaceSourceIP
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
