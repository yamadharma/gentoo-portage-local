# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="An Open Source language checker for English, German, Polish, Dutch, and other languages."
HOMEPAGE="http://www.languagetool.org/"
SRC_URI="http://dev.gentoo.org/~serkan/distfiles/${P}.tar.bz2"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEPEND="dev-java/jdictrayapi:0
	dev-java/jaminid:0
	dev-java/morfologik-stemming:0
	>=dev-java/jwordsplitter-2.2:0"

DEPEND=">=virtual/jdk-1.5
	test? ( dev-java/ant-junit:0 )
	${COMMON_DEPEND}"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

EANT_GENTOO_CLASSPATH="jdictrayapi,jaminid,morfologik-stemming,jwordsplitter"
EANT_BUILD_TARGET="init build"
JAVA_ANT_REWRITE_CLASSPATH="true"

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	epatch "${FILESDIR}"/${P}-build.xml.patch
	rm -vr src/test/de/danielnaber/languagetool/server/HTTPServerTest.java || die "failed removing HTTPServerTest"
}

src_test() {
	ANT_TASKS="ant-junit" \
		eant -Dgentoo.classpath="$(java-pkg_getjars jdictrayapi,jaminid,morfologik-stemming,jwordsplitter):$(java-pkg_getjars --build-only junit)" test
}

src_install() {
	java-pkg_dojar dist/LanguageTool.jar
	java-pkg_dojar dist/LanguageToolGUI.jar

	java-pkg_dolauncher ${PN} --main de.danielnaber.languagetool.Main
	java-pkg_dolauncher ${PN}-gui --main de.danielnaber.languagetool.gui.Main

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/de
	dodoc {README,CHANGES}.txt || die "dodoc failed"
	insinto /usr/share/languagetool
	doins -r src/{rules,resource} || die "doins failed"
}

pkg_postinst() {
	ewarn "HTTPServer of LanguageTool works unexpectedly with ASCII encoding."
}
