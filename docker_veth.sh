#!/bin/bash

container_veth()
{
    local container=$1
    if [ "${container}"x = ""x ];then
        echo "ERROR missing container name"
        return 1
    fi

    if [ $(docker ps | grep attack | wc -l) -eq 0 ];then
        echo "ERROR container \"${container}\" not exist"
        return 1
    fi

    if [ $(docker ps | grep attack | wc -l) -gt 1 ];then
        echo "ERROR more then one container with name \"${container}\""
        return 1
    fi

    iflink=$(docker exec -it ${container} /bin/cat /sys/class/net/eth0/iflink | tr -d '\r')
    #echo "iflink \"${iflink}\""

    for v in $(ls /sys/class/net/ | grep veth);do 
        veth_index=$(cat /sys/class/net/$v/ifindex)
        #echo "$v : \"${veth_index}\"";
        if [ "${veth_index}"x = "${iflink}"x ];then 
            echo $v
            return 0
        fi
    done

    return 1
}

main()
{
    which docker 1>/dev/null 2>&1
    if [ $? -ne 0 ];then
        echo "ERROR failed find docker tool"
        return 1
    fi

    for c in $(docker ps | xargs -L 1 echo | tail -n +2 | grep -o -e " [a-zA-Z0-9_\-]*"$ | xargs echo);do 
        veth=$(container_veth ${c})
        if [ $? -ne 0 ];then
            echo "ERROR failed to get veth of \"${c}\""
            return 1
        fi
        echo "${c} ${veth}"
    done
    return 0
}

main $@
exit $?
