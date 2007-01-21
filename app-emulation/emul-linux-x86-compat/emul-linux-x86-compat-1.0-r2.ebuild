# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-compat/emul-linux-x86-compat-1.0-r2.ebuild,v 1.1 2007/01/03 07:34:45 vapier Exp $

DESCRIPTION="emul-linux-x86 version of lib-compat, with the addition of a 32bit libgcc_s and the libstdc++ versions provided by gcc 3.3 and 3.4 for non-multilib systems."
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/emul-linux-x86-compat-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64"
IUSE=""
RESTRICT="nostrip"

DEPEND="virtual/libc"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd "${S}"
	mkdir usr
	mv emul/linux/x86/usr/lib usr/lib32 || die
	rm emul/linux/x86/usr/lib32 || die
	rmdir emul/linux/x86/usr emul/linux/x86 emul/linux emul || die
	rm usr/lib32/libsmpeg* || die
}

src_install() {
	cp -a "${WORKDIR}"/* "${D}"/ || die
}
