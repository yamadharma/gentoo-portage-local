# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdegraphics
inherit kde4overlay-meta

DESCRIPTION="KDE screen gamma values kcontrol module"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

DEPEND="x11-apps/xgamma
	x11-libs/libXxf86vm
	x11-proto/xf86vidmodeproto"
RDEPEND="${DEPEND}"
