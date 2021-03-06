#!/usr/bin/sh
#################################################################
#                                                               #
# Charter Communications, INC (c) 2017, All rights reserved     #
#                                                               #
# ANT Testing Script v1.0                                       #
#                                                               #
# Author:  Ashutosh Kumar Sinha                                 #
#                                                               #
# History: Ashutosh Kumar	20.10.2017 - First Issue            #
#          Ashutosh Kumar	24.10.2017 - Second Issue           #
#          Ashutosh Kumar	25.10.2017 - Third Issue            #
#                                                               #
#################################################################

# Function for Pushing Test ANT Config Without Delay 
function PushANTConfig () {
    clear
    rm -f /tmp/ANTTest.log
    echo
    echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
    echo "	Applying ANT Test Config Without Delay on `hostname` on `date`" >> /tmp/ANTTest.log
    echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
    echo " " >> /tmp/ANTTest.log
    COUNTER=0
    while [  $COUNTER -lt 50 ]; do
        let RANGEVALUE="99.99.99.1$COUNTER"
        redis-cli -s /tmp/RedisCm01.sock -n 1 get DN1,DU1_CSCF_CTEC01,V10  >> /tmp/ANTTest.log
        /opt/cmbase/cli/bin/cmcli INS DN1/DU1_CSCF_CTEC01/V10/Common ims/cscf/pcscf System.AccessNetworks '{ Range: $RANGEVALUE, Network: direct, Ext_SBC: 0, TLS_Mode: TLS_BOTH, Realm:, CLF:, NetExt:, GqVariant: None, LargeNet: 0, MR_ID: NO, LI_Capable: 0, LI_Capable_PCSCF: 0, PCRF_Signaling: 0, Primary_PDF: 0, Secondary_PDF: 0, Privileged_Sender: 0, Gating: Legacy, NVS_pool_name:, Allow_Emergency_Registrations: 0, Remark: Residential, Primary_PCRF:, Secondary_PCRF:, Transition_Observation: DISABLED, FreqReReg: DISABLED, FreqReRegTime: 90, FreqReRegTimeTcp: 90, DPP: 100 }'  >> /tmp/ANTTest.log
        redis-cli -s /tmp/RedisCm01.sock -n 1 get DN1,DU1_CSCF_CTEC01,V10  >> /tmp/ANTTest.log
        echo $RANGEVALUE
        let COUNTER=COUNTER+1
    done
    echo " " >> /tmp/ANTTest.log
    echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
    echo "	ANT Test Config has been applied on `hostname` on `date` without delay" >> /tmp/ANTTest.log
    echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
    echo " " >> /tmp/ANTTest.log
    mv /tmp/ANTTest.log /tmp/ANTTest_`date +%y%h%d_%H%M`.log
    echo "Log has been written to /tmp/ANTTest_`date +%y%h%d_%H%M`.log"
}

# Function for Pushing Test ANT Config With 20 Seconds Delay 
function PushANTConfigWDelay () {
    clear
    rm -f /tmp/ANTTest.log
    echo
    echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
    echo "	Applying ANT Test Config With 20 Seconds Delay on `hostname` on `date`" >> /tmp/ANTTest.log
    echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
    echo " " >> /tmp/ANTTest.log
    COUNTER=0
    while [  $COUNTER -lt 50 ]; do
        let RANGEVALUE="99.99.99.1$COUNTER"
        redis-cli -s /tmp/RedisCm01.sock -n 1 get DN1,DU1_CSCF_CTEC01,V10  >> /tmp/ANTTest.log
        /opt/cmbase/cli/bin/cmcli INS DN1/DU1_CSCF_CTEC01/V10/Common ims/cscf/pcscf System.AccessNetworks '{ Range: $RANGEVALUE, Network: direct, Ext_SBC: 0, TLS_Mode: TLS_BOTH, Realm:, CLF:, NetExt:, GqVariant: None, LargeNet: 0, MR_ID: NO, LI_Capable: 0, LI_Capable_PCSCF: 0, PCRF_Signaling: 0, Primary_PDF: 0, Secondary_PDF: 0, Privileged_Sender: 0, Gating: Legacy, NVS_pool_name:, Allow_Emergency_Registrations: 0, Remark: Residential, Primary_PCRF:, Secondary_PCRF:, Transition_Observation: DISABLED, FreqReReg: DISABLED, FreqReRegTime: 90, FreqReRegTimeTcp: 90, DPP: 100 }'  >> /tmp/ANTTest.log
        redis-cli -s /tmp/RedisCm01.sock -n 1 get DN1,DU1_CSCF_CTEC01,V10  >> /tmp/ANTTest.log
        echo $RANGEVALUE
        let COUNTER=COUNTER+1
        sleep 20
    done
    echo " " >> /tmp/ANTTest.log
    echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
    echo "	ANT Test Config has been applied on `hostname` on `date` with 20 seconds delay" >> /tmp/ANTTest.log
    echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
    echo " " >> /tmp/ANTTest.log
    mv /tmp/ANTTest.log /tmp/ANTTest_`date +%y%h%d_%H%M`.log
    echo "Log has been written to /tmp/ANTTest_`date +%y%h%d_%H%M`.log"
}

# Function for Deleting Test ANT Config  
function ANTDelete () {
    clear
    rm -f /tmp/ANTTest.log
    echo
    echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
    echo "	Delete ANT Test Config on `hostname` on `date`" >> /tmp/ANTTest.log
    echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
    echo " " >> /tmp/ANTTest.log
    COUNTER=0
    while [  $COUNTER -lt 50 ]; do
        let RANGEVALUE="99.99.99.1$COUNTER"
        /opt/cmbase/cli/bin/cmcli DEL DN1/DU1_CSCF_CTEC01/V10/Common ims/cscf/pcscf System.AccessNetworks --where '{ Range: $RANGEVALUE, Network: direct, Ext_SBC: 0, TLS_Mode: TLS_BOTH, Realm:, CLF:, NetExt:, GqVariant: None, LargeNet: 0, MR_ID: NO, LI_Capable: 0, LI_Capable_PCSCF: 0, PCRF_Signaling: 0, Primary_PDF: 0, Secondary_PDF: 0, Privileged_Sender: 0, Gating: Legacy, NVS_pool_name:, Allow_Emergency_Registrations: 0, Remark: Residential, Primary_PCRF:, Secondary_PCRF:, Transition_Observation: DISABLED, FreqReReg: DISABLED, FreqReRegTime: 90, FreqReRegTimeTcp: 90, DPP: 100 }'  >> /tmp/ANTTest.log
        echo $RANGEVALUE
        let COUNTER=COUNTER+1
    done
    echo " " >> /tmp/ANTTest.log
    echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
    echo "	ANT Test Config has been deleted on `hostname` on `date`" >> /tmp/ANTTest.log
    echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
    echo " " >> /tmp/ANTTest.log
    mv /tmp/ANTTest.log /tmp/ANTTest_`date +%y%h%d_%H%M`.log
    echo "Log has been written to /tmp/ANTTest_`date +%y%h%d_%H%M`.log"
}

# Function for Taking ANT Config Dump
function ANTDumpConfig () {
    clear
    rm -f /tmp/ANTTest.log
    echo
    echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
    echo "	Dump ANT Test Config Dump on `hostname` on `date`" >> /tmp/ANTTest.log
    echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
    echo " " >> /tmp/ANTTest.log
    COUNTER=0
    while [  $COUNTER -lt 50 ]; do
        echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
        echo "---------------------------------------`date`-------------------------------------" >> /tmp/ANTTest.log
        redis-cli -s /tmp/RedisCm01.sock -n 1 get DN1,DU1_CSCF_CTEC01_Spec,VERSIONS >> /tmp/ANTTest.log
        /opt/cmbase/cli/bin/cmcli disp level=DN DN1 param=System.AccessNetworks >> /tmp/ANTTest.log
        echo "---------------------------------------`date`-------------------------------------" >> /tmp/ANTTest.log
        echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
        let COUNTER=COUNTER+1
    done
    echo " " >> /tmp/ANTTest.log
    echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
    echo "	ANT Test Config Dump has finished on `hostname` on `date`" >> /tmp/ANTTest.log
    echo "----------------------------------------------------------------------------------" >> /tmp/ANTTest.log
    echo " " >> /tmp/ANTTest.log
    mv /tmp/ANTTest.log /tmp/ANTTest_`date +%y%h%d_%H%M`.log
    echo "Log has been written to /tmp/ANTTest_`date +%y%h%d_%H%M`.log"
}

# Main function for calling other function
function main () {
    clear
    echo
    echo "--------------------------------------------------------------------------------"
    echo "----------------------- ANT Configuration Testing Script -----------------------"
    echo "--------------------------------------------------------------------------------"
    echo
    echo
    echo "	Please select the appropriate option from below:"
    echo "	   1. Apply ANT Config Without Delay"
    echo "	   2. Apply ANT Config With Delay"
    echo "	   3. Delete ANT Config"
    echo "	   4. Take Continous Config Dump"
    echo "	   5. Quit"
    echo
    read -e -p "	Enter option [1..5]: " OPTI

    finish="-1"
    while [ "$finish" = '-1' ]
        do
            finish="1"
            case $OPTI in
                1 ) OPTI="1";;
                2 ) OPTI="2";;
                3 ) OPTI="3";;
                4 ) OPTI="4";;
                5 ) OPTI="5";;
                *) finish="-1";
                read -e -p "	Invalid response; Please reenter option [1..5]: " OPTI;;
            esac
        done

    if [ "$OPTI" = "1" ]; then
        PushANTConfig
    elif [ "$OPTI" = "2" ]; then
        PushANTConfigWDelay
    elif [ "$OPTI" = "3" ]; then
        ANTDelete
    elif [ "$OPTI" = "4" ]; then
        ANTDumpConfig
    elif [ "$OPTI" = "5" ]; then
        clear
        exit
    fi
}

main