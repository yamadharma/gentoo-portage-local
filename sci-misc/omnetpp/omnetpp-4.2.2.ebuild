# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools eutils toolchain-funcs flag-o-matic

DESCRIPTION="A C++-based object-oriented discrete event simulation."
HOMEPAGE="http://www.omnetpp.org/"
SRC_URI="http://www.omnetpp.org/download/release/${P}-src.tgz"

EAPI=2

LICENSE="omnetpp"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="blt mpi pcap +doc example"

RDEPEND=">=virtual/jdk-1.5.0"
DEPEND="${RDEPEND}
        >=dev-lang/tcl-8.4
	>=dev-lang/tk-8.4
    	dev-lang/perl
	|| ( dev-libs/libxml2 dev-libs/expat )
	blt? ( dev-tcltk/blt )
	mpi? ( sys-cluster/openmpi )
	pcap? ( net-libs/libpcap )
	doc? ( media-gfx/graphviz
	       app-doc/doxygen )"


src_configure() {
    cd "${S}"
    epatch "${FILESDIR}"/wish-configure.patch
    eautoreconf

    export PATH="${PATH}:${S}/bin"
    export TCL_LIBRARY=$(whereis tcl | awk '{print $2}')
    export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${S}/lib"

    econf || die 'econf failed'
}

src_install() {
    local dirs="bin ide images lib include out"
    dodir /opt/${PN}
    
    # remove ide components for win/osx    
    rm ide/win32 ide/macosx -fr

    cp -pPR $dirs "${D}/opt/${PN}/" || die "failed to copy files"

    if use doc; then
       cp -pPR doc "${D}/opt/${PN}/" || die "failed to copy doc files"
    fi

    dodoc README || die "failed to dodoc"

    # Makefile.inc
    sed -i 's#'"${S}"'#'"${ROOT}opt/${PN}"'#g' Makefile.inc
    cp -p "${S}/Makefile.inc" "${D}/opt/${PN}/Makefile.inc"

    cp "${S}/setenv" "${D}/opt/${PN}/setenv"

    if use example; then
       insinto "/opt/${PN}/samples"
       doins -r samples/* || die "error: installing data failed"
       for x in $(find ./samples -executable -type f); do
       	   exeinto "/opt/${PN}/$(dirname ${x})"
	   doexe "${x}"
       done;
    fi

    # fix libs symlinks
    local CC_NAME=$(grep "^CC =" ${S}/Makefile.inc | sed "s:CC = ::")
    cd ${D}/opt/${PN}/lib
    ln -snf ${CC_NAME}/* .
    cd ${S}

    # symbol link
    dosym ${D}/opt/${PN}/ide/omnetpp /usr/bin/omnetpp

#    dodir /etc/env.d
#    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${ROOT}opt/${PN}/lib" > ${D}/etc/env.d/80omnetpp
#    echo "export PATH=\$PATH:${ROOT}opt/${PN}/bin" >> ${D}/etc/env.d/80omnetpp
#    echo "export TCL_LIBRARY=$(whereis tcl | awk '{print $2}')" >> ${D}/etc/env.d/80omnetpp
}

pkg_setup() {
    # used for MiXiM
    filter-ldflags -Wl,--as-needed --as-needed
}

