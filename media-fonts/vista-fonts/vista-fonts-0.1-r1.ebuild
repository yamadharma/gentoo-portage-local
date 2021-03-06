EAPI=7

inherit font

DL_HOST=download.microsoft.com
DL_PATH=download/f/5/a/f5a3df76-d856-4a61-a6bd-722f52a5be26
ARCHIVE=PowerPointViewer.exe

DESCRIPTION="Original Vista Fonts"
HOMEPAGE=""
SRC_URI="http://$DL_HOST/$DL_PATH/$ARCHIVE"
# SRC_URI="https://web.archive.org/web/20171225132744/http://download.microsoft.com/download/E/6/7/E675FFFC-2A6D-4AB0-B3EB-27C9F8C8F696/PowerPointViewer.exe"
# SRC_URI="http://fs2.softfamous.com/downloads/tname-2507a84a3561/software/PowerPointViewer.exe"

FONT_SUPPLIER="microsoft"
S=${WORKDIR}
FONT_S=${WORKDIR}
FONT_SUFFIX="ttf"


LICENSE="MSttfEULA"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""
RESTRICT="nostrip"

DEPEND="app-arch/cabextract"
RDEPEND=""

src_unpack() {
	for exe in ${A} ; do
		echo ">>> Unpacking ${exe} to ${WORKDIR}"
		cabextract --lowercase -F ppviewer.cab "${DISTDIR}"/${exe} > /dev/null \
			|| die "failed to unpack ${exe}"
		cabextract --lowercase -F '*.TT[FC]' ppviewer.cab > /dev/null \
			|| die "failed to unpack ${exe}"
	done
}

src_prepare() {
	mv cambria.ttc cambria.ttf
}

