This repo demonstrates the use of [PRoot][proot], a powerful [chroot][chroot]
emulator without the root permission. PRoot/chroot takes an arbitrary directory
as if it is a new root filesystem. It effectively provides a way to launch a
complex pipeline with dependencies fully contained in a single directory. The
following shows an example:
```sh
wget https://github.com/lh3/proot-wrapper/releases/download/v1/proot-20151005.tgz
tar -zxf proot-20151005.tgz
wget https://github.com/lh3/proot-wrapper/releases/download/v1/sdust.rfs.tgz
tar -zxf sdust.rfs.tgz
proot/proot.pl sdust.rfs sdust MT.fa
```
The structure of `sdust.rfs` looks like:
```
sdust.rfs
|-- bin
|   `-- sdust
|-- lib
|   `-- x86_64-linux-gnu
|       |-- ld-2.15.so
|       |-- libc-2.15.so
|       |-- libc.so.6 -> libc-2.15.so
|       |-- libz.so.1 -> libz.so.1.2.3.4
|       `-- libz.so.1.2.3.4
`-- lib64
    `-- ld-linux-x86-64.so.2
```
When we run
```sh
proot/proot -r sdust.rfs sdust
```
PRoot effectively creates a new root filesystem isolated from the rest of the
parent filesystem. In this new root filesystem, executable `sdust` is in the
default system `bin` directory and linked to dynamic libraries in `lib` and
`lib64` inside `sdust.rfs`, but not the libraries in the parent filesystem.

In addition to dependency isolation, PRoot can also mount parent filesystems
into the new root filesystem. For example
```sh
proot/proot -r sdust.rfs -b $HOME -b /dev sdust
```
Then programs inside `sdust.rfs` can access files in the home directory.
Similarly, if we map all parent mount points into the new root filesystem, we
can access every file in the parent filesystem. `proot.pl` achieves this goal.

How to create such a `sdust.rfs`? We can use [CARE][care], a sister project of
PRoot. CARE grabs all dependencies and package them in a single rootfs. This
example was adapted from a CARE dump created on an Ubuntu 12.04 machine. Note
that `sdust.rfs/bin/sdust` doesn't run on CentOS6 by itself due to glibc ABI
incompatibility, but with PRoot, it runs smoothly. However, the example doesn't
run on CentOS5 due to its ancient Linux kernel 2.6.18.

[proot]: http://proot.me
[chroot]: https://en.wikipedia.org/wiki/Chroot
[care]: http://reproducible.io
