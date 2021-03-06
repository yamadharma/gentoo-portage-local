#!/bin/bash
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Author:  Martin Schlemmer <azarah@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/files/scan_libgcc_linked_ssp.sh,v 1.3 2004/07/15 00:59:02 agriffis Exp $

usage() {
cat << "USAGE_END"
Usage: can_libgcc_linked_ssp.sh

    This scans the system for files that contains the __guard symbol, that was
    linked against libgcc.


USAGE_END

        exit 1
}

if [ "$#" -ne 0 ]
then
	usage
fi

source /etc/profile
source /sbin/functions.sh

AWKDIR="$(portageq envvar PORTDIR)/sys-devel/gcc/files/awk"

if [ ! -r "${AWKDIR}/scanforssp.awk" ]
then
	eerror "${0##*/}: ${AWKDIR}/scanforssp.awk does not exist!"
	exit 1
fi

einfo "Scanning system for __guard@GCC symbols..."
/bin/gawk -f "${AWKDIR}/scanforssp.awk"

exit $?


# vim:ts=4
