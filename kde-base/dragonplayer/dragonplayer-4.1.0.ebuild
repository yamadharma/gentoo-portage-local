# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdemultimedia
inherit kde4overlay-meta

DESCRIPTION="Dragon Player is a simple video player for KDE 4"
HOMEPAGE="http://dragonplayer.org/"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/xine-lib-1.1.9
	kde-base/phonon-xine:${SLOT}"
DEPEND="${RDEPEND}
	sys-devel/gettext"
pkg_setup() {
	if ! built_with_use kde-base/phonon-xine xcb ; then
		eerror "In order to build "
		eerror "you need kde-base/phonon-xine built with xcb USE flag"
		die "no xcb support in phonon-xine"
	fi
}
