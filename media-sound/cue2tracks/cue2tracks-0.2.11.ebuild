# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="Bash script for split audio CD image files with cue sheet to tracks and write tags."
HOMEPAGE="http://cyberdungeon.org.ru/~killy/projects/cue2tracks/"
SRC_URI="http://krigstasks-samling.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="flake mac tta shorten wavpack mp3 vorbis"

DEPEND="flake? ( media-sound/flake )
	mac? ( media-sound/mac media-sound/apetag )
	tta? ( media-sound/ttaenc )
	shorten? ( media-sound/shorten )
	wavpack? ( media-sound/wavpack media-sound/apetag )
	mp3? ( media-sound/lame media-sound/id3v2 )
	vorbis? ( media-sound/vorbis-tools )"
RDEPEND=">=media-sound/shntool-3.0.0
	app-shells/bash
	media-libs/flac
	app-cdr/cuetools"

pkg_setup_()
{
	if use mac && ! built_with_use media-sound/mac shntool ; then
		echo ""
		einfo "media-sound/mac not compiled with shntool support"
		einfo "To recompile it with that USE flag download ebuild with patchset from overlay:"
		einfo "http://cyberdungeon.org.ru/~killy/files/projects/cue2tracks/"
		echo ""
		epause 5
	fi
	if use tta && ! built_with_use media-sound/ttaenc shntool ; then
		echo ""
		einfo "Installed media-sound/ttaenc not compiled with shntool support"
		einfo "To recompile it with shntool you need apply the patch"
		einfo "http://cyberdungeon.org.ru/~killy/files/projects/cue2tracks/ttaenc-3.x-shntool.patch"
		echo ""
		einfo "add USE flag 'shntool' and add the line at end of section src_unpack():"
		einfo "    use shntool && epatch \${FILESDIR}/ttaenc-3.x-shntool.patch"
		echo ""
		einfo "and reemerge modified media-sound/ttaenc"
		epause 5
	fi
}

src_prepare () {
	epatch ${FILESDIR}/remove_shell_check.patch
}

src_install() {
	dobin "${PN}" || die
	dodoc AUTHORS INSTALL ChangeLog README TODO
}

pkg_postinst() {
	echo ""
	einfo 'To get help about usage run "$ cue2tracks -h"'
	echo ""
}
