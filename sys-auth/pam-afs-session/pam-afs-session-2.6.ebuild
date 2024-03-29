# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam-afs-session/pam-afs-session-1.6.ebuild,v 1.1 2008/03/25 11:46:56 stefaan Exp $

EAPI=7

inherit pam

DESCRIPTION="OpenAFS PAM Module"
HOMEPAGE="http://www.eyrie.org/~eagle/software/pam-afs-session/"
SRC_URI="http://archives.eyrie.org/software/afs/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""
RESTRICT=mirror

DEPEND="virtual/krb5 
	sys-libs/pam
	"
RDEPEND="${DEPEND}"

#src_compile() {
#	econf || die "econf failed"
#	emake || die "emake failed"
#}

src_install() {
	dopammod ${S}/.libs/pam_afs_session.so
	doman pam_afs_session.5
	dodoc NEWS README TODO
}
