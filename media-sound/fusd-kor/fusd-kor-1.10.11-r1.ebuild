# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils linux-mod versionator subversion

#ESVN_OPTIONS="-r${PV/*_pre}"
ESVN_REPO_URI="http://svn.xiph.org/trunk/fusd"
#ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/svn.gna.org/gnustep/apps"


#MY_P="${PN}-$(replace_version_separator 2 -)"
DESCRIPTION="Stackable unification file system, which can appear to merge the contents of several directories"
HOMEPAGE="http://fort.xdas.com/~kor/oss2jack/"
#SRC_URI="http://fort.xdas.com/~kor/oss2jack/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 amd64"
SLOT="0"
IUSE="doc"

DEPEND="media-sound/jack-audio-connection-kit"
RDEPEND=${DEPEND}

#S=${WORKDIR}/${MY_P}

MODULE_NAMES="kfusd(extra:${S}/kfusd)"
BUILD_TARGETS="default"

#src_unpack() {
#	unpack ${A}
#	subversion_src_unpack
#	
#	cd "${S}"
#	sed -i -e "s/-Werror//" make.include
#	epatch "${FILESDIR}/disable-target.patch"
#	epatch "${FILESDIR}/linux-2.6.19-kfusd.c.patch"
#}

src_compile() {
	linux-mod_src_compile
	set_arch_to_kernel
	emake || die "emake failed"
}

src_install() {
	linux-mod_src_install
	set_arch_to_kernel
	cd "${S}/obj.${ARCH}"
	dolib.a libfusd.a
	cd "${S}/include"
	insinto /usr/include
	doins *.h
	insinto /etc/modules.d
	newins "${FILESDIR}/fusd.modules" fusd
	if use doc ; then
		cd ${S}/doc
		dodoc fusd.pdf fusd.tex
	fi

	insinto /etc/udev/rules.d
	doins "${FILESDIR}/30-fusd.rules"
}
