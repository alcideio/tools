#!/bin/bash
this_file=$(basename $0)
this_dir=$(dirname $0)
this_dir=$(cd ${this_dir};pwd)
TC=${this_dir}/tc

main()
{
    sudo -E ${TC} exec bpf dbg
}

main $@
exit $?
