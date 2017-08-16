#!/bin/bash
this_file=$(basename $0)
this_dir=$(dirname $0)
this_dir=$(cd ${this_dir};pwd)
TC=${this_dir}/tc
SUDO="sudo -E"
if [ $(id -u) -eq 0 ];then
    echo "running as root"
    SUDO=
fi

clean_nic(){
    local nic=${1}
    ifconfig ${nic} 1>/dev/null 2>&1 
    if [ $? -ne 0 ];then
        echo "ERROR nic \"${nic}\" not exist"
        return 1
    fi
    ${SUDO} ${TC} filter del dev ${nic} ingress
    ${SUDO} ${TC} filter del dev ${nic} egress
    ${SUDO} ${TC} qdisc del dev ${nic} clsact
    return 0
}

main()
{
    local nic=$1
    if [ "${nic}"x != ""x ];then
        clean_nic ${nic}
        return $?
    fi

    for i in $(ifconfig | grep -o -e ^"[a-zA-Z0-9_\-]*");do 
        echo "INFO clean filter from ${i}" 
        clean_nic ${i}
    done
    return 0
}

main $@
exit $?
