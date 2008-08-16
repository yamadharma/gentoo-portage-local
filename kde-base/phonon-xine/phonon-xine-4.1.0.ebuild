# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdebase-runtime
KMMODULE=phonon
inherit kde4overlay-meta

DESCRIPTION="KDE Phonon Xine backend"
KEYWORDS="~amd64 ~x86"
IUSE="debug +xcb"

# There's currently only a xine backend for phonon available,
# a gstreamer backend from TrollTech is in the works.
DEPEND="!kde-base/phonon:${SLOT}
	media-sound/phonon
	>=media-libs/xine-lib-1.1.9
	xcb? ( x11-libs/libxcb )"
RDEPEND="${DEPEND}"

src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with xcb XCB)
		-DWITH_Xine=ON"

	kde4overlay-meta_src_compile
}
