# Quick load tests n°1, 15/03/2022

## Context 

The aim of these tests is to discover what is limiting for JVBs on kubernetes, and for our jitsi-meet-torture tests.

## Common infrastructure

The Jitsi infrastucture we are working on is deployed on Kubernetes on Scaleway. It is based on the deployment available on the [jitsi-k8s repository of OpenFUN](https://github.com/openfun/jitsi-k8s/tree/59bdc9c799db3f0decedbb4b6f870f246091d7c8).

Jitsi is configured so that when there are 10 participants in the conversation, additional participants will join with audio muted and video turned off. So we never have more than 10 videos and 10 audio in one room.

---

## First test

### Description of the infrastucture

Specs of the JVB nodepool for this test:
- 1 server
- 4 CPU
- 16 GB of RAM
- 1 pod
- no HPA
- no resource limits on the JVB pod

### Approach

The aim of the test is to see if the JVB process can use more than 2 CPUs, because it struggles to do so in other tests. We create 2 conferences and add people in each until we go over 2 cpus used by the jvb.

### Results

All metrics were gathered with Prometheus and visualized with Grafana.

The participants were added little by little, which can be seen here:
![1_participants](resources/1_participants.png)

We managed to go over two CPUs on the jvb process, as visible in the following graph:
![1_cpu](resources/1_cpu.jpeg)

We have a loss in participants when reaching 60 participants (POST-EDIT: probably due to limitation in the client VMs). The following metrics were also kept from the test:

| Metric           | Graph                                               | Notes                                                                                         |
| ---------------- | --------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| JVB Ram usage       | ![1_jvb_ram](resources/1_ram.png)             | RAM usage of the JVB                                                |
| Receive bandwidth              | ![1_receive_bw](resources/1_receive_bw.png)                           | Bandwidth in reception of the jvb                             |
| Transmit bandwidth | ![1_transmit_bw](resources/1_transmit_bw.png) | Bandwidth in transmission of the jvb         |
| JVB stress level | ![1_jvb_stresslevel](resources/1_jvb_stresslevel.png) | Stress level of the JVB, defined in the [prometheus exporter](https://github.com/systemli/prometheus-jitsi-meet-exporter)       |

### Conclusion

JVB is not limited by a socket, parallelization occurs correctly.

---

## Second test

### Description of the infrastucture

Specs of the JVB nodepool for this test:
- 1 server
- 4 CPU
- 16 GB of RAM
- 2 pods
- resource limits on the JVB pods: 2 cpu, 5Go RAM
- no HPA

### Approach

The aim of the test is to see if the optimal configuration is with JVBs that use 2 CPUs, as we struggle to use more than 2 CPUs in testw (as seen in previous test)

### Results

All metrics were gathered with Prometheus and visualized with Grafana.

The participants were added little by little on two conferences, which can be seen here:
![2_participants](resources/2_participants.png)

We have a loss in participants when reaching 70 participants (POST-EDIT: probably due to limitation in the client VMs, so test results are faulty because of this). The following metrics were also kept from the test:

| Metric           | Graph                                               | Notes                                                                                         |
| ---------------- | --------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| CPU usage       | ![2_jvb_cpu](resources/2_cpu_all.png)             | CPU usage of each JVB                                                |
| CPU usage jvb 0       | ![2_cpu_jvb0](resources/2_cpu_jvb0.png)             | CPU usage of first JVB                                                |
| CPU usage jvb 1       | ![2_cpu_jvb1](resources/2_cpu_jvb1.png)             | CPU usage of second JVB                                                |
| RAM usage | ![2_ram](resources/2_ram.png) | RAM usage of one jvb, other is almost identical         |
| Receive bandwidth              | ![2_receive_bw](resources/2_receive_bw.png)                           | Bandwidth in reception of one jvb, the other jvb is very similar                             |
| Transmit bandwidth | ![2_transmit_bw](resources/2_transmit_bw.png) | Bandwidth in transmission of one jvb, the other jvb is very similar         |
| Websockets | ![2_websockets](resources/2_websockets.png) | Number of open websockets       |
| JVB jitter aggregate | ![2_jitter_aggregate](resources/2_jitter_aggregate.png) | (Experimental) [Packet delay variation](https://en.wikipedia.org/wiki/Packet_delay_variation)       |

### Conclusion

It does not seem to be better to have multiple JVBs in any case : on each JVB, CPU load climbs almost as fast as when there is only one jvb, which doubles the global demand in ressources.

---

## Third test

### Description of the infrastucture

Specs of the JVB nodepool for this test:
- 4 servers
- 4 CPU by server
- 16 GB of RAM by server
- 4 jvb pods
- no HPA
- resource limits on the JVB pod according to instance size

### Approach

We want to test if we reach more participants with more machines, or if Octo creates so many connections that it limits the numbers.

### Results

All metrics were gathered with Prometheus and visualized with Grafana.

The participants were added little by little on two conferences, which can be seen here:
![3_participants](resources/3_participants.png)

We have a loss in participants when reaching 100 participants (POST-EDIT: probably due to limitation in the client VMs, so test results are faulty because of this). The following metrics were also kept from the test:

| Metric           | Graph                                               | Notes                                                                                         |
| ---------------- | --------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| CPU usage       | ![3_jvb_cpu](resources/3_cpu_all.png)             | CPU usage of each JVB                                                |
| CPU usage jvb 0       | ![3_cpu_jvb0](resources/3_cpu_jvb0.png)             | CPU usage of first JVB                                                |
| CPU usage jvb 1       | ![3_cpu_jvb1](resources/3_cpu_jvb1.png)             | CPU usage of second JVB                                                |
| CPU usage jvb 2       | ![3_cpu_jvb2](resources/3_cpu_jvb2.png)             | CPU usage of third JVB                                                |
| CPU usage jvb 3       | ![3_cpu_jvb3](resources/3_cpu_jvb3.png)             | CPU usage of fourth JVB                                                |
| RAM usage | ![3_ram](resources/3_ram.png) | RAM usage of one jvb, others are almost identical         |
| Receive bandwidth              | ![3_receive_bw](resources/3_receive_bw.png)                           | Bandwidth in reception of one jvb, others are almost identical                             |
| Transmit bandwidth | ![3_transmit_bw](resources/3_transmit_bw.png) | Bandwidth in transmission of one jvb, others are almost identical        |
| Websockets | ![3_websockets](resources/3_websockets.png) | Number of open websockets in one jvb       |
| JVB stress level | ![3_stresslevel](resources/3_stresslevel.png) | Stress level of the JVB, defined in the [prometheus exporter](https://github.com/systemli/prometheus-jitsi-meet-exporter)       |
| JVB jitter aggregate | ![3_jitter_aggregate](resources/3_jitter_aggregate.png) | (Experimental) [Packet delay variation](https://en.wikipedia.org/wiki/Packet_delay_variation)       |
| CPU usage front      | ![3_cpu_front](resources/3_cpu_front.png)             | CPU usage of frontend                                               |
| CPU usage prosody      | ![3_cpu_prosody](resources/3_cpu_prosody.png)             | CPU usage of prosody                                               |

### Conclusion

We reach only 100 participants when multiplicating by 4 the ressources possible (POST-EDIT: due to client limitations, test has to be re-done). However, bandwidth seems to not be limiting. But we need to evaluate difference with/without Octo.

---

## Fourth test

### Description of the infrastucture

Specs of the JVB nodepool for this test:
- 4 servers
- 4 CPU by server
- 16 GB of RAM by server
- 4 jvb pods
- no HPA
- resource limits on the JVB pod according to instance size

### Approach

We want to test if server handles small conferences better than big ones. On the one hand, there is less signaling, on the other there are more video and audio data.

### Results

All metrics were gathered with Prometheus and visualized with Grafana.

The participants were added little by little on ten conferences, which can be seen here:
![4_participants](resources/4_participants.png)

We have a loss in participants when reaching 210 participants (POST-EDIT: probably due to limitation in the client VMs, so test results are faulty because of this). We approach 3 cpus on multiple JVBs : we managed to use ressources more than before. The following metrics were also kept from the test:

| Metric           | Graph                                               | Notes                                                                                         |
| ---------------- | --------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| CPU usage jvb 0       | ![4_cpu_jvb0](resources/4_cpu_jvb0.png)             | CPU usage of first JVB                                                |
| CPU usage jvb 1       | ![4_cpu_jvb1](resources/4_cpu_jvb1.png)             | CPU usage of second JVB                                                |
| CPU usage jvb 2       | ![4_cpu_jvb2](resources/4_cpu_jvb2.png)             | CPU usage of third JVB                                                |
| CPU usage jvb 4       | ![4_cpu_jvb3](resources/4_cpu_jvb3.png)             | CPU usage of fourth JVB                                                |
| RAM usage | ![4_ram](resources/4_ram.png) | RAM usage of one jvb, others are almost identical         |
| Receive bandwidth              | ![4_receive_bw](resources/4_receive_bw.png)                           | Bandwidth in reception of one jvb, others are almost identical                             |
| Transmit bandwidth | ![4_transmit_bw](resources/4_transmit_bw.png) | Bandwidth in transmission of one jvb, others are almost identical        |
| Websockets | ![4_websockets](resources/4_websockets.png) | Number of open websockets in one jvb       |
| JVB stress level | ![4_stresslevel](resources/4_stresslevel.png) | Stress level of the JVB, defined in the [prometheus exporter](https://github.com/systemli/prometheus-jitsi-meet-exporter)       |
| JVB jitter aggregate | ![4_jitter_aggregate](resources/4_jitter_aggregate.png) | (Experimental) [Packet delay variation](https://en.wikipedia.org/wiki/Packet_delay_variation)       |
| CPU usage front      | ![4_cpu_front](resources/4_cpu_front.png)             | CPU usage of frontend                                               |
| CPU usage prosody      | ![4_cpu_prosody](resources/4_cpu_prosody.png)             | CPU usage of prosody                                               |
| CPU usage jicofo      | ![4_cpu_jicofo](resources/4_cpu_jicofo.png)             | CPU usage of jicofo                                               |

### Conclusion

JVBs seem to handle small conferences quite well.

---

## Fifth test

### Description of the infrastucture

Specs of the JVB nodepool for this test:
- 4 servers
- 4 CPU by server
- 16 GB of RAM by server
- 4 jvb pods
- no HPA
- resource limits on the JVB pod according to instance size
- Octo strategy set to SingleBridgeSelection

### Approach

We want to test if JVBs are more efficient when conferences are allocated to one JVB only. This creates less signaling between JVBs who do not have to communicate information anymore.

### Results

All metrics were gathered with Prometheus and visualized with Grafana.

The participants were added little by little on ten conferences. Because Octo is disabled, participant values are seen by jvb, and red line is the total.
![5_participants](resources/5_participants.png)

We have a loss in participants when reaching 100 participants (POST-EDIT: probably due to limitation in the client VMs, so test results are faulty because of this). 

| Metric           | Graph                                               | Notes                                                                                         |
| ---------------- | --------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| CPU usage jvb       | ![5_cpu_all](resources/5_cpu_all.png)             | CPU usage of all JVBs                                                |
| CPU usage jvb 0       | ![5_cpu_jvb0](resources/5_cpu_jvb0.png)             | CPU usage of first JVB                                                |
| CPU usage jvb 1       | ![5_cpu_jvb1](resources/5_cpu_jvb1.png)             | CPU usage of second JVB                                                |
| CPU usage jvb 2       | ![5_cpu_jvb2](resources/5_cpu_jvb2.png)             | CPU usage of third JVB                                                |
| CPU usage jvb 5       | ![5_cpu_jvb3](resources/5_cpu_jvb3.png)             | CPU usage of fourth JVB                                                |
| RAM usage | ![5_ram](resources/5_ram.png) | RAM usage of one jvb, others are almost identical         |
| Receive bandwidth jvb 0            | ![5_receive_bw_jvb0](resources/5_receive_bw_jvb0.png)                           | Bandwidth in reception of jvb 0                             |
| Receive bandwidth jvb 1            | ![5_receive_bw_jvb1](resources/5_receive_bw_jvb1.png)                           | Bandwidth in reception of jvb 1                             |
| Receive bandwidth jvb 2            | ![5_receive_bw_jvb2](resources/5_receive_bw_jvb2.png)                           | Bandwidth in reception of jvb 2                             |
| Receive bandwidth jvb 3             | ![5_receive_bw_jvb3](resources/5_receive_bw_jvb3.png)                           | Bandwidth in reception of jvb3                             |
| Transmit bandwidth jvb 0            | ![5_transmit_bw_jvb0](resources/5_transmit_bw_jvb0.png)                           | Bandwidth in reception of jvb 0                             |
| Transmit bandwidth jvb 1            | ![5_transmit_bw_jvb1](resources/5_transmit_bw_jvb1.png)                           | Bandwidth in reception of jvb 1                             |
| Transmit bandwidth jvb 2            | ![5_transmit_bw_jvb2](resources/5_transmit_bw_jvb2.png)                           | Bandwidth in reception of jvb 2                             |
| Transmit bandwidth jvb 3             | ![5_transmit_bw_jvb3](resources/5_transmit_bw_jvb3.png)                           | Bandwidth in reception of jvb3                             |                                      |

### Conclusion

Some JVBs are way more overloaded than others, because they had more conferences on them. There is no possibility to put incoming people in other JVBs, so they are stuck with what they have. It seems better to use Octo in SplitBridgeStrategy
