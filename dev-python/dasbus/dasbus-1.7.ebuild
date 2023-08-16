# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1

DESCRIPTION="DBus library in Python 3"
HOMEPAGE="https://github.com/rhinstaller/dasbus"
SRC_URI="https://github.com/rhinstaller/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="dev-python/pygobject:3[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

distutils_enable_tests unittest
