# Arch Linux and FreeBSD on ZFS dual-boot

This repository pertains to a [VirtualBox][1] virtual machine of mine, that dual boots [Arch Linux][2] on an [ext4][3] filesystem and [FreeBSD][4] 11.2 on a [ZFS][5] (both on the same virtual disk). Arch Linux does **not** need [ZFS][6] installed in order for the dual-boot to work. 

One side note: I found that ZFS installed on Arch cannot detect my FreeBSD ZFS (I ran `zpool list` with no pools listed), if you know why please let me know via email, or if you prefer an issue/pull request (like if you want to change this sentence in your PR). I suspect it is because ZFS on Linux and FreeBSD ZFS are distinct enough that they do not recognize each other.

I will assume you are reasonably familiar with how to set up a virtual machine in VirtualBox. If you know how to install Arch to a VirtualBox virtual machine then you should be fine in following this guide. If things are unclear open an issue and I will see about any necessary rewording or restructuring of this README or the scripts. 

## Virtual machine settings

These are my more relevant settings:

- Operating system: Arch Linux (64-bit).
	- This does not matter too much, you can choose FreeBSD if you wish, but the FreeBSD system still works fine with this option set to Arch.  
- Base memory: 4096 MB.
	- I think you could get away with even less than 512 MB, as we are working entirely at the command-line, but I chose 4 GB just to be safe.
- Processors: 6.
	- This is entirely up to you, I chose so many cores because I could and because I wanted the tedious parts of this to go as quickly as possible. 
- Boot order: Floppy, Optical, Hard Disk.
	- Also entirely optional, although optical before hard disk is advisable.
- Acceleration: VT-x/AMD-V, Nested Paging, KVM Virtualization.
	- I just chose the defaults here, I do not know if this really matters, but when in doubt just stick to the defaults.
- Video memory: 128 MB.
	- This I chose arbitrarily, just in case I choose to use a GUI, and I think you can set it to whatever you want. 
- Disk size: 128 GB.
	- This too is flexible, although I would not set it to anything less than 10 GB.
- Disk format: VDI.
	- This is the default and it works, so why change it?
- Network adapter 1: Intel PRO/1000 MT Desktop (NAT).
	- Also the default and it works. 
- No EFI firmware. 

In case it proves to be important later this was originally done with VirtualBox 5.2.20, with an openSUSE Tumbleweed 20181107 host. 

## Arch Linux

Simply follow the [installation guide][8] at the *ArchWiki*. I used an ext4 filesystem and the following disk geometry (which the instructions and scripts assume you will be using):

* `/dev/sda1` &mdash; BIOS boot at 1M. This is mandatory to my knowledge for a BIOS setup. If you prefer UEFI, this would be an ESP, which would need to be significantly larger than this (20 MB would probably be enough) and beware some of these instructions may need to be adjusted.
* `/dev/sda2` &mdash; Linux swap at 4G. This is optional, but I used it and it does seem wise, just as a safeguard in case of excessive RAM usage.
* `/dev/sda3` &mdash; Linux filesystem (ext4) at 50G. This will be the root filesystem of Arch Linux. The specifics of this partition should not really matter; frankly, I think it too could have a ZFS or similar filesystem. I just favour standard ext4 partitions, but it is up to you what you use here. 

What packages you install are largely up to you, but I do recommend installing GRUB and using it later to allow dual-booting the systems more easily. Interesting, both FreeBSD and Arch Linux use hard-coded kernel paths (`/boot/kernel/kernel` for FreeBSD and `/boot/vmlinuz-linux` for Arch Linux), that do not change with kernel upgrades; so, updating the GRUB configuration should not be necessary after it is initially set up properly. 

## Install FreeBSD to ZFS and set it up

Boot the live DVD image (filename: [FreeBSD-11.2-RELEASE-amd64-dvd1.iso][9]), in the FreeBSD Installer menu that appears, that is:

![FreeBSD Installer Prompt][10]

select "Shell", which you can enter by pressing <kbd>s</kbd>. Then run [`live-cd.sh`][11]; you can do this either by manually executing each command (which is probably wisest, especially if you are deviating a little from the way I did things), or by running:

```sh
fetch --no-verify-peer https://github.com/fusion809/freebsd-zfs-manual-install/raw/master/live-cd.sh -o /tmp/live-cd.sh
. /tmp/live-cd.sh
```

. After the final command of this script is executed (which is a `shutdown -r now`)&mdash;still with the live DVD image inserted&mdash;press <kbd>Esc</kbd> as soon as you see the FreeBSD Bootloader menu, which is:

![FreeBSD Bootloader screen][12]

. At the "ok" prompt run what is in [`ok-prompt.sh`][13]. Sadly, this must be done manually, although fortunately, it is not that long. This should boot your new FreeBSD install.

In the newly installed system run what is in [`post-successful-boot.sh`][14]. To execute this in one command run (although as before you may wish to look at it before doing this, just in case you wish to deviate a little from the default):

```sh
fetch --no-verify-peer https://github.com/fusion809/freebsd-zfs-manual-install/raw/master/post-successful-boot.sh -o /tmp/post-successful-boot.sh
. /tmp/post-successful-boot.sh
```

. To make the system automatically connect to the Internet on boot, if it does not already, add [`etc/rc.local`][15] to `/etc`. 

## Setting up GRUB

Reboot into Arch Linux, install GRUB if you have not done so already, then add [`etc/grub.d/40_custom`][17] to `/etc/grub.d`. Then run `grub-mkconfig -o /boot/grub/grub.cfg` to generate a GRUB configuration that will offer FreeBSD as a boot option, along with Arch. 

## Switching bootloaders back

[`Bootloader.md`][16] has the command required to change from booting with GRUB to using FreeBSD's bootloader. It has to be run from a FreeBSD live session shell (that is, what you ran `live-cd.sh` in).

## Credits

The main source of this information is [this FreeBSD forum post from 2017][18] (archived [here][19]). Some parts I conjured by myself, based partly on experimentation and partly on past FreeBSD experience, like [`etc/rc.local`][15] and the last line of [`post-successful-boot.sh`][14]. 

## Contributing

If you have some improvements to these scripts I would welcome [pull requests][20] (even for something as simple as spelling/grammatical fixes) or [issues][21]. 

## License

Everything that is mine to license is licensed under the [GPLv3][22] license. 

[1]: https://en.wikipedia.org/wiki/VirtualBox
[2]: https://en.wikipedia.org/wiki/Arch_Linux
[3]: https://en.wikipedia.org/wiki/ext4
[4]: https://en.wikipedia.org/wiki/FreeBSD
[5]: https://en.wikipedia.org/wiki/ZFS
[6]: https://aur.archlinux.org/packages/?O=0&SeB=n&K=zfs-&outdated=&SB=p&SO=d&PP=50&do_Search=Go
[7]: https://fusion809.github.io/images/VBox/Arch-ext4-FreeBSD-11.2-ZFS-VBox-settings.png
[8]: https://wiki.archlinux.org/index.php/Installation_guide
[9]: https://download.freebsd.org/ftp/releases/amd64/amd64/ISO-IMAGES/11.2/FreeBSD-11.2-RELEASE-amd64-dvd1.iso
[10]: https://imgur.com/mAvRJRX.png
[11]: https://github.com/fusion809/freebsd-zfs-manual-install/blob/master/live-cd.sh
[12]: https://imgur.com/sDg6iyR.png
[13]: https://github.com/fusion809/freebsd-zfs-manual-install/blob/master/ok-prompt.sh
[14]: https://github.com/fusion809/freebsd-zfs-manual-install/blob/master/post-successful-boot.sh
[15]: https://github.com/fusion809/freebsd-zfs-manual-install/blob/master/etc/rc.local
[16]: https://github.com/fusion809/freebsd-zfs-manual-install/blob/master/Bootloader.md
[17]: https://github.com/fusion809/freebsd-zfs-manual-install/blob/master/etc/grub.d/40_custom
[18]: https://forums.freebsd.org/threads/installing-freebsd-manually-no-installer.63201/
[19]: https://web.archive.org/web/20181110072004/https://forums.freebsd.org/threads/installing-freebsd-manually-no-installer.63201/
[20]: https://github.com/fusion809/freebsd-zfs-manual-install/pulls
[21]: https://github.com/fusion809/freebsd-zfs-manual-install/issues
[22]: https://github.com/fusion809/freebsd-zfs-manual-install/blob/master/LICENSE
