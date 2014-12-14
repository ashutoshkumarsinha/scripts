#!/usr/bin/sh
#################################################################
#                                                               #
# HP CSCF DNS content creation Script v1.0                      #
#                                                               #
# Author:  Ashutosh Kumar                                       #
#                                                               #
# History: Ashutosh Kumar	10.11.2013 - First Issue            #
#                                                               #
#################################################################

function icscf () {
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.db
echo ";; " >> /tmp/$site_name.db
echo ";;  ${s_name} HP I-CSCF" >> /tmp/$site_name.db
echo ";; " >> /tmp/$site_name.db
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.db
echo >> /tmp/$site_name.db
echo >> /tmp/$site_name.db

count=6
baseaddr="$(echo $s_ip6_range | cut -d: -f1-7)"
lsv="$(echo $s_ip6_range | cut -d: -f8)"
sr_cscf10="$sr_cscf"
echo "${inode_name}${sr_cscf10}.${domain_name}.     IN      AAAA    ${s_ip6_range}" >> /tmp/$site_name.db

while [ $count -gt 0 ] 
do
lsv=$(( $lsv + 2 ))
count=$(( $count - 1 ))
sr_cscf10=$(($sr_cscf10+10))
echo "${inode_name}${sr_cscf10}.${domain_name}.     IN      AAAA    $baseaddr:$lsv" >> /tmp/$site_name.db
done
echo >> /tmp/$site_name.db

count=6
MaxValue=255
baseaddr="$(echo $s_ip4_range | cut -d. -f1-2)"
slsv="$(echo $s_ip4_range | cut -d. -f3)"
lsv="$(echo $s_ip4_range | cut -d. -f4)"
sr_cscf1="$sr_cscf"

echo "${inode_name}${sr_cscf}.${domain_name}.     IN      A    ${s_ip4_range}" >> /tmp/$site_name.db

while [ $count -gt 0 ] 
do
if [ $lsv -eq $MaxValue ] ; then
slsv=$(( $slsv + 1 ))
fi
lsv=$(( $lsv + 4 ))
count=$(( $count - 1 ))
sr_cscf1=$(($sr_cscf1+10))
echo "${inode_name}${sr_cscf1}.${domain_name}.     IN      A    $baseaddr.$slsv.$lsv" >> /tmp/$site_name.db
done
echo >> /tmp/$site_name.db
}

function scscf () {
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.db
echo ";; " >> /tmp/$site_name.db
echo ";;  ${s_name} HP S-CSCF" >> /tmp/$site_name.db
echo ";; " >> /tmp/$site_name.db
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.db
echo >> /tmp/$site_name.db
echo >> /tmp/$site_name.db

count=6
baseaddr="$(echo $s_ip6_range | cut -d: -f1-7)"
lsv="$(echo $s_ip6_range | cut -d: -f8)"
sr_cscf11="$sr_cscf"
echo "${snode_name}${sr_cscf11}.${domain_name}.     IN      AAAA    ${s_ip6_range}" >> /tmp/$site_name.db

while [ $count -gt 0 ] 
do
lsv=$(( $lsv + 2 ))
count=$(( $count - 1 ))
sr_cscf11=$(($sr_cscf11+10))
echo "${snode_name}${sr_cscf11}.${domain_name}.     IN      AAAA    $baseaddr:$lsv" >> /tmp/$site_name.db
done
echo >> /tmp/$site_name.db

echo "${snode_name}${sr_cscf}.${domain_name}.     IN      A    ${s_ip4_range}" >> /tmp/$site_name.db

count=6
MaxValue=255
baseaddr="$(echo $s_ip4_range | cut -d. -f1-2)"
slsv="$(echo $s_ip4_range | cut -d. -f3)"
lsv="$(echo $s_ip4_range | cut -d. -f4)"

while [ $count -gt 0 ] 
do
if [ $lsv -eq $MaxValue ] ; then
slsv=$(( $slsv + 1 ))
fi
lsv=$(( $lsv + 4 ))
count=$(( $count - 1 ))
sr_cscf2=$(($sr_cscf2+10))
echo "${snode_name}${sr_cscf2}.${domain_name}.     IN      A    $baseaddr.$slsv.$lsv" >> /tmp/$site_name.db
done
echo >> /tmp/$site_name.db
}

function cscfvip () {
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.db
echo ";; " >> /tmp/$site_name.db
echo ";;  ${s_name} CSCF VIP (alias) on Int Sig VLAN" >> /tmp/$site_name.db
echo ";; " >> /tmp/$site_name.db
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.db
echo >> /tmp/$site_name.db
echo >> /tmp/$site_name.db

count=6
baseaddr="$(echo $s_ip6_range | cut -d: -f1-7)"
lsv="$(echo $s_ip6_range | cut -d: -f8)"
sr_cscf22=$(($sr_cscf+1))
echo "virtual.${snode_name}${sr_cscf22}-imscore.${domain_name}.     IN      AAAA    ${s_ip6_range}" >> /tmp/$site_name.db

while [ $count -gt 0 ] 
do
lsv=$(( $lsv + 2 ))
count=$(( $count - 1 ))
sr_cscf22=$(($sr_cscf22+1))
echo "virtual.${snode_name}${sr_cscf22}-imscore.${domain_name}.     IN      AAAA    $baseaddr:$lsv" >> /tmp/$site_name.db
done
echo >> /tmp/$site_name.db

count=6
MaxValue=255
baseaddr="$(echo $s_ip4_range | cut -d. -f1-2)"
slsv="$(echo $s_ip4_range | cut -d. -f3)"
lsv="$(echo $s_ip4_range | cut -d. -f4)"
sr_cscf3=$(($sr_cscf+1))
echo "virtual.${snode_name}${sr_cscf3}-imscore.${domain_name}.     IN      A    ${s_ip4_range}" >> /tmp/$site_name.db

while [ $count -gt 0 ] 
do
if [ $lsv -eq $MaxValue ] ; then
slsv=$(( $slsv + 1 ))
fi
lsv=$(( $lsv + 4 ))
count=$(( $count - 1 ))
sr_cscf3=$(($sr_cscf3+10))
echo "virtual.${snode_name}${sr_cscf3}-imscore.${domain_name}.     IN      A    $baseaddr.$slsv.$lsv" >> /tmp/$site_name.db
done
echo >> /tmp/$site_name.db

count=7
baseaddr="$(echo $s_ip6_range | cut -d: -f1-7)"
lsv="$(echo $s_ip6_range | cut -d: -f8)"
sr_cscf14="$sr_cscf"
while [ $count -gt 0 ] 
do
lsv=$(( $lsv + 1 ))
count=$(( $count - 1 ))
sr_cscf14=$(($sr_cscf14+2))
echo "virtual.${snode_name}${sr_cscf14}-imscore.${domain_name}.     IN      AAAA    $baseaddr:$lsv" >> /tmp/$site_name.db
sr_cscf14=$(($sr_cscf14+8))
lsv=$(( $lsv + 1 ))
done
echo >> /tmp/$site_name.db

count=7
MaxValue=255
baseaddr="$(echo $s_ip4_range | cut -d. -f1-2)"
slsv="$(echo $s_ip4_range | cut -d. -f3)"
lsv="$(echo $s_ip4_range | cut -d. -f4)"
sr_cscf4="$sr_cscf"

while [ $count -gt 0 ] 
do
if [ $lsv -eq $MaxValue ] ; then
slsv=$(( $slsv + 1 ))
fi
lsv=$(( $lsv + 2 ))
count=$(( $count - 1 ))
sr_cscf4=$(($sr_cscf4+2))
echo "virtual.${snode_name}${sr_cscf4}-imscore.${domain_name}.     IN      A    $baseaddr.$slsv.$lsv" >> /tmp/$site_name.db
lsv=$(( $lsv + 2 ))
sr_cscf4=$(($sr_cscf4+8))
done
echo >> /tmp/$site_name.db
}

function cscfee () {
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.db
echo ";; " >> /tmp/$site_name.db
echo ";;  ${s_name} CSCF FEE IPs on Int Sig VLAN" >> /tmp/$site_name.db
echo ";; " >> /tmp/$site_name.db
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.db
echo >> /tmp/$site_name.db
echo >> /tmp/$site_name.db

count=6
baseaddr="$(echo $s_ip6_range | cut -d: -f1-7)"
lsv="$(echo $s_ip6_range | cut -d: -f8)"
sr_cscf23=$(($sr_cscf+1))
echo "${fnode_name}${sr_cscf23}.${domain_name}.     IN      AAAA    ${s_ip6_range}" >> /tmp/$site_name.db
while [ $count -gt 0 ] 
do
lsv=$(( $lsv + 2 ))
count=$(( $count - 1 ))
sr_cscf23=$(($sr_cscf23+10))
echo "${fnode_name}${sr_cscf23}.${domain_name}.     IN      AAAA    $baseaddr:$lsv" >> /tmp/$site_name.db
done
echo >> /tmp/$site_name.db

count=6
MaxValue=255
baseaddr="$(echo $s_ip4_range | cut -d. -f1-2)"
slsv="$(echo $s_ip4_range | cut -d. -f3)"
lsv="$(echo $s_ip4_range | cut -d. -f4)"
sr_cscf5=$(($sr_cscf+1))
echo "${fnode_name}${sr_cscf5}.${domain_name}.     IN      A    ${s_ip4_range}" >> /tmp/$site_name.db
while [ $count -gt 0 ] 
do
if [ $lsv -eq $MaxValue ] ; then
slsv=$(( $slsv + 1 ))
fi
lsv=$(( $lsv + 4 ))
count=$(( $count - 1 ))
sr_cscf5=$(($sr_cscf5+10))
echo "${fnode_name}${sr_cscf5}.${domain_name}.     IN      A    $baseaddr.$slsv.$lsv" >> /tmp/$site_name.db
done
echo >> /tmp/$site_name.db

count=7
baseaddr="$(echo $s_ip6_range | cut -d: -f1-7)"
lsv="$(echo $s_ip6_range | cut -d: -f8)"
sr_cscf24="$sr_cscf"
while [ $count -gt 0 ] 
do
lsv=$(( $lsv + 1 ))
count=$(( $count - 1 ))
sr_cscf24=$(($sr_cscf24+2))
echo "${fnode_name}${sr_cscf24}.${domain_name}.     IN      AAAA    $baseaddr:$lsv" >> /tmp/$site_name.db
sr_cscf14=$(($sr_cscf24+8))
lsv=$(( $lsv + 1 ))
done
echo >> /tmp/$site_name.db

count=7
MaxValue=255
baseaddr="$(echo $s_ip4_range | cut -d. -f1-2)"
slsv="$(echo $s_ip4_range | cut -d. -f3)"
lsv="$(echo $s_ip4_range | cut -d. -f4)"
sr_cscf6="$sr_cscf"

while [ $count -gt 0 ] 
do
if [ $lsv -eq $MaxValue ] ; then
slsv=$(( $slsv + 1 ))
fi
lsv=$(( $lsv + 2 ))
count=$(( $count - 1 ))
sr_cscf6=$(($sr_cscf6+2))
echo "virtual.${snode_name}${sr_cscf6}-imscore.${domain_name}.     IN      A    $baseaddr.$slsv.$lsv" >> /tmp/$site_name.db
lsv=$(( $lsv + 2 ))
sr_cscf4=$(($sr_cscf6+8))
done
echo >> /tmp/$site_name.db
}

function pcscfmw () {
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.db
echo ";; " >> /tmp/$site_name.db
echo ";;  ${s_name} P-CSCF Mw Interface" >> /tmp/$site_name.db
echo ";; " >> /tmp/$site_name.db
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.db
echo >> /tmp/$site_name.db
echo >> /tmp/$site_name.db

count=6
baseaddr="$(echo $s_ip6_range | cut -d: -f1-7)"
lsv="$(echo $s_ip6_range | cut -d: -f8)"
sr_cscf20="$sr_cscf"
echo "${pnode_name}${sr_cscf20}.${domain_name}.     IN      AAAA    ${s_ip6_range}" >> /tmp/$site_name.db
while [ $count -gt 0 ] 
do
lsv=$(( $lsv + 2 ))
count=$(( $count - 1 ))
sr_cscf20=$(($sr_cscf20+10))
echo "${pnode_name}${sr_cscf20}.${domain_name}.     IN      AAAA    $baseaddr:$lsv" >> /tmp/$site_name.db
done
echo >> /tmp/$site_name.db

count=6
MaxValue=255
baseaddr="$(echo $s_ip4_range | cut -d. -f1-2)"
slsv="$(echo $s_ip4_range | cut -d. -f3)"
lsv="$(echo $s_ip4_range | cut -d. -f4)"
sr_cscf7="$sr_cscf"
echo "${pnode_name}${sr_cscf7}.${domain_name}.     IN      A    ${s_ip4_range}" >> /tmp/$site_name.db
while [ $count -gt 0 ] 
do
if [ $lsv -eq $MaxValue ] ; then
slsv=$(( $slsv + 1 ))
fi
lsv=$(( $lsv + 4 ))
count=$(( $count - 1 ))
sr_cscf7=$(($sr_cscf7+10))
echo "${pnode_name}${sr_cscf7}.${domain_name}.     IN      A    $baseaddr.$slsv.$lsv" >> /tmp/$site_name.db
done
echo >> /tmp/$site_name.db
}

function pcscfgm () {
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.db
echo ";; " >> /tmp/$site_name.db
echo ";;  ${s_name} P-CSCF Gm Interface" >> /tmp/$site_name.db
echo ";; " >> /tmp/$site_name.db
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.db
echo >> /tmp/$site_name.db
echo >> /tmp/$site_name.db

count=7
sr_cscf19="$sr_cscf"
echo "${lnode_name}${sr_lb}-gm.${domain_name}.     IN      AAAA    ${gm_ip6_range}" >> /tmp/$site_name.db
while [ $count -gt 0 ] 
do
count=$(( $count - 1 ))
echo "${pnode_name}${sr_cscf19}-gm.${domain_name}.     IN      AAAA    ${gm_ip6_range}" >> /tmp/$site_name.db
sr_cscf19=$(($sr_cscf19+10))
done
echo >> /tmp/$site_name.db
}

function bgcfmw () {
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.db
echo ";; " >> /tmp/$site_name.db
echo ";;  ${s_name} BGCF Mw Interface" >> /tmp/$site_name.db
echo ";; " >> /tmp/$site_name.db
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.db
echo >> /tmp/$site_name.db
echo >> /tmp/$site_name.db

count=6
baseaddr="$(echo $s_ip6_range | cut -d: -f1-7)"
lsv="$(echo $s_ip6_range | cut -d: -f8)"
sr_cscf10="$sr_cscf"
echo "${inode_name}${sr_cscf10}.${domain_name}.     IN      AAAA    ${s_ip6_range}" >> /tmp/$site_name.db
while [ $count -gt 0 ] 
do
lsv=$(( $lsv + 2 ))
count=$(( $count - 1 ))
sr_cscf10=$(($sr_cscf10+10))
echo "${inode_name}${sr_cscf10}.${domain_name}.     IN      AAAA    $baseaddr:$lsv" >> /tmp/$site_name.db
done
echo >> /tmp/$site_name.db

count=6
MaxValue=255
baseaddr="$(echo $s_ip4_range | cut -d. -f1-2)"
slsv="$(echo $s_ip4_range | cut -d. -f3)"
lsv="$(echo $s_ip4_range | cut -d. -f4)"
sr_cscf8="$sr_cscf"
echo "${bnode_name}${sr_cscf8}.${domain_name}.     IN      A    ${s_ip4_range}" >> /tmp/$site_name.db

while [ $count -gt 0 ] 
do
if [ $lsv -eq $MaxValue ] ; then
slsv=$(( $slsv + 1 ))
fi
lsv=$(( $lsv + 4 ))
count=$(( $count - 1 ))
sr_cscf8=$(($sr_cscf8+10))
echo "${bnode_name}${sr_cscf8}.${domain_name}.     IN      A    $baseaddr.$slsv.$lsv" >> /tmp/$site_name.db
done
echo >> /tmp/$site_name.db
}

function icscfv () {
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.conf
echo ";; " >> /tmp/$site_name.conf
echo ";;  I-CSCF selection VoLTE ${s_name}" >> /tmp/$site_name.conf
echo ";; " >> /tmp/$site_name.conf
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.conf
echo >> /tmp/$site_name.conf
echo >> /tmp/$site_name.conf

count=6
sr_cscf90="$sr_cscf"
echo "${tinode_name}.vzims.com. 						IN      NAPTR   50      51      \"s\" \"SIP+D2T\" \"\" _sip._tcp.${tinode_name}" >> /tmp/$site_name.conf
echo "                                        			IN      NAPTR   50      50      \"s\" \"SIP+D2U\" \"\" _sip._udp.${tinode_name}" >> /tmp/$site_name.conf
echo >> /tmp/$site_name.conf
echo "_sip._tcp.${tinode_name}.vzims.com.					IN      SRV     10      20      5080    ${inode_name}${sr_cscf90}.${domain_name}." >> /tmp/$site_name.conf

while [ $count -gt 0 ] 
do
count=$(( $count - 1 ))
sr_cscf90=$(($sr_cscf90+10))
echo "                                         			IN      SRV     10      20      5080    ${inode_name}${sr_cscf90}.${domain_name}." >> /tmp/$site_name.conf
done

count=6
sr_cscf91="$sr_cscf"
echo >> /tmp/$site_name.conf
echo "_sip._udp.${tinode_name}.vzims.com.        				IN      SRV     10      20      5080    ${inode_name}${sr_cscf91}.${domain_name}." >> /tmp/$site_name.conf

while [ $count -gt 0 ] 
do
count=$(( $count - 1 ))
sr_cscf91=$(($sr_cscf91+10))
echo "                                         			IN      SRV     10      20      5080    ${inode_name}${sr_cscf91}.${domain_name}." >> /tmp/$site_name.conf
done

echo >> /tmp/$site_name.conf
}

function scscfv () {
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.conf
echo ";; " >> /tmp/$site_name.conf
echo ";;  S-CSCF selection VoLTE ${s_name}" >> /tmp/$site_name.conf
echo ";; " >> /tmp/$site_name.conf
echo ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" >> /tmp/$site_name.conf
echo >> /tmp/$site_name.conf
echo >> /tmp/$site_name.conf

count=6
sr_cscf92="$sr_cscf"
echo "${tsnode_name}.vzims.com. 						IN      NAPTR   50      51      \"s\" \"SIP+D2T\" \"\" _sip._tcp.${tsnode_name}" >> /tmp/$site_name.conf
echo "                                         			IN      NAPTR   50      50      \"s\" \"SIP+D2U\" \"\" _sip._udp.${tsnode_name}" >> /tmp/$site_name.conf
echo >> /tmp/$site_name.conf
echo "_sip._tcp.${tsnode_name}.vzims.com.        				IN      SRV     10      20      5090    ${inode_name}${sr_cscf92}.${domain_name}." >> /tmp/$site_name.conf

while [ $count -gt 0 ] 
do
count=$(( $count - 1 ))
sr_cscf92=$(($sr_cscf92+10))
echo "                                         			IN      SRV     10      20      5090    ${inode_name}${sr_cscf92}.${domain_name}." >> /tmp/$site_name.conf
done

count=6
sr_cscf93="$sr_cscf"
echo >> /tmp/$site_name.conf
echo "_sip._udp.${tsnode_name}.vzims.com.        				IN      SRV     10      20      5090    ${inode_name}${sr_cscf93}.${domain_name}." >> /tmp/$site_name.conf

while [ $count -gt 0 ] 
do
count=$(( $count - 1 ))
sr_cscf93=$(($sr_cscf93+10))
echo "                                         			IN      SRV     10      20      5090    ${inode_name}${sr_cscf93}.${domain_name}." >> /tmp/$site_name.conf
done

echo >> /tmp/$site_name.conf
}

function icscfsrv () {
echo >> /tmp/$site_name.conf
echo ";; please add new entries on icscf.vzims.com SRV records as below" >> /tmp/$site_name.conf
echo >> /tmp/$site_name.conf

count=6
sr_cscf94="$sr_cscf"
echo >> /tmp/$site_name.conf
echo "_sip._tcp.icscf.vzims.com.					IN      SRV     10      20      5080    ${inode_name}${sr_cscf94}.${domain_name}." >> /tmp/$site_name.conf

while [ $count -gt 0 ] 
do
count=$(( $count - 1 ))
sr_cscf94=$(($sr_cscf94+10))
echo "                                         			IN      SRV     10      20      5080    ${inode_name}${sr_cscf94}.${domain_name}." >> /tmp/$site_name.conf
done

count=6
sr_cscf95="$sr_cscf"
echo >> /tmp/$site_name.conf
echo "_sip._udp.icscf.vzims.com.        				IN      SRV     10      20      5080    ${inode_name}${sr_cscf95}.${domain_name}." >> /tmp/$site_name.conf

while [ $count -gt 0 ] 
do
count=$(( $count - 1 ))
sr_cscf95=$(($sr_cscf95+10))
echo "                                         			IN      SRV     10      20      5080    ${inode_name}${sr_cscf95}.${domain_name}." >> /tmp/$site_name.conf
done

echo >> /tmp/$site_name.conf
}

function maindns () {
clear
echo
echo "----------------------------------------------------------------------------------"
echo "	             Creating DNS zone file content for HP CSCF Shelfs"
echo "----------------------------------------------------------------------------------"
echo

read -e -p " Please enter the site name [njwt|njbb|caaz|txsl|cosp|ohci]: " site_name
read -e -p " Please enter the starting CSCF number in the shelf: " sr_cscf
read -e -p " Please enter the starting IPv4 address for the shelf: " s_ip4_range
read -e -p " Please enter the starting IPv6 address for the shelf: " s_ip6_range
read -e -p " Please enter the Load Balancer number for the shelf: " sr_lb
read -e -p " Please enter the Gm IPv6 address for the shelf: " gm_ip6_range
read -e -p " Please enter the segment number for the shelf: " seg

#site_name="njwt"
#sr_cscf="0800"
#s_ip4_range="10.0.18.11"
#s_ip6_range="2001:4888:208:3f30:aa:106::20"
#sr_lb="10"
#gm_ip6_range="2001:4888:8:fe30:aa:106:0:17"
#seg="2"

extr="$(echo $sr_cscf | cut -c1-1)"
val1="0"
val2=""
if [ $extr -eq $val1 ] ; then
sr_cscf="$(echo $sr_cscf | cut -c2-4)"
val2="0"
fi

rm -f /tmp/$site_name.db
touch /tmp/$site_name.db
rm -f /tmp/$site_name.conf
touch /tmp/$site_name.conf

count=3
MaxValue=255
sr_cscf1="$sr_cscf"
sr_cscf2="$sr_cscf"
baseaddr="$(echo $s_ip4_range | cut -d. -f1-2)"
slsv="$(echo $s_ip4_range | cut -d. -f3)"
lsv="$(echo $s_ip4_range | cut -d. -f4)"
inode_name="${site_name}ims1icscf${val2}"
snode_name="${site_name}ims1scscf${val2}"
pnode_name="${site_name}ims1pcscf${val2}"
fnode_name="${site_name}ims1fee${val2}"
bnode_name="${site_name}ims1bgcf${val2}"
lnode_name="${site_name}ims1lb"
domain_name="vzims.com"
tinode_name="${site_name}i0${seg}"
tsnode_name="${site_name}s0${seg}"
sseg_name="${site_name}s0${seg}"
iseg_name="${site_name}i0${seg}"

case $site_name in
	    njwt )
                s_name="Wall"
				;;
		txsl )
                s_name="Southlake"
				;;
		njbb )
                s_name="Branchburg"
				;;
		caaz )
                s_name="Azusa"
				;;
		cosp )
                s_name="Colorado Springs"
				;;
		ohci )
                s_name="Cincinati"
				;;
		* )
        exit 1
        ;;
esac

icscf
scscf
cscfvip
cscfee
pcscfmw
pcscfgm
bgcfmw
icscfv
scscfv
icscfsrv

clear
echo
echo "----------------------------------------------------------------------------------"
echo "     DNS zone files (${site_name}.db & ${site_name}.conf) has been created in /tmp directory"
echo "----------------------------------------------------------------------------------"
}

maindns