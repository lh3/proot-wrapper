This repo demonstrates the use of [PRoot][proot], a powerful [chroot][chroot]
emulator without the root permission. PRoot/chroot takes an arbitrary directory
as if it is a new root filesystem. It effectively provides a way to launch a
complex pipeline fully contained in a single directory. The following shows an
example:
```sh
wget https://github.com/lh3/proot-wrapper/releases/download/v1/proot-20151005.tgz
tar -zxf proot-20151005.tgz
wget https://github.com/lh3/proot-wrapper/releases/download/v1/sdust.rfs.tgz
tar -zxf sdust.rfs.tgz
proot/proot.pl sdust.rfs sdust MT.fa
```

[proot]: http://proot.me
[chroot]: https://en.wikipedia.org/wiki/Chroot
[care]: http://reproducible.io
