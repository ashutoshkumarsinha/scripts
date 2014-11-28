#!/usr/bin/sh
#################################################################
#                                                               #
# Nokia Networks (c)2014, All rights reserved.                  #
#                                                               #
# Log Collection Script v1.0                                    #
#                                                               #
# Author:  Ashutosh Kumar                                       #
#                                                               #
# History: Ashutosh Kumar	09.15.2014 - First Issue            #
#                                                               #
#################################################################

# Configuration parameters
SSH_USER=root
TIMEOUT_SEC=5
TIAMS_IP=10.200.203.254
PCSCF_IP=10.200.203.5
SCSCF_IP=10.200.203.7
RSA_ID_FILE=~/.ssh/id_rsa.pub
RSA_TMP_FILE=id_rsa.pub.ems
WORK_DIR=/tmp
HOME_DIR=/tmp

# Function for TIAMS connectivity with CSCF 
function check_cscf() {
local cscf=$1

echo "Connecting to host...."

ssh -o StrictHostKeyChecking=no -o ConnectTimeout=$TIMEOUT_SEC $SSH_USER@$cscf <<EOF
exit
EOF

if [ $? -ne 0 ]; then
  echo "!!!! Connection to CSCF failed !!!!"
else
  echo "Connection to CSCF successful."
fi

}

# Function for preparing CSCF for password-less SSH/SCP
function prepare_cscf() {
local result=0
local cscf=$1

echo
echo "Transferring RSA Public Key file to CSCF...."

scp -o StrictHostKeyChecking=no -o ConnectTimeout=$TIMEOUT_SEC $RSA_ID_FILE $SSH_USER@$cscf:$RSA_TMP_FILE
result=$?
if [ $result -ne 0 ]; then
    echo "Failed to transfer the RSA Public Key file to CSCF"
    return $result
fi

echo
echo "Installing RSA Public Key file on CSCF...."

ssh -o StrictHostKeyChecking=no -o ConnectTimeout=$TIMEOUT_SEC $SSH_USER@$cscf <<EOF
mkdir -p .ssh
if [ -f .ssh/authorized_keys.$SSH_USER ]; then
 cp .ssh/authorized_keys.$SSH_USER .ssh/authorized_keys.$SSH_USER.ems.backup
fi
cat $RSA_TMP_FILE >> .ssh/authorized_keys.$SSH_USER
rm -f $RSA_TMP_FILE
EOF

result=$?
if [ $result -ne 0 ]; then
    echo "Preparation of CSCF for password-less SSH failed."
else
    echo "Preparation of CSCF for password-less SSH completed."
fi
}

# Function for collecting logs on CSCF 
function collog() {
local result=0
local cscf=$1

ssh -o StrictHostKeyChecking=no -o ConnectTimeout=$TIMEOUT_SEC $SSH_USER@$cscf <<EOF
result=0
mkdir -p /tmp/logcol
rm -f /tmp/logcol*.tar.gz

ClmMonShow -n > /tmp/logcol/ClmMonShow.txt
cat /etc/resolv.conf > /tmp/logcol/Resolv.txt
cat /etc/ntp.conf > /tmp/logcol/ntp.txt
ntpq -p > /tmp/logcol/ntpq.txt
imsPrintNotRunning.sh > /tmp/logcol/imsPrintNotRunning.txt
imsPrintRunning.sh > /tmp/logcol/imsPrintRunning.txt
cat /tspinst/scripts/aiParameter.sh > /tmp/logcol/aiParameter.txt
imsListIMSpkg.sh > /tmp/logcol/imsListIMSpkg.txt
netstat -anpT | egrep '6086|10444|10445|10446|5060|5070|5080|5090|3868|3869' | sort > /tmp/logcol/netstatPort.txt
netstat -rn > /tmp/logcol/netstatRN.txt
su - rtp99 -c "RtpDumpLog" > /tmp/logcol/RtpDumpLog.txt
cat /var/log/messages > /tmp/logcol/VarLogMessages.txt
ip route show > /tmp/logcol/iprouteshowv4.txt
ip -f inet6 route show > /tmp/logcol/iprouteshowv6.txt
ip link show > /tmp/logcol/iplink.txt
cat /proc/net/vlan/config > /tmp/logcol/vlan.txt
cat /etc/sysconfig/network > /tmp/logcol/network.txt
/opt/SMAW/INTP/bin/rapidstat -s > /tmp/logcol/rapidstat.txt
/opt/ims_smt/ims_smt.py --list-full > /tmp/logcol/HotFixStatus.txt
su - rtp99 -c "/opt/SMAW/SMAWrtp/bin/RtpSysConfig -a" > /tmp/logcol/RtpSysConfig.txt
su - rtp99 -c "/opt/SMAW/SMAWrtp/bin/RtpGetClusterAndSubsystemInfo -s" > /tmp/logcol/RtpGetClusterAndSubsystemInfo.txt
su - rtp99 -c "/opt/SMAW/INTP/bin/AdvCfgTool.sh -a LISTCNFINST ALL" > /tmp/logcol/AdvCfgTool.txt
su - rtp99 -c "execRTPenv status1" > /tmp/logcol/execRTPenv.txt
su - rtp99 -c "execRTPenv status1 -e" > /tmp/logcol/execRTPenvE.txt

#/opt/SMAW/bin/TspExplorer
#cp /dump/TspExplorer/TspExplorer.*.tar.gz /tmp/logcol/
cp /dump/TspTrace/RtpTrcError/*.* /tmp/logcol/
cp /opt/SMAW/INTP/help/TPD_*.xls.zip /tmp/logcol/
cd /tmp
tar -zcvf /tmp/logcol_`hostname`.tar.gz logcol
rm -rf logcol/
result=$?
exit $result 
EOF

result=$?
if [ $result -ne 0 ]; then
    echo "Log collection failed on CSCF."
else
    echo "Log collection is successful on CSCF."
fi
}

# Function for transferring logs from CSCF to TIAMS
function transfer() {
local result=0

echo
echo "Transferring log files from CSCF...."

scp -o StrictHostKeyChecking=no -o ConnectTimeout=$TIMEOUT_SEC $WORK_DIR/logcol*.tar.gz $SSH_USER@$TIAMS_IP:/tmp/logcol/
result=$?
if [ $result -ne 0 ]; then
    echo "Failed to transfer the log files from CSCF"
fi
}

# Main function for Log Collection & Transfer function
function mainLogCol () {
clear

P_LC="1" 
C_LC="2"
L_LC="3"
Q_LC="4"

echo
echo "------------------------------------------------------------------------"
echo "------------------------- Log Collection Script ------------------------"
echo "------------------------------------------------------------------------"
echo
echo
echo "	Please select the appropriate option from below:"
echo "	   1. [P]repare for Password-less SSH"
echo "	   2. [C]heck Connectivity with Nodes"
echo "	   3. [L]og Collection"
echo "	   4. [Q]uit"
echo
read -e -p "	Enter option [P|C|L|Q]: " OPTI

hname=`hostname`
finish="-1"
while [ "$finish" = '-1' ]
	do
		finish="1"
		case $OPTI in
			p | P ) OPTI="1";;
			c | C ) OPTI="2";;
			l | L ) OPTI="3";;
			q | Q ) OPTI="4";;
			*) finish="-1";
			read -e -p "	Invalid response; Please re-enter option [P|C|L|Q]: " OPTI;;
        esac
    done

if [ "$OPTI" = "$P_LC" ]; then
	echo
	read -e -p "	Enter Node IP Address: " NIP
	prepare_cscf $NIP 
	mainLogCol
elif [ "$OPTI" = "$C_LC" ]; then
	echo
	read -e -p "	Enter Node IP Address: " NIP
	check_cscf $NIP 
	mainLogCol
elif [ "$OPTI" = "$L_LC" ]; then
	echo
	read -e -p "	Enter Node IP Address: " NIP
	collog $NIP 
	transfer $NIP
	mainLogCol
elif [ "$OPTI" = "$Q_LC" ]; then
	clear
	exit
fi
}

mainLogCol