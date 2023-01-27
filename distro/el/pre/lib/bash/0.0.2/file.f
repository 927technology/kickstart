function file.isempty {
    #accepts 1 arg file name.  returns boolean true if file is empty

    local lfile=${1}
    local lexitcode=${false}

    [ -s ${lfile} ] && lexitcode=${false} || lexitcode=${true}

    ${cmd_echo} ${lexitcode}
}
