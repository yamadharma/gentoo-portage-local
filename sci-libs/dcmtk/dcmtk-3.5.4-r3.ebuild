# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Libraries and applications implementing large parts the DICOM standard"
HOMEPAGE="http://dicom.offis.de/dcmtk.php.en"
DEB_PV=3 # Debian patch dcmtk_3.5.4-3.diff
SRC_URI="
ftp://dicom.offis.de/pub/dicom/offis/software/dcmtk/dcmtk354/${P}.tar.gz
mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-${DEB_PV}.diff.gz
"

# ftp://dicom.offis.de/pub/dicom/offis/software/dcmtk/dcmtk354/COPYRIGHT
LICENSE="BSD"
KEYWORDS="x86 amd64"
SLOT="0"
IUSE="png ssl tcpd tiff xml zlib doc"

RDEPEND="
media-libs/jpeg
png? ( media-libs/libpng )
ssl? ( dev-libs/openssl )
tcpd? ( sys-apps/tcp-wrappers )
tiff? ( media-libs/tiff )
xml? ( dev-libs/libxml2 )
zlib? ( sys-libs/zlib )
"
DEPEND="
doc? ( app-doc/doxygen )
${RDEPEND}
"

src_unpack() {

	unpack ${A}
	epatch "${PN}_3.5.4-3.diff"

}

src_compile() {

	econf \
		--sysconfdir=/etc/dcmtk \
		--with-private-tags \
		$(use_with tiff libtiff) \
		$(use_with zlib) \
		$(use_with png libpng) \
		$(use_with xml libxml) \
		$(use_with tcpd libwrap) \
		$(use_with ssl openssl) \
		|| die "econf failed"
	# Don't know why, but compile only with make not with emake ?!
	make ARCH="" || die "make failed"
	if use doc; then
		emake html
	fi

}

src_install() {

	emake DESTDIR="${D}" install \
			install-lib \
			|| die "emake install failed"
	if use doc; then
		emake DESTDIR="${D}" install-html \
			install-doc \
			|| die "emake install doc failed"
	fi
	dodoc COPYRIGHT FAQ HISTORY *.txt
	if use doc; then
		dohtml "${PN}"/html/*
	fi

}
