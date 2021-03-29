#!/bin/bash

set -x
# CPU no. by default starting from 0 and ending at
#  (total number of cores -1)
cpu_start=${CPU_START:-0}
cpu_end=${CPU_END:-$((`nproc`-1))}
cpu_stride=${CPU_STRIDE:-1}

memnode_start=${MEMNODE_START:-0}
memnode_end=${MEMNODE_END:-`numactl --show | grep "membind" | awk '{ print $NF }'`}
memnode_stride=${MEMNODE_STRIDE:-1}

# The benchmarking command to run
COMMAND=${CMD:-"./bw_mem"}
PARAMETERS=${PARAM:-"1024m bcopy"}

echo "Running benchmark: $COMMAND $PARAMETERS"

# for (( m=memnode_start; m<=memnode_end; m+=memnode_stride))
# do

for (( k=cpu_start; k<=cpu_end; k+=cpu_stride ))
do

result=$(numactl --physcpubind=71,$k $COMMAND $PARAMETERS 2>&1)
echo "CPU $k Memnode $m result $result"

done
# done
