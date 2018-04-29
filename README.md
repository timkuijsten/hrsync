# hrsync

A minimal and hardened version of rsync that only supports receiving and sending
of files over ssh.

Features:
* Removed local-only transfers, daemon mode and batch operations
* Disabled support for ancient protocol versions
* Secure ssh-keys by combining two new options: --chroot and --dropsuper
* [pledge(2)d] to use file-system interfaces only (requires OpenBSD)

Status: **release candidate**

The hardening and security parts are done, broader testing is needed in order to
check if it doesn't break common use cases.


## Installation

Compile and install hrsync on OpenBSD:

```sh
$ git clone https://github.com/timkuijsten/hrsync.git
$ cd hrsync
$ make
$ doas make install
```

Use hrsync as a drop-in replacement for rsync:
```sh
$ doas cp -p /usr/local/bin/hrsync /usr/local/bin/rsync
```


### Requirements

Currently [OpenBSD] is required to run hrsync. Maybe it's worth to make the
pledge calls optional so that it can be used on systems without pledge.


## Usage tips

1. Use --chroot and --dropsuper to deny access from hrsync to the ssh private key
2. Use the following options for the tightest pledge (especially when using
--chroot):
	* --numeric-ids (don't pledge use of getpw)
	* --no-specials (don't pledge use of dpath and unix)
	* --no-devices (don't pledge use of dpath)


## What is pledged

When using rsync in archive mode (-a) the following set of pledges are used:
* When receiving files from a remote rsync:
	* stdio
	* proc
	* fattr
	* rpath
	* cpath
	* wpath
	* dpath
	* unix
	* getpw
* When sending files to a remote rsync:
	* stdio
	* proc
	* rpath

See **Usage tips** on how to drop the need for *dpath*, *unix* and *getpw*.

## License

[rsync] is distributed under the GPL version 3. For simplicity these patches are
distruted under the GPL version 3 as well.

[rsync]: https://rsync.samba.org/
[pledge(2)d]: http://man.openbsd.org/pledge.2
[OpenBSD]: https://www.openbsd.org/
