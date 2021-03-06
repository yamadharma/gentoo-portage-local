# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-nds/gq/gq-0.6.0.ebuild,v 1.1 2002/12/07 09:13:07 leonardop Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GTK-based LDAP client"
SRC_URI="mirror://sourceforge/gqclient/${P}.tar.gz"
HOMEPAGE="http://www.biot.com/gq/"
IUSE="kerberos jpeg nls ssl"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="=x11-libs/gtk+-1.2*
	>=net-nds/openldap-2
	kerberos? ( virtual/krb5 )
	jpeg? ( media-libs/gdk-pixbuf )
	ssl? ( dev-libs/openssl )"

src_compile() {
	local myconf="--enable-browser-dnd --enable-cache"

	use nls \
		&& myconf="${myconf} --with-included-gettext" \
		|| myconf="${myconf} --disable-nls"

	use kerberos && myconf="${myconf} --with-kerberos-prefix=/usr"
	
	use ssl && myconf="${myconf} --with-ssl-prefix=/usr"
	
    econf $myconf || die "./configure failed"
	
    emake || die "Compilation failed"
}

src_install() {
    einstall || die "Installation failed"
	
    dodoc ABOUT-NLS AUTHORS ChangeLog COPYING NEWS README* TODO
}
