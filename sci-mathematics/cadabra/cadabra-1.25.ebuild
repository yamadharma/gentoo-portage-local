# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="Field-theory motivated computer algebra system"
HOMEPAGE="http://cadabra.phi-sci.com"
SRC_URI="http://cadabra.phi-sci.com/${P}.tar.gz"
#### Remove the following line when moving this ebuild to the main tree!
RESTRICT="mirror"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE="doc examples X"
DEPEND="sci-libs/modglue
	sci-mathematics/lie
	dev-libs/gmp[-nocxx]
	dev-libs/libpcre
	X? ( >=x11-libs/gtk+-2.0
	    >=dev-cpp/gtkmm-2.4
	    app-text/dvipng )
	doc? ( || ( app-text/texlive-core dev-tex/pdftex ) )"
RDEPEND="${DEPEND}
	virtual/latex-base
	dev-tex/mh"

src_prepare(){
	# deal with pre-stripping - note that upstream do not provide any makefile.am
	epatch "${FILESDIR}/${P}-no-stripping.patch"
}

src_configure(){
	econf $(use_enable X gui)
}

src_compile() {

	emake

	if ( use doc )
	then
		cd "${S}/doc"
		emake
		cd doxygen/latex
		emake pdf
	fi
}

src_install() {
	emake DESTDIR="${D}" DEVDESTDIR="${D}" install || die "install died"

	dodoc AUTHORS ChangeLog INSTALL || die

	if ( use doc )
		then
		cd "${S}/doc/doxygen"
		dohtml html/*
		dodoc latex/*.pdf
	fi

	if ( use examples )
	then
		docinto examples
		dodoc "${S}/examples/*"
	fi

	rm -rf "${D}/usr/share/TeXmacs"
}

pkg_postinst() {
	/usr/sbin/texmf-update
	elog "This version of the cadabra ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id= 194393"
}

pkg_postrm()
{
	/usr/sbin/texmf-update
}
