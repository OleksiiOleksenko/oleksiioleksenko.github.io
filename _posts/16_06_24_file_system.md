<!--Title: A Newcomer's View on File Systems-->
<!--Date: 2016-06-24 12:00-->
<!--Category: OS-->
<!--Tags: -->


**Disclaimer**: *Right now, I'm learning this topic myself and thus the information here may be not precise or
might even be completely wrong. Also, all examples here are targeted on Linux.*

So what is a file system? From a bird's eye view, file system is a system that manages files - creates and removes them,
structures them and does all the other supervisory things. But what is the file?

## Files

The file is just a unit of stored information. The main goal of a file system is to provide high level abstraction
for persistent storage, regardless of what type of storage is used - a magnetic disk, solid-state drive or even optical disk.

There are two main file types: regular files and directories. Regular files contain user information and directory files
keep file system's structure metadata.

### Regular files

Regular files, in turn, can contain either text (e.g., ASCII text) or binary data. The particular type of a file can
be defined with the `file` command:

```sh
> file myfile.txt
myfile.txt: ASCII text

> file test.c
test.c: C source, ASCII text

> file a.out
a.out: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=3bd74c6ad1d561a98f1d23e2da8121f960844c7a, not stripped
```

The internal structure of a file is pretty much arbitrary and it depends on the file type. For example,
a simple text file contains only the text itself and the EOF (end of file) symbol:

```sh
> hexdump -C myfile.txt
00000000  74 65 73 74 0a                                    |test.|
00000005
```

Here, the first 4 numbers are the ASCII symbols: 74 = t, 65 = e, 73 = s, 0a - line feed, i.e. new line. The EOF symbol is implicit here. 

Binary files, on the contrary, have very complex structure and contents of such a file are not particularly conceivable directly. On Linux, the [ELF](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)
format is a standard for executable and object files, and one of the common ways of reading contents of an ELF file is to use `readelf` utility:

```sh
> readelf -a a.out
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00 
  Class:                             ELF64
  Data:                              2's complement, little endian
...
```

In addition to file's data itself, Linux keeps a bunch of attributes for each file, including protection, creation time, size and other things.
Apart from the `ls` command, you can use the `lsattr` command to display the list of additional attributes of a file and `chattr` - to change them:

```sh
> lsattr myfile.txt
---------------- myfile.txt

> chattr +a myfile.txt  # make the file append-only
> lsattr myfile.txt
-----a---------- myfile.txt

> echo "foo" >> myfile.txt  # append works fine
> cat myfile.txt
foo

> echo "foo" > myfile.txt  # but re-writing is forbidden 
bash: myfile.txt: Operation not permitted
```


### Directories

Directories are files that are used to manage other files.
Well, nowadays it's not that simple, but the idea is still pretty similar.
Using Vim, you can even open it as a normal file:

```sh
> vim . 
" ============================================================================
" Netrw Directory Listing                                        (netrw v155)
"   /home/user/tmp
"   Sorted by      name
"   Sort sequence: [\/]$,\<core\%(\.\d\+\)\=\>,\.h$,\.c$,\.cpp$,\~\=\*$,*,\.o$,\.obj$,\.info$,\.swp$,\.bak$,\~$
"   Quick Help: <F1>:help  -:go up dir  D:delete  R:rename  s:sort-by  x:special
" ==============================================================================
../                                                                                                                                                                                                                                  
./
tmp.txt
tmp.txt~
```

But, even though Vim provides an abstraction of a regular file, a different (but similar)
set of system calls is used to manage directories, e.g. `opendir` is used instead of `open`.

## Partitions

The external interface of a file system consist of files, directories and operations on them.
From the physical point of view, however, there is another, larger unit of storage - a partition. Partition is a region of
disk that is managed separately by the OS, i.e., it is a slice of disk space which
is dedicated to one file system (and to only one).

Partitions' boundaries are tracked by a partition table. This table is usually stored
at the very beginning of the disk, in the Master Boot Record, and used for booting the computer.

There is also another level of abstraction - Logical Volume Management (LVM), which maps
physical partitions to logical ones. The main benefit of such an abstraction is ability to map one big
logical volume to multiple small physical partitions thus breaking the disk boundaries.

There are two simple ways to explore the underlying partition structure in Linux:

**Listing block devices**:

```sh
> lsblk
NAME            MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda               8:0    0 238.5G  0 disk 
├─sda1            8:1    0   200M  0 part /boot/efi
├─sda2            8:2    0   500M  0 part /boot
└─sda3            8:3    0 237.8G  0 part 
  ├─root        253:0    0 149.4G  0 lvm  /
  ├─swap        253:1    0  15.7G  0 lvm  [SWAP]
  └─home        253:2    0 280.0G  0 lvm  /home
sdb               8:16   0 200.7G  0 disk 
└─sdb1            8:17   0 200.7G  0 part 
  └─home        253:2    0 280.8G  0 lvm  /home
sdc               8:32   0 232.9G  0 disk 
└─sdc1            8:33   0 232.9G  0 part /run/media/user/ExternalDrive
sr0              11:0    1  1024M  0 rom  
```

The output may look a bit cryptic, but it gives us a lot of information.

All physical storage devices are named according to the following convention:

* The first two letter indicate the disk type. E.g., `sd` is a SCSI or SATA disk and `sr` is a CD-ROM.
* The third letter is just for ordering, i.e., `sda` is the first disk. 
* The fourth symbol is the partition number, i.e., `sda3` is the third partition on the first disk. `sda1` is usually used for booting.

As mentioned before, physical partitions may include one or more logical partitions (called _lvm_ in the column _TYPE_).
In this example, logical partition _home_ spawns between two physical disks `sda` and `sdb`.

**Listing partitions**:

```sh
> sudo fdisk -l  /dev/sda
Disk /dev/sda: 238.5 GiB, 256060514304 bytes, 500118192 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 5885E171-BD79-4DE9-BFED-7F5E8F7FCD00

Device       Start       End   Sectors   Size Type
/dev/sda1     2048    411647    409600   200M EFI System
/dev/sda2   411648   1435647   1024000   500M Linux filesystem
/dev/sda3  1435648 500117503 498681856 237.8G Linux LVM

...
```

This command shows the detailed information about the partition and also prints the partition table entries.

