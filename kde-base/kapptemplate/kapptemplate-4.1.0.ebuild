# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdesdk
inherit kde4overlay-meta

DESCRIPTION="KAppTemplate - A shell script to create the necessary framework to develop KDE applications."
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

# Fails, checked revision 810882.
RESTRICT="test"

# Check again when kdebindings is available
