# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

# Must be before x-modular eclass is inherited
SNAPSHOT="yes"
XDPVER=4

inherit x-modular git

EGIT_TREE="757d6aa05719b485b126dd45e8f865c9367b1bbb"
EGIT_REPO_URI="git://anongit.freedesktop.org/git/nouveau/${PN}"

DESCRIPTION="Nouveau video driver"
HOMEPAGE="http://nouveau.freedesktop.org/"
SRC_URI=""

LICENSE="MIT"
KEYWORDS="amd64 x86"
IUSE="dri"

COMMON_DEPEND=">=x11-base/xorg-server-1.5"
DEPEND="${COMMON_DEPEND}
	x11-misc/util-macros
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xproto
	dri? ( x11-proto/glproto
			x11-proto/xf86driproto
			>=x11-libs/libdrm-2.4 )"

# need x11-base/x11-drm until nouveau drm enters the kernel
RDEPEND="${COMMON_DEPEND}
	dri? ( >=x11-base/x11-drm-20070314[video_cards_nv] )"

CONFIGURE_OPTIONS="$(use_enable dri)"

src_unpack() {
	x-modular_specs_check
	x-modular_server_supports_drivers_check
	x-modular_dri_check
	git_src_unpack
	cd "${S}"
	x-modular_patch_source
	x-modular_reconf_source
}
