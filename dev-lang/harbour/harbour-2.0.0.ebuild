# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit base toolchain-funcs multilib

MY_P=${P/_/-}
DESCRIPTION="An extended implementation of the Clipper dialect of the xBase language family"
HOMEPAGE="http://harbour-project.org/"
SRC_URI="mirror://sourceforge/${PN}-project/${P}.tar.bz2"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="allegro doc gpm odbc pcre slang threads X"

RDEPEND="sys-libs/ncurses
	allegro? ( media-libs/allegro )
	gpm? ( sys-libs/gpm )
	odbc? ( dev-db/unixODBC )
	slang? ( sys-libs/slang )
	pcre? ( dev-libs/libpcre )
	X? ( media-libs/freetype
		 x11-libs/libX11
		 x11-libs/libXext
		 x11-libs/libXmu
		 x11-libs/libXpm
		 x11-libs/libXt )"

DEPEND="${RDEPEND}"

#PATCHES=(
#	"${FILESDIR}"/${PN}-as-needed.patch
#	"${FILESDIR}"/${PN}-fPIC.patch
#	"${FILESDIR}"/${PN}-mkinstdir.patch
#	"${FILESDIR}"/${PN}-override-cc.patch
#	"${FILESDIR}"/${PN}-parallel-make.patch
#	"${FILESDIR}"/${PN}-skip-static-utils.patch
#)

src_compile() {
	# Harbour uses environment vars to configure the build
	export \
		C_USR="${CFLAGS}" \
		L_USR="${LDFLAGS}" \
		HB_GTALLEG=$(useq allegro && echo yes) \
		HB_GPM_MOUSE=$(useq gpm && echo yes) \
		HB_WITHOUT_GTSLN=$(useq slang || echo yes) \
		HB_MT=$(useq threads && echo MT) \
		HB_WITHOUT_X11=$(useq X || echo yes) \
		HB_COMPILER="gcc" \
		HB_CMP="$(tc-getCC)" \
		HB_ARCHITECTURE="$(uname -s | sed -e 's/-//g;y/BDFHLNOPSUX/bdfhlnopsux/;s/.*bsd/bsd/')" \
		HB_GT_LIB="gtstd" \
		HB_MULTI_GT="yes" \
		HB_WITH_PCRE=$(useq pcre && /usr/include) \
		HB_WITH_SQLITE3=/usr/include \
		HB_COMMERCE="no"
	make PREFIX=/usr HB_INSTALL_PREFIX="${D}"/usr || die
}

src_test() {
	emake -C utils/hbtest || die
	utils/hbtest/*/*/hbtest
	einfo "In general, the package works if 'Total calls passed' figure above"
	einfo "is 90% or greater."
}

src_install() {
	# Harbour uses environment vars to configure the install
	export _DEFAULT_BIN_DIR=/usr/bin
	export _DEFAULT_INC_DIR=/usr/include/harbour
	export _DEFAULT_LIB_DIR=/usr/$(get_libdir)
	export HB_BIN_INSTALL="${D}"/usr/bin
	export HB_INC_INSTALL="${D}"/usr/include/harbour
	export HB_LIB_INSTALL="${D}"/usr/$(get_libdir)
	emake install || die

	insinto /etc/harbour
	doins src/rtl/gtcrs/hb-charmap.def || die
	cat > "${D}"/etc/harbour.cfg <<-EOF
		CC=$(tc-getCC)
		CFLAGS=-c -I${_DEFAULT_INC_DIR} ${CFLAGS}
		VERBOSE=YES
		DELTMP=YES
	EOF

	# build utils with shared libs
	L_USR="${L_USR} -L${HB_LIB_INSTALL} -l${PN}"
	export PRG_USR="\"-D_DEFAULT_INC_DIR='${_DEFAULT_INC_DIR}'\""
#	for utl in hbdict hbmake hbpp hbrun xbscript; do
#		emake -C utils/${utl} install || die
#	done

#	dosym xbscript /usr/bin/pprun
#	dosym xbscript /usr/bin/xprompt

	# remove unused files
#	rm -f "${HB_BIN_INSTALL}"/{hbdict*.hit,gharbour,harbour-link}

	doman ${S}/doc/man/*

	dodoc ChangeLog INSTALL TODO

#	if ! has nodoc ${FEATURES} && use doc; then
#		dodoc doc/*.txt || die
#		strip-linguas en es
#		for LNG in ${LINGUAS}; do
#			docinto "${LNG}"
#			dodoc doc/${LNG}/*.txt || die
#		done
#		docinto ct
#		dodoc doc/en/ct/*.txt || die
#	fi
}
