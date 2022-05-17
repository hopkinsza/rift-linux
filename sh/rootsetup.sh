#!/usr/bin/env mksh

set -e
source err.subr

####
#### Functions
####

function populate {
	if [[ $# != 1 ]]; then
		fatal 'populate(): wrong number of args'
	fi

	# common to all
	mkdir bin sbin
	mkdir lib libexec
	# libdata?

	usr_and_local='games include share src'

	case "$1" in
	root)
		mkdir etc
		mkdir boot dev home mnt opt proc root sys tmp usr var

		cd var
		populate-var
		cd ..
		;;
	usr)
		mkdir $usr_and_local
		mkdir local
		;;
	local)
		mkdir $usr_and_local
		mkdir etc
		;;
	*)
		fatal 'populate(): unrecognized arg'
		;;
	esac
}

function populate-var {
	mkdir backups cron log mail run spool tmp
	ln -s ./run ../run

	# more possibilities:
	# cache, crash, games, msgs
	# db, preserve (bsd)
	# lib (linux)

}


####
#### Set up the filesystem
####

cd $d

populate root

cd usr
populate usr

cd local
populate local

cd ../..

#
# Populate /dev
#

# The /dev/console node is used by init to make the console its ctty,
# before /etc/rc is run and mounts devtmpfs.
# The shell complains if /dev/tty doesn't exist.
cd dev
mknod console c 5 1
mknod tty c 5 0
cd ..

#
# Permissions
#

chmod 1777 tmp var/tmp
