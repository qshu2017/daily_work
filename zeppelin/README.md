Steps:
1. First build java docker file
2. Before build conductor-spark, first copy the spark package from $EGO_TOP/condocutor/builtin/pacakges/Sparkxxx/ and untar the files then copy the spark file under files location. create lib director and place the libvem.so libz.so.1  and sec_ego_default.so in.
3. Before use this Dockerfile to build image, please first get the Zeppelin package from $EGO_TOP/conductor/builtin/notebooks/Zeppelin-0.5/Zeppelin.tar.gz and then untar the tar file and ONLY put the zeppelin-0.5.0-incubating-bin-spark-1.4.0_hadoop-2.3 under files location, then run docker build to build the docker images

