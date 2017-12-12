#!/usr/bin/sh
#################################################################
#                                                               #
# Charter Communications (c) 2017, All rights reserved      		#
#                                                               #
# MM Script v1.0                                                #
#                                                               #
# Author:  Ashutosh Kumar Sinha                                 #
#                                                               #
# History: Ashutosh Kumar	07.12.2017 - First Issue            	#
#                                                               #
#################################################################

function mmChangeCreation () {

echo "Preparing message manipulation change..."

# Removing old files with the same names, if any
rm -f /home/mm/Replace_408_with_480.xml
rm -f /home/mm/Replace_501_with_481.xml

# Creating MM XMLs
echo "<clist><manipulation><name>Replacing408with480</name><rule><replace><path-what>/response/status_line/code</path-what><value>480</value></replace></rule><rule><replace><path-what>/response/status_line/reason</path-what><value>Temporarily Unavailable</value></replace></rule></manipulation></clist>" > /home/mm/Replace_408_with_480.xml
echo "<clist><manipulation><name>Replacing501with481</name><rule><replace><path-what>/response/status_line/code</path-what><value>481</value></replace></rule><rule><replace><path-what>/response/status_line/reason</path-what><value>MTA Does Not Support UPDATE</value></replace></rule></manipulation></clist>" > /home/mm/Replace_501_with_481.xml

# Changing permission of MM XMLs
chmod 777 /home/mm/Replace_408_with_480.xml
chmod 777 /home/mm/Replace_501_with_481.xml

# Changing ownership of MM XMLs to mm user
chown mm:dba /home/mm/Replace_408_with_480.xml
chown mm:dba /home/mm/Replace_501_with_481.xml

# Creating MM Trigger's
echo "INS ims/cscf/pcscf System.SPSConfigTable Priority='50' NetworkIdentifier='::/0' EventTrigger='E1' Direction='INGRESS' SessionSide='BOTH' TriggerPoint='<TP><CT>0</CT><SPT><GP>0</GP><RCO>408</RCO></SPT><SPT><GP>0</GP><HDR><ID>CSeq</ID><CO>INVITE</CO></HDR></SPT></TP>' ServiceName='sip:mm@localhost;clist=Replace_408_with_480' ActualVersion='1'" >> /tmp/clist_sps.conf
echo "INS ims/cscf/pcscf System.SPSConfigTable Priority='55' NetworkIdentifier='::/0' EventTrigger='E1' Direction='INGRESS' SessionSide='BOTH' TriggerPoint='<TP><CT>0</CT><SPT><GP>0</GP><RCO>501</RCO></SPT><SPT><GP>0</GP><HDR><ID>CSeq</ID><CO>UPDATE</CO></HDR></SPT></TP>' ServiceName='sip:mm@localhost;clist=Replace_501_with_481' ActualVersion='1'" >> /tmp/clist_sps.conf

# Changing permission of MM triggers
chmod 777 /tmp/clist_sps.conf

}

function mmChangeInstall () {

echo "Installing message manipulation..."

# Installing MM XMLs
echo "Installing Replace_408_with_480.xml MM" >> /tmp/mm_script.log
su - mm -c "MmConfigClist.sh -p -add mm@`uname -n`:Replace_408_with_480.xml" >> /tmp/mm_script.log

echo "Installing Replace_501_with_481.xml MM" >> /tmp/mm_script.log
su - mm -c "MmConfigClist.sh -p -add mm@`uname -n`:Replace_501_with_481.xml" >> /tmp/mm_script.log

# Changing MM directory permission
chmod -R 777 /home/mm/conf/MessageManipulation/PCSCF/

# Installing MM Trigger Config
su - rtp99 -c "AdvCfgTool.sh -j /tmp/clist_sps.conf" >> /tmp/mm_script.log

}

function mmChangeVerification () {

echo "Verifying message manipulation install..."

# Verifying MM Install

echo "Installed MM listing" >> /tmp/mm_script.log
ls -lrt /home/mm/conf/MessageManipulation/PCSCF/ >> /tmp/mm_script.log

echo "Version of Replace_408_with_480.xml MM" >> /tmp/mm_script.log
su - mm -c "MmConfigClist.sh -p -version Replace_408_with_480.xml" >> /tmp/mm_script.log

echo "Version of Replace_501_with_481.xml MM" >> /tmp/mm_script.log
su - mm -c "MmConfigClist.sh -p -version Replace_501_with_481.xml" >> /tmp/mm_script.log

echo "MM Triggers (look for priority 50 & 55)" >> /tmp/mm_script.log
su - rtp99 -c "AdvCfgTool.sh -e LISTCNFINST ims/cscf/pcscf System.SPSConfigTable" >> /tmp/mm_script.log

}

function mmMain() {}
clear
echo "------------------------------------------------------------------------"
echo "--------------------------- MM Change Script ---------------------------"
echo "------------------------------------------------------------------------"

mmChangeCreation
mmChangeInstall
mmChangeVerification

echo "Log has been written to /tmp/mm_script.log"
echo "------------------------------------------------------------------------"

}

mmMain
