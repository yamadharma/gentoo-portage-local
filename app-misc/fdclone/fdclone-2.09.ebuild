# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

MY_PV=${PV}b

DESCRIPTION="FDClone: Console Filer"
HOMEPAGE="http://hp.vector.co.jp/authors/VA012337/soft/fd/"
SRC_URI="${HOMEPAGE}FD-${MY_PV}.tar.gz"
#PATCHES="${FILESDIR}/FD-2.08d-mswavedash.patch"

LICENSE=""
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="unicode"

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"

S=${S%/*}/FD-${MY_PV}
#src_unpack(){
#	unpack ${A}
#	cd ${S}
#	epatch ${PATCHES}
#}

src_compile(){
	emake PREFIX=/usr CC=$(tc-getCC) \
		CFLAGS="${CFLAGS} -DLINUX=1 -DFILE_OFFSET_BITS=64" || die
	sed	-e '/^#DISPLAYMODE=/{s/^#//;s/0/6/;}' \
		-e '/^#ANSICOLOR=/{s/^#//;s/0/3/}' \
		-e '/^#IMEKEY=/{s/^#//;s/""/ENTER/;}' \
			_fdrc > fd2rc
	#sed -i -e '/^#DEFCOLUMNS=/{s/^#//;s/2/1/;}' fd2rc
	if [ $(tc-arch ${CTARGET}) == "x86" ];then
		sed -i -e '/^#FUNCLAYOUT=/{s/^#//;s/1005/1204/;}' \
			fd2rc
		for((i=1,j=10;i<=12;++i));do
			echo -e "keymap F$i\t\"\\\e["$((i+j))"~\"" >> fd2rc
			if [ $((i%5)) == 0 ];then j=$((j+1));fi
		done
	fi
	if use unicode;then
		sed -i -e '/^#UNICODEBUFFER=/{s/^#//;s/=0/=1/;}' \
		-e '/^#\(LANGUAGE\|INPUTKCODE\|FNAMEKCODE\)=/{s/^#//;s/=""/="utf8"/;}' fd2rc
	fi
}

src_install(){
	dobin fd
	dosym fd /usr/bin/fdsh
	insinto /usr/bin
	doins fd-dict.tbl
	doins fd-unicd.tbl
	dodoc  FAQ* HISTORY* Install* LICENSES* README* TECHKNOW* ToAdmin*
	doman fd.1; dosym fd.1 /usr/share/man/man1/fdsh.1
	insinto /etc;doins fd2rc
}

