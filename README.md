## Getting Started
```sh
# download example source code, vcf-validator which requires both c++11 and boost
git clone https://github.com/EBIvariation/vcf-validator
# download, unpack and launch centos5dev
wget https://github.com/lh3/proot-wrapper/releases/download/v2/centos5dev-v2.tar.bz2
tar -jxf centos5dev-v2.tar.bz2
centos5dev/run  # this enters the centos5dev "virtual machine"
# compile vcf-validator
mkdir -p vcf-validator/build
cd vcf-validator/build
cmake .. && make -j2
# exit the "virtual machine"
exit  # or press "control-D"
```

## About centos5dev

Centos5dev is a package that helps to create portable precompiled binaries for
64-bit Linux. It comes with fundamental libraries from CentOS5 and recent
development tools such as cmake-3.3, gcc-4.9 and boost-1.57.  It uses
[PRoot][proot] to *mimic* a virtual machine entirely in the user space (i.e.
the root permission is *never* required), such that we can compile tools
as if we are working on a CentOS 5 machine. As tools compiled on CentOS 5 are
easily portable to other Linux distributions, tools compiled with centos5dev
are also portable.

Centos5dev can also be used to test if a binary works on CentOS 5:
```sh
cd mytool-dir
/path/to/centos5dev/run
./mytool
```
If `mytool` does not run, it will not work on CentOS 5.

Centos5dev has the following tools or libraries installed, all statically
linked: gcc-4.9.2, cmake-3.3.2, boost-1.57, zlib-1.2.8, sqlite-3.8.11.1,
sparsehash-2.0.2, LibreSSL-2.1.3, curl-7.40.0 and libssh2-1.4.3.

## About PRoot

[PRoot][proot] is a powerful [chroot][chroot] emulator without the root
permission. PRoot/chroot takes an arbitrary directory as if it is a new root
filesystem, isolated from the rest of filesystems. It effectively provides a
way to launch a complex pipeline, or even an entire Linux distribution, with
dependencies fully contained in a single directory.

[proot]: http://proot.me
[chroot]: https://en.wikipedia.org/wiki/Chroot
