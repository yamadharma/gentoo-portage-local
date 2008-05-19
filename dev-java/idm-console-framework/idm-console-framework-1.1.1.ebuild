# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc examples source"
inherit java-pkg-2 eutils java-ant-2

MY_V=1.1.1

DESCRIPTION="A Java Management Console framework used for remote server management."
HOMEPAGE="http://directory.fedoraproject.org/"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="1.1"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86 ~x86-fbsd"
IUSE=""

COMMON_DEP="=dev-java/jss-4*
	dev-java/ldapsdk"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"
	
src_unpack() {
	unpack ${A}
	cd ${S}
	java-pkg_jarfrom ldapsdk-4.1 ldapjdk.jar
	java-pkg_jarfrom jss-3.4 xpclass.jar jss4.jar
}

src_compile() {
	eant -Dbuilt.dir=${S}/build \
	     -Dldapjdk.local.location=${S} \
	     -Djss.local.location=${S} ${antflags}

	use doc && eant -Dbuilt.dir=${S}/build \
	     -Dldapjdk.local.location=${S} \
	     -Djss.local.location=${S} ${antflags} javadoc
}

src_install() {
	java-pkg_newjar ${S}/build/release/jars/idm-console-mcc-${MY_V}.jar idm-console-mcc.jar
	java-pkg_newjar ${S}/build/release/jars/idm-console-mcc-${MY_V}_en.jar idm-console-mcc_en.jar
	java-pkg_newjar ${S}/build/release/jars/idm-console-nmclf-${MY_V}.jar idm-console-nmclf.jar
	java-pkg_newjar ${S}/build/release/jars/idm-console-nmclf-${MY_V}_en.jar idm-console-nmclf_en.jar 
	java-pkg_newjar ${S}/build/release/jars/idm-console-base-${MY_V}.jar idm-console-base.jar 
#	insinto /usr/share/dirsrv/manual/en/console/help/graphics
#        doins ${S}/html/en/help/graphics/*.gif
#        insinto /usr/share/dirsrv/manual/en/console/help
#        doins ${S}/html/en/help/*.htm

	use doc && java-pkg_dojavadoc build/doc
	use examples && java-pkg_doexamples examples
	use source && java-pkg_dosrc src/com
}
