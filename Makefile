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

install: hrsync
	install -m 0555 -g bin hrsync /usr/local/bin

dropin: hrsync
	install -m 0555 -g bin hrsync /usr/local/bin/rsync

clean:
	rm -f hrsync
	rm -rf rsync-3.1.3/
