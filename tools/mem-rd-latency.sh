#!/bin/bash

set -x;
source base.sh

# lmbench/lat_mem_rd
CMD="/home/guodong/lmbench-3.0-a9/bin/lat_mem_rd"


# Benchmarking latency of crossing CCLs
#   Both CPUs and memory are on the same NUMA, i.e. NUMA0

if [ 1 -eq 0 ]; then
# spread over 1 CCL/ 2CCL /3CCL /4CCL:
CPU_BINDINGS=("0-3" "0,1,4,5" "0,1,4,8" "0,4,8,12" "8,12,16,20")
EXTRA_PARAM="-P 4"
PARAM="4096"
# do it
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# spread over 2CCL /3CCL /4CCL/ 5CCL /6CCLs:
CPU_BINDINGS=("0-7" "0-2,4-5,8-10" "0-1,4-5,8-9,12-13" "0-1,4,8-9,12,16-17" "0-1,4,8,12-13,16,20")
EXTRA_PARAM="-P 8"
PARAM="4096"
# do it
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# spread over 3CCL /4CCL/ 5CCL /6CCLs:
CPU_BINDINGS=("0-11" "0-2,4-6,8-10,12-14" "0-1,4-6,8-9,12-14,16-17" "0-1,4-5,8-9,12-13,16-17,20-21")
PARAM="2048"
EXTRA_PARAM="-P 12"
# do it
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# spread over 4CCL/ 5CCL /6CCLs:
CPU_BINDINGS=("0-15" "0-2,4-6,8-10,12-14,16-19" "0-2,4-5,8-10,12-14,16-17,20-22")
PARAM="2048"
EXTRA_PARAM="-P 16"
# do it
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# Benchmarking of latency over NUMA nodes
#   CPUs on multi-NUMA nodes, and memory follows CPUs.
#
# Info: memory is malloc'ed in each individual process, so there is no
#   need to do membinding. 

# for each NUMA node, this benchmark needs use: "2048"MB *24 core = 48GB
# Note: there is more than 96GB (double of 48GB) memory on each NUMA node.
PARAM="2048"

# 24 threads， spread over 1 NUMA / 2 NUMA / 3 NUMA / 4 NUMA nodes:
CPU_BINDINGS=("0-23" "0-11,24-35" "0-7,24-31,48-55" "0-5,24-29,48-53,72-77")
EXTRA_PARAM="-P 24"
# do it without membind
doit_no_membind "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# 48 threads， spread over 2 NUMA / 3 NUMA / 4 NUMA nodes:
CPU_BINDINGS=("0-47" "0-15,24-39,48-63" "0-11,24-35,48-59,72-83")
EXTRA_PARAM="-P 48"
# do it without membind
doit_no_membind "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# 72 threads， spread over 3 NUMA / 4 NUMA nodes:
CPU_BINDINGS=("0-71" "0-17,24-41,48-65,72-89")
EXTRA_PARAM="-P 72"
# do it without membind
doit_no_membind "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"
fi


# Benchmarking cross NUMA latency:
#   i.e. CPUs on NUMA0 ==> Memory on NUMA0..3

# spread over 1 CCL/ 2CCL /3CCL /4CCL:
CPU_BINDINGS=("0-3" "0,1,4,5" "0,1,4,8" "0,4,8,12")
EXTRA_PARAM="-P 4"
PARAM="4096"
# do it
doit_membind_looping "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# spread over 2CCL /3CCL /4CCL/ 5CCL /6CCLs:
CPU_BINDINGS=("0-7" "0-2,4-5,8-10" "0-1,4-5,8-9,12-13" "0-1,4,8-9,12,16-17" "0-1,4,8,12-13,16,20")
EXTRA_PARAM="-P 8"
PARAM="4096"
# do it
doit_membind_looping "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# spread over 3CCL /4CCL/ 5CCL /6CCLs:
CPU_BINDINGS=("0-11" "0-2,4-6,8-10,12-14" "0-1,4-6,8-9,12-14,16-17" "0-1,4-5,8-9,12-13,16-17,20-21")
PARAM="2048"
EXTRA_PARAM="-P 12"
# do it
doit_membind_looping "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# spread over 4CCL/ 5CCL /6CCLs:
CPU_BINDINGS=("0-15" "0-2,4-6,8-10,12-14,16-19" "0-2,4-5,8-10,12-14,16-17,20-22")
PARAM="2048"
EXTRA_PARAM="-P 16"
# do it
doit_membind_looping "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

