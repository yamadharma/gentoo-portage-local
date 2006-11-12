# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libferrisstreams/libferrisstreams-0.5.0.ebuild,v 1.2 2006/03/23 05:13:46 vapier Exp $

inherit flag-o-matic

DESCRIPTION="Loki Standard C++ IOStreams extensions"
HOMEPAGE="http://witme.sourceforge.net/libferris.web/"
SRC_URI="mirror://sourceforge/witme/ferrisstreams-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="stlport"

DEPEND="stlport? ( >=dev-libs/STLport-4.6.2-r1 )
	>=dev-libs/libsigc++-1.2
	>=dev-libs/ferrisloki-2.1.0
	>=dev-libs/glib-2"

S=${WORKDIR}/ferrisstreams-${PV}

src_compile() {
	local myconf
	if ( ! use stlport ); then
		myconf="--disable-stlport"
	#	sed -i "s/-lstlport_gcc //g" ${S}/configure
	#	sed -i "s/-lstlport_gcc //g" ${S}/macros/ferrismacros.m4
	fi
	econf ${myconf} || die "econf failed"
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README
}
