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