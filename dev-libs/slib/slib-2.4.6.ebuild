# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/slib/slib-2.4.6.ebuild,v 1.9 2006/07/28 17:51:53 dertobi123 Exp $

MY_P=${PN}2d6
S=${WORKDIR}/${PN}
DESCRIPTION="library providing functions for Scheme implementations"
SRC_URI="http://swissnet.ai.mit.edu/ftpdir/scm/${MY_P}.zip"
HOMEPAGE="http://swissnet.ai.mit.edu/~jaffer/SLIB.html"

SLOT="0"
LICENSE="public-domain BSD"
KEYWORDS="alpha amd64 ia64 ppc ~sparc x86"
IUSE=""

RDEPEND=">=dev-scheme/guile-1.4"
DEPEND="${RDEPEND}
	>=app-arch/unzip-5.21
	>=dev-scheme/guile-1.4"

RESTRICT="test"

src_install() {
	insinto /usr/share/guile/site/slib
	doins *.scm
	dodoc ANNOUNCE ChangeLog FAQ README
	doinfo slib.info
}

pkg_postinst() {
	if [ "${ROOT}" == "/" ] ; then
		einfo "Installing..."
		guile -c "(use-modules (ice-9 slib)) (require 'new-catalog)" "/"
	fi
}
