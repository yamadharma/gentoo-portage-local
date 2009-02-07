# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

KMNAME="koffice"
KMMODULE="libs"

inherit kde4-meta

DESCRIPTION="Shared KOffice libraries."
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=app-office/koffice-data-${PV}:${SLOT}
	dev-libs/libxml2
	dev-libs/libxslt
	>=media-libs/lcms-1.15
	>=media-libs/openexr-1.2.2-r2"
DEPEND="${RDEPEND}"
#	doc? ( app-doc/doxygen )"

KMEXTRA="
	doc/koffice/
	doc/thesaurus/
	filters/generic_wrapper/
	filters/libkowmf/
	filters/xsltfilter/
	interfaces/
	kounavail/
	plugins/
	tools/"
#	doc/api/"
KMEXTRACTONLY="
	doc/koffice.desktop
	changes-1.4
	changes-1.5
	kchart/kdchart/"

src_prepare() {
	sed -i \
		-e "s:QtCrypto/QtCrypto:QtCrypto:" \
		libs/store/KoEncryptedStore.h || die

	kde4-meta_src_prepare
}

src_install() {
	dodoc changes-*
	newdoc kounavail/README README.kounavail

	kde4-meta_src_install
}
