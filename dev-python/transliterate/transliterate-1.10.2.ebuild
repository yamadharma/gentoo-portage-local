# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..12} )

inherit distutils-r1

DESCRIPTION="Bi-directional transliterator for Python"
HOMEPAGE="https://github.com/barseghyanartur/transliterate"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"

RDEPEND="
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	"

python_test() {
	esetup.py test
}
