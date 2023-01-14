#!/bin/bash

#cmd reference
cmd_awk=/bin/awk
cmd_echo=/bin/echo
cmd_git=/bin/git
cmd_wget=/bin/cmd_wget

#variables
libdaq_git=https://github.com/snort3/libdaq.git

snort_source=https://github.com/snort3/snort3/archive/refs/tags/3.1.47.0.tar.gz
snort_archive=`${cmd_echo} ${snort_source} | ${cmd_awk} -F"/" '{print $NF}'`
snort_version=`${cmd_echo} ${snort_archive} | ${cmd_awk} -F"." '{print $1}'`



#main
##install libdaq
cd /root
${cmd_git} clone ${libdaq_git}
cd libdaq
./bootstrap
./configure
make
make install



##install snort
${cmd_wget} -q -P /root ${snort_source}
${cmd_tar} -xzf ${snort_archive}
cd /root/snort3-${snort_version}