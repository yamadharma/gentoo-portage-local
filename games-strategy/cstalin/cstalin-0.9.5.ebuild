# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games

DESCRIPTION="An open source clone of the game Colonization"
HOMEPAGE="http://commanderstalin.sourceforge.net/"
SRC_URI="mirror://sourceforge/commanderstalin/${P}-src.tar.gz"

KEYWORDS="x86 amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

S=${WORKDIR}/${P}-src

RDEPEND="dev-lang/lua
	virtual/opengl
	!games-strategy/cstalin-bin"

DEPEND="${RDEPEND}
	dev-util/scons"

dir=${GAMES_PREFIX_OPT}/${PN}

src_prepare() {
	sed -i -e 's:.Copy():.Clone():g' \
		SConstruct
}


src_compile() {
	scons PREFIX=/usr || die
}

src_install() {
	dodir ${dir}
	for i in campaigns doc graphics intro languages maps music scripts sounds units video
	do
		cp -R ${i} ${D}/${dir}
	done
	exeinto ${dir}
	newexe boswars ${PN}

	games_make_wrapper ${PN} ./${PN} "${dir}" "${dir}"

	prepgamesdirs
	make_desktop_entry ${PN} "Commander Stalin" ${PN}

	dodoc CHANGELOG COPYRIGHT.txt LICENSE.txt README.txt
}
