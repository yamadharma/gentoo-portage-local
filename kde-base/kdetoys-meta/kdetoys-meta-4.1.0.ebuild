# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit kde4overlay-functions

DESCRIPTION="kdetoys - merge this to pull in all kdetoys-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.1"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=kde-base/amor-${PV}:${SLOT}
	>=kde-base/kteatime-${PV}:${SLOT}
	>=kde-base/ktux-${PV}:${SLOT}
	>=kde-base/kweather-${PV}:${SLOT}
	"
	#>=kde-base/kworldclock-${PV}:${SLOT}
	#"
