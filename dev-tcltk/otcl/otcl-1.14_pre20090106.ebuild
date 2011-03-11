# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=2

inherit eutils autotools virtualx

PRERELEASE_DATE="${PV##*_pre}"
DESCRIPTION="MIT Object extension to Tcl"
HOMEPAGE="http://otcl-tclcl.sourceforge.net/otcl/"
SRC_URI="http://www.isi.edu/nsnam/dist/daily/otcl-${PRERELEASE_DATE}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND=">=dev-lang/tcl-8.4.5
                >=dev-lang/tk-8.4.5"

# the package is not safe :-(
MAKEOPTS="${MAKEOPTS} -j1"

S="${WORKDIR}/${PN}"

src_unpack() {
        unpack ${A}

        cd "${S}"

        epatch "${FILESDIR}"/${PN}-1.11-badfreefix.patch
        epatch "${FILESDIR}"/${PN}-1.13-configure-cleanup.patch

        eautoreconf
}

src_compile() {
        local tclv tkv myconf
        tclv=$(grep TCL_VER /usr/include/tcl.h | sed 's/^.*"\(.*\)".*/\1/')
        tkv=$(grep TK_VER /usr/include/tk.h | sed 's/^.*"\(.*\)".*/\1/')
        myconf="--with-tcl-ver=${tclv} --with-tk-ver=${tkv}"
        CFLAGS="${CFLAGS} -I/usr/$(get_libdir)/tcl${tkv}/include/generic -I/usr/lib/tcl8.5/include/unix -DHAVE_UNISTD_H"

        echo myconf $myconf
        econf ${myconf} || die "econf failed"
        emake all || die "emake all failed"
        emake libotcl.so || die  "emake libotcl.so failed"
}

src_install() {
        dobin otclsh owish
        dolib libotcl.so
        dolib.a libotcl.a
        insinto /usr/include
        doins otcl.h

        # docs
        dodoc VERSION
        dohtml README.html CHANGES.html
        docinto doc
        dohtml doc/*.html
}

src_test() {
        Xmake
test
}
