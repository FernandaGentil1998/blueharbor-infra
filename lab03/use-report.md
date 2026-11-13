

# Exercise 3.3 — Resource Usage Report



## 1. Environment



- VM: WEB01

- OS: Ubuntu Server 24.04.5

- RAM: 2 GB

- Virtual disk: 25 GB

- Initial CPU configuration: 2 vCPUs

- Final CPU configuration: 1 vCPU

- Tools: sysstat 12.6.1 and stress-ng 0.17.06



## 2. Baseline measurements



### CPU



Measured with `mpstat -P ALL 2 5`:



- Average CPU idle: 88.56%

- System: 1.09%

- I/O wait: 0.11%

- Soft IRQ: 10.24%



The CPU had significant idle capacity at baseline.



### Memory



Measured with `free -h`:



- Total: 1.9 GiB

- Used: 348 MiB

- Available: 1.6 GiB

- Swap used: 0 B



No memory pressure was observed.



### Disk



Measured with `iostat -xz 2 5`:



- `sda`: 3.69% utilization, read await 2.58 ms, write await 7 ms.

- `dm-0`: 7.44% utilization, read await 3.29 ms, write await 5.02 ms.

- Queue sizes were low.



No disk saturation was observed.



## 3. Controlled stress tests



The tests below were shortened and reduced to one worker because the initial CPU test with two workers caused the VM to become unresponsive.



### CPU



Command:



`stress-ng --cpu 1 --timeout 15s --metrics-brief`



Results:



- Workers: 1

- Duration: 15 seconds

- Bogo operations: 14,813

- Result: passed 1, failed 0



### Memory



Command:



`stress-ng --vm 1 --vm-bytes 512M --timeout 15s --metrics-brief`



Results:



- Workers: 1

- Memory allocation: 512 MB

- Duration: 15 seconds

- Bogo operations: 75,579

- Result: passed 1, failed 0

- Available memory after test: approximately 1.6 GiB

- Swap used: 0 B



No memory exhaustion was observed.



### Disk



Command:



`stress-ng --hdd 1 --timeout 15s --metrics-brief`



Results from the monitored run:



- Workers: 1

- Duration: approximately 15 seconds

- Bogo operations: 87,420

- Result: passed 1, failed 0



Concurrent `iostat` observations:



- Disk utilization: approximately 2%

- Queue size: up to 0.12

- Write await: approximately 5.44 ms on `dm-0` and 6.16 ms on `sda`

- CPU I/O wait: 0%



No disk saturation was observed.



## 4. Stability incident



The original workbook CPU test was:



`stress-ng --cpu 2 --timeout 60s --metrics-brief`



During this test, the VM became unresponsive and required recovery. The VM booted successfully after reducing its virtual CPU allocation from two vCPUs to one.



This suggests a possible CPU or VM resource stability issue, but the exact cause was not established.



All subsequent controlled tests completed successfully.



## 5. Conclusion and recommendations



At baseline, WEB01 had sufficient available memory and low disk utilization. The controlled memory and disk tests did not indicate saturation.



CPU is the most likely resource constraint to investigate first because the VM became unresponsive during the original two-worker CPU stress test. However, the shorter controlled test did not establish a precise CPU saturation threshold.



Recommendations:



- Keep the VM configured with one vCPU while investigating stability.

- Use moderate CPU workloads and monitor system responsiveness.

- Monitor available memory and swap usage during future tests.

- Continue monitoring disk utilization and I/O wait.



**Overall conclusion:** No memory or disk bottleneck was observed during the controlled tests. CPU and VM stability require further investigation.




