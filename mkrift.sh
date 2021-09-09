#!/bin/ksh

warnx() {
	printf -- "$0: "
	printf -- "$@\n"
}
errx() {
	e=$1; shift
	warnx "$@"
	exit $e
}

populate_common() {
	mkdir -p bin etc include lib libexec sbin share/man src
	ln -s share/man man
}

d=rift-root


#
# Run as root
#

[[ $(id -u) != 0 ]] && errx 1 "must run as root"


### 
### Set up the main filesystem
### 

#
# Directory
#

[[ -e $d ]] && errx 1 "$d already exists"

umask 022
mkdir $d
cd $d

mkdir bin boot dev etc home mnt opt proc root sbin srv sys tmp usr var

#
# Populate /dev
#

# the /dev/console node is used by init to make the console its ctty,
# before /etc/rc is run and mounts devtmpfs
cd dev
mknod console c 5 1
mknod tty c 5 0
cd ..

#
# Populate /usr
#

cd usr
mkdir bin games include lib local sbin share
# /usr/local
cd local
populate_common
cd ..
#
cd ..

#
# Populate /var
#

mkdir backups cache cron lib lock log mail run spool tmp

#
# Symlinks/permissions
#

ln -s var/run run
chmod 1777 tmp var/tmp


###
### Add packages to the filesystem
###
