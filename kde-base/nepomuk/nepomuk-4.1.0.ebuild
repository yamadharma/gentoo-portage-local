# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdebase-runtime
inherit kde4overlay-meta

DESCRIPTION="Nepomuk KDE4 client"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

# dev-cpp/clucene provides the optional strigi backend.
# As there's currently no other *usable* strigi backend, I've added it as a hard
# dependency.
DEPEND=">=app-misc/strigi-0.5.7
	dev-cpp/clucene
	>=dev-libs/soprano-2.0.97"
RDEPEND="${DEPEND}"
