#!/bin/sh
# This is all more or less taken from
# https://forums.freebsd.org/threads/installing-freebsd-manually-no-installer.63201/

# Partition table is GPT, with BIOS firmware. 
# /dev/sda1	/dev/ada0p1	1M	BIOS boot
# /dev/sda2	/dev/ada0p2	4G	Linux swap
# /dev/sda3	/dev/ada0p3	30G	Arch Linux root file system (ext4)
# /dev/sda4	/dev/ada0p4	128k	FreeBSD boot
# /dev/sda5	/dev/ada0p5	94G	FreeBSD ZFS

# The following line would only be executed if we're not talking about dual-boot
# gpart destroy -F ada0

# ls -l /boot/g* will show the size required (what comes after -s, but 128k should
# be more than enough
gpart add -t freebsd-boot -s 128k -l boot ada0

# Create ZFS partition
gpart add -t freebsd-zfs -l system ada0

# This command seems deprecated as it returns errors mentioning missing inputs
zfs import

# Create mount point
mkdir /tmp/zfs

# Create zroot pool
zpool create -m / -R /tmp/zfs zroot ada0p5

#Set it as bootable
zpool set bootfs=zroot zroot

# Set up subfilesystems
## Create /usr directory
mkdir /tmp/zfs/usr

## Create home subfs
zfs create zroot/home

### Create ports subfs
zfs create -o mountpoint=/usr/ports -o compression=on -o setuid=off zroot/ports
#### distfiles for downloaded files
zfs create -o compression=off -o exec=off -o setuid=off zroot/ports/distfiles
#### packages for built packages
zfs create -o compression=off -o exec=off -o setuid=off zroot/ports/packages

### local subfs for installed packages/ports
zfs create -o mountpoint=/usr/local zroot/local

### src subfs for core system source code (for building drivers and alike)
zfs create -o mountpoint=/usr/src -o compression=on zroot/src

### Documentation subfs
zfs create -o mountpoint=/usr/doc -o compression=on zroot/doc

## Create var subfs
zfs create zroot/var
zfs create -o exec=off -o setuid=off zroot/var/db
zfs create -o compression=on -o exec=on -o setuid=off zroot/var/db/pkg
zfs create -o compression=on -o exec=off -o setuid=off zroot/var/mail
zfs create -o compression=on -o exec=off -o setuid=off zroot/var/log
zfs create -o exec=off -o setuid=off zroot/var/run
zfs create -o exec=off -o setuid=off zroot/var/tmp
zfs create -o exec=off -o setuid=off zroot/tmp
chmod 1777 /tmp/zfs/tmp /tmp/zfs/var/tmp

### Create opt subfs
zfs create zroot/opt
zfs create -o refquota=250M zroot/opt/jails

## Swap fs
zfs create -V 4G zroot/swap
zfs set org.freebsd:swap=on zroot/swap

# Install the tar archives
cd /tmp/zfs
tar xvJf /usr/freebsd-dist/base.txz
tar xvJf /usr/freebsd-dist/kernel.txz
tar xvJf /usr/freebsd-dist/lib32.txz
tar xvJf /usr/freebsd-dist/ports.txz
tar xvJf /usr/freebsd-dist/doc.txz
tar xvJf /usr/freebsd-dist/src.txz

# Bootstrap boot
gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 4 ada0
cd /mnt/zfs/boot
echo 'zfs_load="YES"' > loader.conf
echo 'vfs.root.mountfrom="zfs:zroot"' >> loader.conf
echo 'zfs_enable="YES"' > ../etc/rc.conf

# Reboot time
shutdown -r now

