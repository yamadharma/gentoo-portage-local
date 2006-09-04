# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/krita/krita-1.5.2-r1.ebuild,v 1.2 2006/08/30 20:59:19 flameeyes Exp $

MAXKOFFICEVER=${PV}
KMNAME=koffice
inherit kde-meta eutils

DESCRIPTION="KOffice image manipulation program."
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"

SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
# See bug #130442.
#IUSE="opengl"
IUSE=""

DEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-libs)
	>=media-gfx/imagemagick-6.2.5.5
	>=media-libs/lcms-1.14-r1
	media-libs/tiff
	media-libs/jpeg
	media-libs/openexr
	media-libs/libpng
	>=media-libs/libexif-0.6.13-r1
	virtual/opengl
	virtual/glu"

#opengl? ( virtual/opengl virtual/glu )"

KMCOPYLIB="libkformula lib/kformula
	libkofficecore lib/kofficecore
	libkofficeui lib/kofficeui
	libkopainter lib/kopainter
	libkopalette lib/kopalette
	libkotext lib/kotext
	libkwmf lib/kwmf
	libkowmf lib/kwmf
	libkstore lib/store
	libkrossapi lib/kross/api/
	libkrossmain lib/kross/main/"

KMEXTRACTONLY="lib/"

KMEXTRA="filters/krita"

need-kde 3.4

pkg_setup() {
	# use opengl &&
		if ! built_with_use x11-libs/qt opengl ; then
			eerror "You need to build x11-libs/qt with opengl use flag enabled."
			die
		fi
}

src_compile() {
#	local myconf="$(use_with opengl gl)"

	for i in $(find ${S}/lib -iname "*\.ui"); do
		${QTDIR}/bin/uic ${i} > ${i%.ui}.h
	done

	kde-meta_src_compile
}