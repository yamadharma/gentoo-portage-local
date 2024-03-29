# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..12} )

inherit distutils-r1

DESCRIPTION="Microsoft Authentication Library (MSAL) for Python library"
HOMEPAGE="https://pypi.org/project/msal"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
https://github.com/AzureAD/microsoft-authentication-library-for-python/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 ~arm ~x86"
LICENSE="MIT"
SLOT="0"

RDEPEND=">=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
	>=dev-python/pyjwt-1.7.1[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/microsoft-authentication-library-for-python-${PV}