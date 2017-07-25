## ICp System Test High Level Test Plan



### Environment

Following hardware and software resource needed.

**1. Environment:**

* Icp: 3 master nodes + 300 workers.

* Docker: 1.17.06-ce

* OS: Ubuntu 16.04 LTS

* Network: Calico

* Storage: Ceph/GlusterFS/GPFS/etc
		      
		      
		      
### Scalability Test.

**Scalability Test Criteria:**

| Priority | Scalability Metric| Criteria  | Comments |
|------|------|------|------|
| P1 | ICp Master nodes| 3 | |
| P1 | ICp worker nodes|300| |
| P1 | ICp workloads | 9000 |30 pods per node|
| P1 | ICp services | 900 | 1 service match 10 pods|
| P1 | Ingress service | 100 | |
| P1 | Users | 10000 | the number was from SuperVessel|
| P2 | Namespace | 10000 | the numer was from SuperVessel |
| ... | ... | ... | ...|




**Test Strategy**:

The scalability test will be devided into each Sprint and each of squad need to handle their part in each Sprint.


**Test Sprint1**:
  
  * Infrastructure squad draft the test plan and collect the environment requirement from other squad.
  * Infrastructure squad prepare the environment based on the current environment.
  * Each squad draft the scalability test criteria, test cases, test scripts in this sprint. 


**Test Sprint2**:

  * Belows cases will be handled by Infrastructure squad in Sprint 2:
      
       1) Deploy 300 worker nodes in ICp
       
       2) Deploy 9000 pods(1 pods pre 9000 deployments)
       
       3) Deploy 9000 pods(10 pods pre 900 deployments)
       
       4) Deploy 9000 pods(100 pods pre 90 deployments)
       
       5) Deploy 9000 pods(1000 pods pre 9 deployments)
   
  * Belows cases need to be handled by other squad in Sprint 2:

       1) 

**Test Sprint3**

* Belows cases will be handled by Infrastructure squad in Sprint 3:

      1) Deploy 10000 users in ICp
      
      2) Deploy 10000 namespaces in ICp
      
      3) Deploy 900 services resource in ICp
      
* Belows cases need to be handled by other squad in Sprint 3:
      
      1) 
      
**Test Sprint4**

* Bug retest related to scalability test

* Patch the Sprint3 features and do the related scalability test.



### Performance Test

The performance test will be executed in each Sprint and each of the squard should test their own performance cases 


**Performance Test Criteria:**

| Priority | Performance Metric| Criteria  | Comments |
|------|------|------|------|
| P1 | cli/api response | <1s | |
| P1 | GUI response | <5s | |
| P1 | Pod start time | <500s | 95% pod ready |
| P1 | Service discover time | <2s | |
| P1 | CRUD users | api response time within 1s| |
| P2 | CRUD namespace | api response time within 1s | |
| P1 | Network TPS/ | | need other aquad input |
| P1 | Disk I/O | | need other squad input |
| P1 | Application QPS | | need other squad input |
| P1 | Concurrent users| | need other squad input | 
| P2 | Installation | | monitor the time of environment ready|
| ... | ... | ... | ...|



**Test Sprint1**

* Belows cases will be handled by Infrastructure squad in Sprint 1:

	1) monitor the Installation time of each installer component/tasks.
	
	2) monitor the time of 300 nodes register in ICp.

**Test Sprint2**

* Belows cases will be handled by Infrastructure squad in Sprint 2:

   1) Monitor the pod start time, record the time of 50% ready time, 85% ready time, 95% ready time.
   
   2) Monitor the CLI response time
   
   3) Monitor the response time of query Nodes/Deployments/Pods time.
   
   4) Monitor the System service and management service metric usage like(CPU, memory, Network I/O) during operations.
   
* Belows cases will be handled by other squad in Sprint 2:

   1) Network TPS comparation test:
      
        a. compare the container to container network TPS with container to host
        b. compare the container to container network TPS with host to host
        c. compare the network TPS with ipip_enable and ipip_disable
        d. compare the different network solution with other vendor 

   2) Disk IO
        
         need other squad input
         
   3) Service comparation test 
   
        a. compare the service performance in ICp and without ICp(put the service outof the docker/ICp)
 

**Test Sprint3**

* Belows cases will be handle by Infrastructure squad in Sprint 3.

   1) Monitor the time of user CRUD response time.
   
   2) Monitor the time of service discover time.
   
   3) Monitor the time of delete deployments/pods/service response time.
   
   
  
* Blows cases will be handled by other squad in Sprint 4

  1) Concurrent users use Jmeter/load running
  
  
**Test Sprint4**

* Bug retest which related to performance test

* Patch the Sprint3 features and do the related performance cases.



### Reliability Test

The test will be handled from Sprint 2 and ended before Sprint 3.

* And below cases will be handled by Infrastructure squad:

    1). ICp master HA

    2). ICp System service and management service recover

    3). ICp workloads recover


* Below cases will be handled by other squad:

    1). Network reliability
    
    2). Storage reliability
    
	 3). Service reliability(start concurrent client to send request, and during the service recive the request, shutdown some of pods to see the error request percentage.)
    

### Longevity and Stress Test


The Longevity and Stress test will started from Sprint 1 and finished before RC sanity check.

And the main focus was on cluster healty like: monitory the cluster resource usage like cpu/memory usage to ensure no leak.


* The Longevity test cases will be finalized at the end of Sprint 1.
* Eash squad need to prepare the test cases, test scripts and monitor scripts in each sprint and patch their cases in the Longevity test environment in each test cycle.
* Before new sprint started, the longevity test environment need to be patched with the latest build(each sprint will have a small release, so we can use the release packages in Longevity test) and re-run in 7*24 hours.


### Feature integration Test

* Each of squad focal should go through the new features delivery in each sprint and consider which features have interaction with others, pick them out and do interaction test to make sure the interaction quality.
