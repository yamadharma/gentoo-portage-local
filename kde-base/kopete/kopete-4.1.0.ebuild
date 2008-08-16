# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdenetwork
inherit kde4overlay-meta

DESCRIPTION="KDE multi-protocol IM client"
KEYWORDS="~amd64 ~x86"
IUSE="+addbookmarks +alias +autoreplace +contactnotes debug gadu groupwise
	+highlight +history htmlhandbook +jabber latex messenger +msn +nowlistening
	+oscar +otr +pipes +privacy qq sms ssl +statistics testbed +texteffect
	+translator +urlpicpreview +webpresence winpopup yahoo"
# IUSE="irc jingle meanwhile"

# plugins: addbookmarks, alias, autoreplace, contactnotes, highlight, history,
#		latex, nowlistening, otr, pipes, privacy, (sqlite?) statistics, texteffect,
#		translator, urlpicpreview, (&& xml2 xslt) webpresence

# protocols: (ssl?) gadu, (qca2?) groupwise, irc (disabled), (&& qca2 idn) jabber,
#		jingle (disabled), meanwhile (not ported), messenger (not ready), msn, oscar,
# 		qq, sms, (decibel?) telepathy (not ready), testbed, winpopup, yahoo

# Tests are KDE-ish.
RESTRICT="test"

RDEPEND="
	dev-libs/libpcre
	kde-base/qimageblitz
	x11-libs/libXScrnSaver
	gadu? ( dev-libs/openssl )
	groupwise? ( app-crypt/qca:2 )
	jabber? ( net-dns/libidn app-crypt/qca:2 )
	otr? ( net-libs/libotr )
	ssl? ( app-crypt/qca-ossl )
	statistics? ( dev-db/sqlite:3 )
	webpresence? ( dev-libs/libxml2 dev-libs/libxslt )"
#	telepathy? ( net-libs/decibel )

DEPEND="${RDEPEND}
	x11-proto/scrnsaverproto"

src_compile() {
	# Xmms isn't in portage, thus forcefully disabled.
	mycmakeargs="${mycmakeargs}
		-DWITH_Xmms=OFF
		-DWITH_Telepathy=OFF -DWITH_Decibel=OFF
		$(cmake-utils_use_with addbookmarks)
		$(cmake-utils_use_with alias)
		$(cmake-utils_use_with autoreplace)
		$(cmake-utils_use_with contactnotes)
		$(cmake-utils_use_with gadu)
		$(cmake-utils_use_with gadu OPENSSL)
		$(cmake-utils_use_with groupwise)
		$(cmake-utils_use_with groupwise QCA2)
		$(cmake-utils_use_with highlight)
		$(cmake-utils_use_with history)
		$(cmake-utils_use_with jabber IDN)
		$(cmake-utils_use_with jabber QCA2)
		$(cmake-utils_use_with latex)
		$(cmake-utils_use_with messenger)
		$(cmake-utils_use_with msn)
		$(cmake-utils_use_with nowlistening)
		$(cmake-utils_use_with oscar)
		$(cmake-utils_use_with otr)
		$(cmake-utils_use_with pipes)
		$(cmake-utils_use_with privacy)
		$(cmake-utils_use_with qq)
		$(cmake-utils_use_with sms)
		$(cmake-utils_use_with statistics Sqlite)
		$(cmake-utils_use_with statistics)
		$(cmake-utils_use_with testbed)
		$(cmake-utils_use_with texteffect)
		$(cmake-utils_use_with translator)
		$(cmake-utils_use_with urlpicpreview)
		$(cmake-utils_use_with webpresence LibXml2)
		$(cmake-utils_use_with webpresence LibXslt)
		$(cmake-utils_use_with webpresence)
		$(cmake-utils_use_with winpopup)
		$(cmake-utils_use_with yahoo)"
#		$(cmake-utils_use_with telepathy)
#		$(cmake-utils_use_with telepathy Decibel)

	kde4overlay-meta_src_compile
}

pkg_postinst() {
	if use telepathy; then
		elog "To use kopete telepathy plugins, you need to start gabble first:"
		elog "GABBLE_PERSIST=1 telepathy-gabble &"
		elog "export TELEPATHY_DATA_PATH=/usr/share/telepathy/managers/"
	fi
	if use jabber || use messenger; then
		echo
		elog "In order to use ssl in jabber, messenger and irc you'll need to have qca-ossl"
		echo
	fi
}
