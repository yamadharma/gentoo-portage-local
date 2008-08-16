# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdesdk
KMNOMODULE=true
inherit kde4overlay-meta

DESCRIPTION="kdesdk-misc - Various files and utilities"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

# FIXME:
# currently broken:
#	kdepalettes/
# currently doesn't do anything: scheck
KMEXTRA="
	scheck/
	poxml/
	kprofilemethod/"
