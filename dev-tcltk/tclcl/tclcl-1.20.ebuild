# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tclcl/tclcl-1.19.ebuild,v 1.3 2007/05/03 15:19:16 gustavoz Exp $

EAPI=4

WANT_AUTOMAKE="latest"
WANT_AUTOCONF="latest"

#inherit eutils autotools
inherit cmake-utils multilib flag-o-matic

MY_P="${PN}-src-${PV}"
DESCRIPTION="Tcl/C++ interface library"
HOMEPAGE="http://otcl-tclcl.sourceforge.net/tclcl/"
SRC_URI="mirror://sourceforge/otcl-tclcl/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="x11-libs/libX11
	x11-libs/libXt
	=dev-lang/tcl-8.5*
	=dev-lang/tk-8.5*
	>=dev-tcltk/otcl-1.11"


src_prepare() {
	cp ${FILESDIR}/CMakeLists.txt .
	cp ${FILESDIR}/tclcl.pc.cmake .
	cp ${FILESDIR}/config-tclcl.h.cmake .
}

src_configure() {
#	append-flags -DHAVE_UNISTD_H

	local mycmakeargs=(
		-DLIB_INSTALL_DIR=/usr/$(get_libdir) 
		-DINCLUDE_INSTALL_DIR=/usr/include
	)
	cmake-utils_src_configure
#	cmake ${S}
}


#src_unpack() {
#	unpack ${A}
#	cd "${S}"
#	epatch "${FILESDIR}"/${PN}-1.16-http.patch
#	epatch "${FILESDIR}"/${P}-configure-cleanup.patch
#	eautoreconf
#}

src_compile_() {
	local tclv tkv myconf

	tclv=$(grep TCL_VER /usr/include/tcl.h | sed 's/^.*"\(.*\)".*/\1/')
	tkv=$(grep TK_VER /usr/include/tk.h | sed 's/^.*"\(.*\)".*/\1/')
	myconf="--with-tcl-ver=${tclv} --with-tk-ver=${tkv}"

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install_() {
	dolib.a libtclcl.a
	dobin tcl2c++
	insinto /usr/include
	doins *.h

	dodoc FILES README VERSION
	dohtml CHANGES.html
}
