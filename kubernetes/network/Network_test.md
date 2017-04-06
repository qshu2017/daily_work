kc run --tty -i  --image=hchenxa1986/qperf:latest --image-pull-policy="IfNotPresent" bash

kc run --tty -i  --image=hchenxa1986/qperf:latest --image-pull-policy="IfNotPresent" bash1

qperf -oo msg_size:1:64K:*2  10.1.186.137 tcp_bw tcp_lat
