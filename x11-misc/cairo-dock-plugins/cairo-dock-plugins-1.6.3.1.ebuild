# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

WANT_AUTOCONF=latest
WANT_AUTOMAKE=latest
inherit autotools eutils

# Upstream sources use date instead version number
#MY_PV="1.6.2.3"
MY_PV=${PV}

#ESVN_REPO_URI="svn://svn.berlios.de/cairo-dock/trunk"
#or http://svn.berlios.de/svnroot/repos/cairo-dock/trunk

DESCRIPTION="Cairo-dock plugins"
HOMEPAGE="http://developer.berlios.de/projects/cairo-dock/"
SRC_URI="http://download2.berlios.de/cairo-dock/cairo-dock-plugins-${MY_PV}.tar.bz2"

LICENSE="GPL"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

IUSE_PLUGINS="
	plugins_Cairo-Penguin
	plugins_Dbus
	plugins_Xgamma
	plugins_alsaMixer
	plugins_clock
	plugins_compiz-icon
	plugins_cpusage
	plugins_dustbin
	plugins_gauge-test
	plugins_gnome-integration
	plugins_gnome-integration-old
	plugins_logout
	plugins_mail
	plugins_musicPlayer
	plugins_musicplayer
	plugins_netspeed
	plugins_nVidia
	plugins_powermanager
	plugins_rame
	plugins_rendering
	plugins_rhythmbox
	plugins_shortcuts
	plugins_showDesklets
	plugins_showDesktop
	plugins_switcher
	plugins_systray
	plugins_terminal
	plugins_tomboy
	plugins_weather
	plugins_wifi
	plugins_xfce-integration
	plugins_xmms"

IUSE=${IUSE_PLUGINS}

DEPEND="x11-misc/cairo-dock
	dev-libs/glib
	dev-libs/libxml2
	dbus? ( sys-apps/dbus dev-libs/dbus-glib )
	Xgamma? ( x11-libs/libXxf86vm )
	alsa? ( media-sound/alsa-headers )
	gnome? ( >=gnome-base/gnome-vfs-2.0
                                >=gnome-base/libgnomeui-2.0 )
	gnome-integration-old? ( >=gnome-base/gnome-vfs-2.0
                                >=gnome-base/libgnomeui-2.0 )
	mail?	( net-libs/gnutls )
	powermanager? ( sys-apps/dbus dev-libs/dbus-glib )
	rhythmbox? ( sys-apps/dbus dev-libs/dbus-glib )
	tomboy?	( sys-apps/dbus dev-libs/dbus-glib )
	weblets? ( || ( www-client/mozilla-firefox www-client/seamonkey ) )
	xfce? ( xfce-base/xfwm4 xfce-base/thunar )"

RDEPEND=${DEPEND}

src_unpack() {
#	subversion_src_unpack
unpack cairo-dock-plugins-${MY_PV}.tar.bz2
#	#the source tree seems to have issues, let's fix it:
#	sed s/\-fgnu89\-inline// <mail/src/Makefile.am >tmp.am
#	mv tmp.am mail/src/Makefile.am
#	#cp rame/po/Makefile.in.in slider/po/Makefile.in.in
	
	# Rename folders to match more 'canonical' use flag names (dbus, gnome, xfce are the main reasons).
	# Renaming folders avoid use another list to map real folder to declared use flag
#	mv alsaMixer alsa
#	mv Cairo-Penguin penguin
#	mv Xgamma xgamma
#	mv showDesklets show-desklets
#	mv showDesktop show-desktop
	
	cd "${S}"
	eautoreconf || die "eautoreconf failed"
	for plugin in ${IUSE_PLUGINS}; do
		if use ${plugin}; then
			cd "${S}/${plugin:8}"
			if [ ! -f Makefile ]; then
				eautoreconf || die "eautoreconf failed on ${plugin}"
				econf || die "econf failed on ${plugin}"
			fi
		fi
	done
}

src_compile() {
	cd "${S}"
#	econf || die "econf failed"
#	emake || die "emake failed"
	for plugin in ${IUSE_PLUGINS}; do
		if use ${plugin}; then
			cd "${S}/${plugin:8}"
#			make || die "emake failed on ${plugin}"
			emake || die "emake failed on ${plugin}"
		fi
	done
}

src_install() {
	for plugin in ${IUSE_PLUGINS}; do
		if use ${plugin}; then
			cd "${S}/${plugin:8}"
			emake DESTDIR="${D}" install || die "emake install failed on ${plugin}"
		fi
	done
}
