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


main()
{
    ${SUDO} ${TC} exec bpf dbg
}

main $@
exit $?
