# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils autotools java-pkg-2 check-reqs flag-o-matic

MY_PV=${PV/_beta/-beta-}
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Scientific software package for numerical computations"
LICENSE="CeCILL-2"
HOMEPAGE="http://www.scilab.org/"
SRC_URI="http://www.scilab.org/download/${MY_PV}/${MY_P}-src.tar.gz"

SLOT="0"
IUSE="doc fftw +gui hdf5 +matio nls tk +umfpack xcos"
KEYWORDS="~amd64 ~x86"

# hdf5 is required to compile (and use) xcos
# doc generation and xcos is disabled if gui is disabled
# see http://wiki.scilab.org/Description_of_configure_options

# http://wiki.scilab.org/Dependencies_of_Scilab_5.X
RDEPEND="virtual/lapack
	tk? ( dev-lang/tk )
	xcos? ( dev-lang/ocaml )
	umfpack? ( sci-libs/umfpack )
	gui? ( >=virtual/jre-1.5
		dev-java/commons-logging
		>=dev-java/flexdock-0.5.2
		>=dev-java/jeuclid-core-3.1
		>=dev-java/jlatexmath-0.9.2
		=dev-java/jgraphx-1.4.1.0
		dev-java/jogl
		dev-java/jgoodies-looks
		dev-java/jrosetta
		dev-java/javahelp
		dev-java/fop
		>=dev-java/batik-1.7
		hdf5? ( dev-java/hdf-java ) )
	fftw? ( sci-libs/fftw:3.0 )
	matio? ( sci-libs/matio )
	hdf5? ( ~sci-libs/hdf5-1.8.4 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? (
		>=dev-java/jlatexmath-fop-0.9.2
		~dev-java/saxon-6.5.5
		app-text/docbook-xsl-stylesheets )"

pkg_setup() {
	CHECKREQS_MEMORY="512"
	java-pkg-2_pkg_setup

	# temp
	filter-ldflags -Wl,--as-needed --as-needed
}

src_prepare() {
	# Increases java heap to 512M when available, when building docs
	check_reqs_conditional && epatch "${FILESDIR}"/java-heap.patch
	# fix scilib path
	epatch "${FILESDIR}"/scilib-fix.patch


	# add the correct java directories to the config file
	sed \
		-i "/^.DEFAULT_JAR_DIR/{s|=.*|=\"$(echo $(ls -d /usr/share/*/lib))\"|}" \
		m4/java.m4 || die

	sed -i "s|-L\$SCI_SRCDIR/bin/|-L\$SCI_SRCDIR/bin/ \
		-L$(java-config -i gluegen) \
		-L$(java-config -i hdf-java) \
		-L$(java-config -i jogl)|" \
		configure.ac || die
	sed -i \
		-e "/<\/librarypaths>/i\<path value=\"$(java-config -i gluegen)\"\/>" \
		-e "/<\/librarypaths>/i\<path value=\"$(java-config -i jogl)\"\/>" \
		-e "/<\/librarypaths>/i\<path value=\"$(java-config -i hdf-java)\"\/>" \
		etc/librarypath.xml || die
	eautoreconf
	java-pkg-2_src_prepare

	# even with hdf-java path in librarypath.xml libjhdf5.so is not detected...
	epatch "${FILESDIR}"/jhdf5-configure.patch
}

src_configure() {
	local myopts
	use doc && myopts="--with-docbook=/usr/share/sgml/docbook/xsl-stylesheets"
	# javac complained about (j)hdf
	use hdf5 && myopts="$myopts --with-hdf5-library=`java-config -i hdf-java`"
	export JAVA_HOME=$(java-config -O)
	export BLAS_LIBS="$(pkg-config --libs blas)"
	export LAPACK_LIBS="$(pkg-config --libs lapack)"
	# mpi is only used for hdf5 i/o
	if use hdf5 && has_version sci-libs/hdf5[mpi]; then
		export CC=mpicc
		export CXX=mpicxx
		export FC=mpif90
		export F77=mpif77
	fi
	econf \
		--disable-rpath \
		--without-pvm \
		$(use_enable doc build-help) \
		$(use_enable nls) \
		$(use_enable nls build-localization) \
		$(use_with fftw) \
		$(use_with gui)\
		$(use_with gui javasci)\
		$(use_with hdf5) \
		$(use_with matio) \
		$(use_with umfpack) \
		$(use_with tk) \
		$(use_with xcos scicos) \
		${myopts}
}

src_compile() {
	emake || die "emake failed"
	if use doc; then
		emake doc || die "emake failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# install docs
	dodoc ACKNOWLEDGEMENTS CHANGES_5.3.X README_Unix RELEASE_NOTES_5.3.X \
		Readme_Visual.txt || die "failed to install docs"

	#install icon
	newicon icons/scilab.xpm scilab.xpm
	make_desktop_entry ${PN} "Scilab" ${PN}
}

pkg_postinst() {
	einfo "To tell Scilab about your printers, set the environment"
	einfo "variable PRINTERS in the form:"
	einfo
	einfo "PRINTERS=\"firstPrinter:secondPrinter:anotherPrinter\""
}
