# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Languages/LanguageKit"

DESCRIPTION="a compiler kit built on top of LLVM for creating dynamic language implementations using an Objective-C runtime for the object model"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND=">=sys-devel/llvm-2.4"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}/Etoile-${PV}"

	sed -i -e "s/-Werror/& -fgnu89-inline/" etoile.make || die "sed failed"
}
