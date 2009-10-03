# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils multilib toolchain-funcs

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="http://llvm.org/"
#SRC_URI="http://llvm.org/releases/${PV}/${P}.tar.gz"
SRC_URI="http://llvm.org/prereleases/${PV/_pre*}/pre-release${PV/*_pre}/${PN}-${PV/_pre*}.tar.gz -> ${P}.tar.gz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alltargets debug llvm-gcc test"

DEPEND="dev-lang/perl
	>=sys-devel/make-3.79
	>=sys-devel/flex-2.5.4
	>=sys-devel/bison-1.28
	!~sys-devel/bison-1.85
	!~sys-devel/bison-1.875
	>=sys-devel/gcc-3.0
	>=sys-devel/binutils-2.18
	llvm-gcc? ( sys-devel/llvm-gcc )
	test? ( dev-util/dejagnu )"
RDEPEND="dev-lang/perl"

S=${WORKDIR}/${PN}-${PV/_pre*}

pkg_setup() {
	# need to check if the active compiler is ok

	broken_gcc=" 3.2.2 3.2.3 3.3.2 4.1.1 "
	broken_gcc_x86=" 3.4.0 3.4.2 "
	broken_gcc_amd64=" 3.4.6 "

	gcc_vers=$(gcc-fullversion)

	if [[ ${broken_gcc} == *" ${version} "* ]] ; then
		elog "Your version of gcc is known to miscompile llvm."
		elog "Check http://www.llvm.org/docs/GettingStarted.html for"
		elog "possible solutions."
		die "Your currently active version of gcc is known to miscompile llvm"
	fi

	if [[ ${CHOST} == i*86-* && ${broken_gcc_x86} == *" ${version} "* ]] ; then
		elog "Your version of gcc is known to miscompile llvm on x86"
		elog "architectures.  Check"
		elog "http://www.llvm.org/docs/GettingStarted.html for possible"
		elog "solutions."
		die "Your currently active version of gcc is known to miscompile llvm"
	fi

	if [[ ${CHOST} == x86_64-* && ${broken_gcc_amd64} == *" ${version} "* ]];
	then
		 elog "Your version of gcc is known to miscompile llvm in amd64"
		 elog "architectures.  Check"
		 elog "http://www.llvm.org/docs/GettingStarted.html for possible"
		 elog "solutions."
		die "Your currently active version of gcc is known to miscompile llvm"
	 fi
}

src_prepare() {
	# unfortunately ./configure won't listen to --mandir and the-like, so take
	# care of this.
	einfo "Fixing install dirs"
	sed -e 's,^PROJ_docsdir.*,PROJ_docsdir := $(DESTDIR)$(PROJ_prefix)/share/doc/'${PF}, \
		-e 's,^PROJ_etcdir.*,PROJ_etcdir := $(DESTDIR)/etc/llvm,' \
		-e 's,^PROJ_libdir.*,PROJ_libdir := $(DESTDIR)/usr/'$(get_libdir), \
		-i Makefile.config.in || die "sed failed"

	# this points by default to the build directory
	einfo "Fixing gccld and gccas"
	sed -e 's,^TOOLDIR.*,TOOLDIR=/usr/bin,' \
		-i tools/gccld/gccld.sh tools/gccas/gccas.sh || die "sed failed"

	einfo "Fixing rpath"
	sed -e 's/\$(RPATH) -Wl,\$(\(ToolDir\|LibDir\))//g' -i Makefile.rules || die "sed failed"

	# Fix docs installation
	sed -e '/^NO_INSTALL_MANS/s/$/$(DST_MAN_DIR)tblgen.1 $(DST_MAN_DIR)llvmgcc.1 $(DST_MAN_DIR)llvmgxx.1/' \
		-i docs/CommandGuide/Makefile || die "manpages sed failed"
	epatch "${FILESDIR}"/${PN}-2.6-nohtmltargz.patch

	# Buggy test, http://llvm.org/bugs/show_bug.cgi?id=5047
	rm test/DebugInfo/2009-01-15-dbg_declare.ll
}

src_configure() {
	local CONF_FLAGS=""

	if use debug; then
		CONF_FLAGS="${CONF_FLAGS} --disable-optimized"
		einfo "Note: Compiling LLVM in debug mode will create huge and slow binaries"
		# ...and you probably shouldn't use tmpfs, unless it can hold 900MB
	else
		CONF_FLAGS="${CONF_FLAGS} \
			--enable-optimized \
			--disable-assertions \
			--disable-expensive-checks"
	fi

	if use alltargets; then
		CONF_FLAGS="${CONF_FLAGS} --enable-targets=all"
	else
		CONF_FLAGS="${CONF_FLAGS} --enable-targets=host-only"
	fi

	if use amd64; then
		CONF_FLAGS="${CONF_FLAGS} --enable-pic"
	fi

	# things would be built differently depending on whether llvm-gcc is
	# used or not.
	local LLVM_GCC_DIR=/dev/null
	local LLVM_GCC_DRIVER=nope ; local LLVM_GPP_DRIVER=nope
	if use llvm-gcc ; then
		LLVM_GCC_DIR=$(find /usr/$(get_libdir)/llvm-gcc/ -mindepth 1 -maxdepth 1 2> /dev/null)
		LLVM_GCC_DRIVER=$(find ${LLVM_GCC_DIR} -name 'llvm*-gcc' 2> /dev/null)

		if [[ -z ${LLVM_GCC_DRIVER} ]] ; then
			die "failed to find installed llvm-gcc, LLVM_GCC_DIR=${LLVM_GCC_DIR}"
		fi

		einfo "Using $LLVM_GCC_DRIVER"
		LLVM_GPP_DRIVER=${LLVM_GCC_DRIVER/%-gcc/-g++}
	fi

	CONF_FLAGS="${CONF_FLAGS} \
		--with-llvmgccdir=${LLVM_GCC_DIR} \
		--with-llvmgcc=${LLVM_GCC_DRIVER} \
		--with-llvmgxx=${LLVM_GPP_DRIVER}"

	econf ${CONF_FLAGS} || die "econf failed"
}

src_compile() {
	emake VERBOSE=1 KEEP_SYMBOLS=1 || die "emake failed"
}

src_install() {
	emake KEEP_SYMBOLS=1 DESTDIR="${D}" install # || die "install failed"
}
