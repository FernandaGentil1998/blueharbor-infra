\# Lab 04 — Advanced Virtualisation Administration



\## Exercise 4.1 — Inventory Hypervisor and Plan Capacity



\### 1. Hypervisor Inventory



| Property | Value |

|---|---|

| Host operating system | Windows 11 |

| Processor | AMD Ryzen AI 9 365 w/ Radeon 880M |

| Physical CPU cores | 10 |

| Logical processors (threads) | 20 |

| Total host memory | 32,043 MB (\~31.3 GiB) |

| Available memory at inventory time | 11,890 MB (\~11.6 GiB) |

| Hardware virtualization | Supported |

| Nested paging | Supported |



\### 2. Virtual Machine Inventory



| Virtual Machine | vCPUs | RAM | Disk Capacity |

|---|---:|---:|---:|

| DC01 | 2 | 4 GB | 60 GB |

| WEB01 | 1 | 2 GB | 25 GB |

| WEB02 | 1 | 1 GB | 25 GB |

| STOR01 | 1 | 1 GB | 45 GB |

| \*\*Total\*\* | \*\*5\*\* | \*\*8 GB\*\* | \*\*155 GB\*\* |



Disk capacity represents logical provisioned capacity. Some VM disks are differencing disks that share parent disks, so these values should not be interpreted as the physical storage currently consumed.



\### 3. CPU Overcommit Ratio



Total allocated virtual CPUs: 5



Total host logical processors: 20



Formula:



`CPU overcommit ratio = Total VM vCPUs / Host logical processors`



`5 / 20 = 0.25:1`



The CPU overcommit ratio is low. The current virtual machine configuration does not indicate significant CPU overcommitment.



\### 4. RAM Commitment



Total allocated VM memory: 8,192 MB



Reserved memory for the host operating system: 4,096 MB



Total committed memory:



`8,192 + 4,096 = 12,288 MB`



Total physical host memory: 32,043 MB



Formula:



`RAM commitment = (VM RAM + Host OS reserve) / Total host RAM × 100`



`12,288 / 32,043 × 100 = 38.35%`



The calculated RAM commitment is approximately 38.35%, leaving sufficient theoretical memory capacity for the current VM configuration.



\### 5. Capacity Assessment



\*\*Which VMs can run together without swapping?\*\*



Based on the inventory, all four virtual machines can potentially run simultaneously without significant memory pressure. Their combined configured memory is 8 GB, while the host has approximately 31.3 GiB of physical memory. At the time of inventory, approximately 11.6 GiB was available.



Actual memory usage should still be monitored because guest operating systems, background applications and host processes consume additional resources.



\*\*What would you upgrade first to run all VMs?\*\*



No hardware upgrade appears necessary for the current configuration. The host has sufficient CPU capacity and RAM to support all four virtual machines based on the calculated commitment ratios.



If future workloads require additional capacity, RAM should be monitored first because memory exhaustion can lead to swapping and performance degradation.



\### 6. Conclusion



The host currently has sufficient resources to support the four registered virtual machines. CPU overcommitment is low (0.25:1), and RAM commitment is approximately 38.35%.



The inventory also identifies dynamically allocated and differencing VDI disks. Linked clones share parent disk data, which reduces duplicated storage consumption but creates dependencies on their base disks.

