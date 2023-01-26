#!/bin/bash

#functions
function config.get {
    #accepts 1 argument, setting to be queried.  outputs configuration from git repo to /tmp

    local lsetting=${1}

    #Query ID/Version/Arch
    ${cmd_echo} ${ID}/${major_version}/${lsetting}/${arch}
    ${cmd_curl} -sf ${url}/distro/${ID}/${major_version}/${lsetting}/${arch}/config.ks               > /tmp/${lsetting}.ks
    ${cmd_curl} -sf ${url}/distro/${ID}/${major_version}/${lsetting}/${arch}/${build}.ks            >> /tmp/${lsetting}.ks
    ${cmd_echo} writing /tmp/${lsetting}.ks
    ${cmd_echo}

    #Query ID/Version
    ${cmd_echo} ${ID}/${major_version}/${lsetting}
    ${cmd_curl} -sf ${url}/distro/${ID}/${major_version}/${lsetting}/config.ks                      >> /tmp/${lsetting}.ks
    ${cmd_curl} -sf ${url}/distro/${ID}/${major_version}/${lsetting}/${build}.ks                    >> /tmp/${lsetting}.ks
    ${cmd_echo} writing /tmp/${lsetting}.ks
    ${cmd_echo}

    #Query ID/Arch
    ${cmd_echo} ${ID}/${lsetting}/${arch}
    ${cmd_curl} -sf ${url}/distro/${ID}/${lsetting}/${arch}/config.ks                                       >> /tmp/${lsetting}.ks
    ${cmd_curl} -sf ${url}/distro/${ID}/${lsetting}/${arch}/${build}.ks                                     >> /tmp/${lsetting}.ks
    ${cmd_echo} writing /tmp/${lsetting}.ks
    ${cmd_echo}

    #Query ID
    ${cmd_echo} ${ID}/${lsetting}
    ${cmd_curl} -sf ${url}/distro/${ID}/${lsetting}/config.ks                                       >> /tmp/${lsetting}.ks
    ${cmd_curl} -sf ${url}/distro/${ID}/${lsetting}/${build}.ks                                     >> /tmp/${lsetting}.ks
    ${cmd_echo} writing /tmp/${lsetting}.ks
    ${cmd_echo}

    #Query EL/Version/Arch
    ${cmd_echo} el/${major_version}/${arch}/${lsetting}
    ${cmd_curl} -sf ${url}/distro/el/${major_version}/${lsetting}/${arch}/config.ks                 >> /tmp/${lsetting}.ks
    ${cmd_curl} -sf ${url}/distro/el/${major_version}/${lsetting}/${arch}/${build}.ks               >> /tmp/${lsetting}.ks
    ${cmd_echo} writing /tmp/${lsetting}.ks
    ${cmd_echo}

    #Query EL/Version
    ${cmd_echo} el/${major_version}/${lsetting}
    ${cmd_curl} -sf ${url}/distro/el/${major_version}/${lsetting}/config.ks                         >> /tmp/${lsetting}.ks
    ${cmd_curl} -sf ${url}/distro/el/${major_version}/${lsetting}/${build}.ks                       >> /tmp/${lsetting}.ks
    ${cmd_echo} writing /tmp/${lsetting}.ks
    ${cmd_echo}

    #Query EL/Arch
    ${cmd_echo} el/${lsetting}/${arch}
    ${cmd_curl} -sf ${url}/distro/el/${lsetting}/${arch}/${build}.ks                                          >> /tmp/${lsetting}.ks
    ${cmd_curl} -sf ${url}/distro/el/${lsetting}/${arch}/config.ks                                          >> /tmp/${lsetting}.ks
    ${cmd_echo} writing /tmp/${lsetting}.ks
    ${cmd_echo}

    #Query EL
    ${cmd_echo} el/${lsetting}
    ${cmd_curl} -sf ${url}/distro/el/${lsetting}/${build}.ks                                        >> /tmp/${lsetting}.ks
    ${cmd_curl} -sf ${url}/distro/el/${lsetting}/config.ks                                          >> /tmp/${lsetting}.ks
    ${cmd_echo} writing /tmp/${lsetting}.ks
    ${cmd_echo}
}
function file.isempty {
    #accepts 1 arg file name.  returns boolean true if file is empty

    local lfile=${1}
    local lexitcode=${false}

    [ -s ${lfile} ] && lexitcode=${false} || lexitcode=${true}

    ${cmd_echo} ${lexitcode}
}

#variables
#url=${1}                                                                                            #url from kickstart                                                                                                   
source /tmp/variables.v                                                                             #source varables provided by kickstart
                                                                                                    #source bools from git
/bin/curl -s ${url}/distro/el/pre/lib/bash/${bash_lib_ver}/bool.v                                      > /tmp/bool.v
source /tmp/bool.v
                                                                                                    #source dracut commands from git
/bin/curl -s ${url}/distro/el/pre/lib/bash/${bash_lib_ver}/cmd_dracut.v                                > /tmp/cmd_dracut.v
source /tmp/cmd_dracut.v

                                                                                                    #get ID and Version form initrd
eval `${cmd_cat} /etc/os-release | ${cmd_grep} ^ID=`
eval `${cmd_cat} /etc/os-release | ${cmd_grep} ^VERSION_ID=`

                                                                                                    #get arch from kernel
arch=`/bin/uname -p`
                                                                                                    #select the 1st block device only
block_device=`${cmd_lsblk} | ${cmd_grep} disk[[:space:]]$ | ${cmd_head} -n 1 | ${cmd_awk} '{print $1}'`
block_device_size_raw=`${cmd_lsblk} | ${cmd_grep} disk[[:space:]]$ | ${cmd_awk} '{print $4}' | ${cmd_head} -n 1`

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
config.get addon

#anaconda
config.get anaconda
#authorization
config.get authorization

#firstboot
config.get firstboot

#language
config.get language

#keyboard
config.get keyboard

#network
config.get network

#Repo
config.get repo

#packages
config.get packages

#partition - clear
${cmd_curl} -sf "${url}/distro/el/${major_version}/partition/clear/${block_device}.ks"              1> /tmp/partition.ks 2>/dev/null
[ ${?} -eq ${exitok} ] && ${cmd_echo} wrote /tmp/partition.ks as clear || ${cmd_echo} failed to write /tmp/partition.ks as clear

#partition - sometimes if there is a partiton already configured el will fail
${cmd_udevadm} settle
${cmd_dmsetup} remove_all

# De-activate exiting Volume Groups
${cmd_vgchange} -an system
${cmd_vgchange} -an os
${cmd_vgchange} -an ol_minimal

# Clear software raid devices if any
raid_devices=`${cmd_mktemp} /tmp/mdstat.XXXXXXXXX`
${cmd_cat} /proc/mdstat | ${cmd_grep} ^md | ${cmd_cut} -d : -f 1                                    > ${raid_devices}

if [ -s ${raid_devices} ]; then
    for raid_device in `${cmd_cat} ${raid_devices}`;do
       ${cmd_wipefs} -f -a /dev/${raid_device}
       ${cmd_mdadm} --stop -f /dev/${raid_device}
       if [ ${?} != ${exitok} ]; then
          ${cmd_udevadm} settle
          ${cmd_dmsetup} remove_all
          ${cmd_mdadm} --stop -f /dev/${raid_device}
       fi
   done
fi

${cmd_rm} -vf ${raid_devices}

${cmd_wipefs} -f -a /dev/${block_device}

#partition - select partition scheme
case ${block_device_unit} in
    G)
        if [ ${block_device_size} -ge 32 ]; then
            ${cmd_curl} -sf ${url}/distro/el/partition/scheme/32g.ks                                1> /tmp/partition.ks 2>/dev/null
            [ ${?} -eq ${exitok} ] && ${cmd_echo} wrote /tmp/partiton.ks as 32g || ${cmd_echo} failed to write /tmp/partition.ks as 32g
        else
            ${cmd_curl} -sf ${url}/distro/el/partition/scheme/auto.ks                               1> /tmp/partition.ks 2>/dev/null
            [ ${?} -eq ${exitok} ] && ${cmd_echo} wrote /tmp/partition.ks as auto || ${cmd_echo} failed to write /tmp/partition.ks as auto
        fi
    ;;
    *)
        ${cmd_curl} -sf ${url}/distro/el/partition/scheme/auto.ks                                   1>> /tmp/partition.ks 2>/dev/null
        [ ${?} -eq ${exitok} ] && ${cmd_echo} wrote /tmp/partition.ks as auto || ${cmd_echo} failed to write /tmp/partition.ks as auto
    ;;
esac

#services
config.get services

#source
config.get source

#timezone
config.get timezone

#type
config.get type

#users
config.get users

#output
${cmd_echo} ID: ${ID}
${cmd_echo} Version ID: ${VERSION_ID}
${cmd_echo} Major Version: ${major_version}
${cmd_echo} Block Device: ${block_device}
${cmd_echo} Block Device Size Raw: ${block_device_size_raw}
${cmd_echo} Block Device Size: ${block_device_size}
${cmd_echo} Block Device Unit: ${block_device_unit}
${cmd_echo} URL: ${url}
