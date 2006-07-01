# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/icu/icu-3.4.ebuild,v 1.3 2005/11/10 03:18:25 weeve Exp $

DESCRIPTION="IBM Internationalization Components for Unicode"
SRC_URI="ftp://ftp.software.ibm.com/software/globalization/icu/${PV}/${P}.tgz"
HOMEPAGE="http://ibm.com/software/globalization/icu/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~ppc-macos ~sparc x86 amd64"
IUSE=""

DEPEND="virtual/libc"

S="${WORKDIR}/${PN}/source"

src_compile() {
	econf || die "econf failed"
	emake -j1 || die "emake failed"  # bug 102426
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"
	dohtml ../readme.html ../license.html
}
