\# Lab 04 — Resource Allocation and Performance



\## 1. CPU Performance



\### Baseline — 1 vCPU



Command:

```bash

stress-ng --cpu 2 --timeout 30s --metrics-brief

```



| Metric | Result |

|---|---:|

| Bogo operations | 20,071 |

| Real time | 30.01 s |

| Bogo ops/s (real time) | 668.84 |

| Bogo ops/s (CPU time) | 691.95 |

| Failed | 0 |



\### 2 vCPUs and CPU Execution Cap



The VM was configured with 2 vCPUs and tested with a 100% CPU execution cap. The stress-ng process repeatedly stalled and did not produce reliable metrics.



The test was also attempted with a 50% CPU execution cap, but the VM became unresponsive.



Both tests were considered inconclusive. No performance comparison was recorded.



The CPU execution cap was restored to 100%.



\## 2. Memory Performance



The VM has 1024 MB of configured RAM (961 MiB available to the guest OS) and 2 GB of swap.



The workbook's original 1200 MB stress test was reduced to 400 MB to avoid exhausting the VM's available memory.



Command:

```bash

stress-ng --vm 1 --vm-bytes 400M --timeout 15s --metrics-brief

```



| Metric | Result |

|---|---:|

| Bogo operations | 469,044 |

| Real time | 15.12 s |

| Bogo ops/s (real time) | 31,031.33 |

| Bogo ops/s (CPU time) | 31,120.49 |

| Failed | 0 |

| Metrics untrustworthy | 0 |



After the test, approximately 623 MiB of RAM remained available and swap usage was only 652 KiB.



The VM completed the reduced memory test successfully.



\## 3. Disk Allocation



Disk inspected: WEB01 differencing VDI.



| Property | Result |

|---|---:|

| Virtual capacity | 25,600 MB (25 GB) |

| File size on disk | 64 MB |

| Format | VDI |

| Type | Normal (differencing) |



The virtual capacity represents the maximum logical size of the disk. The physical file size represents the space occupied by this differencing image.



A differencing disk stores changes relative to its parent disk, reducing duplicated storage. Its 64 MB size does not represent the total storage used by the complete virtual disk chain.



\## 4. Paravirtualization



The WEB02 VM was configured explicitly with the KVM paravirtualization provider.



Verification:

```powershell

VBoxManage showvminfo WEB02 | findstr /i paravirt

```



Result:

\- Paravirt. Provider: KVM

\- Effective Paravirt. Provider: KVM



\## 5. Conclusion



The 1-vCPU baseline and reduced memory test completed successfully. The 2-vCPU CPU stress tests were inconclusive because the VM became unresponsive.



The memory test was adjusted to 400 MB due to the VM's limited RAM. Disk inspection confirmed a differencing VDI, and KVM paravirtualization was explicitly configured and verified.



The CPU execution cap was restored to 100%.

