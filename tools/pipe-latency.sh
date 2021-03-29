#!/bin/bash

set -x; 
source base.sh

CMD="/home/guodong/lmbench-3.0-a9/bin/lat_pipe"
PARAM="-W 10 -N 100" 
EXTRA_PARAM=""

# Benchmark pipe latency between each and every pair of cores from CCL0 to CCL5
#   , at stride of 4 (CCL size):
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_PAIR_0[@]}"
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_PAIR_1[@]}"
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_PAIR_2[@]}"
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_PAIR_3[@]}"
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_PAIR_4[@]}"
doit "${CMD}" "${EXTRA_PARAM}" "${PARAM}" "${CPU_PAIR_5[@]}"
