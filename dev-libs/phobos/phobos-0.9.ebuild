# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic libtool gnuconfig


do_filter_flags() {
	declare setting

	strip-flags

	# In general gcc does not like optimization, and add -O2 where
	# it is safe.  This is especially true for gcc 3.3 + 3.4
	replace-flags -O? -O2

	if use amd64
	then
		# gcc 3.3 doesn't support -march=k8/etc on amd64, so xgcc will fail
		setting="`get-flag march`"
		[ ! -z "${setting}" ] && filter-flags -march="${setting}"
	fi

	# and on x86, we just need to filter the 3.4 specific amd64 -marchs
	filter-flags -march=k8
	filter-flags -march=athlon64
	filter-flags -march=opteron

	# gcc 3.3 doesn't support -march=pentium-m
	replace-flags -march=pentium-m -march=pentium3

	# gcc 3.3 doesn't support -mtune on numerous archs, so xgcc will fail
	setting="`get-flag mtune`"
	[ ! -z "${setting}" ] && filter-flags -mtune="${setting}"

	# xgcc wont understand gcc 3.4 flags...
	filter-flags -fno-unit-at-a-time
	filter-flags -funit-at-a-time
	filter-flags -fweb
	filter-flags -fno-web

	# xgcc isnt patched with propolice
	filter-flags -fstack-protector-all
	filter-flags -fno-stack-protector-all
	filter-flags -fstack-protector
	filter-flags -fno-stack-protector

	# xgcc isnt patched with the gcc symbol visibility patch
	filter-flags -fvisibility-inlines-hidden
	filter-flags -fvisibility=hidden

	# ...sure, why not?
	strip-unsupported-flags
}

GCC_PV="3.3.4"

# Theoretical cross compiler support
[ ! -n "${CCHOST}" ] && export CCHOST="${CHOST}"

LOC="/usr"
MY_PV="`echo ${GCC_PV} | awk -F. '{ gsub(/_pre.*|_alpha.*/, ""); print $1 "." $2 }'`"
MY_PV_FULL="`echo ${GCC_PV} | awk '{ gsub(/_pre.*|_alpha.*/, ""); print $0 }'`"

LIBPATH="${LOC}/lib/gcc-lib/${CCHOST}/${MY_PV_FULL}"
BINPATH="${LOC}/${CCHOST}/gcc-bin/${MY_PV}"
DATAPATH="${LOC}/share/gcc-data/${CCHOST}/${MY_PV}"
# Dont install in /usr/include/g++-v3/, but in gcc internal directory.
# We will handle /usr/include/g++-v3/ with gcc-config ...
STDCXX_INCDIR="${LIBPATH}/include/g++-v${MY_PV/\.*/}"

DESCRIPTION="D main library"
HOMEPAGE="http://home.earthlink.net/~dvdfrdmn/d"
SRC_URI="http://home.earthlink.net/~dvdfrdmn/d/gdc-${PV}.tar.bz2
	ftp://gcc.gnu.org/pub/gcc/releases/gcc-${GCC_PV}/gcc-${GCC_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="${MY_PV}"
KEYWORDS="x86 ~sparc ~amd64"
IUSE="nls"

S="${WORKDIR}/gcc-${GCC_PV}"

DEPEND="virtual/libc
	=sys-devel/gcc-${GCC_PV}*
	dev-lang/gdc"

RDEPEND="${DEPEND}"

pkg_setup() {
	if test_version_info ${GCC_PV}
	then
		einfo "Correctly using gcc version ${GCC_PV}"
	else
		eerror "Not using gcc version ${GCC_PV}!"
		einfo "Please switch to this gcc profile using gcc-config and re-run emerge."
		einfo "If you are using a newer version of gcc, you can see if there is a matching version of libffi."
		die
	fi
}

src_unpack () 
{
	unpack ${A}

	cd "${WORKDIR}"
	mv d "${S}/gcc/"

	cd ${S}/gcc
	epatch d/patch-gcc-3.3.x
}


src_compile () 
{

	local myconf=

	if ! use nls || use build
	then
		myconf="${myconf} --disable-nls"
	else
		myconf="${myconf} --enable-nls --without-included-gettext"
	fi

	#use amd64 && myconf="${myconf} --disable-multilib"

	do_filter_flags
	einfo "CFLAGS=\"${CFLAGS}\""
	einfo "CXXFLAGS=\"${CXXFLAGS}\""

	# Build in a separate build tree
	mkdir -p ${WORKDIR}/build/phobos

	cd ${WORKDIR}/build

	einfo "Configuring gcc..."
	addwrite "/dev/zero"

	cd ${WORKDIR}/build/phobos

	${S}/gcc/d/phobos/configure --prefix=${LOC} \
		--bindir=${BINPATH} \
		--includedir=${LIBPATH}/include \
		--datadir=${DATAPATH} \
		--mandir=${DATAPATH}/man \
		--infodir=${DATAPATH}/info \
		--enable-shared \
		--host=${CHOST} \
		--target=${CCHOST} \
		--with-system-zlib \
		--enable-threads=posix \
		--enable-long-long \
		--disable-checking \
		--enable-languages=c,d,c++ \
		--enable-cstdio=stdio \
		--enable-__cxa_atexit \
		--enable-version-specific-runtime-libs \
		--with-gxx-include-dir=${STDCXX_INCDIR} \
		--with-local-prefix=${LOC}/local \
		${myconf} 

	cd ${WORKDIR}/build/phobos/boehm-gc
	
	${S}/gcc/d/phobos/boehm-gc/configure --prefix=${LOC} \
		--bindir=${BINPATH} \
		--includedir=${LIBPATH}/include \
		--datadir=${DATAPATH} \
		--mandir=${DATAPATH}/man \
		--infodir=${DATAPATH}/info \
		--enable-shared \
		--host=${CHOST} \
		--target=${CCHOST} \
		--with-system-zlib \
		--enable-languages=c,d,c++ \
		--enable-threads=posix \
		--enable-long-long \
		--disable-checking \
		--enable-cstdio=stdio \
		--enable-__cxa_atexit \
		--enable-version-specific-runtime-libs \
		--with-gxx-include-dir=${STDCXX_INCDIR} \
		--with-local-prefix=${LOC}/local \
		${myconf} || die

	touch ${S}/gcc/c-gperf.h

	# Setup -j in MAKEOPTS
	get_number_of_jobs

	einfo "Compiling phobos..."
	S="${WORKDIR}/build/phobos" \
	emake \
		LIBPATH="${LIBPATH}" \
		BOOT_CFLAGS="${CFLAGS}" STAGE1_CFLAGS="-O" || die
}

src_install () 
{
	local x=

	# Do allow symlinks in ${LOC}/lib/gcc-lib/${CHOST}/${PV}/include as
	# this can break the build.
	for x in ${WORKDIR}/build/gcc/include/*
	do
		if [ -L ${x} ]
		then
			rm -f ${x}
			continue
		fi
	done
	# Remove generated headers, as they can cause things to break
	# (ncurses, openssl, etc).
	for x in `find ${WORKDIR}/build/gcc/include/ -name '*.h'`
	do
		if grep -q 'It has been auto-edited by fixincludes from' ${x}
		then
			rm -f ${x}
		fi
	done

	einfo "Installing phobos..."
	# Do the 'make install' from the build directory
	cd ${WORKDIR}/build/phobos
	S="${WORKDIR}/build/phobos" \
	make prefix=${D}${LOC} \
		bindir=${D}${BINPATH} \
		includedir=${D}${LIBPATH}/include \
		datadir=${D}${DATAPATH} \
		mandir=${D}${DATAPATH}/man \
		infodir=${D}${DATAPATH}/info \
		DESTDIR="${D}" \
		LIBPATH=${D}"${LIBPATH}" \
		install || die


	# These should be symlinks
#	cd ${D}${BINPATH}
#	for x in gdc 
#	do
#    	    rm -f ${CCHOST}-${x}
#	    [ -f "${x}" ] && ln -sf ${x} ${CCHOST}-${x}
#	    
#	    if [ -f "${CCHOST}-${x}-${PV}" ]
#		then
#		rm -f ${CCHOST}-${x}-${PV}
#		ln -sf ${x} ${CCHOST}-${x}-${PV}
#	    fi
#	done

#	cd ${D}${BINPATH}
#	for i in `ls | grep -v gdc | grep -v dmd`
#	do
#	    rm -f ${i}
#	done

	# remove now useless directory...
#	rm -Rf ${D}/${LOC}/lib
#	rm -Rf ${D}/${LOC}/share
	
#	dodir /usr/bin
#	dosym ${BINPATH}/dmd /usr/bin/dmd
#	dosym ${BINPATH}/gdc /usr/bin/gdc
}

