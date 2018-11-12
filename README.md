# Manual FreeBSD 11.2 installation to a ZFS, alongside Arch Linux ext4 install

This repository pertains to a VirtualBox virtual machine of mine, that dual boots Arch Linux on a ext4 filesystem and FreeBSD 11.2 on a ZFS (both on the same virtual disk). Arch Linux does **not** need [ZFS][1] installed in order for the dual-boot to work, although it is helpful for, for example, accessing the files in ZFS from Arch. 

Boot the live DVD image (filename: [FreeBSD-11.2-RELEASE-amd64-dvd1.iso][2]), then run [`live-cd.sh`][3]. Then, with the live DVD image inserted, boot from it, but at the bootloader start press <kbd>Esc</kbd>. At the "ok" prompt run what is in [`ok-prompt.sh`][4]. Then in the newly booted system run what is in [`post-successful-boot.sh`][5]. To make the system automatically connect to the Internet on boot at [`etc/rc.local`][6] to `/etc`. 

[`Bootloader.md`][7] has the command required to change from booting with GRUB to using FreeBSD's bootloader. It has to be run from a FreeBSD live session (select 'Shell' from the dialogue that pops up after the live session boots).

The main source of this information is [this FreeBSD forum post from 2017][8] (archived [here][9]). Some parts I conjured by myself, based partly on experimentation and partly on past FreeBSD experience, like [`etc/rc.local`][6] and the last line of [`post-successful-boot.sh`][5]. 

[`etc/grub.d/40_custom`][10] is what, if placed in `/etc/grub.d`, will cause `grub-mkconfig -o /boot/grub/grub.cfg` to generate a GRUB configuration that will offer FreeBSD as a boot option, along with Arch. 

[1]: https://aur.archlinux.org/packages/?O=0&SeB=n&K=zfs-&outdated=&SB=p&SO=d&PP=50&do_Search=Go
[2]: https://download.freebsd.org/ftp/releases/amd64/amd64/ISO-IMAGES/11.2/FreeBSD-11.2-RELEASE-amd64-dvd1.iso
[3]: https://github.com/fusion809/freebsd-zfs-manual-install/blob/master/live-cd.sh
[4]: https://github.com/fusion809/freebsd-zfs-manual-install/blob/master/ok-prompt.sh
[5]: https://github.com/fusion809/freebsd-zfs-manual-install/blob/master/post-successful-boot.sh
[6]: https://github.com/fusion809/freebsd-zfs-manual-install/blob/master/etc/rc.local
[7]: https://github.com/fusion809/freebsd-zfs-manual-install/blob/master/Bootloader.md
[8]: https://forums.freebsd.org/threads/installing-freebsd-manually-no-installer.63201/
[9]: https://web.archive.org/web/20181110072004/https://forums.freebsd.org/threads/installing-freebsd-manually-no-installer.63201/
[10]: https://github.com/fusion809/freebsd-zfs-manual-install/blob/master/etc/grub.d/40_custom
