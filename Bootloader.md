If the bootloader of FreeBSD is overridden like by GRUB and you wish to boot it again run:

```bash
gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 4 ada0
```

from a FreeBSD live DVD shell. 
