# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-perl/Config-Tiny/Config-Tiny-1.ebuild,v 1.2 2003/06/21 21:36:36 drobbins Exp $

EAPI=5
inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Cyrillic Software Suite"
SRC_URI="http://www.cpan.org/modules/by-module/Convert/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Convert/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ~alpha ~arm ~hppa ~mips ~ppc ~sparc"

RDEPEND="${RDEPEND}
	dev-perl/Unicode-Map8
	dev-perl/Unicode-String"
