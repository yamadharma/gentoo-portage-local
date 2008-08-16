# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdeutils
CPPUNIT_REQUIRED="optional"
inherit kde4overlay-meta

DESCRIPTION="KDE calculator"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

DEPEND="dev-libs/gmp"
RDEPEND="${DEPEND}"

src_test() {
	pushd "${WORKDIR}"/${PN}_build/kcalc/knumber/tests > /dev/null
	emake knumbertest && \
		./knumbertest.shell || die "Tests failed."
	popd > /dev/null
}
