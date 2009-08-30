# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# TODO: The following optionals are probably not compiled
# * Possibly unneeded dependencies found
# * 	jmock-1.0
# * 	swing-layout-1
# * 	filters

EAPI="1"
WANT_ANT_TASKS="ant-nodeps"
JAVA_PKG_IUSE="doc source examples"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A collection of powerful, useful, and just plain fun Swing components."
HOMEPAGE="http://swinglabs.org/index.jsp"
SRC_URI="https://swingx.dev.java.net/files/documents/2981/131987/${P}-src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEPEND=">=dev-java/jmock-1.1.0
	dev-java/swing-worker
	dev-java/swing-layout:1
	dev-java/batik:1.7
	dev-java/filters
	dev-java/jmock"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEPEND}"

S="${WORKDIR}/${P}-src"

src_unpack(){
	unpack ${A}
	cd "${S}/lib" || die

	find . -name "*.jar" $(use doc && echo -not -name demo-taglet.jar) -print -delete || die "bundled jar cleanup failed."

	#jmock-1.1.0 seems to be slotted in 1.0
	java-pkg_jar-from jmock-1.0 jmock.jar jmock-1.1.0RC1.jar
	cd optional || die

	java-pkg_jar-from swing-worker
	java-pkg_jar-from swing-layout-1
	java-pkg_jar-from batik-1.7 batik-all.jar MultipleGradientPaint.jar
	java-pkg_jar-from filters filters.jar Filters.jar
}

src_install() {
	java-pkg_dojar "dist/${PN}.jar"
	use doc && java-pkg_dojavadoc dist/javadoc/

	use source && java-pkg_dosrc src/java/*
	use examples && java-pkg_doexamples src/demo
}

