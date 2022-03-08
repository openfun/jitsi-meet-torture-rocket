# Load test n°3, 04/03/2022

## Context 

We want to test the limits of our infrastructure (especially JVB) before adding autoscaling and various optimizations; we do not know yet how the JVB pods react to high load. Therefore, we will do this test to analyze the patterns of the infrastructure under high load.

---

## Description of the infrastucture

The Jitsi infrastucture we are working on is deployed on Kubernetes on Scaleway. It is based on the deployment available on the [jitsi-k8s repository of OpenFUN](https://github.com/openfun/jitsi-k8s/tree/59bdc9c799db3f0decedbb4b6f870f246091d7c8). More precisely, here are the specs of the JVB nodepool on our cluster:
- 1 server
- 4 CPU
- 16 GB of RAM
- 1 pod
- no HPA
- no resource limits on the JVB pod

---

## Approach

We deployed Jitsi-Meet-Torture instances in the cloud (on multiple instances on Scaleway) to apply a high load on the infrastructure. We can therefore legitimately assume that we emulate the perfect participants in our conferences that send and receive audio and video without any client-side limit.

We chose to apply batches of participant which are distributed into conferences of `5` participants. Each batch have a specific number of conferences and lasts between 10 minutes and 20 minutes (we realized during the 3rd batch that the RAM usage was not leveling off in a short period of time). Between two batches, the JVB pod is destroyed in order to reset all resource accumulation (especially for the RAM metric that does not go down).

We made sure the video and audio quality were ok when a human participant joined the conferences (note that for the last batch, it seems that the quality was a little deteriorated).

---

## Results

All metrics were gathered with Prometheus on the JVB pod. We wrote down asymptotic values as every metric seemed to converge.

| CONFERENCES | START HOUR | ASYMPTOTIC CPU LOAD (mCPU) | ASYMPTOTIC RAM USAGE (MB) | ASYMPTOTIC TRANSMIT BANDWIDTH (kB/s) |
| ----------- | ---------- | -------------------------- | ------------------------- | ------------------------------------ |
| 4           | 8h28       | 830                        | 550                       | 820                                  |
| 8           | 10h46      | 900                        | 670                       | 2120                                 |
| 12          | 12h47      | 1210                       | 990                       | 3700                                 |
| 16          | 13h16      | 1410                       | 1150                      | 4300                                 |
| 20          | 13h48      | 1600                       | 1160                      | 5700                                 |
| 28          | 14h12      | 1870                       | 1770                      | 7900                                 |
| 36          | 14h46      | 2140                       | 2320                      | 9500                                 |

Note that the start hours are not precise because the Jitsi-Meet-Torture instances are launched with Terraform and the Jist-Meet-Torture process is started when the instance completes its first boot.

| CONFERENCES | CPU load                      | RAM usage                     | Transmit bandwidth                        |
| ----------- | ----------------------------- | ----------------------------- | ----------------------------------------- |
| 4           | ![cpu-1](resources/cpu-1.png) | ![ram-1](resources/ram-1.png) | ![bandwidth-1](resources/bandwidth-1.png) |
| 8           | ![cpu-2](resources/cpu-2.png) | ![ram-2](resources/ram-2.png) | ![bandwidth-2](resources/bandwidth-2.png) |
| 12          | ![cpu-3](resources/cpu-3.png) | ![ram-3](resources/ram-3.png) | ![bandwidth-3](resources/bandwidth-3.png) |
| 16          | ![cpu-4](resources/cpu-4.png) | ![ram-4](resources/ram-4.png) | ![bandwidth-4](resources/bandwidth-4.png) |
| 20          | ![cpu-5](resources/cpu-5.png) | ![ram-5](resources/ram-5.png) | ![bandwidth-5](resources/bandwidth-5.png) |
| 28          | ![cpu-7](resources/cpu-7.png) | ![ram-7](resources/ram-7.png) | ![bandwidth-7](resources/bandwidth-7.png) |
| 36          | ![cpu-9](resources/cpu-9.png) | ![ram-9](resources/ram-9.png) | ![bandwidth-9](resources/bandwidth-9.png) |

For a better visualization of resource consumption, data have been congregated into 5 charts:

![cpu](resources/cpu.png)
![ram](resources/ram.png)
![bandwidth](resources/bandwidth.png)
![cpu-bandwidth](resources/cpu-bandwidth.png)
![ram-bandwidth](resources/ram-bandwidth.png)

---

## Interpretation of results

The three metrics that we based our study on do converge after every participant joins a conference, which means that the three values may be suitably used to analyze the load on our JVB pods. However, the convergence speed varies: transmit bandwidth converges faster, then CPU load and finally RAM usage.

The metric which seems to fit best to a linear model is the transmit bandwidth.

Our experimentations and the linear regressions leads us to the rough estimations:
```
transmit bandwidth = number of participants * 11 MB/s + 45 MB/s
CPU = transmit bandwidth * 0,16 s/kB + 660
RAM = transmit bandwidth * 0,2 MB.s/kB + 270
```

Note that these estimations are specific to the video and audio records that the Jitsi Meet Torture instances are sending: they do not constitute absolute formulas but may be used to compare different autoscaling solutions.

---

## Conclusion

The metric that seems to be the more relevant to autoscale our JVBs is the transmit bandwidth. We may choose the CPU and RAM allocations accordingly to the equations given in the previous subsection.

Besides, during the experimentation we had the following testing implementation limits that we should work on:
- Terraform is configured to deploy 10 resources at a time by default. We overwrited it with the parameter `-parallelism=X`.
- We had to launch several `terraform apply` because the scaleway provider reach a `maximum attempts` error: we should explore this timeout issue.
- It was difficult to apply all the load at a specific time, because instances were not booting at the same time: we had to lenghten the duration of tests to 20 minutes in order to have interesting results. It may be interesting to slightly modify cloud-init or build to control the trigger of Meet Torture with a cron or a timer for instance. Besides, this may lead to a solution to deploy load little by little.
