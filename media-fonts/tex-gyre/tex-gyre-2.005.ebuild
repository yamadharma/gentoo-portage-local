# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit latex-package font

MY_P=tg-${PV}bas

DESCRIPTION="Fonts extending freely available URW fonts."
HOMEPAGE="http://www.gust.org.pl/projects/e-foundry/tex-gyre"
SRC_URI="${HOMEPAGE}/whole/${MY_P}.zip"
LICENSE="GUST-FONT-LICENSE"

SLOT="0"
KEYWORDS="x86 amd64"
IUSE="latex doc"

SUPPLIER="public"
S=${WORKDIR}/
# FONT_S=${S}/fonts/opentype/${SUPPLIER}/${PN}
FONT_SUFFIX="otf"

src_install() {
	if use latex; then
		cd "${S}/tex/latex/${PN}/"
		latex-package_src_doinstall styles
		for f in tfm afm; do
			cd "${S}/fonts/${f}/${SUPPLIER}/${PN}/"
			latex-package_src_doinstall fonts
		done

		for f in enc map; do
			cd "${S}/fonts/${f}/dvips/${PN}"
			insinto "${TEXMF}/fonts/${f}/dvips/${PN}"
			doins * || die "doins ${f} failed"
		done

		cd "${FONT_S}"
		insinto "${TEXMF}/fonts/opentype/${SUPPLIER}/${PN}"
		doins * || die "failed to install opentype fonts"

		cd "${S}/fonts/type1/${SUPPLIER}/${PN}"
		insinto "/usr/share/texmf-dist/fonts/type1/${SUPPLIER}/${PN}"
		doins * || die "failed to install type1 fonts"

		cd "${S}/doc/fonts/tex-gyre"
		latex-package_src_doinstall

		if latex-package_has_tetex_3; then
			insinto /etc/texmf/updmap.d
			doins "${FILESDIR}/${PN}.cfg"
		fi
	fi

	cd "${S}/fonts/opentype/public/tex-gyre"
	font_src_install

	if ( use doc )
	then
		dodir /usr/share/doc/${PF}
		cp -R ${S}/doc/fonts/tex-gyre ${D}/usr/share/doc/${PF}
	fi
}

pkg_postinst() {
	use latex && latex-package_pkg_postinst
	font_pkg_postinst
}


pkg_postrm() {
	use latex && latex-package_pkg_postrm
	font_pkg_postrm
}
