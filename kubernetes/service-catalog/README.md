# Service Catalog in CFC

This document outlines the basic features of the service catalog by walking
through a short demo.

## Step 0 - Prerequisites

### environment requirement

1. kubernetes 1.6.1 +


## Step 1 - Installing the Service Catalog System

Get the tar file [service-catalog](https://github.com/hchenxa/daily_work/blob/master/kubernetes/service-catalog/catalog-0.0.1.tgz) and use helm to deploy the service catalog system

```console
helm install catalog-0.0.1.tgz --name catalog
```

And the catalog will be created as kubernetes deployment.

```console
root@hchenk8s1:~# kc get deployment --all-namespaces

NAMESPACE     NAME                                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
kube-system   catalog-catalog-apiserver            1         1         1            1           1d
kube-system   catalog-catalog-controller-manager   1         1         1            1           1d
```

And also the deployment will be expose as the service
```console
root@hchenk8s1:~# kc get service --all-namespaces | grep cata
kube-system   catalog-catalog-apiserver   10.0.0.149   <nodes>       80:30080/TCP,443:30443/TCP       1d
```

## Step 2 - Setup MySQL broker server
Environment requirement: Need java installed

1.First setup the mysql server.

```console
apt install mysql-server
```

and the mysql root password must be **root**

And need to create a database named **test** by CREATE DATABASE test;


2.Startup the broker server

Get the JAR file [mysql-broker](https://github.com/hchenxa/daily_work/blob/master/kubernetes/service-catalog/cf-mysql-java-broker-0.1.0.jar)

and execute

```console
java -jar cf-mysql-java-broker-0.1.0.jar
```

The default port was 9000, we can use http://<host_ip>:9000/v2/catalog to check if the server was ready.

## Step 3 - Create broker resource

```console
root@hchenk8s1:~# kubeca get broker -o yaml
apiVersion: v1
items:
- apiVersion: servicecatalog.k8s.io/v1alpha1
  kind: Broker
  metadata:
    creationTimestamp: 2017-04-07T09:11:37Z
    finalizers:
    - kubernetes
    name: mysql-broker
    namespace: ""
    resourceVersion: "393"
    selfLink: /apis/servicecatalog.k8s.io/v1alpha1/brokersmysql-broker
    uid: 343173af-1b72-11e7-9917-4a6adf82f80b
  spec:
    url: http://9.111.254.218:9000
  status:
    conditions:
    - message: Error fetching catalog
      reason: ErrorFetchingCatalog
      status: "False"
      type: Ready
kind: List
metadata: {}
resourceVersion: ""
selfLink: ""
```

## Step 4 - Check the catalog

```console
root@hchenk8s1:~# kubeca get serviceclass -o yaml
apiVersion: v1
items:
- apiVersion: servicecatalog.k8s.io/v1alpha1
  bindable: false
  brokerName: mysql-broker
  kind: ServiceClass
  metadata:
    creationTimestamp: 2017-04-07T09:11:37Z
    name: p-mysql
    namespace: ""
    resourceVersion: "302"
    selfLink: /apis/servicecatalog.k8s.io/v1alpha1/serviceclassesp-mysql
    uid: 343299e5-1b72-11e7-9917-4a6adf82f80b
  osbGuid: 3101b971-1044-4816-a7ac-9ded2e028079
  osbMetadata:
    listing:
      blurb: MySQL service for application development and testing
      imageUrl: null
    provider:
      name: null
  osbTags:
  - mysql
  - relational
  planUpdatable: false
  plans:
  - name: 5mb
    osbFree: false
    osbGuid: 2451fa22-df16-4c10-ba6e-1f682d3dcdc9
    osbMetadata:
      bullets:
      - content: Shared MySQL server
      - content: 5 MB storage
      - content: 40 concurrent connections
      cost: 0
kind: List
metadata: {}
resourceVersion: ""
selfLink: ""
```

## Step 5 - Create Instance

```console
root@hchenk8s1:~# kubeca get instance --namespace=hchentest
NAME             KIND
mysql-instance   Instance.v1alpha1.servicecatalog.k8s.io
root@hchenk8s1:~# kubeca get instance --namespace=hchentest -o yaml
apiVersion: v1
items:
- apiVersion: servicecatalog.k8s.io/v1alpha1
  kind: Instance
  metadata:
    creationTimestamp: 2017-04-07T14:48:29Z
    finalizers:
    - kubernetes
    name: mysql-instance
    namespace: hchentest
    resourceVersion: "408"
    selfLink: /apis/servicecatalog.k8s.io/v1alpha1/namespaces/hchentest/instances/mysql-instance
    uid: 43a08214-1ba1-11e7-9917-4a6adf82f80b
  spec:
    checksum: 6e79e8643d9382239a666b44b9948e65789b72e0dc12ad3fc23cfc47b6cfc425
    osbGuid: 2df17f6c-6b5a-44bb-8492-64899c7b2541
    planName: 5mb
    serviceClassName: p-mysql
  status:
    conditions:
    - message: The instance was provisioned successfully
      reason: ProvisionedSuccessfully
      status: "True"
      type: Ready
kind: List
metadata: {}
resourceVersion: ""
selfLink: ""
```


## Step 6 - Binding Instance

```console
root@hchenk8s1:~# kubeca get binding --namespace=hchentest
NAME            KIND
mysql-binding   Binding.v1alpha1.servicecatalog.k8s.io
root@hchenk8s1:~# kubeca get binding --namespace=hchentest -o yaml
apiVersion: v1
items:
- apiVersion: servicecatalog.k8s.io/v1alpha1
  kind: Binding
  metadata:
    creationTimestamp: 2017-04-07T09:56:37Z
    deletionGracePeriodSeconds: 0
    deletionTimestamp: 2017-04-07T10:14:02Z
    finalizers:
    - kubernetes
    name: mysql-binding
    namespace: hchentest
    resourceVersion: "409"
    selfLink: /apis/servicecatalog.k8s.io/v1alpha1/namespaces/hchentest/bindings/mysql-binding
    uid: 7dd163e1-1b78-11e7-9917-4a6adf82f80b
  spec:
    checksum: b6119b55a57267347ab7dec8cadf86aee68a1261ed381e8c6b75f1790ff671a1
    instanceRef:
      name: mysql-instance
    osbGuid: 078a417e-4492-4091-b9c4-f41d0aeffd54
    secretName: mysql-secret
  status:
    conditions:
    - message: Injected bind result
      reason: InjectedBindResult
      status: "True"
      type: Readykind: List
metadata: {}
resourceVersion: ""
selfLink: ""
```

