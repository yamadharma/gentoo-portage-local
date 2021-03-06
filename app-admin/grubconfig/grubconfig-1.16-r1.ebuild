# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-admin/grubconfig/grubconfig-1.16.ebuild,v 1.3 2002/12/09 04:17:34 manson Exp $

DESCRIPTION="Simple Tool to configure Grub-Bootloader"
HOMEPAGE="http://www.tux.org/pub/people/kent-robotti/looplinux/index.html"
SRC_URI="http://www.tux.org/pub/people/kent-robotti/looplinux/${P}.tar.gz"

KEYWORDS="x86 -ppc -sparc  -alpha"
LICENSE="GPL-2"
SLOT="0"

DEPEND=">=dev-util/dialog-0.7"

src_install() {
	dosbin grubconfig
	dodoc README
}
