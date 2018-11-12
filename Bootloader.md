If the bootloader of FreeBSD is overridden like by [GRUB][1] and you wish to boot it again run (you may wish to view the [gpart(8)][2] man page):

```bash
gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 4 ada0
```

from a FreeBSD live DVD shell. 

[1]: https://en.wikipedia.org/wiki/GRUB
[2]: https://en.wikipedia.org/wiki/gpart
