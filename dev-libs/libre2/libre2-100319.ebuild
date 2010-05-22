# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils

DESCRIPTION="an efficient, principled regular expression library"
HOMEPAGE="http://code.google.com/p/re2/"
SRC_URI=""

LICENSE="BSD"
SLOT=0
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}
	dev-vcs/mercurial
	"

src_unpack() {
	hg clone https://re2.googlecode.com/hg ${P}
	cd "${S}"
	hg update -r 6fa549bb3bed || die
}

src_install() {
	dodir /usr/include/re2
	insinto /usr/include/re2
	doins re2/{re2,stringpiece,variadic_function}.h
	dolib obj/libre2.a
}

