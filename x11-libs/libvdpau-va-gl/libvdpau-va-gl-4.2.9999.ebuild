# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake multilib git-r3

DESCRIPTION="VDPAU driver with VA-API/OpenGL backend."
HOMEPAGE="https://github.com/i-rinat/libvdpau-va-gl/"
EGIT_REPO_URI="https://github.com/i-rinat/libvdpau-va-gl.git"

LICENSE="LGPL-3"
SLOT="0"

KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/glib:2
	media-libs/libva[X]
	x11-libs/libvdpau
	x11-libs/libX11
	x11-libs/libXext
	media-libs/glu
	virtual/opengl
	media-video/ffmpeg
"

DEPEND="${RDEPEND}"

DOCS=(ChangeLog README.md)

pkg_postinst() {
	einfo "In order to use vdpau hardware video acceleration via ${PN}"
	einfo "you have to add VDPAU_DRIVER=va_gl to your environment"
}
