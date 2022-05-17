#!/usr/bin/env mksh

####
#### Sanity check
####

set -e
source err.subr

if [[ $(id -u) != 0 ]]; then
	fatal 'must run as root'
fi

export LC_ALL=C
umask 022

####
#### Directory to build in
####

# figure out dirname

d=
if [[ $# > 1 ]]; then
	fatal 'too many args'
elif [[ $# == 1 ]]; then
	d="$1"
else
	d=rift-root
fi

# make sure it exists and is empty

if [[ -e $d ]]; then
	# dir already exists, make sure it's empty
	# or a fresh filesystem
	list=`ls -A $d`
	if [[ $list = 'lost+found' ]]; then
		# allow a fresh filesystem
		list=''
	fi

	if [[ $list != '' ]]; then
		fatal "directory $d is not empty"
	fi
else
	mkdir $d
fi

export d

./sh/rootsetup.sh
