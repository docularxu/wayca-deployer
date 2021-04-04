grep -E -- '^\+ numactl|^[1-9]' log.mem-band.0325.txt 
grep -E -- '^\+ numactl|^0\.' log.mem-rd-latency.0325.txt > log.mem-rd-latency.0325.level0.txt
grep -E -- '^\+ numactl|^[1-9]\.' log.mem-rd-latency.0325.txt > log.mem-rd-latency.0325.level1.txt
grep -E -- '^\+ numactl|^[1-9][0-9]' log.mem-rd-latency.0325.txt > log.mem-rd-latency.0325.level2.txt

grep -E -- '^\+ numactl|^Copy|^Scale|^Add|^Triad|^Number of' log.mem-band.0326.txt 
grep -E -- '^\+ numactl|^Pipe|^\+ LMBENCH|^\+ \/home' log.pipe-latency.0404.txt | sed "s/^\+ numactl/numactl/g" >  log.pipe-latency.0404.filtered.txt



