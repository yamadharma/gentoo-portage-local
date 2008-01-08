# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-utils-2

DESCRIPTION="A XML pull parser and writer for all Java platforms"
HOMEPAGE="http://kxml.objectweb.org/"
SRC_URI="http://dev.gentooexperimental.org/~kiorky/${P}.tar.bz2"

LICENSE="Enhydra"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="source"
DEPEND=">=virtual/jdk-1.4"
RDEPEND="${DEPEND} >=virtual/jre-1.4"
S=${WORKDIR}

src_compile() {
	local build="${WORKDIR}/build" dist="${WORKDIR}/dist"
	mkdir -p "${build}" "${dist}" || die "mkdir failed"
	ejavac -nowarn -d "${build}/" \
		$(find	"${S}" -name "*.java")\
		|| die "failed to build"
	jar cf "${dist}/${PN}.jar" -C "${build}/$i" . \
	|| die "failed too create jar"
}

src_install() {
	local dist="${WORKDIR}/dist"
	cd "${dist}" || die "cd failed"
	java-pkg_dojar *jar
	use source && java-pkg_dosrc "${S}/${P}"
}
