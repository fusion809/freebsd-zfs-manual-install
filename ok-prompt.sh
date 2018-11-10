unload
load /boot/kernel/kernel
load /boot/kernel/opensolaris.ko
load /boot/kernel/zfs.ko
set currdev="disk0p5"
set vfs.root.mountfrom="zfs:zroot"
boot
