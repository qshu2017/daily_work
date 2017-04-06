Mesos Quota



1)Set quota
Operator support to set quota by a HTTP POST request.

```
curl http://mesos1.eng.platformlab.ibm.com:5050/quota -X POST -d @set_quota.json
```

The output like:
```

```


2)Remove the quota
Operator can remove a previously set quota by sending an HTTP DELETE request, the command like below:

```
curl http://mesos1.eng.platformlab.ibm.com:5050/quota/<role_name> -X DELETE
```


3)Get quota status
Operator support to get quota status by sending an HTTP request, the command like below:

```
curl http://mesos1.eng.platformlab.ibm.com:5050/quota -X GET
```
