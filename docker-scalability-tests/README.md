# docker-scalability-tests

## Running
Copy all files to your environment (e.g. swarm client or single docker engine node), set up env.rc
with the MANAGER_IP and MANAGER_PORT values for your environment. Setup also the max number of containers
to create.

Run the appropriate script e.g.:
```
  ./scaletest-engine.sh run
```
For long running tests best to run:

nohup ./scaletest-engine.sh run &

## Cleaning up
You can clean up simply running:
```
  ./scaletest-engine.sh clean
```
For large scale tests it is reccommended also a restart of the docker engine before and after cleanup.

## Plotting

A file with extension .txt is created for every test. The format is a set of rows with the following fields:
```
<timestamp (ms)> <container #> <profile delta creation time (ms)> <time delta to launch (ms)> <time delta to running (ms)> <time delta to get tcp connectivity (ms)>
```
The profile field can be ignored as it is only used in the calico networking tests.

e.g.
```
1444961943279 1 3 58 498 185
1444961944046 2 3 29 1485 194
1444961945780 3 3 29 505 179
1444961946519 4 4 29 1440 184
```
You may plot with the provided simple plotting tool (mkplot_flat2.py) excel, or any other plotting tool.

### Using the plotting tool

The plotting tool requires python 2.7 + and an environment with graphics capabilities (e.g. Mac/Linux with Desktop).

You need to install the dependencies with:
```
pip install matplotlib
```

To run:
```
./mkplot_flat2.py  <test-results>.txt
```
The tool will open a graphical window with the result and it will also create automatically a graphic file.

You can adjust the axes and the plot style (lines vs. points) via command line arguments.
Here is the usage message:
```
Usage: ./mkplot_flat2.py (--lines | --points | --xmax ("auto" | number) | --ymax ("auto" | number) | --yscale ("log" | "linear" | "auto") | filename) * [ -- filename]
       ... with filename occuring exactly once.
```

The plotting tool was kindly provided by Gheorghe Almasi and is the same used for the OpenStack scalability tests.
