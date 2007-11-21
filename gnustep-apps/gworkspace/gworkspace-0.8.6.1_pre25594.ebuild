# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/gworkspace/gworkspace-0.8.6.ebuild,v 1.5 2007/11/08 23:36:22 voyageur Exp $

inherit autotools gnustep-2 subversion

ESVN_OPTIONS="-r${PV/*_pre}"
ESVN_REPO_URI="http://svn.gna.org/svn/gnustep/apps/gworkspace/trunk"

#S=${WORKDIR}/${P/gw/GW}

DESCRIPTION="A workspace manager for GNUstep"
HOMEPAGE="http://www.gnustep.it/enrico/gworkspace/"
#SRC_URI="http://www.gnustep.it/enrico/gworkspace/${P}.tar.gz"

KEYWORDS="amd64 ppc x86"
LICENSE="GPL-2"
SLOT="0"

IUSE="pdf"
DEPEND="pdf? ( gnustep-libs/popplerkit )
	>=gnustep-apps/systempreferences-1.0.1_p24791
	>=dev-db/sqlite-3.2.8"
RDEPEND="!gnustep-apps/desktop
	!gnustep-apps/recycler"

src_unpack() {
	subversion_src_unpack 
	cd "${S}"

	epatch "${FILESDIR}"/gworkspace-0.8.6-rpath.patch
	epatch "${FILESDIR}"/gworkspace-0.8.6-popplerkit.patch

	cd Inspector
	eautoreconf || die "failed running autoreconf"
}

src_compile() {
	local myconf=""

	use kernel_linux && myconf="${myconf} --with-inotify"

	egnustep_env
	econf ${myconf}
	egnustep_make

#	cd "${S}"/GWMetadata
#	ln -s ../DBKit
#	econf || die "GWMetadata configure failed"
#	egnustep_make || die "GWMetadata make failed"
}

src_install() {
	egnustep_env

	egnustep_install

#	cd "${S}"/GWMetadata
#	egnustep_install

	if use doc;
	then
		dodir /usr/share/doc/${PF}
		cp "${S}"/Documentation/*.pdf "${D}"/usr/share/doc/${PF}
	fi
}
