FETCH=ftp
CKSUM=sha256

all:
	make build

rsync-3.1.3.tar.gz:
	${FETCH} https://download.samba.org/pub/rsync/src/rsync-3.1.3.tar.gz

rsync-3.1.3: rsync-3.1.3.tar.gz
	${CKSUM} -c SHA256SUMS
	tar zxf rsync-3.1.3.tar.gz
	patch rsync-3.1.3/rsync.h	patch-rsync_h
	patch rsync-3.1.3/rsync.c	patch-rsync_c
	patch rsync-3.1.3/main.c	patch-main_c
	patch rsync-3.1.3/pipe.c	patch-pipe_c
	patch rsync-3.1.3/options.c	patch-options_c
	patch rsync-3.1.3/support/rrsync	patch-rrsync

build: rsync-3.1.3
	cd rsync-3.1.3 && ./configure \
		--disable-locale \
		--disable-iconv-open \
		--disable-iconv \
		--disable-acl-support \
		--disable-xattr-support \
		--with-included-popt \
		--with-included-zlib && make
	cp rsync-3.1.3/rsync hrsync
	cp rsync-3.1.3/rsync.1 hrsync.1
	cp rsync-3.1.3/support/rrsync .

install: hrsync
	install -m 0555 -g bin hrsync /usr/local/bin
	install -m 0644 -g bin hrsync.1 /usr/local/man/man1
	install -m 0555 -g bin rrsync /usr/local/bin

dropin: install
	ln -f /usr/local/bin/hrsync /usr/local/bin/rsync
	ln -f /usr/local/man/man1/hrsync.1 /usr/local/man/man1/rsync.1

clean:
	rm -f hrsync hrsync.1 rrsync
	rm -rf rsync-3.1.3/
