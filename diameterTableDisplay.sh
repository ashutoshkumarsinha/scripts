su - rtp99 -c "AdvCfgTool.sh -e LISTCNFINST ims/common/diameterdisp  Connections"  | cut -d. -f2- > /tmp/diameterConnections
flag="true";
while read line; 
do
if [ "$flag" == "true" ]; then 
	flag="false"; 
	printf "%-17s %-25s \t\t %-30s %-17s %-29s %-17s %-17s %-17s %-17s \t\n" "ConnectionID" "SourceHostname" "SourceAddress" "SourceRealm" "DestinationAddress" "ConnectionType" "ConnectionKind" "Watchdog" "Reconnect"; 
	echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
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
 if [ "$test" == "SourceSecAddress" ]; then printf "%-17s %-25s \t %-30s %-17s" $ConnectionID $SourceHostname $SourceAddress $SourceRealm;
 	printf "%-30s %-17s %-17s %-17s %-17s \t\n" $DestinationAddress $ConnectionType $ConnectionKind $Watchdog $Reconnect; fi
done < /tmp/diameterConnections;

rm -f /tmp/diameterConnections;



ConnectionID      ConnectionID      SourceHostname                       SourceAddress                  SourceRealm      DestinationAddress             ConnectionType    ConnectionKind    Watchdog          Reconnect
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BBNJCCF1          BBNJCCF1          virtual.cscfl-imscore.ims1.com       2a00:8a00:2000:50::22          ims1.com         vora1-ccf.njbb.vzims.com       TCP               static            6                 5
BBNJCCF2          BBNJCCF2          virtual.cscfl-imscore.ims1.com       2a00:8a00:2000:50::22          ims1.com         vora3-ccf.njbb.vzims.com       TCP               static            6                 5
NJBBSLF11_CX      NJBBSLF11_CX      virtual.cscfk-imscore.ims1.com       10.203.247.104                 ims1.com         njbbslf11-n01.vzims.com        TCP               static            6                 5
CSCF3             CSCF3             virtual.cscfk-imscore.ims1.com       10.203.247.104                 ims1.com         								TCP_LISTEN        static            6                 5
CSCF4             CSCF4             virtual.cscfl-imscore.ims1.com       10.203.247.106                 ims1.com         								TCP_LISTEN        static            6                 5
TXSLSLF12_CX      TXSLSLF12_CX      virtual.cscfk-imscore.ims1.com       10.203.247.104                 ims1.com         txslslf12-n01.vzims.com        TCP               static            6                 5
CSCF6             CSCF6             virtual.cscfk-imscore.ims1.com       2a00:8a00:2000:50::20          ims1.com         hip.hssdd-imscore.ims1.com     TCP               static            6                 5
SLTXCCF1          SLTXCCF1          virtual.cscfl-imscore.ims1.com       2a00:8a00:2000:50::22          ims1.com         vora1-ccf.txsl.vzims.com       TCP               static            6                 5
CSCF3_V6          CSCF3_V6          virtual.cscfk-imscore.ims1.com       2a00:8a00:2000:50::20          ims1.com         								TCP_LISTEN        static            6                 5
SLTXCCF2          SLTXCCF2          virtual.cscfl-imscore.ims1.com       2a00:8a00:2000:50::22          ims1.com         vora3-ccf.txsl.vzims.com       TCP               static            6                 5
CSCF4_V6          CSCF4_V6          virtual.cscfl-imscore.ims1.com       2a00:8a00:2000:50::22          ims1.com         								TCP_LISTEN        static            6                 5



table of SCSCF URI
su - rtp99 -c "AdvCfgTool.sh -e LISTCNFINST ims/cscf/icscf System.TableOfScscfs"

System.TableOfScscfs[0].ScscfName=sip:scscflab120.ims.bell.ca:5090
    System.TableOfScscfs[0].ScscfCapabilities=1
    System.TableOfScscfs[0].ScscfPriority=1
    System.TableOfScscfs[0].ScscfWeight=100
	
FEE servlet

su - rtp99 -c "AdvCfgTool.sh -e LISTCNFINST ims/cscf/fee servletConfigParam"

   servletConfigParam[0].servletName=transc
    servletConfigParam[0].attribute=H264
    servletConfigParam[0].value=sdp=m=video 49264 RTP/AVP 106;;a=rtpmap: 106 H264/90000
    servletConfigParam[0].entryComment=H264 video codec line

Table of Phone number range

	    System.PhoneNumbersTable[0].SequenceNumber=11
    System.PhoneNumbersTable[0].PhoneNumberRange=1
    System.PhoneNumbersTable[0].DomainName=
    System.PhoneNumbersTable[0].MgcfName=sip:sipi.mss1b.ims.bell.ca:5060
    System.PhoneNumbersTable[0].RequestUriType=any
    System.PhoneNumbersTable[0].PhoneNumberKind=e.164
    System.PhoneNumbersTable[0].MediaTypes=
    System.PhoneNumbersTable[0].UseTopologyHidingGateway=false
	
	IP_cluster_routing
	su - rtp99 -c "AdvCfgTool.sh -e LISTCNFINST platform/cframe IP_CLUSTER_ROUTING" 
	IP_CLUSTER_ROUTING[0].DESTINATION=192.168.181.42
	Line 12516:     IP_CLUSTER_ROUTING[0].NETMASK=/32
	Line 12517:     IP_CLUSTER_ROUTING[0].GATEWAY=172.16.137.1
	Line 12518:     IP_CLUSTER_ROUTING[0].DESCRIPTION=Broadworks AS1/2
	Line 12519:     IP_CLUSTER_ROUTING[0].DEVICE=none
	
	
	Shared iFC
	
	su - rtp99 -c "AdvCfgTool.sh -e LISTCNFINST ims/cscf/scscf ServiceProfile.SharediFCList"
	
	ServiceProfile.SharediFCList[0].SharediFCID=64
    ServiceProfile.SharediFCList[0].Priority=5
    ServiceProfile.SharediFCList[0].ApplServerAddress=sip:ps.ims.mav.bell.ca:5060;transport=udp
    ServiceProfile.SharediFCList[0].TriggerPoints=<TriggerPoint><ConditionTypeCNF>1</ConditionTypeCNF><SPT><ConditionNegated>0</ConditionNegated><Group>0</Group><Method>PUBLISH</Method></SPT></TriggerPoint>
    ServiceProfile.SharediFCList[0].DefaultHandling=0
    ServiceProfile.SharediFCList[0].ServiceInformation=
    ServiceProfile.SharediFCList[0].IncludeRegisterRequest=n
    ServiceProfile.SharediFCList[0].IncludeRegisterResponse=n
	
	Operator Trigger
	su - rtp99 -c "AdvCfgTool.sh -e LISTCNFINST ims/cscf/scscf OperatorService.ForcedList"
	 OperatorService.ForcedList[0].Priority=999
    OperatorService.ForcedList[0].ApplServerAddress=sip:enum@localhost;snh;numglob;ast=0
    OperatorService.ForcedList[0].TriggerPoints=<TP><CT>1</CT><SPT><GP>0</GP><CN>1</CN><SCE>1</SCE></SPT><SPT><GP>1</GP><CN>1</CN><SCE>2</SCE></SPT><SPT><GP>2</GP><HDR><ID>IsPhoneNumber</ID></HDR></SPT></TP>
    OperatorService.ForcedList[0].DefaultHandling=0
    OperatorService.ForcedList[0].ServiceInformation=enum
    OperatorService.ForcedList[0].IncludeRegisterRequest=n
    OperatorService.ForcedList[0].IncludeRegisterResponse=n
  
  
	ASPOOL
	
	su - rtp99 -c "AdvCfgTool.sh -a LISTCNFINST ims/cscf/scscf ResourceManagement.ASPool"
	ResourceManagement.ASPool[0].PoolName=bspool.ims.bell.ca
	Line 10697:     ResourceManagement.ASPool[0].PoolType=STATEFUL
	Line 10698:     ResourceManagement.ASPool[0].FailResponseType=408
	Line 10699:     ResourceManagement.ASPool[0].FailureThreshold=10
	Line 10700:     ResourceManagement.ASPool[0].InactiveRevokeTimer=10
	Line 10701:     ResourceManagement.ASPool[0].FailbackBehavior=ON_REGISTER
	
	su - rtp99 -c "AdvCfgTool.sh -e LISTCNFINST ims/cscf/scscf ResourceManagement.ASResource"
	 ResourceManagement.ASResource[0].PoolName=feepool
	Line 10733:     ResourceManagement.ASResource[0].PoolName=feepool
	Line 10734:     ResourceManagement.ASResource[0].Address=sip:\\1@172.16.137.8:\\2
	Line 10734:     ResourceManagement.ASResource[0].Address=sip:\\1@172.16.137.8:\\2
	Line 10735:     ResourceManagement.ASResource[0].Priority=2
	Line 10735:     ResourceManagement.ASResource[0].Priority=2
	Line 10736:     ResourceManagement.ASResource[0].Weight=100
	Line 10736:     ResourceManagement.ASResource[0].Weight=100
	Line 10737:     ResourceManagement.ASResource[0].State=ENABLED
	Line 10737:     ResourceManagement.ASResource[0].State=ENABLED