# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/submount/submount-0.9-r2.ebuild,v 1.9 2006/10/14 13:56:56 dsd Exp $

inherit linux-mod eutils

DESCRIPTION="Submount is a new attempt to solve the removable media problem for Linux."
HOMEPAGE="http://submount.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-2.4-${PV}.tar.gz
		mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ppc ~sparc x86"
IUSE=""

pkg_setup() {
	linux-mod_pkg_setup
	if kernel_is 2 4
	then
		MY_PV="2.4-${PV}"
	elif ! use_m
	then
		eerror "This version of submount requires a kernel of 2.6.6 or greater"
		die "Kernel is too old."
	else
		MY_PV="${PV}"
	fi

	MY_P="${PN}-${MY_PV}"
	S="${WORKDIR}/${MY_P}"
	MODULE_NAMES="subfs(fs:${S}/subfs-${MY_PV})"
	BUILD_PARAMS="KDIR=${KV_OUT_DIR}"
	BUILD_TARGETS=" "
}

src_unpack() {
	S=${WORKDIR}/${MY_P}
	unpack ${A}
	cd ${S}
	convert_to_m ${S}/subfs-${MY_PV}/Makefile

	# Fix compile on 2.6.16, bug #119538
	epatch ${FILESDIR}/${P}-sem2mutex.patch

	# Fix compile on 2.6.18, bug #148381
	epatch ${FILESDIR}/${P}-2.6.18.patch
}

src_compile() {
	S=${WORKDIR}/${MY_P}
	cd ${S}/submountd-${MY_PV}
	econf --sbindir=/sbin || die "econf failed"
	emake || die "emake failed"

	linux-mod_src_compile
}

src_install() {
	S=${WORKDIR}/${MY_P}
	cd ${S}/submountd-${MY_PV}
	make install DESTDIR=${D} mandir=/usr/share/man || die "make install failed"

	linux-mod_src_install

	cd ${S}
	./rename-docs ${PV}
	dodoc README* COPYING INSTALL*
}
