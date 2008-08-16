# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME="kdegraphics"
KMMODULE=libs/libkipi
NEED_KDE="4.1"

inherit kde4overlay-meta

DESCRIPTION="A library for image plugins accross KDE applications."
HOMEPAGE="http://www.kipi-plugins.org"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="4.1"

DEPEND="!media-libs/libkipi
	kde-base/libkdcraw:${SLOT}"
RDEPEND="${DEPEND}"

# Install to KDEDIR to slot the package
PREFIX="${KDEDIR}"
# Needed to find the slotted libkdcraw
PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${KDEDIR}/$(get_libdir)/pkgconfig"
