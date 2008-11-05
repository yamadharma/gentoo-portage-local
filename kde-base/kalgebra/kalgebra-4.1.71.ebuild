# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

KMNAME=kdeedu
OPENGL_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="MathML-based graph calculator for KDE."
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook +plasma python readline"

DEPEND="opengl? ( virtual/opengl )
	plasma? ( kde-base/libplasma:${SLOT} )
	python? ( kde-base/pykde4:${SLOT} )
	readline? ( sys-libs/readline )"
RDEPEND="${DEPEND}"

KMEXTRACTONLY=libkdeedu/kdeeduui

# Needed for USE="-opengl"
PATCHES=( "${FILESDIR}/${PN}-4.1.68-opengl.patch"
          "${FILESDIR}/${P}-compile.patch" )

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with readline Readline)
		$(cmake-utils_use_with plasma Plasma)
		$(cmake-utils_use_with python PyKDE4)
		$(cmake-utils_use_with opengl OpenGL)"

	kde4-meta_src_configure
}
