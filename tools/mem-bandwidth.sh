#!/bin/bash

set -x; 
source base.sh

# stream
CMD="/home/guodong/stream/Code/stream.100m.100.openmp"
PARAM=""
EXTRA_PARAM=""

if [ 1 -eq 0 ]; then
# Stream 4 threads， spread over 1 CCL/ 2CCL /3CCL /4CCL:
OMP_NUM_THREADS=4 CPU_BINDINGS=("0-3" "0,1,4,5" "0,1,4,8" "0,4,8,12" "8,12,16,20") 
# do it
# for cpu_binding in "${CPU_BINDINGS[@]}"; do numactl --physcpubind=$cpu_binding $CMD $PARAM; done;
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# Stream 8 threads， spread over 2CCL /3CCL /4CCL/ 5CCL /6CCLs:
OMP_NUM_THREADS=8 CPU_BINDINGS=("0-7" "0-2,4-5,8-10" "0-1,4-5,8-9,12-13" "0-1,4,8-9,12,16-17" "0-1,4,8,12-13,16,20")
# do it
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# Stream 12 threads， spread over 3CCL /4CCL/ 5CCL /6CCLs:
OMP_NUM_THREADS=12 CPU_BINDINGS=("0-11" "0-2,4-6,8-10,12-14" "0-1,4-6,8-9,12-14,16-17" "0-1,4-5,8-9,12-13,16-17,20-21")
# do it
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# Stream 16 threads， spread over 4CCL/ 5CCL /6CCLs:
OMP_NUM_THREADS=16 CPU_BINDINGS=("0-15" "0-2,4-6,8-10,12-14,16-19" "0-2,4-5,8-10,12-14,16-17,20-22")
# do it
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# 24 threads， spread over 1 NUMA / 2 NUMA / 3 NUMA / 4 NUMA nodes:
OMP_NUM_THREADS=24
CPU_BINDINGS=("0-23" "0-11,24-35" "0-7,24-31,48-55" "0-5,24-29,48-53,72-77")
# do it without membind
doit_no_membind "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# 48 threads， spread over 2 NUMA / 3 NUMA / 4 NUMA nodes:
OMP_NUM_THREADS=48
CPU_BINDINGS=("0-47" "0-15,24-39,48-63" "0-11,24-35,48-59,72-83")
# do it without membind
doit_no_membind "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# 72 threads， spread over 3 NUMA / 4 NUMA nodes:
OMP_NUM_THREADS=72
CPU_BINDINGS=("0-71" "0-17,24-41,48-65,72-89")
# do it without membind
doit_no_membind "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"
fi

# lmbench/bw_mem
for what in rd wr rdwr cp fwr frd fcp bzero bcopy
do
CMD="/home/guodong/lmbench-3.0-a9/bin/bw_mem"
PARAM="4096m "$what

if [ 1 -eq 0 ]; then
# Stream 4 threads， spread over 1 CCL/ 2CCL /3CCL /4CCL:
OMP_NUM_THREADS=4 CPU_BINDINGS=("0-3" "0,1,4,5" "0,1,4,8" "0,4,8,12" "8,12,16,20")
EXTRA_PARAM="-P 4"
# do it
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# Stream 8 threads， spread over 2CCL /3CCL /4CCL/ 5CCL /6CCLs:
OMP_NUM_THREADS=8 CPU_BINDINGS=("0-7" "0-2,4-5,8-10" "0-1,4-5,8-9,12-13" "0-1,4,8-9,12,16-17" "0-1,4,8,12-13,16,20")
EXTRA_PARAM="-P 8"
# do it
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# Stream 12 threads， spread over 3CCL /4CCL/ 5CCL /6CCLs:
OMP_NUM_THREADS=12 CPU_BINDINGS=("0-11" "0-2,4-6,8-10,12-14" "0-1,4-6,8-9,12-14,16-17" "0-1,4-5,8-9,12-13,16-17,20-21")
PARAM="2048m "$what
EXTRA_PARAM="-P 12"
# do it
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# Stream 16 threads， spread over 4CCL/ 5CCL /6CCLs:
OMP_NUM_THREADS=16 CPU_BINDINGS=("0-15" "0-2,4-6,8-10,12-14,16-19" "0-2,4-5,8-10,12-14,16-17,20-22")
PARAM="2048m "$what
EXTRA_PARAM="-P 16"
# do it
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# 24 threads， spread over 1 NUMA / 2 NUMA / 3 NUMA / 4 NUMA nodes:
OMP_NUM_THREADS=24
CPU_BINDINGS=("0-23" "0-11,24-35" "0-7,24-31,48-55" "0-5,24-29,48-53,72-77")
PARAM="2048m "$what
EXTRA_PARAM="-P 24"
# do it without membind
doit_no_membind "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# 48 threads， spread over 2 NUMA / 3 NUMA / 4 NUMA nodes:
OMP_NUM_THREADS=48
CPU_BINDINGS=("0-47" "0-15,24-39,48-63" "0-11,24-35,48-59,72-83")
PARAM="2048m "$what
EXTRA_PARAM="-P 48"
# do it without membind
doit_no_membind "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# 72 threads， spread over 3 NUMA / 4 NUMA nodes:
OMP_NUM_THREADS=72
CPU_BINDINGS=("0-71" "0-17,24-41,48-65,72-89")
PARAM="2048m "$what
EXTRA_PARAM="-P 72"
# do it without membind
doit_no_membind "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"
fi

# CPU on NUMA0 ==> Memory on (NUMA0, NUMA1, NUMA2, or NUMA3)
# spread over 1 CCL/ 2CCL /3CCL /4CCL:
CPU_BINDINGS=("0-3" "0,1,4,5" "0,1,4,8" "0,4,8,12")
EXTRA_PARAM="-P 4"
# do it
doit_membind_looping "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# spread over 2CCL /3CCL /4CCL/ 5CCL /6CCLs:
CPU_BINDINGS=("0-7" "0-2,4-5,8-10" "0-1,4-5,8-9,12-13" "0-1,4,8-9,12,16-17" "0-1,4,8,12-13,16,20")
EXTRA_PARAM="-P 8"
# do it
doit_membind_looping "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# spread over 3CCL /4CCL/ 5CCL /6CCLs:
CPU_BINDINGS=("0-11" "0-2,4-6,8-10,12-14" "0-1,4-6,8-9,12-14,16-17" "0-1,4-5,8-9,12-13,16-17,20-21")
PARAM="2048m "$what
EXTRA_PARAM="-P 12"
# do it
doit_membind_looping "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# spread over 4CCL/ 5CCL /6CCLs:
CPU_BINDINGS=("0-15" "0-2,4-6,8-10,12-14,16-19" "0-2,4-5,8-10,12-14,16-17,20-22")
PARAM="2048m "$what
EXTRA_PARAM="-P 16"
# do it
doit_membind_looping "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

done
