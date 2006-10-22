# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib fortran

DEB_PV="${PV}.dfsg"
DEB_PR="5"

DESCRIPTION="CERN program library for High Energy Physics"
HOMEPAGE="http://wwwasd.web.cern.ch/wwwasd/cernlib"
LICENSE="GPL-2 LGPL-2"
SRC_URI="mirror://debian/pool/main/c/${PN}/${PN}_${DEB_PV}.orig.tar.gz
	mirror://debian/pool/main/c/${PN}/${PN}_${DEB_PV}-${DEB_PR}.diff.gz"
SLOT="0"
KEYWORDS="amd64 x86"
DEPEND="virtual/motif
	x11-misc/imake
	app-admin/eselect-blas
	virtual/lapack
	dev-lang/cfortran
	virtual/tetex"

S=${WORKDIR}/${PN}-${DEB_PV}.orig

FORTRAN="gfortran g77"

src_unpack() {
	unpack ${A}

	# apply the big debian patch
	epatch ${PN}_${DEB_PV}-${DEB_PR}.diff || die "epatch failed"

	cd "${S}"

	# temporary fix for threading support (while we have buggy eselect)
	if eselect blas show | grep "atlas" | grep -q threaded; then
		einfo "Fixing threads linking for blas"
		sed -i \
			-e 's/$DEPS -lm/$DEPS -lm -lpthread/' \
			-e 's/$DEPS -l$1 -lm/$DEPS -l$1 -lm -lpthread/' \
			debian/add-ons/bin/cernlib.in
	fi

	# fix X11 library path
	sed -i \
		-e "s:L/usr/X11R6/lib:L/usr/$(get_libdir)/X11:g" \
		-e "s:XDIR=/usr/X11R6/lib:XDIR=/usr/$(get_libdir)/X11:g" \
		-e "s:XDIR64=/usr/X11R6/lib:XDIR64=/usr/$(get_libdir)/X11:g" \
		debian/add-ons/bin/cernlib.in

	# fix some default paths
	sed -i \
		-e "s:/usr/local:/usr:g" \
		-e "s:prefix)/lib:prefix)/$(get_libdir):" \
		-e 's:$(prefix)/etc:/etc:' \
		-e 's:$(prefix)/man:$(prefix)/share/man:' \
		debian/add-ons/cernlib.mk

	cp debian/add-ons/Makefile .
	einfo "Applying Debian patches"
	make patch &> /dev/null || die "make patch failed"
	# since we depend on cfortran, do not use the one from cernlib
	# (adapted from $S/debian/rules)
	mv -f src/include/cfortran/cfortran.h \
		src/include/cfortran/cfortran.h.disabled

	# gfortran fix	
	if [[ "${FORTRANC}" == "gfortran" ]] 
	    then
	    echo "#define HasGFortran YES" >> ${S}/src/config/host.def
	    # Dirty hack 1	    
	    sed -i -e "s:-lg2c:-lgfortran:g" ${S}/debian/add-ons/bin/cernlib.in
	    # Dirty hack 2
	    sed -i -e "s:-fugly-complex::g" ${S}/src/config/linux.cf
	    if ( use amd64 )
		then
		sed -i -e "s:-fugly-complex::g" ${S}/src/config/linux-lp64.cf
	    fi
	fi
}


src_compile() {
        if ( use amd64 )
    	    then
	    append-flags -fPIC
	    if [[ "${FORTRANC}" == "g77" ]] 
		then
		append-flags -fno-f2c
	    fi
        fi

	make || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	#einstall | die "einstall failed"
	cd "${S}"/debian
	docinto debian
	dodoc changelog README.* deadpool.txt NEWS copyright
	docinto debian/add-ons
	dodoc add-ons/README
}

pkg_postinst() {
	einfo
	einfo "Gentoo cernlib is based on Debian's one"
	einfo "and respects file system standards, contrary"
	einfo "to standard cernlib from cern"
	einfo
}
