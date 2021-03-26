# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="a re-implementation of the asyncio mainloop on top of Trio"
HOMEPAGE="
	https://github.com/python-trio/trio-asyncio
	https://pypi.org/project/trio-asyncio
"
SRC_URI="https://github.com/python-trio/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE=" || ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=dev-python/async_generator-1.6[${PYTHON_USEDEP}]
	dev-python/outcome[${PYTHON_USEDEP}]
	>=dev-python/trio-0.12.0[${PYTHON_USEDEP}]
"

DEPEND="test? (
	dev-python/pytest-trio[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source

python_prepare_all() {
	# do not depend on deprecated dep
	sed -i -e '/pytest-runner/d' setup.py || die

	#remove tests from installed packages
	#TODO: remove hardcoded
	sed -i 's|packages=find_packages()|packages=["trio_asyncio"]|' setup.py || die

	distutils-r1_python_prepare_all
}
