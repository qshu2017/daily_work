vgextend can do what vgcreate + vgmerge did.

[root@hchenvm2 ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/mapper/rhel-root 24G 8.7G 15G 38% /
devtmpfs 3.9G 0 3.9G 0% /dev
tmpfs 3.9G 0 3.9G 0% /dev/shm
tmpfs 3.9G 8.5M 3.9G 1% /run
tmpfs 3.9G 0 3.9G 0% /sys/fs/cgroup
/dev/sr0 3.7G 3.7G 0 100% /mnt
/dev/sda1 497M 120M 378M 24% /boot

[root@hchenvm2 ~]# fdisk /dev/sdc
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x5d7d3676.

Command (m for help): n
Partition type:
p primary (0 primary, 0 extended, 4 free)
e extended
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-6291455, default 2048):
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-6291455, default 6291455):
Using default value 6291455
Partition 1 of type Linux and of size 3 GiB is set

Command (m for help): t
Selected partition 1
Hex code (type L to list all codes): 8e
Changed type of partition 'Linux' to 'Linux LVM'

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
[root@hchenvm2 ~]# pvs
PV VG Fmt Attr PSize PFree
/dev/sda2 rhel lvm2 a-- 24.51g 0
/dev/sdb1 rhel lvm2 a-- 2.00g 548.00m
[root@hchenvm2 ~]# pvcreate /dev/sdc1
Physical volume "/dev/sdc1" successfully created
[root@hchenvm2 ~]# vgs
VG #PV #LV #SN Attr VSize VFree
rhel 2 2 0 wz--n- 26.50g 548.00m
[root@hchenvm2 ~]# vgextend rhel /dev/sdc1
Volume group "rhel" successfully extended
[root@hchenvm2 ~]# vgs
VG #PV #LV #SN Attr VSize VFree
rhel 3 2 0 wz--n- 29.50g 3.53g
[root@hchenvm2 ~]# lvextend -L +3G -f -r /dev/rhel/root
Size of logical volume rhel/root changed from 23.47 GiB (6008 extents) to 26.47 GiB (6776 extents).
Logical volume root successfully resized
meta-data=/dev/mapper/rhel-root isize=256 agcount=5, agsize=1439744 blks
= sectsz=512 attr=2, projid32bit=1
= crc=0 finobt=0
data = bsize=4096 blocks=6152192, imaxpct=25
= sunit=0 swidth=0 blks
naming =version 2 bsize=4096 ascii-ci=0 ftype=0
log =internal bsize=4096 blocks=2812, version=2
= sectsz=512 sunit=0 blks, lazy-count=1
realtime =none extsz=4096 blocks=0, rtextents=0
data blocks changed from 6152192 to 6938624
[root@hchenvm2 ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/mapper/rhel-root 27G 8.7G 18G 33% /
devtmpfs 3.9G 0 3.9G 0% /dev
tmpfs 3.9G 0 3.9G 0% /dev/shm
tmpfs 3.9G 8.5M 3.9G 1% /run
tmpfs 3.9G 0 3.9G 0% /sys/fs/cgroup
/dev/sr0 3.7G 3.7G 0 100% /mnt
/dev/sda1 497M 120M 378M 24% /boot
