# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdesdk
inherit kde4overlay-meta

DESCRIPTION="KDE: Umbrello UML Modeller"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

COMMONDEPEND=">=dev-libs/boost-1.33.1
	dev-libs/libxml2
	dev-libs/libxslt"
DEPEND="${COMMONDEPEND}"
RDEPEND="${COMMONDEPEND}"
