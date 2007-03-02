# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils wxwidgets

DESCRIPTION="Multithreaded download manager (also known as wxDownload Fast)"
HOMEPAGE="http://dfast.sourceforge.net/"
SRC_URI="mirror://sourceforge/dfast/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="debug"

DEPEND=">=x11-libs/wxGTK-2.6"
RDEPEND="${DEPEND}"

src_compile() {
	WX_GTK_VER=2.6
	need-wxconfig unicode
	econf $(use_enable debug) \
	    --with-wx-config=/usr/bin/wx-config-2.6
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	doicon resources/RipStop/icon/wxdfast.png
	#the makefile creates the appropriate desktop entry

	dodoc AUTHORS ChangeLog README TODO
}
