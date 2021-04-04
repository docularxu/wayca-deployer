#!/bin/bash

set -x

# The benchmarking command to run
COMMAND=${CMD:-"/home/guodong/attractivechaos.benchmarks.git/lock/lock_test"}
#
# Usage: lock_test [-t nThreads=1] [-n size=1000000] [-m repeat=100] [-l lockType=1]
# Lock type: 0 for single-thread; 1 for gcc builtin; 2 for spin lock; 3 for pthread spin; 4 for mutex;
#            5 for semaphore; 6 for buffer+spin; 7 for buffer+mutex

REPETITION=1

# 3-pthread-spin; 4-mutex
for (( type=3; type<=4; type+=1 ))
do

for cpu_binding in "0-3" "0-1,4-5" "0-1,4,8" "0,4,8,12" "0,1,24,25" "0,1,48,49" "0,1,72,73" "0,24,48,72"
do

	for (( repetition=1; repetition<=$REPETITION; repetition+=1 ))
	do
		echo "Benching CPU $cpu_binding for lock_type $type, round $repetition:"
		numactl --physcpubind=$cpu_binding --membind=0 $COMMAND -t 4 -n 1000000 -m 100 -l $type  2>&1
	done
done
done

