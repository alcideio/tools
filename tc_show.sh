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


show_nic(){
    local nic=${1}
    ifconfig ${nic} 1>/dev/null 2>&1 
    if [ $? -ne 0 ];then
        echo "ERROR nic \"${nic}\" not exist"
        return 1
    fi
    echo ""
    echo "INFO ${i} filter" 
    echo "====================" 
    for gress in ingress egress;do
        ${SUDO} ${TC} filter show dev ${nic} ${gress}
    done
    return 0
}

main()
{
    local nic=$1
    if [ "${nic}"x != ""x ];then
        show_nic ${nic}
        return $?
    fi

    for i in $(ifconfig | grep -o -e ^"[a-zA-Z0-9_\-]*");do 
        show_nic ${i}
    done
    return 0
}

main $@
exit $?
