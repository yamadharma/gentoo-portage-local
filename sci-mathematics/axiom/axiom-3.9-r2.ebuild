# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/axiom/axiom-3.9-r1.ebuild,v 1.5 2007/07/22 06:57:09 dberkholz Exp $

inherit eutils latex-package

DESCRIPTION="Axiom is a general purpose Computer Algebra system"
HOMEPAGE="http://axiom.axiom-developer.org/"
SRC_URI="http://axiom.axiom-developer.org/axiom-website/downloads/silver-nov2007-src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="virtual/latex-base
	x11-libs/libXaw"

S="${WORKDIR}/silver"

src_setenv() {
	export AXIOM=`pwd`/mnt/linux
	export PATH=${AXIOM}/bin:${PATH}
}

src_unpack() {
	unpack ${A}
	cd ${S}
	
	src_setenv
	
	# Patch the lsp Makefile since GCL goes kaboom with newer BFDs
	# from Portage, so we need to use the BFD distributed with GCL for
	# things to compile and work.
	sed -i -e 's/--enable-statsysbfd/--enable-locbfd --disable-statsysbfd/' Makefile.pamphlet || die 'Failed to patch the lsp Makefile!'
	
	# Dirty hack?
	# Don't compile with gcl-2.6.8pre
	sed -i -e "s/^#GCLVERSION=gcl-2.6.7$/GCLVERSION=gcl-2.6.7/" \
		-e "s/^GCLVERSION=gcl-2.6.8pre/#GCLVERSION=gcl-2.6.8pre/" \
		Makefile.pamphlet || die 'Failed to patch the lsp Makefile!'

	sed -i -e "s/^#GCLVERSION=gcl-2.6.7$/GCLVERSION=gcl-2.6.7/" \
		-e "s/^GCLVERSION=gcl-2.6.8pre/#GCLVERSION=gcl-2.6.8pre/" \
		Makefile || die 'Failed to patch the Makefile!'


	# Sandbox happiness, fix noweb
	cd ${WORKDIR}
	mkdir noweb
	cd noweb
	tar zxf ${S}/zips/noweb-2.10a.tgz
	sed -i -e 's/-texhash || echo "Program texhash not found or failed"//' src/Makefile* ${S}/zips/noweb.src.Makefile*
	tar czf ${S}/zips/noweb-2.10a.tgz *
	cd ${S}
	rm ${WORKDIR}/noweb -rf

	# Fix compile bugs (if sed fails, it's fixed; so we don't || die :-])
	#	(plasmaroo; 20050116)
	sed -e 's/struct termio ptermio;/struct termios ptermio;/' -i src/clef/edible.c.pamphlet
	mkdir src/graph/viewports

	# Fix include paths for libXpm
	# (Bug #143738)
	sed -i -e '/^XLIB=/s:/X11R6::g' Makefile.pamphlet || die "Failed to fix XLIB in Makefile.pamphlet"
}

src_compile() {
	src_setenv

	# Let the fun begin...
	./configure
	make || die # -jX breaks
}

src_install() {
	src_setenv

	dodir /usr/bin
	einstall DESTDIR=${D}/opt/axiom COMMAND=${D}/usr/bin/axiom || die 'Failed to install Axiom!'
	sed -e '2d;3i AXIOM=/opt/axiom' -i ${D}/usr/bin/axiom ${D}/opt/axiom/mnt/linux/bin/axiom || die 'Failed to patch axiom runscript!'
	cat <<- EOF > ${D}/usr/bin/AXIOMsys
		#!/bin/sh -
		AXIOM=/opt/axiom
		export AXIOM
		PATH=\${AXIOM}/bin:\${PATH}
		export PATH
		exec \$AXIOM/bin/AXIOMsys \$*
	EOF

	# Get rid of /mnt/linux
	cd ${D}/opt/axiom
	mv mnt/linux/* .
	rm -rf mnt

	sed -e 's/AXIOMsys/sman/g' ${D}/usr/bin/axiom > ${D}/usr/bin/sman
	chmod +x ${D}/usr/bin/sman
	chmod +x ${D}/usr/bin/AXIOMsys
	
	insinto ${TEXMF}/tex/latex/${PN}
	doins ${D}/opt/axiom/bin/tex/axiom.sty
}
