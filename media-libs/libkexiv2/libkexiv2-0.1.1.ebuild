# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libkexiv2/libkexiv2-0.1.1.ebuild,v 1.4 2007/03/17 16:00:53 cryos Exp $

inherit kde

RDEPEND=">=media-gfx/exiv2-0.12"

DEPEND="${RDEPEND}"

need-kde 3

IUSE=""
DESCRIPTION="KDE Image Plugin Interface: an exiv2 library wrapper"
HOMEPAGE="http://www.kipi-plugins.org"
SRC_URI="mirror://sourceforge/kipi/${P}.tar.bz2"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="amd64 ~sparc x86"


