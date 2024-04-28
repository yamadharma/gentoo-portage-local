# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.7.3.0
# NOTE: These flags may be needed for macOS
#hackport: flags: -dext,-kext

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal systemd

DESCRIPTION="Advanced keyboard remapping utility"
HOMEPAGE="https://github.com/kmonad/kmonad#readme"
REPO_URI="https://github.com/kmonad/kmonad"
#COMMIT="296e463fe7761a919a2a3e39599293526ce55454"
#BRANCH="master"
#SRC_URI="${REPO_URI}/archive/${COMMIT}.tar.gz -> ${PN}-${COMMIT}.tar.gz"
SRC_URI="https://github.com/kmonad/kmonad/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"
S="${WORKDIR}/${P}"
CABAL_FILE="${S}/${PN}.cabal"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64"

RDEPEND="dev-haskell/cereal:=[profile?]
	dev-haskell/lens:=[profile?]
	dev-haskell/megaparsec:=[profile?]
	dev-haskell/optparse-applicative:=[profile?]
	dev-haskell/resourcet:=[profile?]
	dev-haskell/rio:=[profile?]
	dev-haskell/unliftio:=[profile?]
	>=dev-lang/ghc-8.4.3:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.2.0.1
	test? ( dev-haskell/hspec )
"

src_configure() {
	haskell-cabal_src_configure \
		--flag=-dext \
		--flag=-kext
}

src_install() {
	haskell-cabal_src_install

	dodoc -r ${S}/keymap
	dodoc -r ${S}/doc

	systemd_dounit startup/kmonad@.service
}