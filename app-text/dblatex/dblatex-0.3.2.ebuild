# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_MODNAME="dbtexmf"

inherit distutils eutils

DESCRIPTION="Transform DocBook using TeX macros"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="http://dblatex.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
  dev-texlive/texlive-latexextra
  dev-texlive/texlive-mathextra
  dev-texlive/texlive-xetex
  dev-libs/libxslt
  app-text/docbook-xml-dtd
  dev-texlive/texlive-pictures"
RDEPEND="${DEPEND}"

#src_unpack() {
#  unpack ${A}
#  cd "${S}"
#  EPATCH_SOURCE="${FILESDIR}" \
#    EPATCH_SUFFIX="patch" \
#    EPATCH_FORCE="yes" \
#    epatch
#}

src_install() {
  distutils_src_install || die "distutils install failed"

  newbin "${S}"/scripts/dblatex docbook2latex || die "newbin failed"
  mv "${D}"/usr/share/man/man1/dblatex.1.gz \
     "${D}"/usr/share/man/man1/docbook2latex.1.gz || die "mv dblatex.1.gz"
  mv "${D}"/usr/share/doc/${PN}/* "${D}"/usr/share/doc/${PF}

  einfo "This package installs its main binary as"
  einfo "  docbook2latex"
  einfo "to avoid collisions with other latex packages."
}
