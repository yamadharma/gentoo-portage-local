# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_IN_SOURCE_BUILD=1

inherit cmake desktop systemd

DESCRIPTION="Shrew soft VPN Client"
HOMEPAGE="http://www.shrew.net/"
SRC_URI="http://www.shrew.net/download/${PN}/${P}-release.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="ldap +nat qt5 systemd"

COMMON_DEPEND="dev-libs/libedit
	dev-libs/openssl:0=
	ldap? ( net-nds/openldap )"

DEPEND="${COMMON_DEPEND}
	>=sys-devel/bison-2.3
	sys-devel/flex"

RDEPEND="${COMMON_DEPEND}"

DOCS="CONTRIB.TXT README.TXT TODO.TXT"

S="${WORKDIR}/${PN}"

src_prepare(){
	sed -i -e 's|define "parser_class_name"|define parser_class_name|' \
		source/iked/conf.parse.yy || die
	has_version ">=dev-libs/openssl-1.1.0:0" && eapply "${FILESDIR}/${PN}-openssl-1.1.0.patch"
	use qt5 && eapply "${FILESDIR}/${PN}-qt5.patch"
	cmake_src_prepare
}

src_configure(){
	local mycmakeargs=(
		-DLDAP=$(usex ldap)
		-DNATT=$(usex nat)
		-DLIBDIR=/usr/$(get_libdir)
		-DETCDIR=/etc/${PN}
		-DQTGUI=$(usex qt5)
	)
	cmake_src_configure
}

src_install(){
	cmake_src_install
	use systemd && systemd_dounit "${FILESDIR}"/iked.service
}

pkg_postinst() {
	echo
	elog "a default configuration for the IKE Daemon"
	elog "is stored in /etc/${PN}/iked.conf.sample"
	echo
}
