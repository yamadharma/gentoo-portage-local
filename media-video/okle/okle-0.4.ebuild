# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/okle/okle-0.4.ebuild,v 1.9 2006/07/23 14:08:45 dertobi123 Exp $

inherit kde eutils

DESCRIPTION="oKle is a KDE frontend to the Ogle DVD player."
HOMEPAGE="http://okle.sourceforge.net/"
SRC_URI="mirror://sourceforge/okle/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=media-video/ogle-0.9.2"
need-kde 3

src_unpack() {
	kde_src_unpack

	use arts || epatch ${FILESDIR}/${P}-configure-arts.patch
}