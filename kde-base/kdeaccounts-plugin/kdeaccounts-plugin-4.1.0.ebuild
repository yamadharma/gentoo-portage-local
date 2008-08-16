# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdesdk
inherit kde4overlay-meta

DESCRIPTION="Addressbook Plugin that puts names/email addresses of all KDE SVN accounts into an addressbook"
KEYWORDS="~amd64 ~x86"
IUSE="debug"
DEPEND="kde-base/kdepimlibs:${SLOT}"
