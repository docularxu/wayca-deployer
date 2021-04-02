/*
 * TODO: read the topology from sysfs
 */
#include <sys/types.h>
#include <dirent.h>
#include <string.h>

static int nb_cores_in_ccl = -1;
static int nb_cores_in_node = -1;
static int nb_cores_in_package = -1;
static int nb_cores_in_total = -1;
static int nb_nodes_in_package = -1;
static int nb_nodes_in_total = -1;

#define NODE_FNAME 	"/sys/devices/system/node"
#define CPU_FNAME 	"/sys/devices/system/cpu"

int topo_init(void)
{
	DIR *dir;
	struct dirent *dirent;
	unsigned long idx;
	char *endptr;

	/* find number of nodes in total
	 *  - loop through NODE_FNAME, and count the number of node* subdirectoires. I.E.
	 *  # cd $NODE_FNAME
	 *  # ls -d node* | grep -E -- '^node[0-9]' | wc --words
	 */
	dir = opendir(NODE_FNAME);
	if (!dir)
		return 0;

	nb_nodes_in_total = 0;
	while ((dirent = readdir(dir)) != NULL) {
		if (strncmp(dirent->d_name, "node", 4))
			continue;
		idx = strtoul(dirent->d_name+4, &endptr, 0);
		if (endptr == dirent->d_name+4) /* not a number */
			continue;
		nb_nodes_in_total ++;
	}
	closedir(dir);

	/* find nodes in package */
	TODO ?  nb_nodes_in_package?

	/* find number of cores in total
	 *  - loop through CPU_FNAME, and count the number of cpu* subdirectories. IE.
	 *  # cd $CPU_FNAME
	 *  # ls -d cpu* | grep -E -- '^cpu[0-9]' | wc --words
	 */
	dir = opendir(CPU_FNAME);
	if (!dir)
		return 0;

	nb_cores_in_total = 0;
	while ((dirent = readdir(dir)) != NULL) {
		if (strncmp(dirent->d_name, "cpu", 3))
			continue;
		idx = strtoul(dirent->d_name+3, &endptr, 0);
		if (endptr == dirent->d_name+3) /* not a number */
			continue;
		nb_cores_in_total ++;
		/* there could be other things that we can do for a cpu* directory */
		TODO
	}
	closedir(dir);
}

int cores_in_ccl(void)
{
	return nb_cores_in_ccl;
}

int cores_in_node(void)
{
	return nb_cores_in_node;
}

int cores_in_package(void)
{
	return nb_cores_in_package;
}

int cores_in_total(void)
{
	return nb_cores_in_total;
}

int nodes_in_package(void)
{
	return nb_nodes_in_package;
}

int nodes_in_total(void)
{
	return nb_nodes_in_total;
}

/* memory bandwidth (relative value) of speading over multiple CCLs
 *
 * Measured with: bw_mem bcopy
 *
 * Implication:
 *  6 CCLs (clusters) per NUMA node
 *  multiple threads run spreadingly over multiple Clusters. One thread per core.
 */
int mem_bandwidth_6CCL[][6] = {
	/* 1CCL, 2CCLs, 3CCLs, 4CCLs, 5CCLs, 6CCLs */
	{  15,   18,    18,    19,    19,    19},  /* 4 threads */
	{  0,    23,    23,    24,    24,    24},  /* 8 threads */
	{  0,    0,     28,    28,    28,    29},  /* 12 threads */
	{  0,    0,     0,     31,    32,    31},  /* 16 threads */
};

/* memory bandwidth (relative value) of speading over multiple NUMA nodes
 *
 * Measured with: bw_mem bcopy
 *
 * Implication:
 *  4 NUMA nodes
 *  multiple threads run spreadingly over multiple NUMA nodes. One thread per core.
 */
int mem_bandwidth_4NUMA[][4] = {
	/* 1NUMA, 2NUMA, 3NUMA, 4NUMA */
	{  33,    55,    68,    79 }, /* 24 threads */
	{  0,     66,    92,    112}, /* 48 threads */
	{  0,     0,     99,    130}  /* 72 threads */
};

/* memory bandwidth when computing is on one NUMA, but memory is interleaved on different NUMA node(s)
 * Measured with: numactl --interleave, bw_mem bcopy
 *
 * Implication:
 *  4 NUMA nodes
 *  multiple threads run spreadingly over multiple NUMA nodes. One thread per core.
 */
int mem_bandwidth_interleave_4NUMA[][7] = {
	/* Same | Neighbor | Remote | Remote | Neighbor |         |         *
	 * NUMA |  NUMA    | NUMA0  | NUMA1  |  2 NUMAs | 3 NUMAs | 4 NUMAs */
	{  19,    5,         9,       6,       9,         11,       9 },    /* 4 threads */
	{  24,    5,         7,       6,       10,        14,       13},    /* 8 threads */
	{  29,    5,         7,       6,       10,        15,       13},    /* 12 threads */
	{  31,    5,         7,       6,       10,        16,       13}     /* 16 threads */
};

/* memory read latency for range [1M ~ 8M], multiple threads spreading over multiple CCLs, same NUMA
 *
 * Measured with: lat_mem_rd
 * Implication:
 *  6 CCLs (clusters) per NUMA node
 *  multiple threads run spreadingly over multiple Clusters. One thread per core.
 */
int mem_rd_latency_1M_6CCL[][6] = {
	/* 1CCL, 2CCLs, 3CCLs, 4CCLs, 5CCLs, 6CCLs */
	{  13,   6,     4,     4,     4,     4 },  /* 4 threads */
	{  0,    12,    6,     9,     5,     5 },  /* 8 threads */
	{  0,    0,     16,    15,    12,    10},  /* 12 threads */
	{  0,    0,     0,     17,    14,    12},  /* 16 threads */
};

/* memory read latency for range [12M ~ 2G+], multiple threads spreading over multiple CCLs, same NUMA
 *
 * Measured with: lat_mem_rd
 * Implication:
 *  6 CCLs (clusters) per NUMA node
 *  multiple threads run spreadingly over multiple Clusters. One thread per core.
 */
int mem_rd_latency_12M_6CCL[][6] = {
	/* 1CCL, 2CCLs, 3CCLs, 4CCLs, 5CCLs, 6CCLs */
	{  13,   8,     6,     6,     6,     6 },  /* 4 threads */
	{  0,    14,    9,     9,     8,     8 },  /* 8 threads */
	{  0,    0,     15,    12,    11,    11},  /* 12 threads */
	{  0,    0,     0,     16,    14,    13},  /* 16 threads */
};

/* memory read latency for range [1M ~ 8M], multiple threads spreading over multiple NUMAs
 *
 * Measured with: lat_mem_rd
 * Implication:
 *  4 NUMA nodes
 *  multiple threads run spreadingly over multiple NUMAs. One thread per core.
 */
int mem_rd_latency_1M_4NUMA[][4] = {
	/* 1NUMA, 2NUMA, 3NUMA, 4NUMA */
	{  19,    16,    11,    6  }, /* 24 threads */
	{  0,     19,    17,    14 }, /* 48 threads */
	{  0,     0,     17,    9  }  /* 72 threads */
};

/* memory read latency for range [12M ~ 2G+], multiple threads spreading over multiple NUMAs
 *
 * Measured with: lat_mem_rd
 * Implication:
 *  4 NUMA nodes
 *  multiple threads run spreadingly over multiple NUMAs. One thread per core.
 */
int mem_rd_latency_12M_4NUMA[][4] = {
	/* 1NUMA, 2NUMA, 3NUMA, 4NUMA */
	{  21,    15,    14,    8  }, /* 24 threads */
	{  0,     20,    16,    15 }, /* 48 threads */
	{  0,     0,     18,    12 }  /* 72 threads */
};

/* pipe latency within the same CCL, and across two CCLs of the same NUMA
 *
 * Measaured with: lat_pipe
 * Implications:
 *  6 CCLs (clusters) per NUMA node
 *  Pipe latencies between different CCLs have no notice-worthy difference. Just categorized
 *     'cross CCLs' in below.
 */
int pipe_latency_CCL[3] = {
	/* same | same | cross *
	 * CPU  | CCL  | CCLs  */
	   46,    49,    66   /* 2 processes in pipe communitcaiton */
};

/* pipe latency across NUMA nodes */
int pipe_latency_NUMA[4] = {
	/* Same NUMA | Neighbor | Remote | Remote *
	 * diff CCLs |  NUMAs   | NUMA0  | NUMA1  */
'TBD
};