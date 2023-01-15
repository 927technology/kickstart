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

#bools
true=1
false=0
exitok=0
exitcrit=1

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

#addon
${cmd_curl} ${url}/distro/el/${major_version}/addon.ks 1> /tmp/addon.ks 2>/dev/null
[ ${?} -eq ${exitok} ] && ${cmd_echo} wrote /tmp/addon.ks || ${cmd_echo} faild to write /tmp/addon.ks

#authorization
${cmd_curl} ${url}/distro/el/${major_version}/system/authorization.ks 1> /tmp/authorization.ks 2>/dev/null
[ ${?} -eq ${exitok} ] && ${cmd_echo} wrote /tmp/authorization.ks || ${cmd_echo} faild to write /tmp/authorization.ks

#source repo
${cmd_curl} ${url}/distro/${ID}/${major_version}/install/source/${arch}/cloud.ks 1> /tmp/cloud.ks 2>/dev/null
[ ${?} -eq ${exitok} ] && ${cmd_echo} wrote /tmp/cloud.ks || ${cmd_echo} faild to write /tmp/cloud.ks

#keyboard
${cmd_curl} ${url}/distro/el/${major_version}/keyboard/us.ks 1> /tmp/keyboard.ks 2>/dev/null
[ ${?} -eq ${exitok} ] && ${cmd_echo} wrote /tmp/keyboard.ks || ${cmd_echo} faild to write /tmp/keyboard.ks

#network
${cmd_curl} ${url}/distro/el/${major_version}/network/dhcp/no-ipv6.ks 1> /tmp/network.ks 2>/dev/null
[ ${?} -eq ${exitok} ] && ${cmd_echo} wrote /tmp/network.ks || ${cmd_echo} faild to write /tmp/network.ks

#Repo - Base
${cmd_curl} ${url}/distro/${ID}/${major_version}/repo/${arch}/base.ks 1>  /tmp/repo.ks 2>/dev/null
[ ${?} -eq ${exitok} ] && ${cmd_echo} wrote base into  /tmp/repo.ks || ${cmd_echo} failed to write base into /tmp/repo.ks

#Repo - EPEL
#${cmd_curl} ${url}/distro/${ID}/${major_version}/repo/${arch}/epel.ks 1>> /tmp/repo.ks 2>/dev/null
#[ ${?} -eq ${exitok} ] && ${cmd_echo} wrote epel into /tmp/repo.ks || ${cmd_echo} faild to write epel into /tmp/repo.ks

#partition
${cmd_curl} "${url}/distro/el/${major_version}/partition/clear/${block_device}.ks" 1> /tmp/partition.ks 2>/dev/null
[ ${?} -eq ${exitok} ] && ${cmd_echo} wrote /tmp/partition.ks as clear || ${cmd_echo} faild to write /tmp/partition.ks as clear

#services
${cmd_curl} ${url}/distro/el/${major_version}/services/minimal.ks 1> /tmp/services.ks 2>/dev/null
[ ${?} -eq ${exitok} ] && ${cmd_echo} wrote ${ID} ${major_version} services into /tmp/services.ks || ${cmd_echo} faild to write ${ID} ${major_version} into /tmp/services.ks

${cmd_curl} ${url}/distro/el/${major_version}/services/minimal.ks 1>> /tmp/services.ks 2>/dev/null
[ ${?} -eq ${exitok} ] && ${cmd_echo} wrote el ${major_version} services into /tmp/services.ks || ${cmd_echo} faild to write el ${major_version} into /tmp/services.ks

case ${block_device_unit} in
    G)
        if [ ${block_device_size} -ge 32 ]; then
            ${cmd_curl} "${url}/distro/el/${major_version}/partition/32g.ks" 1>> /tmp/partition.ks 2>/dev/null
            [ ${?} -eq ${exitok} ] && ${cmd_echo} wrote /tmp/partiton.ks as 32g || ${cmd_echo} faild to write /tmp/partition.ks as 32g

        else
            ${cmd_curl} "${url}/distro/el/${major_version}/partition/auto.ks" 1>> /tmp/partition.ks 2>/dev/null
            [ ${?} -eq ${exitok} ] && ${cmd_echo} wrote /tmp/partition.ks as auto || ${cmd_echo} faild to write /tmp/partition.ks as auto

        fi
    ;;
    *) 
        ${cmd_curl} "${url}/distro/el/${major_version}/partition/auto.ks" 1>> /tmp/partition.ks 2>/dev/null
        [ ${?} -eq ${exitok} ] && ${cmd_echo} wrote /tmp/partition.ks as auto || ${cmd_echo} faild to write /tmp/partition.ks as auto

    ;;
esac

${cmd_echo} ID: ${ID}
${cmd_echo} Version ID: ${VERSION_ID}
${cmd_echo} Major Version: ${major_version}
${cmd_echo} Block Device: ${block_device}
${cmd_echo} Block Device Size Raw: ${block_device_size_raw}
${cmd_echo} Block Device Size: ${block_device_size}
${cmd_echo} Block Device Unit: ${block_device_unit}
${cmd_echo} URL: ${url}
