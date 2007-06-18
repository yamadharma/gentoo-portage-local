# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Docbook2odf is a toolkit that automaticaly converts DocBook to OASIS OpenDocument"
HOMEPAGE="http://open.comsultia.com/docbook2odf/"
SRC_URI="http://open.comsultia.com/docbook2odf/dwn/docbook2odf-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64"
IUSE="kde examples"

DEPEND="
	( ||
		(	>=app-text/docbook2odf-xsl-stylesheets-svn-0.244
			>=app-text/docbook2odf-xsl-stylesheets-0.244 ) )
	>=dev-lang/perl-5.8
	( ||
		(
			>=dev-perl/XML-Sablot-1.01
			>=dev-libs/libxslt-1.1
		) )
	>=media-gfx/imagemagick-6.2
	( ||
		(
			>=dev-perl/Archive-Zip-1.1
			>=app-arch/zip-2.3
		) )
	
	
"

src_install() {
	WORKDIR=${WORKDIR}/docbook2odf-${PV};
	DEST="/usr/share/docbook2odf"
	EXEDESTTREE="/usr/bin"

	if use kde; then
                insinto /usr/kde/3.5/share/apps/konqueror/servicemenus/
                doins ${WORKDIR}/bindings/desktop/*.desktop
        fi

	if use examples; then
		insinto ${DEST}/examples/
		doins ${WORKDIR}/examples/*
	fi

	insinto /usr/share/applications
	doins ${WORKDIR}/bindings/desktop/*.desktop

	insinto /usr/share/man/man1/
	doins ${WORKDIR}/docs/docbook2odf.1
	prepallman

	exeinto /usr/bin
	doexe ${WORKDIR}/utils/docbook2odf

}
