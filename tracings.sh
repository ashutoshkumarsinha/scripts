#!/usr/bin/sh
#################################################################
#                                                               #
# Nokia Networks (c)2014, All rights reserved.                  #
#                                                               #
# Trace Collection Script v1.0                                  #
#                                                               #
# Author:  Ashutosh Kumar                                       #
#                                                               #
# History: Ashutosh Kumar       10.01.2014 - First Issue        #
#                                                               #
#################################################################

# Main function 
function TraceCol() {
clear
echo
echo "------------------------------------------------------------------------"
echo "------------------------ Trace Collection Script -----------------------"
echo "------------------------------------------------------------------------"
echo
echo
	echo
	ttimer=0
	read -e -p "	Enter Trace File Tag: " tag
	read -e -p "	Enter Trace Execution Time (in Min) (Default is 3 minutes): " ttimer
	
	# Configuration parameters
	SSH_USER=root
	if [ $ttimer -eq 0 ]; then SCRIPT_TIME=30; else SCRIPT_TIME=$((ttimer*60)); fi
	TIMEOUT_SEC=5
	TIAMS_IP=10.200.203.254
	PCSCF_IP1=10.200.203.5
	PCSCF_IP2=10.200.203.6
	SCSCF_IP1=10.200.203.7
	SCSCF_IP2=10.200.203.10
	WORK_DIR=/tmp/$tag
	HOME_DIR=/tmp/tracelog/$tag

	clear
	trace_vp
	trace_vs
	trace_p $tag &
	trace_s $tag &
	wait
	clear
	transfer_p
	clear
	transfer_s
	clear
	clean_p 
	clear
	clean_s 
	clear
	echo
	echo
	echo "------------------------------------------------------------------------"
	echo "	Please collect the trace files from "$HOME_DIR
	echo "------------------------------------------------------------------------"
	echo
	echo	
}

# Function for finding primary P-CSCF 
function trace_vp() {
local result=0

ssh -o StrictHostKeyChecking=no -o ConnectTimeout=$TIMEOUT_SEC $SSH_USER@$PCSCF_IP1 <<EOF
result=0
HNAME=`hostname`
ANODE=`su - rtp99 -c "IcmAdminTool.pl  PrintRoutingTable | grep 'ActiveNode=' | cut -d '=' -f2 | cut -d ',' -f1"`
if [ "$ANODE" != "$HNAME" ]; then
result=1
else
result=0
fi
exit $result 
EOF

result=$?
if [ $result -ne 0 ]; then
    ssh -o StrictHostKeyChecking=no -o ConnectTimeout=$TIMEOUT_SEC $SSH_USER@$PCSCF_IP2 <<EOF
		result=0
		HNAME=`hostname`
		ANODE=`su - rtp99 -c "IcmAdminTool.pl  PrintRoutingTable | grep 'ActiveNode=' | cut -d '=' -f2 | cut -d ',' -f1"`
		if [ "$ANODE" != "$HNAME" ]; then
		result=1
		else
		result=0
		fi
		exit $result 
EOF
PCSCF_IP="$PCSCF_IP2"
else
PCSCF_IP="$PCSCF_IP1"
fi
}

# Function for finding primary S-CSCF 
function trace_vs() {
local result=0

ssh -o StrictHostKeyChecking=no -o ConnectTimeout=$TIMEOUT_SEC $SSH_USER@$SCSCF_IP1 <<EOF
result=0
HNAME=`hostname`
ANODE=`su - rtp99 -c "IcmAdminTool.pl  PrintRoutingTable | grep 'ActiveNode=' | cut -d '=' -f2 | cut -d ',' -f1"`
if [ "$ANODE" != "$HNAME" ]; then
result=1
else
result=0
fi
exit $result 
EOF

result=$?
if [ $result -ne 0 ]; then
    ssh -o StrictHostKeyChecking=no -o ConnectTimeout=$TIMEOUT_SEC $SSH_USER@$SCSCF_IP2 <<EOF
		result=0
		HNAME=`hostname`
		ANODE=`su - rtp99 -c "IcmAdminTool.pl  PrintRoutingTable | grep 'ActiveNode=' | cut -d '=' -f2 | cut -d ',' -f1"`
		if [ "$ANODE" != "$HNAME" ]; then
		result=1
		else
		result=0
		fi
		exit $result 
EOF
SCSCF_IP="$SCSCF_IP2"
else
SCSCF_IP="$SCSCF_IP1"
fi
}

# Function for tracing on P-CSCF 
function trace_p() {
local result=0

ssh -o StrictHostKeyChecking=no -o ConnectTimeout=$TIMEOUT_SEC $SSH_USER@$PCSCF_IP <<EOF
result=0
mkdir -p $WORK_DIR
cd $WORK_DIR
tshark -i bond0 -s0 -a duration:$SCRIPT_TIME -w P_CSCF-`date '+%Y-%m-%d'`_$tag.pcap
result=$?
exit $result 
EOF

result=$?
if [ $result -ne 0 ]; then
    echo "Tracing failed on P-CSCF."
else
    echo "Tracing is successful on P-CSCF."
fi
}

# Function for tracing on S-CSCF 
function trace_s() {
local result=0

ssh -o StrictHostKeyChecking=no -o ConnectTimeout=$TIMEOUT_SEC $SSH_USER@$SCSCF_IP <<EOF
result=0
mkdir -p $WORK_DIR
cd $WORK_DIR
tshark -i bond0 -s0 -a duration:$SCRIPT_TIME -w S_CSCF-`date '+%Y-%m-%d'`_$tag.pcap
result=$?
exit $result 
EOF

result=$?
if [ $result -ne 0 ]; then
    echo "Tracing failed on S-CSCF."
else
    echo "Tracing is successful on S-CSCF."
fi
}

# Function for transferring trace from P-CSCF to TIAMS
function transfer_p() {
local result=0

echo
echo "Transferring Trace files from P-CSCF...."

mkdir -p $HOME_DIR
cd $HOME_DIR
scp -o StrictHostKeyChecking=no -o ConnectTimeout=$TIMEOUT_SEC $SSH_USER@$PCSCF_IP:$WORK_DIR/P_CSCF-*.pcap .
result=$?
if [ $result -ne 0 ]; then
    echo "Failed to transfer the Trace files from P-CSCF"
fi
}

# Function for transferring trace from S-CSCF to TIAMS
function transfer_s() {
local result=0

echo
echo "Transferring Trace files from S-CSCF...."

mkdir -p $HOME_DIR
cd $HOME_DIR 
scp -o StrictHostKeyChecking=no -o ConnectTimeout=$TIMEOUT_SEC $SSH_USER@$SCSCF_IP:$WORK_DIR/S_CSCF-*.pcap .
result=$?
if [ $result -ne 0 ]; then
    echo "Failed to transfer the Trace files from S-CSCF"
fi
}

# Function for collecting trace on P-CSCF 
function clean_p() {
local result=0

ssh -o StrictHostKeyChecking=no -o ConnectTimeout=$TIMEOUT_SEC $SSH_USER@$PCSCF_IP <<EOF
result=0
rm -rf $WORK_DIR
result=$?
exit $result 
EOF

result=$?
if [ $result -ne 0 ]; then
    echo "Trace clean up failed on P-CSCF."
else
    echo "Trace clean up is successful on P-CSCF."
fi
}

# Function for collecting trace on S-CSCF 
function clean_s() {
local result=0

ssh -o StrictHostKeyChecking=no -o ConnectTimeout=$TIMEOUT_SEC $SSH_USER@$SCSCF_IP <<EOF
result=0
rm -rf $WORK_DIR
result=$?
exit $result 
EOF

result=$?
if [ $result -ne 0 ]; then
    echo "Trace clean up failed on S-CSCF."
else
    echo "Trace clean up is successful on S-CSCF."
fi
}

TraceCol