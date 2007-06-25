# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/stardict-freedict-eng-rus/stardict-freedict-eng-rus-2.4.2.ebuild,v 1.10 2007/02/01 14:42:27 blubb Exp $

FROM_LANG="English"
TO_LANG="Russian"
DICT_PREFIX="dictd_www.freedict.de_"

inherit stardict

HOMEPAGE="http://stardict.sourceforge.net/Dictionaries_dictd-www.freedict.de.php"

KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND=">=app-dicts/stardict-2.4.2"
