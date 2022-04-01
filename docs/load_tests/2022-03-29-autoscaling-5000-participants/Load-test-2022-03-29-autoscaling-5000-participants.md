# Load test n°9, 24/02/2022

## Context 

We want to test how Jitsi handles big conferences after implementing autoscaling. To enable this, we needed to deploy way more ressources be it for Jitsi or for load testing.

---

## Description of the infrastucture

The Jitsi infrastucture we are working on is deployed on Kubernetes on Scaleway. It is based on the deployment available on the [jitsi-k8s repository of OpenFUN](https://github.com/openfun/jitsi-k8s/tree/59bdc9c799db3f0decedbb4b6f870f246091d7c8). More precisely, here are the specs of the JVB nodepool on our cluster:

- 1 server
- 20-90 JVBs GP1-XS
- HPA

Specs of the torture instances:
- 3 CPU
- 4 GB of RAM
- 2 participants per instance

---

## Approach

We deployed Jitsi-Meet-Torture instances in the cloud (on multiple instances on Scaleway) to apply a high load on the infrastructure. We can therefore legitimately assume that we emulate the perfect participants in our conferences that send and receive audio and video without any client-side limit. 

We did this test with four computers launching the same number of jitsi-meet-torture instances.

We loaded a big conference of 500 participants and 126 conferences of 30 participants. 


---

## Results

All metrics were gathered with Prometheus and visualized with Grafana.

The process was to observe the autoscaling, and how it handles a great number of participants. What component breaks first and why. 

We started the test at 10 am and ended at 18 pm.

The number of participants have been tracked down to follow the evolution of metrics in terms of participants:

![Participants](resources/Participants.png)

Same goes for the number of conferences:

![Conferences](resources/Conferences.png)

### Graphs




## Interpretation of results

Video and audio quality were correct whatever the number of participants because Jitsi limits the number of open cameras and its unrealistic to imagine too many people talking at the same time.

We had some problems with OCTO because the BRIDGE_STRESS_THRESHOLD wasn't fit for the test we did. Indeed, the JVB was overloaded beforre the BRIDGE_STRESS_THRESHOLD reached the value we set up.

We note that at 12 am the Prosody broke. Checking the logs, we saw that Kubernetes shut it down due the lack of responce to liveness probe. The Prosody was to slow to answer. Looking at other components, the front deals with too many requests resulting in the overloading of the Prosody.
 
## Conclusion

According to the tests, we need to resolve the overloading. A solution could be to put an ingress controler to handle the requests instead of nginx.
The BRIDGE_STRESS_THRESHOLD isn't enough to setup OCTO, we also need to set up a threshold of participant on each JVB.