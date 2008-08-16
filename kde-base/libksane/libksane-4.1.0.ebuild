# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdegraphics
KMMODULE=libs/libksane
inherit kde4overlay-meta

DESCRIPTION="KDE scanner library"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"
LICENSE="LGPL-2"

DEPEND="kde-base/qimageblitz
	media-gfx/sane-backends"
RDEPEND="${DEPEND}"
