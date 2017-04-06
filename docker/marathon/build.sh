#!/bin/bash


curl -O http://downloads.mesosphere.com/marathon/v0.10.1/marathon-0.10.1.tgz
tar xvf marathon-*.tgz
rm -rf marathon-*.tgz
mv marathon-* marathon
docker build -t hchenxa1986/marathon .
rm -rf marathon
