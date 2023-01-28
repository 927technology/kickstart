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
    ${cmd_curl} -sf ${url}/distro/${ID}/${lsetting}/${arch}/config.ks                               >> /tmp/${lsetting}.ks
    ${cmd_curl} -sf ${url}/distro/${ID}/${lsetting}/${arch}/${build}.ks                             >> /tmp/${lsetting}.ks
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
    ${cmd_curl} -sf ${url}/distro/el/${lsetting}/${arch}/${build}.ks                                >> /tmp/${lsetting}.ks
    ${cmd_curl} -sf ${url}/distro/el/${lsetting}/${arch}/config.ks                                  >> /tmp/${lsetting}.ks
    ${cmd_echo} writing /tmp/${lsetting}.ks
    ${cmd_echo}

    #Query EL
    ${cmd_echo} el/${lsetting}
    ${cmd_curl} -sf ${url}/distro/el/${lsetting}/${build}.ks                                        >> /tmp/${lsetting}.ks
    ${cmd_curl} -sf ${url}/distro/el/${lsetting}/config.ks                                          >> /tmp/${lsetting}.ks
    ${cmd_echo} writing /tmp/${lsetting}.ks
    ${cmd_echo}
}
