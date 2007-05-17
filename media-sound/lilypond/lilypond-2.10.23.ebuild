# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/lilypond/lilypond-2.10.23.ebuild,v 1.1 2007/05/13 15:12:07 hkbst Exp $

inherit eutils autotools versionator toolchain-funcs

DESCRIPTION="GNU Music Typesetter"
SRC_URI="http://download.linuxaudio.org/lilypond/sources/v$(get_version_component_range 1-2)/${P}.tar.gz"
HOMEPAGE="http://lilypond.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~sparc x86"

#LANGS="cs da de es fi fr it ja nl ru rw sv tr zh_TW"
IUSE="debug profile"
#IUSE="debug doc emacs gtk profile vim"

#for X in ${LANGS} ; do
#		 IUSE="${IUSE} linguas_${X/-/_}"
#done

# guile with deprecated and regex
RDEPEND="
	>=media-libs/freetype-2
	media-libs/fontconfig
	>=x11-libs/pango-1.12.3
	>=dev-scheme/guile-1.8.1
	>=dev-lang/python-2.4
	|| ( >=app-text/ghostscript-gnu-8.15
		 >=app-text/ghostscript-gpl-8.15
		 >=app-text/ghostscript-esp-8.15 )"
#	>=app-text/ghostscript-gnu-8.55"

#	virtual/tetex

DEPEND="${RDEPEND}
	>=media-gfx/fontforge-20060406
	<=media-gfx/fontforge-20070312
	>=app-text/mftrace-1.2.9
	>=sys-apps/texinfo-4.8
	sys-devel/make
	sys-devel/gettext
	sys-devel/flex
	dev-lang/perl
	>=sys-devel/bison-2.0"
#	doc? (	media-libs/netpbm
#		media-gfx/imagemagick )"

pkg_setup() {
	if has_version =guile-1.8*; then
		local flags="deprecated regex"
		built_with_use dev-scheme/guile ${flags} || die "guile must be built with \"${flags}\" use flags"
	fi
}

src_compile() {
	if [[ $(gcc-major-version) -lt 4 ]]; then
		eerror "You need GCC 4.x to build this software."
		die "you need to compile with gcc-4 or later"
	fi

	econf \
		$(use_enable debug debugging) \
		$(use_enable profile profiling) \
		--disable-gui \
		--disable-documentation
#		$(use_enable doc documentation) \


	# without -j1 it will not fail, but building docs later will
	emake -j1 || die "emake failed"

#	if use doc; then
#		emake -j1 web || die "emake web failed"
#	fi
}

# lilypond doesn't include the answers to the tests.
# You are supposed to build those yuorself with an
# earlier version. Then running tests will compare the
# results of the tests against the results from the
# earlier version. As such tests seem mostly useless
# for our purposes.
RESTRICT=test

src_install () {
	emake DESTDIR=${D} install || die "emake install failed"

#	vimdir=/usr/share/vim/vimfiles
#	|| die "emake install failed"

#	if use doc; then
#		# Note: installs .html docs, .pdf docs and examples
#		emake out=www web-install DESTDIR=${D} \
#			webdir=/usr/share/doc/${PF}/html || die "emake web-install failed"
#	fi

	dodoc AUTHORS.txt ChangeLog DEDICATION NEWS.txt README.txt THANKS

#	use vim || rm -r ${D}/usr/share/vim
#	use emacs || rm -r ${D}/usr/share/emacs
}
