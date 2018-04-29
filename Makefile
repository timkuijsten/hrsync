hrsync: buildhrsync patch-* rsync-3.1.3/*.[ch]
	./buildhrsync

install: hrsync
	install -m 0555 -g bin hrsync /usr/local/bin

clean:
	rm -f hrsync
	rm -rf rsync-3.1.3/
