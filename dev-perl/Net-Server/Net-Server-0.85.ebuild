# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-perl/Net-Daemon/Net-Daemon-0.37.ebuild,v 1.1 2003/06/16 13:57:23 mcummings Exp $

EAPI=5
inherit perl-module

S=${WORKDIR}/${P}
CATEGORY="dev-perl"
DESCRIPTION="Abstract base class for portable servers"
SRC_URI="mirror://cpan/modules/by-module/Net/${P}.tar.gz"
HOMEPAGE="http://seamons.com/net_server.html"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~hppa ~arm"

src_unpack()
{
    unpack ${A}
    cd ${S}
    for i in ${FILESDIR}/patch/version/${PV}/*.patch.bz2
    do
	epatch $i
    done
}
