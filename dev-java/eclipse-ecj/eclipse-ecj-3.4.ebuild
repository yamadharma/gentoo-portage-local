# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/eclipse-ecj/eclipse-ecj-3.3.0-r2.ebuild,v 1.6 2008/03/22 00:51:50 maekke Exp $

inherit eutils java-pkg-2

MY_PN="ecj"
MY_PV="${PV/_rc/RC}"
DMF="R-${MY_PV}-200806172000"
S="${WORKDIR}"

DESCRIPTION="Eclipse Compiler for Java"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops/${DMF}/${MY_PN}src-${MY_PV}.zip"
#SRC_URI="http://ganymede-mirror2.eclipse.org/eclipse/downloads/drops/${DMF}/${MY_PN}src-${MY_PV}.zip"


LICENSE="EPL-1.0"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86 ~x86-fbsd"
SLOT="3.4"
IUSE="java6"

RDEPEND="
	java6? ( >=virtual/jre-1.6 )
	!java6? ( >=virtual/jre-1.4 )"
DEPEND="
	java6? ( >=virtual/jdk-1.6 )
	!java6? ( >=virtual/jdk-1.4 )
	sys-apps/findutils
	app-arch/unzip"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# own package
	rm -f org/eclipse/jdt/core/JDTCompilerAdapter.java
	rm -fr org/eclipse/jdt/internal/antadapter

	# java6
	if ! use java6; then
		rm -fr org/eclipse/jdt/internal/compiler/tool/ \
			org/eclipse/jdt/internal/compiler/apt/
	fi

	# gcj feature, broken
	#epatch "${FILESDIR}"/${PN}-3.4_pre6-gcj.diff
}

src_compile() {
	mkdir -p bootstrap
	cp -a org bootstrap

	einfo "bootstrapping ${MY_PN} with javac"

	cd "${S}"/bootstrap
	javac $(find org/ -name '*.java') || die "${MY_PN} bootstrap failed!"

	find org/ -name '*.class' -o -name '*.properties' -o -name '*.rsc' | \
		xargs jar cf ${MY_PN}.jar

	einfo "build ${MY_PN} with bootstrapped ${MY_PN}"

	cd "${S}"
	java -classpath bootstrap/${MY_PN}.jar \
		org.eclipse.jdt.internal.compiler.batch.Main $(java-pkg_javac-args) \
		-nowarn -encoding ISO-8859-1 org || die "${MY_PN} build failed!"
	find org/ -name '*.class' -o -name '*.properties' -o -name '*.rsc' | \
		xargs jar cf ${MY_PN}.jar
}

src_install() {
	java-pkg_dojar ${MY_PN}.jar
	java-pkg_dolauncher ${MY_PN}-${SLOT} --main \
		org.eclipse.jdt.internal.compiler.batch.Main
}

pkg_postinst() {
	ewarn "to get the compiler adapter of ecj for ant do"
	ewarn "	# emerge ant-eclipse-ecj"
}
