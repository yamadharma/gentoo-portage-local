# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Build written by Andrew John Hughes

EAPI="2"

inherit autotools pax-utils java-pkg-2 java-vm-2

DESCRIPTION="A harness to build the OpenJDK using Free Software build tools and dependencies"
OPENJDK_BUILD="16"
OPENJDK_DATE="24_apr_2009"
OPENJDK_TARBALL="openjdk-6-src-b${OPENJDK_BUILD}-${OPENJDK_DATE}.tar.gz"
HOTSPOT_TARBALL="09f7962b8b44.tar.gz"
CACAO_TARBALL="cacao-0.99.4.tar.gz"
SRC_URI="http://icedtea.classpath.org/download/source/${P}.tar.gz
		 http://download.java.net/openjdk/jdk6/promoted/b${OPENJDK_BUILD}/${OPENJDK_TARBALL}
		 http://hg.openjdk.java.net/hsx/hsx14/master/archive/${HOTSPOT_TARBALL}
		 cacao? ( http://www.complang.tuwien.ac.at/cacaojvm/download/cacao-0.99.4/${CACAO_TARBALL} )"
HOMEPAGE="http://icedtea.classpath.org"

# Missing options:
# shark - still experimental, requires llvm which is not yet packaged
# visualvm - requries netbeans which would cause major bootstrap issues
IUSE="cacao debug doc examples javascript nio2 nsplugin pulseaudio systemtap xrender zero"

# JTReg doesn't pass at present
RESTRICT="test"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND=">=net-print/cups-1.2.12
	 >=x11-libs/libX11-1.1.3
	 >=media-libs/freetype-2.3.5
	 >=media-libs/alsa-lib-1.0
	 >=x11-libs/gtk+-2.8
	 >=x11-libs/libXinerama-1.0.2
	 >=x11-libs/libXp-1.0.0
	 >=x11-libs/libXi-1.1.3
	 >=x11-libs/libXau-1.0.3
	 >=x11-libs/libXdmcp-1.0.2
	 >=x11-libs/libXtst-1.0.3
	 >=media-libs/jpeg-7
	 >=media-libs/libpng-1.2
	 >=media-libs/giflib-4.1.6
	 >=sys-libs/zlib-1.2.3
	 x11-proto/inputproto
	 x11-proto/xineramaproto
	 nsplugin? ( >=net-libs/xulrunner-1.9 )
	 pulseaudio?  ( >=media-sound/pulseaudio-0.9.11 )
	 javascript? ( dev-java/rhino:1.6 )
	 zero? ( sys-devel/gcc )
	 xrender? ( >=x11-libs/libXrender-0.9.4 )
	 systemtap? ( >=dev-util/systemtap-0.9.5 ) "

# Additional dependencies for building:
#   unzip: extract OpenJDK tarball
#   xalan/xerces: automatic code generation
#   ant, ecj, jdk: required to build Java code
# Only ant-core-1.7.1-r2 contains a version of Ant that
# properly respects environment variables, if the build
# sets some environment variables.
#   ca-certificates, perl and openssl are used for the cacerts keystore generation
#   xext headers have two variants depending on version - bug #288855
DEPEND="${RDEPEND}
	|| ( >=virtual/gnu-classpath-jdk-1.5
		 dev-java/icedtea6-bin
		 dev-java/icedtea6
	)
	|| (
		dev-java/icedtea6-bin
		dev-java/icedtea6
		dev-java/eclipse-ecj:3.3
	)
	>=virtual/jdk-1.5
	>=app-arch/unzip-5.52
	>=dev-java/xalan-2.7.0:0
	>=dev-java/xerces-2.9.1:2
	>=dev-java/ant-core-1.7.1-r2
	app-misc/ca-certificates
	dev-lang/perl
	dev-libs/openssl
	|| (
		(
			>=x11-libs/libXext-1.1.1
			>=x11-proto/xextproto-7.1.1
			x11-proto/xproto
		)
		<x11-libs/libXext-1.1.1
	)
	"

pkg_setup() {
# Shark support disabled for now - still experimental and needs sys-devel/llvm
#	if use shark ; then
#	  if ( ! use x86 && ! use sparc && ! use ppc ) ; then
#		eerror "The Shark JIT has known issues on 64-bit platforms.  Please rebuild"
#		errror "without the shark USE flag turned on."
#		die "Rebuild without the shark USE flag on."
#	  fi
#	  if ( ! use zero ) ; then
#		eerror "The use of the Shark JIT is only applicable when used with the zero assembler port.";
#		die "Rebuild without the shark USE flag on or with the zero USE flag turned on."
#	  fi
#	fi

	# quite a hack since java-config does not provide a way for a package
	# to limit supported VM's for building and their preferred order
	if has_version dev-java/icedtea6; then
		JAVA_PKG_FORCE_VM="icedtea6"
	elif has_version dev-java/icedtea6-bin; then
		JAVA_PKG_FORCE_VM="icedtea6-bin"
	elif has_version dev-java/gcj-jdk; then
		JAVA_PKG_FORCE_VM="gcj-jdk"
	elif has_version dev-java/cacao; then
		JAVA_PKG_FORCE_VM="cacao"
	else
		die "Unable to find a supported VM for building"
	fi

	einfo "Forced vm ${JAVA_PKG_FORCE_VM}"
	java-vm-2_pkg_setup
	java-pkg-2_pkg_setup
}

src_unpack() {
	unpack ${P}.tar.gz
}

unset_vars() {
	unset JAVA_HOME JDK_HOME CLASSPATH JAVAC JAVACFLAGS
}

src_prepare() {
	# bug #283248
	epatch "${FILESDIR}/1.6.1-jpeg7.patch"
	epatch "${FILESDIR}/splitdebug.patch"

	# bug #288855 - ABI is the same, just definitions moved between headers
	# conditional patching should be thus safe
	if has_version ">=x11-libs/libXext-1.1.1"; then
		epatch "${FILESDIR}/1.6.1-shmproto.patch"

		eautoreconf || die "eautoreconf failed"
	fi
}

src_configure() {
	local config procs rhino_jar
	local vm=$(java-pkg_get-current-vm)
	local vmhome="/usr/lib/jvm/${vm}"

	# IcedTea6 can't be built using IcedTea7; its class files are too new
	if [[ "${vm}" == "icedtea6" ]] || [[ "${vm}" == "icedtea6-bin" ]] ; then
		# If we are upgrading icedtea, then we don't need to bootstrap.
		config="${config} --with-openjdk=$(java-config -O)"
	elif [[ "${vm}" == "gcj-jdk" || "${vm}" == "cacao" ]] ; then
		# For other 1.5 JDKs e.g. GCJ, CACAO.
		config="${config} --with-ecj-jar=$(java-pkg_getjar --build-only eclipse-ecj:3.3 ecj.jar)" \
		config="${config} --with-gcj-home=${vmhome}"
	else
		eerror "IcedTea6 must be built with either a JDK based on GNU Classpath or an existing build of IcedTea6."
		die "Install a GNU Classpath JDK (gcj-jdk, cacao)"
	fi

	# OpenJDK-specific parallelism support.
	procs=$(echo ${MAKEOPTS} | sed -r 's/.*-j\W*([0-9]+).*/\1/')
	if [[ -n ${procs} ]] ; then
		config="${config} --with-parallel-jobs=${procs}";
		einfo "Configuring using --with-parallel-jobs=${procs}"
	fi

	if use_cacao ; then
		config="${config} --enable-cacao"
	else
		config="${config} --disable-cacao"
	fi

	if use javascript ; then
		rhino_jar=$(java-pkg_getjar rhino:1.6 js.jar);
	fi

	unset_vars

	econf ${config} \
		--with-openjdk-src-zip="${DISTDIR}/${OPENJDK_TARBALL}" \
		--with-hotspot-src-zip="${DISTDIR}/${HOTSPOT_TARBALL}" \
		--with-cacao-src-zip="${DISTDIR}/${CACAO_TARBALL}" \
		--with-java="${vmhome}/bin/java" \
		--with-javac="${vmhome}/bin/javac" \
		--with-javah="${vmhome}/bin/javah" \
		--with-pkgversion="Gentoo" \
		--with-abs-install-dir=/usr/$(get_libdir)/${PN} \
		$(use_enable !debug optimizations) \
		$(use_enable doc docs) \
		$(use_enable nsplugin plugin) \
		$(use_with javascript rhino ${rhino_jar}) \
		$(use_enable zero) \
		$(use_enable pulseaudio pulse-java) \
		$(use_enable xrender) \
		$(use_enable systemtap) \
		$(use_enable nio2) \
		|| die "configure failed"
}

src_compile() {
	# Newer versions of Gentoo's ant add
	# an environment variable so it works properly...
	export ANT_RESPECT_JAVA_HOME=TRUE
	# Also make sure we don't bring in additional tasks
	export ANT_TASKS=none

	# Paludis does not respect unset from src_configure
	unset_vars
	emake -j 1  || die "make failed"
}

src_install() {
	local dest="/usr/$(get_libdir)/${PN}"
	local ddest="${D}/${dest}"
	dodir "${dest}" || die

	local arch=${ARCH}
	use x86 && arch=i586

	cd "${S}/openjdk/build/linux-${arch}/j2sdk-image" || die

	if use doc ; then
		dohtml -r ../docs/* || die "Failed to install documentation"
	fi

	# doins can't handle symlinks.
	cp -vRP bin include jre lib man "${ddest}" || die "failed to copy"

	# Set PaX markings on all JDK/JRE executables to allow code-generation on
	# the heap by the JIT compiler.
	pax-mark m $(list-paxables "${ddest}"{,/jre}/bin/*)

	dodoc ASSEMBLY_EXCEPTION THIRD_PARTY_README || die
	dohtml README.html || die

	if use examples; then
		dodir "${dest}/share";
		cp -vRP demo sample "${ddest}/share/" || die
	fi

	cp src.zip "${ddest}" || die

	# Fix the permissions.
	find "${ddest}" \! -type l \( -perm /111 -exec chmod 755 {} \; -o -exec chmod 644 {} \; \) || die

	if use nsplugin; then
		use x86 && arch=i386;
		install_mozilla_plugin "${dest}/jre/lib/${arch}/IcedTeaPlugin.so";
	fi

	# We need to generate keystore - bug #273306
	einfo "Generating cacerts file from certificates in /usr/share/ca-certificates/"
	mkdir "${T}/certgen" && cd "${T}/certgen" || die
	cp "${FILESDIR}/generate-cacerts.pl" . && chmod +x generate-cacerts.pl || die
	for c in /usr/share/ca-certificates/*/*.crt; do
		openssl x509 -text -in "${c}" >> all.crt || die
	done
	./generate-cacerts.pl "${ddest}/bin/keytool" all.crt || die
	cp -vRP cacerts "${ddest}/jre/lib/security/" || die
	chmod 644 "${ddest}/jre/lib/security/cacerts" || die

	set_java_env
}

use_cacao() {
	use cacao || ( ! use amd64 && ! use x86 && ! use sparc )
}

pkg_postinst() {
	# Set as default VM if none exists
	java-vm-2_pkg_postinst

	if use nsplugin; then
		elog "The icedtea6 browser plugin can be enabled using eselect java-nsplugin"
		elog "Note that the plugin works only in browsers based on xulrunner-1.9"
		elog "such as Firefox 3 or Epiphany 2.24 and not in older versions!"
		elog "Also note that you need to recompile icedtea6 if you upgrade"
		elog "from xulrunner-1.9.0 to 1.9.1."
	fi
}
