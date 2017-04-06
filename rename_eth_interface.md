The following example shows one method of disabling consistent network device naming.
1. Back up the network interface files to another directory, for example $HOME:
 mv /etc/sysconfig/network-scripts/ifcfg-e*  $HOME
2. Edit the /etc/default/grub file. Add net.ifnames=0 to the end of GRUB_CMDLINE_LINUX:
GRUB_CMDLINE_LINUX = “rd.lvm.lv=rhel/swap crashkernel=auto rd.lvm.lv=rhel/root 
rhgb quiet net.ifnames=0”
3. Update the GRUB2 configuration file:
grub2-mkconfig -o /boot/grub2/grub.cfg
4. restart the host
