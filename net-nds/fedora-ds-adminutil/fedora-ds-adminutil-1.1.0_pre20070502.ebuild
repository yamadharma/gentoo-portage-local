# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils cvs

ECVS_CO_OPTS="-D ${PV/*_pre}"
ECVS_UP_OPTS="-D ${PV/*_pre}"
ECVS_AUTH="pserver"
ECVS_SERVER="cvs.fedora.redhat.com:/cvs/dirsec"
ECVS_MODULE="adminutil"
#ECVS_BRANCH=""
ECVS_USER="anonymous"
ECVS_CVS_OPTIONS="-dP"
ECVS_TOP_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/cvs-src/fedora-ds"

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="Fedora DS LDAP adminutils"
HOMEPAGE="http://directory.fedora.redhat.com/"
#SRC_URI="http://directory.fedora.redhat.com/sources/fedora-setuputil-${PV}.tar.gz"

SLOT="0"
LICENSE="LGPL"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="dev-lib/mozldap
	dev-libs/nspr
	dev-libs/nss
	dev-libs/svrcore
	dev-libs/icu
	dev-libs/cyrus-sasl
	dev-libs/openssl"

RDEPEND="${DEPEND}"

#S="${WORKDIR}/fedora-setuputil-${PV}"

src_compile() {

	econf  --with-fhs \
	    || die
	emake || die
#	    --with-ldapsdk-inc=/usr/include/mozldap --with-ldapsdk-lib=/usr/lib \

}

src_install() {
	make install DESTDIR=${D} || die

#	rm -rf ${D}/usr/share/doc/setuputil
#	dodoc installer/relnotes/*
#	dohtml -r installer/doc/*
	
}
