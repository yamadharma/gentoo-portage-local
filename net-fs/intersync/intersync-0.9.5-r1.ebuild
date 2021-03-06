# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Intermezzo is an advanced replicating networked filesystem."
HOMEPAGE="http://www.inter-mezzo.org"

LICENSE="GPL"
SLOT="0"
KEYWORDS="x86"

DEPEND="net-ftp/curl
	media-gfx/transfig
	>=dev-libs/glib-2*
	>=gnome-base/libghttp-1.0.9-r3
	>=sys-kernel/linux-headers-2.4
	dev-util/efence"

SRC_URI="ftp://ftp.inter-mezzo.org/pub/intermezzo/${P}.tar.gz"

src_compile () 
{
	local myconf=""
	has "net-www/apache" \
		&& $myconf="${myconf} --with-apache-modules=/etc/apache/modules"
	
	./configure \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--datadir=/usr/share \
		--libdir=/lib \
		--enable-linuxdir=/usr/src/linux \
		--enable-efence=yes \
		${myconf}
		
	emake -j2 || die "emake failed"
}

src_install () {
	make DESTDIR=${D} install
	
	exeinto /etc/init.d ; newexe ${FILESDIR}/intersync.rc intersync
	insinto /etc/conf.d ; newins ${FILESDIR}/intersync.conf intersync
}
