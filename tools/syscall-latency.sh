#!/bin/bash

set -x; 
source base.sh

# stream
CMD="/home/guodong/lmbench-3.0-a9/bin/lat_syscall"
PARAM=""
EXTRA_PARAM=""

# syscall latency benchmarking
for what in null read write
do

# 4 processes spread over 1 CCL/ 2CCL /3CCL /4CCL:
CPU_BINDINGS=("0-3" "0,1,4,5" "0,1,4,8" "0,4,8,12")
PARAM="-P 4 -N 10 -W 2 ${what}"
# do it
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# 8 processes spread over 2CCL /3CCL /4CCL/ 5CCL /6CCLs:
CPU_BINDINGS=("0-7" "0-2,4-5,8-10" "0-1,4-5,8-9,12-13" "0-1,4,8-9,12,16-17" "0-1,4,8,12-13,16,20")
PARAM="-P 8 -N 10 -W 2 ${what}"
# do it
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# 12 processes spread over 3CCL /4CCL/ 5CCL /6CCLs:
CPU_BINDINGS=("0-11" "0-2,4-6,8-10,12-14" "0-1,4-6,8-9,12-14,16-17" "0-1,4-5,8-9,12-13,16-17,20-21")
PARAM="-P 12 -N 10 -W 2 ${what}"
# do it
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

# 16 processes spread over 4CCL/ 5CCL /6CCLs:
CPU_BINDINGS=("0-15" "0-2,4-6,8-10,12-14,16-19" "0-2,4-5,8-10,12-14,16-17,20-22")
PARAM="-P 16 -N 10 -W 2 ${what}"
# do it
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_BINDINGS[@]}"

done
