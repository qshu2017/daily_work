#!/bin/bash

mesos-master --work_dir=/var/log/work --log_dir=/var/log/mesos $*
