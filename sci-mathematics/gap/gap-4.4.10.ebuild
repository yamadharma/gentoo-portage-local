# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit versionator elisp-common

DESCRIPTION="GAP - Groups, Algorithms, Programming - a system for computational discrete algebra"
HOMEPAGE="http://www.gap-system.org/"
SLOT="0"
IUSE="emacs vim-syntax xtom"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"

XTOM_VERSION=1r1p2

PV1=$(get_version_component_range 1-2 )
PV2=$(get_version_component_range 3 )
PV1=$(replace_version_separator 1 'r' ${PV1} )
PV2=${PV1}p${PV2}

SRC_URI="ftp://ftp.gap-system.org/pub/gap/gap4/tar.bz2/${PN}${PV2}.tar.bz2
	xtom? ( ftp://ftp.gap-system.org/pub/gap/gap4/tar.bz2/xtom${XTOM_VERSION}.tar.bz2 )"

RDEPEND="emacs? ( virtual/emacs )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )"

#### delete the next line when moving this ebuild to the main tree!
RESTRICT=mirror

S="${WORKDIR}"/${PN}${PV1}

src_compile() {
	econf || die "econf failed"
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_test() {
	emake teststandard || die "test failed"
}

src_install() {
	dodoc README description*
	insinto /usr/share/${PN}
	doins -r doc grp lib pkg prim small trans tst
	source sysinfo.gap
	exeinto /usr/libexec/${PN}
	doexe bin/${GAParch}/gap
	sed -e "s|@gapdir@|/usr/share/${PN}|" \
		-e "s|@target@-@CC@|/usr/libexec/${PN}|" \
		-e "s|@EXEEXT@||" \
		-e 's|$GAP_DIR/bin/||' \
		gap.shi > gap
	exeinto /usr/bin
	doexe gap

	if use emacs ; then
		elisp-site-file-install etc/emacs/gap-mode.el
		elisp-site-file-install etc/emacs/gap-process.el
		elisp-site-file-install "${FILESDIR}"/64gap-gentoo.el
		dodoc etc/emacs/gap-mode.doc
	fi

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax
		doins etc/gap.vim
		insinto /usr/share/vim/vimfiles/indent
		newins etc/gap_indent.vim gap.vim
		insinto /usr/share/vim/vimfiles/plugin
		newins etc/debug.vim debug_gap.vim
		dodoc etc/README.vim-utils etc/debugvim.txt
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
