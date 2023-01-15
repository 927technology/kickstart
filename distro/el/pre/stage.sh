#!/bin/bash

#commands
cmd_awk=/bin/awk
cmd_cat=/bin/cat
cmd_curl=/bin/curl
cmd_echo=/bin/echo
cmd_grep=/bin/grep
cmd_head=/bin/head
cmd_lsblk=/bin/lsblk
cmd_sed=/bin/sed
cmd_uname=/bin/uname

#variables
eval `${cmd_cat} /etc/os-release | ${cmd_grep} ^ID=`
eval `${cmd_cat} /etc/os-release | ${cmd_grep} ^VERSION_ID=`

arch=`/bin/uname -p`
                                                                                                    #select the 1st block device only
block_device=`${cmd_lsblk} | ${cmd_grep} disk[[:space:]]$ | ${cmd_head} -n 1 | ${cmd_awk} '{print $1}'`     
block_device_size_raw=`${cmd_lsblk} | ${cmd_grep} disk[[:space:]]$ | ${cmd_awk} '{print $4}' | ${cmd_head} -n 1`
url="https://raw.githubusercontent.com/927technology/kickstart/main"


#main
                                                                                                    #get size unit and size for 1st block device
if [[ "${block_device_size_raw}" =~ "T"$ ]]; then
    block_device_unit=T
elif [[ "${block_device_size_raw}" =~ "G"$ ]]; then
    block_device_unit=G
elif [[ "${block_device_size_raw}" =~ "M"$ ]]; then
    block_device_unit=M
elif [[ "${block_device_size_raw}" =~ "K"$ ]]; then
    block_device_unit=K
fi

block_device_size=`${cmd_echo} ${block_device_size_raw} | ${cmd_sed} 's/'${block_device_unit}'//g'`

case ${VERSION_ID} in
    7 | 7.*)    major_version=7     ;;
    8 | 8.*)    major_version=8     ;;
    9 | 9.*)    major_version=9     ;;
esac

${cmd_curl} ${url}/distro/${ID}/${major_version}/install/source/${arch}/cloud.ks 1> /tmp/cloud.ks 2>/dev/null
${cmd_curl} ${url}/distro/${ID}/${major_version}/repo/${arch}/base.ks 1>  /tmp/repo.ks 2>/dev/null
${cmd_curl} ${url}/distro/${ID}/${major_version}/repo/${arch}/epel.ks 1>> /tmp/repo.ks 2>/dev/null


${cmd_curl} "${url}/distro/el/${major_version}/partition/clear/${block_device}.ks" 1> /tmp/partition.ks 2>/dev/null

case ${block_device_unit} in
    g)
        if [ ${block_device_size} -ge 32 ]; then
            ${cmd_curl} "${url}/distro/el/${major_version}/partition/32g.ks" 1>> /tmp/partition.ks 2>/dev/null
        else
            ${cmd_curl} "${url}/distro/el/${major_version}/partition/auto.ks" 1>> /tmp/partition.ks 2>/dev/null
        fi
    ;;
    *) 
        ${cmd_curl} "${url}/distro/el/${major_version}/partition/auto.ks" 1>> /tmp/partition.ks 2>/dev/null
    ;;
esac