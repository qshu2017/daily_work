#!/usr/bin/python
#
# courtesy of Gheorghe Almasi
#


import time
import numpy
import math
import matplotlib
import matplotlib.pyplot as plt
import csv
import glob
import sys
import traceback

ms_per_time_unit = 1000.0
legend_height_fraction = 0.275

# ##################################################################
# ##################################################################

def read_timings (fname):
    dates = []
    tenants = []
    proftimes = []
    launchtimes = []
    runtimes = []
    pingtimes = []
#    fname = 'timings-2105-08-19.txt'
    fd = open(fname, 'rd')
    count=0
    for line in fd:
        if line.strip()=='': break
        try:
            print line
            values = line.split(' ')
            dates.append(int(values[0]))
            tenants.append(int(values[1]))
            proftimes.append(int(values[2]) / ms_per_time_unit)
            launchtimes.append(int(values[3]) / ms_per_time_unit)
            runtimes.append(int(values[4]) / ms_per_time_unit)
            pingtimes.append(int(values[5]) / ms_per_time_unit)
            count+=1
            print count
        except Exception, e:
            print 'Exception in line %d: %s'%(count,str(e))
            traceback.print_exc()
            exit(1)

    return dates,tenants,proftimes,launchtimes,runtimes,pingtimes

# ##################################################################
# ##################################################################

def smoothit (arr):
    result = []
    for idx in xrange(len(arr)):
        if idx < len(arr)-4:
            mean=(arr[idx]+arr[idx+1]+arr[idx+2]+arr[idx+3])/4.0
        else:
            mean = arr[idx]
        result.append(mean)
    return result

# ##################################################################
# ##################################################################

filename = None
xmax = "auto"
ymax = "auto"
yscale = "auto"
style = 'lines'

i = 1
while i < len(sys.argv):
    arg = sys.argv[i];
    if len(arg) > 0 and arg[0] != '-' and None == filename:
        filename = arg
    elif '--' == arg and i+1 < len(sys.argv) and None == filename:
        i += 1
        file = sys.argv[i]
        break
    elif '--lines' == arg:
        style = 'lines'
    elif '--points' == arg:
        style = 'points'
    elif '--xmax' == arg and i+1 < len(sys.argv):
        i += 1
        xmax = sys.argv[i]
    elif '--ymax' == arg and i+1 < len(sys.argv):
        i += 1
        ymax = sys.argv[i]
    elif '--yscale' == arg and i+1 < len(sys.argv):
        i += 1
        yscale = sys.argv[i]
    else:
        break
    i += 1

if i < len(sys.argv) or None == filename:
    sys.stderr.write("Arguments parse finished with i==%s and filename=%s\n" %(i, filename))
    sys.stderr.write('Usage: %s (--lines | --points |'
                     ' --xmax ("auto" | number) |'
                     ' --ymax ("auto" | number) |'
                     ' --yscale ("log" | "linear" | "auto") |'
                     ' filename) * [ -- filename]\n' % sys.argv[0])
    sys.stderr.write('       ... with filename occuring exactly once.\n')
    exit(1)

dates,tenants,proftimes,launchtimes,runtimes, pingtimes = read_timings(filename)

if len(launchtimes) <= 0:
    print "Zero data points in %s !" % filename
    exit(2)

#pingtimes = smoothit(pingtimes)

# no title.
width=1
plt.title('Scale up test: %s '% filename)
plt.xlabel('Number of Containers')
plt.ylabel('Resource creation time (seconds)')

def add(x, y):
    return x+y

def plot(x, dy, c):
    top_y = map(add, offset, dy)
    if 'lines' == style:
        return top_y, plt.bar(x, dy, bottom=offset, color=c, edgecolor=c)
    else:
        return top_y, plt.scatter(x, top_y, c=c)

#l1=plt.bar(tenants,proftimes,color='r',edgecolor='r')
offset = proftimes

offset, l2 = plot(tenants,launchtimes,'b')

offset, l3 = plot(tenants,runtimes,'k')

offset, l4 = plot(tenants,pingtimes,'m')

if ("auto" == xmax):
    xmax = max(6, int(max(tenants)))
else:
    xmax = int(xmax)
plt.xlim(0, xmax)

ylo = min(offset)
if tenants[0] < xmax*0.55:
    yhi1 = max(offset[i] for i in xrange(0, len(offset)) if tenants[i] < xmax*0.55)
else:
    yhi1 = 1 / ms_per_time_unit

yhi2 = max(offset)
if yhi2 <= 0:
    sys.stderr.write("No positive data in %s!\n" % filename)
    exit(3)

log_yhi2 = math.log(yhi2, 10)
if 'auto' == yscale:
    if math.log(max(ylo, 1/ms_per_time_unit), 10) + 2.5 < log_yhi2:
        yscale = 'log'
    else:
        yscale = 'linear'

if 'log' == yscale:
    if 'auto' == ymax:
        lms = math.log(ms_per_time_unit, 10)
        log_yhi1 = math.log(yhi1, 10)
        log_range = max(log_yhi2 + lms,
                        (log_yhi1 + lms) / (1 - legend_height_fraction))
        ymax = 10 ** (math.ceil(( log_range - lms) * 2) / 2)
    else:
        ymax = float(ymax)
    plt.ylim(1 / ms_per_time_unit, ymax)
    plt.yscale('log')
else:
    if 'auto' == ymax:
        ymax = max(yhi1 / (1 - legend_height_fraction), yhi2)
    else:
        ymax = float(ymax)
    plt.ylim(min(ylo, 0), ymax)

plt.legend ([l4,l3,l2],
            [#'Profile creation',
             'TCP conn. established',
             'Container running',
             'Container launched',
         ],
            bbox_to_anchor=(0.5, 0.95))

fname=filename.replace('.log','')
fname=fname.replace('.txt','')
print fname
plt.savefig(fname+'.png')
plt.show()

