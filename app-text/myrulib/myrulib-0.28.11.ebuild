# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
WX_GTK_VER="2.8"

inherit eutils wxwidgets

DESCRIPTION="E-book collection manager"
HOMEPAGE="http://www.lintest.ru/wiki/MyRuLib"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+icu reader syslog"

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	>=dev-libs/faxpp-0.4
	dev-db/sqlite:3[fts3,icu?]
	icu? ( dev-libs/icu )
	reader? (
		media-libs/freetype:2
		media-libs/libpng
		virtual/jpeg
		sys-libs/zlib
	)
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
"

src_prepare() {
	# for sure
	rm -rf \
		3rdparty/faxpp \
	|| die
#		3rdparty/sqlite3 \
}

src_configure() {
	econf \
		$(use_with icu) \
		$(use_with reader) \
		$(use_with syslog) \
		--with-sqlite \
		--without-strip
}
