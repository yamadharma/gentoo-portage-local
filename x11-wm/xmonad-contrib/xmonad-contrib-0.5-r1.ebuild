# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

CABAL_FEATURES="lib profile haddock"
CABAL_MIN_VERSION=1.2

inherit haskell-cabal

DESCRIPTION="Third party extentions for xmonad"
HOMEPAGE="http://www.xmonad.org/"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="xft"

DEPEND="dev-haskell/mtl
	~x11-wm/xmonad-${PV}
	xft? ( >=dev-haskell/x11-xft-0.2 )
	>=dev-lang/ghc-6.6"
RDEPEND="${DEPEND}"

src_compile() {
	CABAL_CONFIGURE_FLAGS=""
	if use xft; then
		CABAL_CONFIGURE_FLAGS="--flags=use_xft"
	else
		CABAL_CONFIGURE_FLAGS="--flags=-use_xft"
	fi
	cabal_src_compile
}
