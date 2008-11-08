# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils multilib autotools depend.apache

DESCRIPTION="Fedora Directory Server (admin)"
HOMEPAGE="http://directory.fedora.redhat.com/"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.bz2"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ipv6 debug"

DEPEND=">=dev-libs/nss-3.11.4
	>=dev-libs/nspr-4.6.4
	>=dev-libs/svrcore-4.0.3
	>=dev-libs/mozldap-6.0.2
	>=dev-libs/adminutil-1.1.5
	>=dev-libs/cyrus-sasl-2.1.19
	>=dev-libs/icu-3.4
	>=sys-libs/db-4.2.52
	>=net-analyzer/net-snmp-5.1.2
	sys-apps/lm_sensors
	app-arch/bzip2
	dev-libs/openssl
	sys-apps/tcp-wrappers
	sys-libs/pam
	sys-libs/zlib
	app-misc/mime-types
	>=www-servers/apache-2.0
	www-apache/mod_restartd
	www-apache/mod_nss
	www-apache/mod_admserv
	>=app-admin/fedora-ds-admin-console-1.1.0
	>=app-admin/fedora-ds-console-1.1.0"

need_apache2

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/fedora-ds-admin-1.1.5-cfgstuff-1.patch
	sed -e "s!SUBDIRS!# SUBDIRS!g" -i Makefile.am
	rm -rf mod_*
	eautoreconf
}

src_compile() {
	econf $(use_enable debug) \
	--with-fhs \
	--with-httpd=${APACHE_BIN} \
	|| die "econf failed"

	emake || die "emake failed"

#             --with-nspr=yes \
#             --with-nss=yes \
#             --with-ldapsdk=yes \
#             --with-db=yes \
#             --with-svrcore=yes \
#             --with-icu=yes \

}

src_install () {
	emake DESTDIR="${D}" install || die "emake failed"
	keepdir /var/log/dirsrv/admin-serv

	# remove redhat style init script.
	rm -rf "${D}"/etc/rc.d
	rm -rf "${D}"/etc/default
	# install gentoo style init script.
	newinitd "${FILESDIR}"/dirsrv-admin.initd dirsrv-admin
	newconfd "${FILESDIR}"/dirsrv-admin.confd dirsrv-admin
}
