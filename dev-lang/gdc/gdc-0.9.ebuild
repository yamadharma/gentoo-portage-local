# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/gcc-3.3.4-r1.ebuild,v 1.23 2004/12/07 04:13:33 vapier Exp $

inherit eutils flag-o-matic libtool gnuconfig versionator

# The next command strips most flags from CFLAGS/CXXFLAGS.  If you do 
# not like it, comment it out, but do not file bugreports if you run into
# problems.
do_filter_flags() {
	strip-flags

	# In general gcc does not like optimization ... we'll add -O2 where safe
	filter-flags -O?

	# -O2 is safe and good for sparc
	[ "${ARCH}" = "sparc" ] && append-flags -O2

	# Compile problems with these (bug #6641 among others)...
	#filter-flags -fno-exceptions -fomit-frame-pointer -fforce-addr
}

# gcc produce unstable binaries if compiled with a different CHOST.
[ "${ARCH}" = "hppa" ] && export CHOST="hppa-unknown-linux-gnu"

# Theoretical cross compiler support
[ ! -n "${CCHOST}" ] && export CCHOST="${CHOST}"

GCC_PV="3.3.4"

LOC="/usr"
MY_PV="`echo ${GCC_PV} | awk -F. '{ gsub(/_pre.*|_alpha.*/, ""); print $1 "." $2 }'`"
MY_PV_FULL="`echo ${GCC_PV} | awk '{ gsub(/_pre.*|_alpha.*/, ""); print $0 }'`"

LIBPATH="${LOC}/lib/gcc-lib/${CCHOST}/${MY_PV_FULL}"
BINPATH="${LOC}/${CCHOST}/gcc-bin/${MY_PV}"
DATAPATH="${LOC}/share/gcc-data/${CCHOST}/${MY_PV}"
# Dont install in /usr/include/g++-v3/, but in gcc internal directory.
# We will handle /usr/include/g++-v3/ with gcc-config ...
STDCXX_INCDIR="${LIBPATH}/include/g++-v${MY_PV/\.*/}"

# PIE support
PIE_VER="8.7.6"

# ProPolice version
PP_VER="3_3_2"
PP_FVER="${PP_VER//_/.}-2"

# Patch tarball support ...
#PATCH_VER="1.0"
PATCH_VER="1.0"

# Snapshot support ...
#SNAPSHOT="2002-08-12"
SNAPSHOT=

# Branch update support ...
MAIN_BRANCH="${GCC_PV}"  # Tarball, etc used ...

#BRANCH_UPDATE="20040412"
BRANCH_UPDATE="20040623"

if [ -z "${SNAPSHOT}" ]
then
	S="${WORKDIR}/gcc-${MAIN_BRANCH}"
	SRC_URI="ftp://gcc.gnu.org/pub/gcc/releases/gcc-${GCC_PV}/gcc-${MAIN_BRANCH}.tar.bz2"

	if [ -n "${PATCH_VER}" ]
	then
		SRC_URI="${SRC_URI}
		         mirror://gentoo/gcc-${GCC_PV}-patches-${PATCH_VER}.tar.bz2"
	fi

	if [ -n "${BRANCH_UPDATE}" ]
	then
		SRC_URI="${SRC_URI}
		         mirror://gentoo/gcc-${MAIN_BRANCH}-branch-update-${BRANCH_UPDATE}.patch.bz2"
	fi
else
	S="${WORKDIR}/gcc-${SNAPSHOT//-}"
	SRC_URI="ftp://sources.redhat.com/pub/gcc/snapshots/${SNAPSHOT}/gcc-${SNAPSHOT//-}.tar.bz2"
fi
if [ -n "${PP_VER}" ]
then
	SRC_URI="${SRC_URI}
		mirror://gentoo/protector-${PP_FVER}.tar.gz
		http://www.research.ibm.com/trl/projects/security/ssp/gcc${PP_VER}/protector-${PP_FVER}.tar.gz"
fi
# bug #6148 - the bounds checking patch interferes with gcc.c
if [ -n "${PIE_VER}" ]
then
	PIE_CORE="gcc-3.3.3-piepatches-v${PIE_VER}.tar.bz2"
	SRC_URI="${SRC_URI} mirror://gentoo/${PIE_CORE}"
fi
SRC_URI="${SRC_URI}
	http://home.earthlink.net/~dvdfrdmn/d/${P}.tar.bz2"

DESCRIPTION="The GNU Compiler Collection.  Includes C/C++, java compilers, pie and ssp extensions"
HOMEPAGE="http://www.gnu.org/software/gcc/gcc.html"

LICENSE="GPL-2 LGPL-2.1"
## SpanKY says hppa is a no go with any 3.3.x

KEYWORDS="-hppa ~alpha amd64 arm ~mips sparc x86"

IUSE="static nls bootstrap build X multilib pic hardened uclibc debug"

# Ok, this is a hairy one again, but lets assume that we
# are not cross compiling, than we want SLOT to only contain
# $PV, as people upgrading to new gcc layout will not have
# their old gcc unmerged ...
SLOT="3.3"

# We need the later binutils for support of the new cleanup attribute.
# 'make check' fails for about 10 tests (if I remember correctly) less
# if we use later bison.
# This one depends on glibc-2.3.2-r3 containing the __guard in glibc
# we scan for Guard@@libgcc and then apply the function moving patch.
# If using NPTL, we currently cannot however depend on glibc-2.3.2-r3,
# else bootstap will break.

# we need a proper glibc version for the Scrt1.o provided to the pie-ssp specs

DEPEND="virtual/libc
	!uclibc? ( !nptl? ( >=sys-libs/glibc-2.3.2-r3 ) )
	!uclibc? ( hardened? ( >=sys-libs/glibc-2.3.2-r9 ) )
	( !sys-devel/hardened-gcc )
	>=sys-devel/binutils-2.14.90.0.6-r1
	>=sys-devel/bison-1.875
	>=sys-devel/gcc-config-1.3.6
	amd64? ( multilib? ( >=app-emulation/emul-linux-x86-baselibs-1.0 ) )
	sparc? ( hardened? ( >=sys-libs/glibc-2.3.3.20040420 ) )
	!build? ( >=sys-libs/ncurses-5.2-r2
	          nls? ( sys-devel/gettext ) )
	=sys-devel/gcc-${GCC_PV}*"

RDEPEND="virtual/libc
	!uclibc? ( !nptl? ( >=sys-libs/glibc-2.3.2-r3 ) )
	!uclibc? ( hardened? ( >=sys-libs/glibc-2.3.2-r9 ) )
	>=sys-devel/gcc-config-1.3.1
	>=sys-libs/zlib-1.1.4
	>=sys-apps/texinfo-4.2-r4
	!build? ( >=sys-libs/ncurses-5.2-r2 )
	=sys-devel/gcc-${GCC_PV}*"

pkg_setup () 
{
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


chk_gcc_version() {
	# This next bit is for updating libtool linker scripts ...
	local OLD_GCC_VERSION="`gcc -dumpversion`"
	local OLD_GCC_CHOST="$(gcc -v 2>&1 | egrep '^Reading specs' |\
	                       sed -e 's:^.*/gcc[^/]*/\([^/]*\)/[0-9]\+.*$:\1:')"

	if [ "${OLD_GCC_VERSION}" != "${MY_PV_FULL}" ]
	then
		echo "${OLD_GCC_VERSION}" > "${WORKDIR}/.oldgccversion"
	fi

	if [ -n "${OLD_GCC_CHOST}" ]
	then
		if [ "${CHOST}" = "${CCHOST}" -a "${OLD_GCC_CHOST}" != "${CHOST}" ]
		then
			echo "${OLD_GCC_CHOST}" > "${WORKDIR}/.oldgccchost"
		fi
	fi

	# Did we check the version ?
	touch "${WORKDIR}/.chkgccversion"
}

version_patch() {
	[ ! -f "$1" ] && return 1
	[ -z "$2" ] && return 1

	sed -e "s:@GENTOO@:$2:g" ${1} > ${T}/${1##*/}
	epatch ${T}/${1##*/}
}

glibc_have_ssp() {
	use uclibc \
		&& local my_libc="${ROOT}/lib/libc.so.0" \
		|| local my_libc="${ROOT}/lib/libc.so.6"

# Not necessary. lib64 is a symlink to /lib. -- avenj@gentoo.org  3 Apr 04
#	case "${ARCH}" in
#		"amd64")
#			my_libc="${ROOT}/lib64/libc.so.?"
#			;;
#	esac

	# Check for the glibc to have the __guard symbols
	if  [ "$(readelf -s "${my_libc}" 2>/dev/null | \
	         grep GLOBAL | grep OBJECT | grep '__guard')" ] && \
	    [ "$(readelf -s "${my_libc}" 2>/dev/null | \
	         grep GLOBAL | grep FUNC | grep '__stack_smash_handler')" ]
	then
		return 0
	else
		return 1
	fi
}

glibc_have_pie() {
	if [ ! -f ${ROOT}/usr/lib/Scrt1.o ] ; then
		echo
		ewarn "Your glibc does not have support for pie, the file Scrt1.o is missing"
		ewarn "Please update your glibc to a proper version or disable hardened"
		echo
		return 1
	fi
}

check_glibc_ssp() {
	if glibc_have_ssp
	then
		if [ -n "${GLIBC_SSP_CHECKED}" ] && \
		   [ -z "$(readelf -s  "${ROOT}/$(gcc-config -L)/libgcc_s.so" 2>/dev/null | \
		           grep 'GLOBAL' | grep 'OBJECT' | grep '__guard')" ]
		then
			# No need to check again ...
			return 0
		fi

		echo
		ewarn "This sys-libs/glibc has __guard object and __stack_smash_handler functions"
		ewarn "scanning the system for binaries with __guard - this may take 5-10 minutes"
		ewarn "Please do not press ctrl-C or ctrl-Z during this period - it will continue"
		echo
		if ! bash ${FILESDIR}/scan_libgcc_linked_ssp.sh
		then
			echo
			eerror "Found binaries that are dynamically linked to the libgcc with __guard@@GCC"
			eerror "You need to compile these binaries without CFLAGS -fstack-protector/hcc -r"
			echo
			eerror "Also, you have to make sure that using ccache needs the cache to be flushed"
			eerror "wipe out /var/tmp/ccache or /root/.ccache.  This will remove possible saved"
			eerror "-fstack-protector arguments that still may reside in such a compiler cache"
			echo
			eerror "When such binaries are found, gcc cannot remove libgcc propolice functions"
			eerror "leading to gcc -static -fstack-protector breaking, see gentoo bug #25299"
			echo
			einfo  "To do a full scan on your system, enter this following command in a shell"
			einfo  "(Please keep running and remerging broken packages until it do not report"
			einfo  " any breakage anymore!):"
			echo
			einfo  " # ${FILESDIR}/scan_libgcc_linked_ssp.sh"
			echo
			die "Binaries with libgcc __guard@GCC dependencies detected!"
		else
			echo
			einfo "No binaries with suspicious libgcc __guard@GCC dependencies detected"
			echo
		fi
	fi

	return 0
}

update_gcc_for_libc_ssp() {
	if glibc_have_ssp
	then
		einfo "Updating gcc to use SSP from glibc..."
		sed -e 's|^\(LIBGCC2_CFLAGS.*\)$|\1 -D_LIBC_PROVIDES_SSP_|' \
			-i ${S}/gcc/Makefile.in || die "Failed to update gcc!"
	fi
}

src_unpack() {
	local release_version="Gentoo Linux ${PVR}"
	
	local GCC_FILESDIR=${PORTDIR}/sys-devel/gcc/files

	if [ -n "${PP_VER}" ] && [ "${ARCH}" != "hppa" ]
	then
		# the guard check should be very early in the unpack process
		check_glibc_ssp
	fi

	[ -n "${PIE_VER}" ] && use hardened && glibc_have_pie

	if [ -z "${SNAPSHOT}" ]
	then
		unpack gcc-${MAIN_BRANCH}.tar.bz2

		if [ -n "${PATCH_VER}" ]
		then
			unpack gcc-${GCC_PV}-patches-${PATCH_VER}.tar.bz2
		fi
	else
		unpack gcc-${SNAPSHOT//-}.tar.bz2
	fi

	if [ -n "${PP_VER}" ]
	then
		unpack protector-${PP_FVER}.tar.gz
	fi

	if [ -n "${PIE_VER}" ]
	then
		unpack ${PIE_CORE}
	fi

	cd ${S}

	# Branch update ...
	if [ -n "${BRANCH_UPDATE}" ]
	then
		epatch ${DISTDIR}/gcc-${MAIN_BRANCH}-branch-update-${BRANCH_UPDATE}.patch.bz2
	fi

	# Do bulk patches included in gcc-${GCC_PV}-patches-${PATCH_VER}.tar.bz2
	if [ -n "${PATCH_VER}" ]
	then
		mkdir -p ${WORKDIR}/patch/exclude
		mv -f ${WORKDIR}/patch/16* ${WORKDIR}/patch/exclude/
		mv -f ${WORKDIR}/patch/70* ${WORKDIR}/patch/exclude/

		if use multilib && [ "${ARCH}" = "amd64" ]
		then
			mv -f ${WORKDIR}/patch/06* ${WORKDIR}/patch/exclude/
			bzip2 -c ${GCC_FILESDIR}/gcc331_use_multilib.amd64.patch > \
				${WORKDIR}/patch/06_amd64_gcc331-use-multilib.patch.bz2
		fi

		epatch ${WORKDIR}/patch
		mv ${S}/gcc-3.3.2/libstdc++-v3/config/os/uclibc ${S}/libstdc++-v3/config/os/ || die
		mv ${S}/gcc-3.3.2/libstdc++-v3/config/locale/uclibc ${S}/libstdc++-v3/config/locale/ || die
		use uclibc && epatch ${GCC_FILESDIR}/3.3.3/gcc-uclibc-3.3-loop.patch
	fi

	if [ -n "${PIE_VER}" ]
	then
		# corrects startfile/endfile selection and shared/static/pie flag usage
		epatch ${WORKDIR}/piepatch/upstream
		# adds non-default pie support (for now only rs6000)
		epatch ${WORKDIR}/piepatch/nondef
		# adds default pie support for all archs less rs6000 if DEFAULT_PIE[_SSP] is defined
		epatch ${WORKDIR}/piepatch/def
		# disable relro/now
		use uclibc && epatch ${GCC_FILESDIR}/3.3.3/gcc-3.3.3-norelro.patch
	fi

	if [ "${ARCH}" = "ppc" -o "${ARCH}" = "ppc64" ]
	then
		epatch ${GCC_FILESDIR}/3.3.3/gcc333_pre20040408-stack-size.patch
	fi

	if [ "${ARCH}" = "arm" ]
	then
		epatch ${GCC_FILESDIR}/3.3.3/gcc333-debian-arm-getoff.patch
		epatch ${GCC_FILESDIR}/3.3.3/gcc333-debian-arm-ldm.patch
	fi

	# non-default SSP support.
	if [ "${ARCH}" != "hppa" -a "${ARCH}" != "hppa64" -a -n "${PP_VER}" ]
	then
		# ProPolice Stack Smashing protection
		EPATCH_OPTS="${EPATCH_OPTS} ${WORKDIR}/protector.dif" \
		epatch ${GCC_FILESDIR}/3.3.1/gcc331-pp-fixup.patch

		EPATCH_OPTS="${EPATCH_OPTS} ${WORKDIR}/protector.dif" \
		epatch ${GCC_FILESDIR}/3.3.3/gcc333-ssp-3.3.2_1-fixup.patch

		epatch ${WORKDIR}/protector.dif
		epatch ${GCC_FILESDIR}/pro-police-docs.patch

		cp ${WORKDIR}/protector.c ${WORKDIR}/gcc-${GCC_PV}/gcc/ || die "protector.c not found"
		cp ${WORKDIR}/protector.h ${WORKDIR}/gcc-${GCC_PV}/gcc/ || die "protector.h not found"

		[ -n "${PATCH_VER}" ] && epatch ${GCC_FILESDIR}/3.3.3/gcc-3.3.3-uclibc-add-ssp.patch

		# we apply only the needed parts of protectonly.dif
		sed -e 's|^CRTSTUFF_CFLAGS = |CRTSTUFF_CFLAGS = -fno-stack-protector-all |' \
			-i gcc/Makefile.in || die "Failed to update crtstuff!"
		#sed -e 's|^\(LIBGCC2_CFLAGS.*\)$|\1 -fno-stack-protector-all|' \
		#	-i ${S}/gcc/Makefile.in || die "Failed to update libgcc!"

		release_version="${release_version}, ssp-${PP_FVER}"

		update_gcc_for_libc_ssp
	fi

	cd ${WORKDIR}/gcc-${GCC_PV}

	[ -n "${PIE_VER}" ] && release_version="${release_version}, pie-${PIE_VER}"

	if use hardened && ( use x86 || use amd64 || use sparc || use hppa )
	then
		einfo "Updating gcc to use automatic PIE + SSP building ..."
		sed -e 's|^ALL_CFLAGS = |ALL_CFLAGS = -DEFAULT_PIE_SSP |' \
			-i ${S}/gcc/Makefile.in || die "Failed to update gcc!"

		# rebrand to make bug reports easier
		release_version="${release_version/Gentoo/Gentoo Hardened}"
	fi

	# corrects text relocations in libiberty.a
	(use pic || use hardened) && epatch ${GCC_FILESDIR}/3.3.3/gcc-3.3.3-libiberty-pic.patch

	version_patch ${GCC_FILESDIR}/3.3.4/gcc334-gentoo-branding.patch \
		"${BRANCH_UPDATE} (${release_version})" || die "Failed Branding"

	# Misdesign in libstdc++ (Redhat)
	cp -a ${S}/libstdc++-v3/config/cpu/i{4,3}86/atomicity.h

	# disable --as-needed from being compiled into gcc specs
	# natively when using >=sys-devel/binutils-2.15.90.0.1 this is
	# done to keep our gcc backwards compatible with binutils. 
	# gcc 3.4.1 cvs has patches that need back porting.. 
	# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=14992 (May 3 2004)
	sed -i -e s/HAVE_LD_AS_NEEDED/USE_LD_AS_NEEDED/g ${S}/gcc/config.in

	cd "${WORKDIR}"
	unpack ${P}.tar.bz2
	mv d "${S}/gcc/"

	cd ${S}/gcc
	epatch d/patch-gcc-${MY_PV}.x

	cd ${S}
	# Fixup libtool to correctly generate .la files with portage
	elibtoolize --portage --shallow

	gnuconfig_update

	cd ${S}; ./contrib/gcc_update --touch &> /dev/null

}

src_compile() {
	local myconf=
	local gcc_lang=

	if ! use nls || use build
	then
		myconf="${myconf} --disable-nls"
	else
		myconf="${myconf} --enable-nls --without-included-gettext"
	fi

	# Enable building of the gcj Java AWT & Swing X11 backend
	# if we have X as a use flag and are not in a build stage.
	# X11 support is still very experimental but enabling it is
	# quite innocuous...  [No, gcc is *not* linked to X11...]
	# <dragon@gentoo.org> (15 May 2003)
	if ! use build && use gcj && use X && [ -f /usr/X11R6/include/X11/Xlib.h ]
	then
		myconf="${myconf} --x-includes=/usr/X11R6/include --x-libraries=/usr/X11R6/lib"
		myconf="${myconf} --enable-interpreter --enable-java-awt=xlib --with-x"
	fi

	# Multilib not yet supported
	if use multilib && [ "${ARCH}" = "amd64" ]
	then
		einfo "WARNING: Multilib support enabled. This is still experimental."
		myconf="${myconf} --enable-multilib"
	else
		if [ "${ARCH}" = "amd64" ]
		then
			einfo "WARNING: Multilib not enabled. You will not be able to build 32bit binaries."
		fi
		myconf="${myconf} --disable-multilib"
	fi

	# Fix linking problem with c++ apps which where linked
	# against a 3.2.2 libgcc
	[ "${ARCH}" = "hppa" ] && myconf="${myconf} --enable-sjlj-exceptions"

	# --with-gnu-ld needed for cross-compiling
	# --enable-sjlj-exceptions : currently the unwind stuff seems to work 
	# for statically linked apps but not dynamic
	# so use setjmp/longjmp exceptions by default
	# --disable-libunwind-exceptions needed till unwind sections get fixed. see ps.m for details

	if ! use uclibc
	then
		# it's getting close to a time where we are going to need USE=glibc, uclibc, bsdlibc -solar
		myconf="${myconf} --enable-__cxa_atexit --enable-clocale=generic"
	else
		myconf="${myconf} --disable-__cxa_atexit --enable-target-optspace --with-gnu-ld --enable-sjlj-exceptions"
	fi

	# Make sure we have sane CFLAGS
	do_filter_flags

	# Build in a separate build tree
	mkdir -p ${WORKDIR}/build
	cd ${WORKDIR}/build

	# Install our pre generated manpages if we do not have perl ...
	if [ ! -x /usr/bin/perl ]
	then
		unpack ${P}-manpages.tar.bz2
	fi

	einfo "Configuring GCC..."
	addwrite "/dev/zero"
	${S}/configure --prefix=${LOC} \
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
		--disable-libunwind-exceptions \
		--enable-cstdio=stdio \
		--enable-version-specific-runtime-libs \
		--with-gxx-include-dir=${STDCXX_INCDIR} \
		--with-local-prefix=${LOC}/local \
		${myconf} || die

	touch ${S}/gcc/c-gperf.h

	# Do not make manpages if we do not have perl ...
	if [ ! -x /usr/bin/perl ]
	then
		find ${WORKDIR}/build -name '*.[17]' -exec touch {} \; || :
	fi

	# Setup -j in MAKEOPTS
	get_number_of_jobs

	einfo "Building GCC..."
	# Only build it static if we are just building the C frontend, else
	# a lot of things break because there are not libstdc++.so ....
	if use static && [ "${gcc_lang}" = "c" ]
	then
		# Fix for our libtool-portage.patch
		S="${WORKDIR}/build" \
		emake LDFLAGS="-static" bootstrap \
			LIBPATH="${LIBPATH}" \
			BOOT_CFLAGS="${CFLAGS}" STAGE1_CFLAGS="-O" || die
		# Above FLAGS optimize and speedup build, thanks
		# to Jeff Garzik <jgarzik@mandrakesoft.com>
	else
		# Fix for our libtool-portage.patch
		S="${WORKDIR}/build" \
		emake bootstrap-lean \
			LIBPATH="${LIBPATH}" \
			BOOT_CFLAGS="${CFLAGS}" STAGE1_CFLAGS="-O" || die

	fi
}


src_install () 
{
	local x=

	# Do allow symlinks in ${LOC}/lib/gcc-lib/${CHOST}/${GCC_PV}/include as
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

	einfo "Installing gdc..."
	# Do the 'make install' from the build directory
	cd ${WORKDIR}/build
	S="${WORKDIR}/build" \
	make prefix=${LOC} \
		bindir=${BINPATH} \
		includedir=${LIBPATH}/include \
		datadir=${DATAPATH} \
		mandir=${DATAPATH}/man \
		infodir=${DATAPATH}/info \
		DESTDIR="${D}" \
		LIBPATH="${LIBPATH}" \
		install || die


	# These should be symlinks
	cd ${D}${BINPATH}
	for x in gdc 
	do
    	    rm -f ${CCHOST}-${x}
	    [ -f "${x}" ] && ln -sf ${x} ${CCHOST}-${x}
	    
	    if [ -f "${CCHOST}-${x}-${PV}" ]
		then
		rm -f ${CCHOST}-${x}-${GCC_PV}
		ln -sf ${x} ${CCHOST}-${x}-${GCC_PV}
	    fi
	done

	cd ${D}${BINPATH}
	for i in `ls | grep -v gdc | grep -v dmd`
	do
	    rm -f ${i}
	done

	cd ${D}${LIBPATH}
	for i in `ls | grep -v cc1d`
	do
	    rm -Rf ${i}
	done

    	cd ${D}/usr/lib/
	rm libiberty.a

	# remove now useless directory...
	rm -Rf ${D}/${LOC}/share
	
#	dodir /usr/bin
#	dosym ${BINPATH}/dmd /usr/bin/dmd
#	dosym ${BINPATH}/gdc /usr/bin/gdc
}

