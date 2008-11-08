# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# usually apr-util has the same PV as apr, but in case of security fixes, this
# may change.
#APR_PV=${PV}
APR_PV="1.3.3"

inherit eutils flag-o-matic libtool db-use autotools

DESCRIPTION="Apache Portable Runtime Utility Library"
HOMEPAGE="http://apr.apache.org/"
SRC_URI="mirror://apache/apr/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="berkdb doc freetds gdbm ldap mozldap mysql odbc postgres sqlite sqlite3"
RESTRICT="test"

RDEPEND="dev-libs/expat
	>=dev-libs/apr-${APR_PV}
	berkdb? ( =sys-libs/db-4* )
	freetds? ( dev-db/freetds )
	gdbm? ( sys-libs/gdbm )
	ldap? ( =net-nds/openldap-2* )
	mozldap? ( =dev-libs/mozldap-6*
		  =dev-libs/nspr-4*
		  =dev-libs/nss-3* )
	mysql? ( =virtual/mysql-5* )
	odbc? ( dev-db/unixODBC )
	postgres? ( virtual/postgresql-base )
	sqlite? ( =dev-db/sqlite-2* )
	sqlite3? ( =dev-db/sqlite-3* )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/"${PN}"-1.3.4-mozldap60-4.patch
	eautoconf
}

src_compile() {
	local myconf=""

	use ldap && myconf="${myconf} --with-ldap"

	use mozldap && myconf="${myconf} --with-ldap \
					 --with-ldap-include=/usr/include/mozldap/ \
					 --with-ldap-lib=/usr/$(get_libdir)/mozldap"

	if use berkdb; then
		dbver="$(db_findver sys-libs/db)" || die "Unable to find db version"
		dbver="$(db_ver_to_slot "$dbver")"
		dbver="${dbver/\./}"
		myconf="${myconf} --with-dbm=db${dbver}
		--with-berkeley-db=$(db_includedir):/usr/$(get_libdir)"
	else
		myconf="${myconf} --without-berkeley-db"
	fi

	# use mozldap && append-ldflags "-L/usr/$(get_libdir)/nss/ -L/usr/$(get_libdir)/nspr"
	econf --datadir=/usr/share/apr-util-1 \
		--with-apr=/usr \
		--with-expat=/usr \
		$(use_with freetds) \
		$(use_with gdbm) \
		$(use_with mysql) \
		$(use_with odbc) \
		$(use_with postgres pgsql) \
		$(use_with sqlite sqlite2) \
		$(use_with sqlite3) \
		${myconf}

	#if use mozldap; then
	#	emake EXTRA_LDFLAGS="-L/usr/$(get_libdir)/nss/ -L/usr/$(get_libdir)/nspr" || die "emake failed!"
	#else
		emake || die "emake failed!"
	#fi

	if use doc; then
		emake dox || die "emake dox failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc CHANGES NOTICE

	if use doc; then
		dohtml docs/dox/html/* || die "dohtml failed"
	fi

	# This file is only used on AIX systems, which gentoo is not,
	# and causes collisions between the SLOTs, so kill it
	rm "${D}"/usr/$(get_libdir)/aprutil.exp
}
