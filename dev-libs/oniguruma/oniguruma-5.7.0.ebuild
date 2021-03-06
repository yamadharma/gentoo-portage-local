# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/oniguruma/oniguruma-4.1.1.ebuild,v 1.1 2006/07/01 04:01:22 usata Exp $

MY_P="onig-${PV}"

DESCRIPTION="Regular expression library"
HOMEPAGE="http://www.geocities.jp/kosako3/oniguruma/"
SRC_URI="http://www.geocities.jp/kosako3/oniguruma/archive/${MY_P}.tar.gz"

LICENSE="BSD"

SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc-macos x86"
IUSE=""

DEPEND="virtual/libc"

S=${WORKDIR}/${MY_P}

src_compile() {

	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc HISTORY README doc/*
}
