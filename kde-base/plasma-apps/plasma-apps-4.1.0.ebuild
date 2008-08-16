# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdebase
KMMODULE=apps/plasma
inherit kde4overlay-meta

DESCRIPTION="Additional Applets for Plasma"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

DEPEND="!kde-base/plasma:${SLOT}
	kde-base/libplasma:${SLOT}
	kde-base/libkonq:${SLOT}"
