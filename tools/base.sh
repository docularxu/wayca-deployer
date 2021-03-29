#!/bin/bash

function doit()
{
	cmd=$1
	extra_param=$2
	param=$3
	shift 3
	cpu_bindings=("$@")

	for cpu_binding in "${cpu_bindings[@]}"
       	do
	       numactl --physcpubind=$cpu_binding --membind=0 $cmd $extra_param $param
	done
}

function doit_no_membind()
{
	cmd=$1
	extra_param=$2
	param=$3
	shift 3
	cpu_bindings=("$@")

	for cpu_binding in "${cpu_bindings[@]}"
       	do
	       numactl --physcpubind=$cpu_binding $cmd $extra_param $param
	done
}

function doit_membind_looping()
{
	cmd=$1
	extra_param=$2
	param=$3
	shift 3
	cpu_bindings=("$@")
	MEM_INTERLEAVES=("0" "0,1" "0,1,2" "0,1,2,3")

	for cpu_binding in "${cpu_bindings[@]}"
       	do
		for mem_binding in {0..3}
		do
			numactl --physcpubind=$cpu_binding --membind=$mem_binding $cmd $extra_param $param
		done
		for mem_interleaving in "${MEM_INTERLEAVES[@]}"
		do
			numactl --physcpubind=$cpu_binding --interleave=$mem_interleaving $cmd $extra_param $param
		done
	done
}

# spread over 1 CCL/ 2CCL /3CCL /4CCL:
CPU_BINDINGS_4=("0-3" "0,1,4,5" "0,1,4,8" "0,4,8,12")
# spread over 2CCL /3CCL /4CCL/ 5CCL /6CCLs:
CPU_BINDINGS_8=("0-7" "0-2,4-5,8-10" "0-1,4-5,8-9,12-13" "0-1,4,8-9,12,16-17" "0-1,4,8,12-13,16,20")
# spread over 3CCL /4CCL/ 5CCL /6CCLs:
CPU_BINDINGS_12=("0-11" "0-2,4-6,8-10,12-14" "0-1,4-6,8-9,12-14,16-17" "0-1,4-5,8-9,12-13,16-17,20-21")
# spread over 4CCL/ 5CCL /6CCLs:
CPU_BINDINGS_16=("0-15" "0-2,4-6,8-10,12-14,16-19" "0-2,4-5,8-10,12-14,16-17,20-22")

# pipe pairs CCL0..CCL5
CPU_PAIR_0=("1,0" "1,4" "1,8" "1,12" "1,16" "1,20" "0,0")
CPU_PAIR_1=("5,0" "5,4" "5,8" "5,12" "5,16" "5,20" "4,4")
CPU_PAIR_2=("9,0" "9,4" "9,8" "9,12" "9,16" "9,20" "8,8")
CPU_PAIR_3=("13,0" "13,4" "13,8" "13,12" "13,16" "13,20" "12,12")
CPU_PAIR_4=("17,0" "17,4" "17,8" "17,12" "17,16" "17,20" "16,16")
CPU_PAIR_5=("21,0" "21,4" "21,8" "21,12" "21,16" "21,20" "20,20")

