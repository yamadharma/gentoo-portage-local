# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdemultimedia
inherit kde4overlay-meta

DESCRIPTION="KDE mixer gui"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug htmlhandbook"

DEPEND="
	media-sound/phonon
	alsa? ( >=media-libs/alsa-lib-1.0.14a )"
RDEPEND="${DEPEND}"

src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with alsa Alsa)"
	kde4overlay-meta_src_compile
}
