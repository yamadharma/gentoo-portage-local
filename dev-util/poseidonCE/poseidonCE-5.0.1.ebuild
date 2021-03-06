# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/poseidonCE/poseidonCE-3.0.1.ebuild,v 1.6 2006/10/05 14:38:45 gustavoz Exp $

inherit eutils

DESCRIPTION="A UML CASE-Tool powered by Java"
SRC_URI="ftp://download.gentleware.biz/${P}.zip"
HOMEPAGE="http://www.gentleware.com/"
LICENSE="PoseidonCommon.pdf"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
RDEPEND=">=virtual/jre-1.6"
DEPEND="app-arch/unzip"
RESTRICT="nomirror"
IUSE="doc"

src_install() {
	insinto /opt/${PN}/lib
	doins lib/*.jar

	echo "#!/bin/sh" > ${PN}
	echo "cd /opt/${PN}" >> ${PN}
	echo '${JAVA_HOME}'/bin/java -cp lib/floating-server.jar:lib/poseidon.jar:lib/umlplugin.jar:${JAVA_HOME}/jre/lib/rt.jar \
	      -Xms64m -Xmx160m -Dposeidon.java.home="${JAVA_HOME}" -Dposeidon.user.dir.PE="$POSEIDONPE_HOME" \
		  com.gentleware.poseidon.Poseidon '$*' >> ${PN}

	into /opt
	dobin ${PN}

	if use doc ; then
		dohtml -r docs/*
		dosym /usr/share/doc/${P}/html/ /opt/${PN}/docs

		insinto /usr/share/doc/${P}
		doins docs/PoseidonUsersGuide.pdf
	fi

	insinto /opt/${PN}/lib
	doins bin/poseidon.ico

	make_desktop_entry ${PN} ${PN} /opt/${PN}/lib/poseidon.ico Development

	dodoc LICENSE.txt

	dodir /opt/${PN}/examples
	cp -R examples/* ${D}opt/${PN}/examples
}
