# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdeaccessibility
inherit kde4overlay-meta

DESCRIPTION="KDE: A type-and-say front end for speech synthesizers"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

# KDE text to speech daemon
#PDEPEND="suggested:
#	kde-base/kttsd:${SLOT}"
