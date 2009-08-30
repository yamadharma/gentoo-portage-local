# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils multilib toolchain-funcs

DESCRIPTION="Chromium Web Browser"
HOMEPAGE="http://chromium.org/"
SRC_URI="http://build.chromium.org/buildbot/archives/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	app-arch/bzip2
	dev-db/sqlite:3
	dev-libs/libxml2
	dev-libs/libxslt
	>=dev-libs/nss-3.12.2
	>=gnome-base/gconf-2.24.0
	media-fonts/corefonts
	>=media-libs/alsa-lib-1.0.19
	media-libs/jpeg
	media-libs/libpng
	media-video/ffmpeg
	sys-libs/zlib
	>=x11-libs/gtk+-2.14.7"
DEPEND="${RDEPEND}
	>=dev-util/gperf-3.0.3
	>=dev-util/pkgconfig-0.23
	>=dev-util/scons-1.2.0"

pkg_setup() {
	# Fails in webkit, core browser, ... Any scons expert around?
	append-ldflags -Wl,--no-as-needed
}

src_configure() {
	# CFLAGS/LDFLAGS
	mkdir -p "${S}"/.gyp
	cat << EOF > "${S}"/.gyp/include.gypi
{
 'target_defaults': {
  'cflags': [ '${CFLAGS// /','}' ],
  'ldflags': [ '${LDFLAGS// /','}' ],
 },
}
EOF
	export HOME="${S}"

	# Configuration options
	local myconf="-Duse_system_bzip2=1 -Duse_system_zlib=1 -Duse_system_libjpeg=1 -Duse_system_libpng=1 -Duse_system_libxml=1 -Duse_system_libxslt=1 -Duse_system_sqlite=1 -Duse_system_ffmpeg=1"

	if use amd64; then
		myconf="${myconf} -Dtarget_arch=x64"
	fi
	if [[ "$(gcc-major-version)$(gcc-minor-version)" == "44" ]]; then
		myconf="${myconf} -Dno_strict_aliasing=1 -Dgcc_version=44"
	fi

	tools/gyp/gyp_chromium build/all.gyp ${myconf} --depth=. || die "gyp failed"
}

src_compile() {
	scons --site-dir="${S}/site_scons" -C build \
		--mode=Release chrome || die "scons failed"
}

src_install() {
	# Chromium does not have "install" target in the build system.
	declare CHROMIUM_HOME=/usr/$(get_libdir)/chromium-browser

	dodir ${CHROMIUM_HOME}

	exeinto ${CHROMIUM_HOME}
	doexe sconsbuild/Release/chrome
	doexe sconsbuild/Release/xdg-settings
	doexe "${FILESDIR}"/chromium-launcher.sh

	insinto ${CHROMIUM_HOME}
	doins sconsbuild/Release/chrome.pak

	doins -r sconsbuild/Release/locales
	doins -r sconsbuild/Release/resources
	doins -r sconsbuild/Release/themes

	# Chromium compiles patched versions of these media libraries.
	#dodir ${CHROMIUM_HOME}/lib
	#insinto ${CHROMIUM_HOME}/lib
	#doins sconsbuild/Release/libavcodec.so.52
	#doins sconsbuild/Release/libavformat.so.52
	#doins sconsbuild/Release/libavutil.so.50

	# Plugins symlink
	dosym /usr/$(get_libdir)/nsbrowser/plugins ${CHROMIUM_HOME}/plugins

	newicon sconsbuild/Release/product_logo_48.png ${PN}-browser.png
	dosym ${CHROMIUM_HOME}/chromium-launcher.sh /usr/bin/chromium
	make_desktop_entry chromium "Chromium" ${PN}-browser.png "Network;WebBrowser"
}
