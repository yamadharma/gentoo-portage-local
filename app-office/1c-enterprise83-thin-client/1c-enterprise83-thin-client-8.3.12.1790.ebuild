# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit eutils pax-utils  user versionator

DESCRIPTION="Native linux thin client of 1C ERP system"
HOMEPAGE="http://v8.1c.ru/"

MY_PV="$(replace_version_separator 3 '-' )"

SRC_URI="${PN}_${MY_PV}_amd64.deb
	nls? ( ${PN}-nls_${MY_PV}_amd64.deb )
	mirror://debian/pool/main/w/webkitgtk/libwebkitgtk-3.0-0_2.4.11-3_amd64.deb
	mirror://debian/pool/main/w/webkitgtk/libjavascriptcoregtk-3.0-0_2.4.11-3_amd64.deb
	mirror://debian/pool/main/libw/libwebp/libwebp6_0.6.1-2_amd64.deb
	mirror://debian/pool/main/i/icu/libicu57_57.1-6+deb9u3_amd64.deb
"

SLOT=$(get_version_component_range 1-2)
LICENSE="1CEnterprise_en"
KEYWORDS="amd64"
#RESTRICT="fetch strip"
RESTRICT="strip"

IUSE="+nls"

RDEPEND="app-arch/dpkg
	sys-libs/zlib"

DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_unpack() {
	for i in ${A}
	do
	    dpkg-deb -R "${DISTDIR}"/"${i}" ${WORKDIR}
	    rm -rf ${WORKDIR}/DEBIAN
	done
}

src_install() {
	dodir /opt /usr/bin
	mv "${WORKDIR}"/opt/* "${D}"/opt
	mv "${WORKDIR}"/usr/lib/x86_64-linux-gnu/* "${D}"/opt/1C/v8.3/x86_64

	local res
	for res in 16 22 24 32 36 48 64 72 96 128 192 256; do
		for icon in 1cv8c; do
			newicon -s ${res} "${WORKDIR}/usr/share/icons/hicolor/${res}x${res}/apps/${icon}.png" "${icon}.png"
		done
	done

	domenu "${WORKDIR}"/usr/share/applications/1cv8c.desktop

	dosym /opt/1C/v8.3/x86_64/1cv8c /usr/bin/1cv8c
}

