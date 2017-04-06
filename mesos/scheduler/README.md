#####################
#Mesos scheduler api#
##################### 


#Register a framework

Use below command to regiester a mesos framework, and you will get a message container the framework ID.
```
curl http://mesos1.eng.platformlab.ibm.com:5050/api/v1/scheduler -X POST -H 'Content-Type:application/json' -d @register_framework.json

{"subscribed":{"framework_id":{"value":"f904e0e8-6f92-4c4b-bebe-05690e109cdc-0003"}},"type":"SUBSCRIBED"}
```


#Accept offer to launch task
Use curl to request accept offer to launch tasks
```
curl http://mesos1.eng.platformlab.ibm.com:5050/api/v1/scheduler -X POST -H 'Content-Type:application/json' -d @accept_LaunchTask.json
```


#Kill tasks
Sent by the scheduler to kill a specific task. If the scheduler has a custom executor, the kill is forwarded to the executor and it is up to the executor to kill the task and send a TASK_KILLED (or TASK_FAILED) update. Mesos releases the resources for a task once it receives a terminal update for the task. If the task is unknown to the master, a TASK_LOST will be generated.

```
curl http://mesos1.eng.platformlab.ibm.com:5050/api/v1/scheduler -X POST -H 'Content-Type:application/json' -d @kill_task.json
```


#Shutdown the framework
Use below command to shutdown a mesos framework.
```
curl http://mesos1.eng.platformlab.ibm.com:5050/api/v1/scheduler -X POST -H 'Content-Type:application/json' -d @shutdown_framework.json
```

