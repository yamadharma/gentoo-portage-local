# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit gst-plugins-bad

KEYWORDS="amd64 x86"

RDEPEND=">=media-libs/gst-plugins-base-0.10.13
        >=media-libs/gstreamer-0.10.13
		media-sound/jack-audio-connection-kit"

DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD="jack"

