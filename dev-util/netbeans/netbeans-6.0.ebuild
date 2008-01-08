# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/netbeans/netbeans-5.5-r4.ebuild,v 1.1 2007/01/28 19:40:16 fordfrog Exp $

# NOTE:
# - for debug purposes you can set JAVA_PKG_NB_BUNDLED="true" if you want to disable unbundling
# - for unbundling purposes you can set JAVA_PKG_NB_REMOVE_JARS="true" if you want to remove
#   all but symlinked jars in src_unpack()
# - though no part of 'ide' module is built when building just platform, it is needed because
#   some files are copied from 'ide' module in 'build-nozip' target

# TODO:
# - bind dependencies to USE flags
# - commons-jxpath seems to be patched
# - antlr in uml module seems to be patched

WANT_SPLIT_ANT="true"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="NetBeans IDE for Java"
HOMEPAGE="http://www.netbeans.org"

SLOT="6.0"
MY_PV=${PV}
SOURCE_SITE="http://dev.gentoo.org/~fordfrog/distfiles/"
SRC_URI="
	${SOURCE_SITE}/${PN}-autoupdate-${MY_PV}.tar.bz2
	${SOURCE_SITE}/${PN}-core-${MY_PV}.tar.bz2
	${SOURCE_SITE}/${PN}-editor-${MY_PV}.tar.bz2
	${SOURCE_SITE}/${PN}-graph-${MY_PV}.tar.bz2
	${SOURCE_SITE}/${PN}-ide-${MY_PV}.tar.bz2
	${SOURCE_SITE}/${PN}-libs-${MY_PV}.tar.bz2
	${SOURCE_SITE}/${PN}-nbbuild-${MY_PV}.tar.bz2
	${SOURCE_SITE}/${PN}-openide-${MY_PV}.tar.bz2
	${SOURCE_SITE}/${PN}-projects-${MY_PV}.tar.bz2
	${SOURCE_SITE}/${PN}-translatedfiles-${MY_PV}.tar.bz2
	apisupport? (
		${SOURCE_SITE}/${PN}-apisupport-${MY_PV}.tar.bz2
	)
	cnd? (
		${SOURCE_SITE}/${PN}-cnd-${MY_PV}.tar.bz2
	)
	harness? (
		${SOURCE_SITE}/${PN}-apisupport-${MY_PV}.tar.bz2
	)
	ide? (
		${SOURCE_SITE}/${PN}-ant-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-classfile-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-core-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-db-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-debuggercore-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-diff-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-editor-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-extbrowser-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-html-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-httpserver-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-ide-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-image-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-javacvs-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-languages-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-lexer-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-libs-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-openidex-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-projects-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-properties-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-refactoring-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-schema2beans-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-scripting-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-subversion-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-usersguide-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-utilities-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-versioncontrol-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-web-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-xml-${MY_PV}.tar.bz2
	)
	identity? (
		${SOURCE_SITE}/${PN}-identity-${MY_PV}.tar.bz2
	)
	j2ee? (
		${SOURCE_SITE}/${PN}-j2ee-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-j2eeserver-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-monitor-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-serverplugins-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-tomcatint-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-web-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-websvc-${MY_PV}.tar.bz2
	)
	java? (
		${SOURCE_SITE}/${PN}-ant-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-db-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-debuggerjpda-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-form-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-i18n-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-j2ee-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-java-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-javadoc-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-javawebstart-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-junit-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-refactoring-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-usersguide-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-websvc-${MY_PV}.tar.bz2
	)
	mobility? (
		${SOURCE_SITE}/${PN}-mobility-${MY_PV}.tar.bz2
	)
	nb? (
		${SOURCE_SITE}/${PN}-ide-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-logger-${MY_PV}.tar.bz2
	)
	profiler? (
		${SOURCE_SITE}/${PN}-debuggerjpda-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-profiler-${MY_PV}.tar.bz2
	)
	ruby? (
		${SOURCE_SITE}/${PN}-languages-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-ruby-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-scripting-${MY_PV}.tar.bz2
	)
	soa? (
		${SOURCE_SITE}/${PN}-enterprise-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-print-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-xml-${MY_PV}.tar.bz2
	)
	stableuc? (
		${SOURCE_SITE}/${PN}-ant-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-apisupport-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-collab-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-ide-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-management-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-monitor-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-libs-${MY_PV}.tar.bz2
		${SOURCE_SITE}/${PN}-logger-${MY_PV}.tar.bz2
	)
	uml? (
		${SOURCE_SITE}/${PN}-uml-${MY_PV}.tar.bz2
	)
	visualweb? (
		${SOURCE_SITE}/${PN}-visualweb-${MY_PV}.tar.bz2
	)
	xml? (
		${SOURCE_SITE}/${PN}-xml-${MY_PV}.tar.bz2
	)"

LICENSE="CDDL"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE="apisupport cnd debug doc harness ide identity j2ee java mobility nb profiler ruby soa stableuc uml visualweb xml linguas_de linguas_es linguas_ja linguas_pl linguas_pt_BR linguas_sq linguas_zh_CN"

#RDEPEND=">=virtual/jre-1.5
#	>=dev-java/commons-io-1.2
#	dev-java/commons-validator
#	dev-java/fastinfoset
#	dev-java/jax-rpc
#	dev-java/jax-ws
#	dev-java/jax-ws-api
#	dev-java/jaxp
#	dev-java/jsr67
#	dev-java/jsr101
#	dev-java/jsr181
#	dev-java/jsr250
#	=dev-java/struts-1.2*
#	dev-java/relaxng-datatype
#	dev-java/saaj
#	dev-java/xsdlib
#	${COMMON_DEPEND}"

RDEPEND=">=virtual/jdk-1.5
	>=dev-java/javahelp-2.0.02
	=dev-java/swing-layout-1*
	java? ( >=dev-java/ant-tasks-1.7.0-r2 )"

DEPEND="=virtual/jdk-1.5*
	dev-java/ant-contrib
	>=dev-java/ant-nodeps-1.7.0
	<dev-java/antlr-3
	=dev-java/asm-2.2*
	>=dev-java/avalon-logkit-2.0
	dev-java/axion
	=dev-java/commons-beanutils-1.7*
	>=dev-java/commons-cli-1
	>=dev-java/commons-codec-1.3
	>=dev-java/commons-collections-3.1
	dev-java/commons-digester
	dev-java/commons-el
	>=dev-java/commons-httpclient-3
	>=dev-java/commons-jxpath-1.1
	>=dev-java/commons-lang-2.1
	>=dev-java/commons-logging-1.1
	>=dev-java/commons-net-1.4.1
	>=dev-java/commons-primitives-1.0
	dev-java/flute
	>=dev-java/freemarker-2.3.8
	dev-java/glassfish-persistence
	>=dev-java/httpunit-1.6
	dev-java/ical4j
	>=dev-java/jakarta-jstl-1.1.2
	>=dev-java/jakarta-oro-2.0.8
	>=dev-java/javahelp-2.0.02
	>=dev-java/jaxb-2
	>=dev-java/jaxb-tools-2
	>=dev-java/jaxen-1.1
	>=dev-java/jcalendar-1.3.2
	>=dev-java/jdom-1.0
	>=dev-java/jexcelapi-2.5
	>=dev-java/jsch-0.1.24
	dev-java/jsr173
	=dev-java/junit-3.8*
	>=dev-java/junit-4
	>=dev-java/kxml-2
	>=dev-java/log4j-1.2.8
	>=dev-java/lucene-2.1.0
	>=dev-java/portletapi-1
	>=dev-java/prefuse-20060715_beta
	dev-java/proguard
	dev-java/sac
	dev-java/saxpath
	dev-java/sjsxp
	>=dev-java/sun-jaf-1.1
	dev-java/sun-javamail
	dev-java/sun-jdbc-rowset-bin
	dev-java/sun-jmx
	=dev-java/swing-layout-1*
	>=dev-java/velocity-1.4
	>=dev-java/wsdl4j-1.5.2
	>=dev-java/xerces-2.8.1
	>=dev-java/xml-xmlbeans-1.0.4_pre
	>=dev-java/xmlunit-1.0
	dev-util/checkstyle
	>=dev-util/pmd-1.3
	apisupport? ( >=dev-java/ant-trax-1.7.0 )
	cnd? ( >=dev-java/antlr-netbeans-cnd-2.7.7 )
	doc? ( >=dev-java/ant-trax-1.7.0 )"

S=${WORKDIR}/netbeans-src
BUILDDESTINATION="${S}/nbbuild/netbeans"
ENTERPRISE="4"
IDE_VERSION="8"
PLATFORM="7"
MY_FDIR="${FILESDIR}/${SLOT}"
DESTINATION="/usr/share/netbeans-${SLOT}"
JAVA_PKG_BSFIX="off"

pkg_setup() {
	if use doc ; then
		ewarn "Currently building with 'doc' USE flag fails, see bugs http://www.netbeans.org/issues/show_bug.cgi?id=109722 http://www.netbeans.org/issues/show_bug.cgi?id=107510"
	fi

	if use apisupport && ! ( use harness && use ide && use java ) ; then
		eerror "'apisupport' USE flag requires 'harness', 'ide' and 'java' USE flags"
		exit 1
	fi

	if use cnd && ! use ide ; then
		eerror "'cnd' USE flag requires 'ide' USE flag"
		exit 1
	fi

	if use identity && ! ( use ide && use j2ee && use java ) ; then
		eerror "'identity' USE flag requires 'ide', 'j2ee' and 'java' USE flags"
		exit 1
	fi

	if use j2ee && ! ( use ide && use java ) ; then
		eerror "'j2ee' USE flag requires 'ide' and 'java' USE flags"
		exit 1
	fi

	if use java && ! use ide ; then
		eerror "'java' USE flag requires 'ide' USE flag"
		exit 1
	fi

	if use mobility && ! ( use ide && use java ) ; then
		eerror "'mobility' USE flag requires 'ide' and 'java' USE flags"
		exit 1
	fi

	if use nb && ! use ide ; then
		eerror "'nb' USE flag requires 'ide' USE flag"
		exit 1
	fi

	if use profiler && ! ( use ide && use java && use xml ) ; then
		eerror "'profiler' USE flag requires 'ide', 'java' and 'xml' USE flags"
		exit 1
	fi

	if use ruby && ! use ide ; then
		eerror "'ruby' USE flag requires 'ide' USE flag"
		exit 1
	fi

	if use soa && ! ( use ide && use java ) ; then
		eerror "'soa' USE flag requires 'ide' and 'java' USE flags"
		exit 1
	fi

	if use stableuc && ! ( use apisupport && use cnd && use ide && use identity && use j2ee && use java && use mobility && use nb && use profiler && use ruby && use soa && use uml && use visualweb && use xml ) ; then
		eerror "'stableuc' USE flag requires 'apisupport', 'cnd', 'ide', 'identity', 'j2ee', 'java', 'mobility', 'nb', 'profiler', 'ruby', 'soa', 'uml', 'visualweb' and 'xml' USE flags"
		exit 1
	fi

	if use uml && ! ( use harness && use ide && use java && use nb ) ; then
		eerror "'uml' USE flag requires 'harness', 'ide', 'java' and 'nb' USE flags"
		exit 1
	fi

	if use visualweb && ! ( use ide && use j2ee && use java ) ; then
		eerror "'visualweb' USE flag requires 'ide', 'j2ee' and 'java' USE flags"
		exit 1
	fi

	if use xml && ! use ide ; then
		eerror "'xml' USE flag requires 'ide' USE flag"
		exit 1
	fi

	java-pkg-2_pkg_setup
}

src_unpack () {
	unpack ${A}

	if use visualweb && [ -z "${JAVA_PKG_NB_BUNDLED}" ] ; then
		cd "${S}"/visualweb/insync/src/org/netbeans/modules/visualweb/insync/markup
		epatch ${MY_FDIR}/visualweb-JxpsSerializer.java-xerces-2.8.1.patch
	fi

	# Clean up nbbuild
	einfo "Removing prebuilt *.class files from nbbuild"
	find "${S}"/nbbuild -name "*.class" -delete

	# Remove JARs that are not needed
	if [ -z "${JAVA_PKG_NB_BUNDLED}" ] ; then
		einfo "Removing not needed JARs"
		for FILE in `find "${S}" -name "*.jar" | grep "/test/"`; do
			rm -v ${FILE} || die "Cannot remove ${FILE}"
		done
		for FILE in `find "${S}" -name "*.jar" | grep "/qa/"`; do
			rm -v ${FILE} || die "Cannot remove ${FILE}"
		done
	fi

	place_unpack_symlinks

	if [[ -n "${JAVA_PKG_NB_REMOVE_JARS}" ]] ; then
		einfo "Removing rest of the bundled jars as requested by JAVA_PKG_NB_REMOVE_JARS..."
		find "${S}" -type f -name "*.jar" | xargs rm -v
	fi
}

src_compile() {
	local antflags="-Dstop.when.broken.modules=true"

	if use debug; then
		antflags="${antflags} -Dbuild.compiler.debug=true"
		antflags="${antflags} -Dbuild.compiler.deprecation=true"
	else
		antflags="${antflags} -Dbuild.compiler.deprecation=false"
	fi

	local clusters="-Dnb.clusters.list=nb.cluster.platform"
	use apisupport && clusters="${clusters},nb.cluster.apisupport"
	use cnd && clusters="${clusters},nb.cluster.cnd"
	use harness && clusters="${clusters},nb.cluster.harness"
	use ide && clusters="${clusters},nb.cluster.ide"
	use identity && clusters="${clusters},nb.cluster.identity"
	use j2ee && clusters="${clusters},nb.cluster.j2ee"
	use java && clusters="${clusters},nb.cluster.java"
	use mobility && clusters="${clusters},nb.cluster.mobility"
	use nb && clusters="${clusters},nb.cluster.nb"
	use profiler && clusters="${clusters},nb.cluster.profiler"
	use ruby && clusters="${clusters},nb.cluster.ruby"
	use soa && clusters="${clusters},nb.cluster.soa"
	use stableuc && clusters="${clusters},nb.cluster.stableuc"
	use uml && clusters="${clusters},nb.cluster.uml"
	use visualweb && clusters="${clusters},nb.cluster.visualweb"
	use xml && clusters="${clusters},nb.cluster.xml"

	# Fails to compile
	java-pkg_filter-compiler ecj-3.1 ecj-3.2

	# Build the the clusters
	use ruby && addpredict /root/.jruby
	ANT_TASKS="ant-nodeps"
	use cnd && ANT_TASKS="${ANT_TASKS} antlr-netbeans-cnd"
	use apisupport && ANT_TASKS="${ANT_TASKS} ant-trax"
	ANT_OPTS="-Xmx1g -Djava.awt.headless=true" eant ${antflags} ${clusters} -f nbbuild/build.xml build-nozip

	use linguas_de && compile_locale_support "${antflags}" "${clusters}" de
	use linguas_es && compile_locale_support "${antflags}" "${clusters}" es
	use linguas_ja && compile_locale_support "${antflags}" "${clusters}" ja
	use linguas_pl && compile_locale_support "${antflags}" "${clusters}" pl
	use linguas_pt_BR && compile_locale_support "${antflags}" "${clusters}" pt_BR
	use linguas_sq && compile_locale_support "${antflags}" "${clusters}" sq
	use linguas_zh_CN && compile_locale_support "${antflags}" "${clusters}" zh_CN

	# Running build-javadoc from the same command line as build-nozip doesn't work
	# so we must run it separately
	if use doc ; then
		! use apisupport && ANT_TASKS="${ANT_TASKS} ant-trax"
		ANT_OPTS="-Xmx1g" eant ${antflags} ${clusters} -f nbbuild/build.xml build-javadoc
	fi

	# Remove non-Linux binaries
	find ${BUILDDESTINATION} -type f \
		-name "*.exe" -o \
		-name "*.cmd" -o \
		-name "*.bat" -o \
		-name "*.dll"	  \
		| xargs rm -f

	# Removing external stuff. They are api docs from external libs.
	rm -f ${BUILDDESTINATION}/ide${IDE_VERSION}/docs/*.zip

	# Remove zip files from generated javadocs.
	rm -f ${BUILDDESTINATION}/javadoc/*.zip

	# Use the system ant
	if use java ; then
		cd ${BUILDDESTINATION}/java1/ant || die "Cannot cd to ${BUILDDESTINATION}/ide${IDE_VERSION}/ant"
		rm -fr lib
		rm -fr bin
	fi

	# Set initial default jdk
	if [[ -e ${BUILDDESTINATION}/etc/netbeans.conf ]]; then
		echo "netbeans_jdkhome=\"\$(java-config -O)\"" >> ${BUILDDESTINATION}/etc/netbeans.conf
	fi

	# fix paths per bug# 163483
	if [[ -e ${BUILDDESTINATION}/bin/netbeans ]]; then
		sed -i -e 's:"$progdir"/../etc/:/etc/netbeans-6.0/:' ${BUILDDESTINATION}/bin/netbeans
		sed -i -e 's:"${userdir}"/etc/:/etc/netbeans-6.0/:' ${BUILDDESTINATION}/bin/netbeans
	fi
}

src_install() {
	insinto ${DESTINATION}

	einfo "Installing the program..."
	cd ${BUILDDESTINATION}
	doins -r *

	# Remove the build helper files
	rm -f "${D}"/${DESTINATION}/nb.cluster.*
	rm -f "${D}"/${DESTINATION}/*.built
	rm -f "${D}"/${DESTINATION}/moduleCluster.properties
	rm -f "${D}"/${DESTINATION}/module_tracking.xml
	rm -f "${D}"/${DESTINATION}/build_info

	# Change location of etc files
	if [[ -e ${BUILDDESTINATION}/etc ]]; then
		insinto /etc/${PN}-${SLOT}
		doins ${BUILDDESTINATION}/etc/*
		rm -fr "${D}"/${DESTINATION}/etc
		dosym /etc/${PN}-${SLOT} ${DESTINATION}/etc
	fi

	# Replace bundled jars with system jars
	symlink_extjars

	# Correct permissions on executables
	local nbexec_exe="${DESTINATION}/platform${PLATFORM}/lib/nbexec"
	fperms 775 ${nbexec_exe} || die "Cannot update perms on ${nbexec_exe}"
	if [[ -e "${D}"/${DESTINATION}/bin/netbeans ]] ; then
		local netbeans_exe="${DESTINATION}/bin/netbeans"
		fperms 755 ${netbeans_exe} || die "Cannot update perms on ${netbeans_exe}"
	fi
	if use ruby ; then
		local ruby_path="${DESTINATION}/ruby1/jruby-1.0.2/bin"
		cd "${D}"/${ruby_path} || die "Cannot cd to ${D}/${ruby_path}"
		for file in * ; do
			fperms 755 ${ruby_path}/${file} || die "Cannot update perms on ${ruby_path}/${file}"
		done
	fi

	# Link netbeans executable from bin
	if [[ -f "${D}"/${DESTINATION}/bin/netbeans ]]; then
		dosym ${DESTINATION}/bin/netbeans /usr/bin/${PN}-${SLOT}
	else
		dosym ${DESTINATION}/platform7/lib/nbexec /usr/bin/${PN}-${SLOT}
	fi

	# Ant installation
	if use java ; then
		local ANTDIR="${DESTINATION}/java1/ant"
		dosym /usr/share/ant/lib ${ANTDIR}/lib
		dosym /usr/share/ant-core/bin ${ANTDIR}/bin
	fi

	# Documentation
	einfo "Installing Documentation..."

	cd "${D}"/${DESTINATION}
	dohtml CREDITS.html README.html netbeans.css
	rm -f build_info CREDITS.html README.html netbeans.css

	use doc && java-pkg_dojavadoc "${S}"/nbbuild/build/javadoc

	# Icons and shortcuts
	if use nb ; then
		einfo "Installing icon..."
		dodir /usr/share/icons/hicolor/32x32/apps
		dosym ${DESTINATION}/nb${SLOT}/netbeans.png /usr/share/icons/hicolor/32x32/apps/netbeans-${SLOT}.png

	fi

	make_desktop_entry netbeans-${SLOT} "Netbeans ${SLOT}" netbeans-${SLOT}.png Development
}

pkg_postinst() {
	einfo "If you want to use specific locale of netbeans, use --locale argument, for example:"
	einfo "${PN}-${SLOT} --locale de"
	einfo "${PN}-${SLOT} --locale pt:BR"
}

pkg_postrm() {
	if ! test -e /usr/bin/netbeans-${SLOT}; then
		elog "Because of the way Portage works at the moment"
		elog "symlinks to the system jars are left to:"
		elog "${DESTINATION}"
		elog "If you are uninstalling Netbeans you can safely"
		elog "remove everything in this directory"
	fi
}

# Supporting functions for this ebuild

place_unpack_symlinks() {
	local target=""

	if [ -e "${S}"/apisupport ] ; then
		einfo "Symlinking jars for apisupport"
		target="apisupport/harness/external"
		dosymcompilejar ${target} javahelp jhall.jar jsearch-2.0_05.jar
	fi

	if [ -e "${S}"/collab ] ; then
		einfo "Symlinking jars for collab"
		target="collab/im/external"
		dosymcompilejar ${target} jaxen-1.1 jaxen.jar jaxen-core-1.0.jar
		dosymcompilejar ${target} log4j log4j.jar log4j-1.2.8.jar
		dosymcompilejar ${target} saxpath
	fi

	if [ -e "${S}"/contrib ] ; then
		einfo "Symlinking jars for contrib"
		target="contrib/doap/external"
		dosymcompilejar ${target} commons-codec commons-codec.jar commons-codec-1.2.jar
		dosymcompilejar ${target} commons-httpclient-3 commons-httpclient.jar commons-httpclient-3.0.1.jar
		dosymcompilejar ${target} commons-logging commons-logging.jar commons-logging-1.0.3.jar
		target="contrib/jalopy/external"
		dosymcompilejar ${target} log4j log4j.jar log4j-1.2.6.jar
		target="contrib/pmd-nb-wrapper/external"
		dosymcompilejar ${target} pmd pmd.jar pmd-1.3.jar
		target="contrib/projectpackager/external"
		dosymcompilejar ${target} sun-jaf activation.jar activation-1.0.2.jar
		dosymcompilejar ${target} sun-javamail mail.jar mail-1.3.2.jar
		target="contrib/tasklist/checkstyle/external"
		dosymcompilejar ${target} checkstyle checkstyle.jar checkstyle-all.jar
		target="contrib/tteditor/GDESuite/GDEWizard/src/gdefolder/std-lib"
		dosymcompilejar ${target} portletapi-1 portletapi.jar portlet.jar
	fi

	if [ -e "${S}"/core ] ; then
		einfo "Symlinking jars for core"
		target="core/javahelp/external"
		dosymcompilejar ${target} javahelp jh.jar jh-2.0_05.jar
	fi

	if [ -e "${S}"/db ] ; then
		einfo "Symlinking jars for db"
	fi

	if [ -e "${S}"/enterprise ] ; then
		einfo "Symlinking jars for enterprise"
		target="enterprise/dataintegrator/external"
		dosymcompilejar ${target} avalon-logkit-2.0 avalon-logkit.jar avalon-logkit-current.jar
		dosymcompilejar ${target} axion axion.jar axiondb.jar
		dosymcompilejar ${target} commons-codec commons-codec.jar commons-codec-1.3.jar
		dosymcompilejar ${target} commons-collections commons-collections.jar commons-collections-3.0.jar
		dosymcompilejar ${target} commons-primitives commons-primitives.jar commons-primitives-1.0.jar
		dosymcompilejar ${target} jexcelapi-2.5 jexcelapi.jar jxl.jar
		dosymcompilejar ${target} jsr173 jsr173.jar jsr173_api.jar
		dosymcompilejar ${target} sjsxp
		dosymcompilejar ${target} velocity velocity.jar velocity-1.4.jar
		dosymcompilejar ${target} wsdl4j wsdl4j.jar
		target="enterprise/dcom/external"
		dosymcompilejar ${target} wsdl4j wsdl4j.jar wsdl4j-1.5.2.jar
		target="enterprise/libs/httpunit/external"
		dosymcompilejar ${target} httpunit httpunit.jar httpunit-1.6.2.jar
		target="enterprise/libs/xmlunit/external"
		dosymcompilejar ${target} xmlunit-1 xmlunit.jar xmlunit-1.0.jar
		target="enterprise/openesbaddons/aspect/external"
		dosymcompilejar ${target} sun-jaf
		dosymcompilejar ${target} jaxb-2 jaxb-api.jar
		dosymcompilejar ${target} jaxb-2 jaxb-impl.jar
		dosymcompilejar ${target} jaxb-tools-2 jaxb-tools.jar jaxb-xjc.jar
		dosymcompilejar ${target} jsr173 jsr173.jar jsr173_api.jar
		dosymcompilejar ${target} wsdl4j wsdl4j.jar
		target="enterprise/openesbaddons/contrib-imola/cics-bc/netbeansplugin/libraries/release/modules/ext"
		dosymcompilejar ${target} sun-jaf activation.jar activation-1.1.jar
		dosymcompilejar ${target} antlr antlr.jar antlr-2.7.7.jar
		dosymcompilejar ${target} asm-2.2 asm.jar asm-all-2.2.3.jar
		dosymcompilejar ${target} commons-collections commons-collections.jar commons-collections-3.2.jar
		dosymcompilejar ${target} jdom-1.0 jdom.jar jdom-1.0.jar
		dosymcompilejar ${target} wsdl4j wsdl4j.jar wsdl4j-1.5.2.jar
		target="enterprise/openesbaddons/contrib-imola/corba-bc/netbeansplugin/libraries/release/modules/ext"
		dosymcompilejar ${target} sun-jaf activation.jar activation-1.1.jar
		dosymcompilejar ${target} antlr antlr.jar antlr-2.7.6.jar
		dosymcompilejar ${target} asm-2.2 asm.jar asm-all-2.2.3.jar
		dosymcompilejar ${target} commons-beanutils-1.7 commons-beanutils-core.jar commons-beanutils-core-1.7.0.jar
		dosymcompilejar ${target} commons-beanutils-1.7 commons-beanutils.jar commons-beanutils-1.7.0.jar
		dosymcompilejar ${target} commons-lang-2.1 commons-lang.jar commons-lang-2.3.jar
		dosymcompilejar ${target} checkstyle checkstyle.jar checkstyle-4.3.jar
		dosymcompilejar ${target} jaxb-2 jaxb-api.jar jaxb-api-2.1.jar
		dosymcompilejar ${target} jdom-1.0 jdom.jar jdom-1.0.jar
		dosymcompilejar ${target} wsdl4j wsdl4j.jar wsdl4j-1.6.1.jar
		target="enterprise/openesbaddons/contrib-imola/ejb-bc/netbeansplugin/libraries/release/modules/ext"
		dosymcompilejar ${target} sun-jaf activation.jar activation-1.1.jar
		dosymcompilejar ${target} asm-2.2 asm.jar asm-all-2.2.3.jar
		dosymcompilejar ${target} commons-lang-2.1 commons-lang.jar commons-lang-2.1.jar
		dosymcompilejar ${target} jdom-1.0 jdom.jar jdom-1.0.jar
		dosymcompilejar ${target} jsr173 jsr173.jar jsr173_api-1.0.jar
		dosymcompilejar ${target} wsdl4j wsdl4j.jar wsdl4j-1.5.2.jar
		target="enterprise/openesbaddons/smtpmail/release/modules/ext"
		dosymcompilejar ${target} sun-javamail
		target="enterprise/openesbaddons/workflow/project/external"
		dosymcompilejar ${target} log4j log4j.jar log4j-1.2.13.jar
	fi

	if [ -e "${S}"/form ] ; then
		einfo "Symlinking jars for forms"
	fi

	if [ -e "${S}"/httpserver ] ; then
		einfo "Symlinking jars for httpserver"
	fi

	if [ -e "${S}"/java ] ; then
		einfo "Symlinking jars for java"
	fi

	if [ -e "${S}"/junit ] ; then
		einfo "Symlinking jars for junit"
		target="junit/external"
		dosymcompilejar ${target} junit junit.jar junit-3.8.2.jar
		dosymcompilejar ${target} junit-4 junit.jar junit-4.1.jar
	fi

	if [ -e "${S}"/j2ee ] ; then
		einfo "Symlinking jars for j2ee"
		target="j2ee/external"
		dosymcompilejar ${target} glassfish-persistence
	fi

	if [ -e "${S}"/j2eeserver ] ; then
		einfo "Symlinking jars for j2eeserver"
		target="j2eeserver/external"
		# sun-j2ee-deployment-bin is not compatible with glassfish deployment library anymore
		#dosymcompilejar ${target} sun-j2ee-deployment-bin-1.1 sun-j2ee-deployment-bin.jar jsr88javax.jar
	fi

	if [ -e "${S}"/lexer ] ; then
		einfo "Symlinking jars for lexer"
		target="lexer/external"
		dosymcompilejar ${target} antlr antlr.jar antlr-2.7.1.jar
	fi

	if [ -e "${S}"/libs ] ; then
		einfo "Symlinking jars for libs"
		target="libs/commons_lang/external"
		dosymcompilejar ${target} commons-lang-2.1 commons-lang.jar commons-lang-2.1.jar
		target="libs/commons_logging/external"
		dosymcompilejar ${target} commons-logging commons-logging.jar commons-logging-1.0.4.jar
		target="libs/freemarker/external"
		dosymcompilejar ${target} freemarker-2.3 freemarker.jar freemarker-2.3.8.jar
		target="libs/ical4j/external"
		dosymcompilejar ${target} commons-logging commons-logging-api.jar commons-logging-api-1.1.jar
		dosymcompilejar ${target} ical4j ical4j.jar ical4j-1.0-beta1.jar
		target="libs/jcalendar/external"
		dosymcompilejar ${target} jcalendar-1.2 jcalendar.jar jcalendar-1.3.2.jar
		target="libs/jsch/external"
		dosymcompilejar ${target} jsch jsch.jar jsch-0.1.24.jar
		target="libs/lucene/external"
		dosymcompilejar ${target} lucene-2 lucene-core.jar lucene-core-2.1.0.jar
		target="libs/swing-layout/external"
		dosymcompilejar ${target} swing-layout-1 swing-layout.jar swing-layout-1.0.3.jar
		target="libs/xerces/external"
		dosymcompilejar ${target} xerces-2 xercesImpl.jar xerces-2.8.0.jar
		target="libs/xmlbeans/external"
		dosymcompilejar ${target} xml-xmlbeans-1 xbean.jar xbean-1.0.4.jar
	fi

	if [ -e "${S}"/mobility ] ; then
		einfo "Symlinking jars for mobility"
		target="mobility/ant-ext/external"
		dosymcompilejar ${target} ant-contrib ant-contrib.jar ant-contrib-1.0b3.jar
		target="mobility/cdcplugins/ricoh/external"
		dosymcompilejar ${target} commons-codec commons-codec.jar commons-codec-1.3.jar
		dosymcompilejar ${target} commons-httpclient-3 commons-httpclient.jar commons-httpclient-3.0.jar
		target="mobility/deployment/ftpscp/external"
		dosymcompilejar ${target} commons-net commons-net.jar commons-net-1.4.1.jar	fi
		dosymcompilejar ${target} jakarta-oro-2.0 jakarta-oro.jar jakarta-oro-2.0.8.jar
		target="mobility/deployment/webdav/external"
		dosymcompilejar ${target} commons-httpclient-3
		dosymcompilejar ${target} commons-logging commons-logging.jar
		dosymcompilejar ${target} jdom-1.0 jdom.jar jdom-1.0.jar
		target="mobility/proguard/external"
		dosymcompilejar ${target} proguard proguard.jar proguard3.7.jar
	fi

	if [ -e "${S}"/monitor ] ; then
		einfo "Symlinking jars for monitor"
	fi

	if [ -e "${S}"/performance ] ; then
		einfo "Symlinking jars for performance"
	fi

	if [ -e "${S}"/ruby ] ; then
		einfo "Symlinking jars for ruby"
		target="ruby/kxml2/external"
		dosymcompilejar ${target} kxml-2 kxml2.jar kxml2-2.3.0.jar
	fi

	if [ -e "${S}"/serverplugins ] ; then
		einfo "Symlinking jars for serverplugins"
		target="serverplugins/external"
		dosymcompilejar ${target} sun-jmx jmxri.jar jmxremote.jar
	fi

	if [ -e "${S}"/subversion ] ; then
		einfo "Symlinking jars for subversion"
	fi

	if [ -e "${S}"/tasklist ] ; then
		einfo "Symlinking jars for tasklist"
	fi

	if [ -e "${S}"/uml ] ; then
		einfo "Symlinking jars for uml"
		target="uml/antlr-2-7-2/external"
		#dosymcompilejar ${target} antlr antlr.jar antlr-2.7.2.jar
	fi

	if [ -e "${S}"/visualweb ] ; then
		einfo "Symlinking jars for visualweb"
		target="visualweb/ravelibs/rowset/external"
		dosymcompilejar ${target} sun-jdbc-rowset-bin rowset.jar rowset-1.0.1.jar
	fi

	if [ -e "${S}"/web ] ; then
		einfo "Symlinking jars for web"
		target="web/css/external"
		dosymcompilejar ${target} flute
		dosymcompilejar ${target} sac
		target="web/libs/jstl11/external"
		dosymcompilejar ${target} jakarta-jstl jstl.jar jstl-1.1.2.jar
		dosymcompilejar ${target} jakarta-jstl standard.jar standard-1.1.2.jar
	fi

	if [ -e "${S}"/xml ] ; then
		einfo "Symlinking jars for xml"
		target="xml/jxpath/external"
		#dosymcompilejar ${target} commons-jxpath commons-jxpath.jar jxpath1.1.jar
		target="xml/prefuse/external"
		dosymcompilejar ${target} prefuse-2006 prefuse.jar
	fi

	if [ -e "${S}"/xtest ] ; then
		einfo "Symlinking jars for xtest"
	fi
}

symlink_extjars() {
	local targetdir=""

	#einfo "Symlinking enterprise jars"

	#cd ${1}/enterprise${ENTERPRISE}/modules/ext
	#java-pkg_jar-from sun-j2ee-deployment-bin-1.1 sun-j2ee-deployment-bin.jar jsr88javax.jar
	#java-pkg_jar-from jakarta-jstl jstl.jar
	#java-pkg_jar-from jakarta-jstl standard.jar

	#cd ${1}/enterprise${ENTERPRISE}/modules/ext/blueprints
	#java-pkg_jar-from commons-fileupload commons-fileupload.jar commons-fileupload-1.1.1.jar
	#java-pkg_jar-from commons-io-1 commons-io.jar commons-io-1.2.jar
	#java-pkg_jar-from commons-logging commons-logging.jar commons-logging-1.1.jar

	#cd ${1}/enterprise${ENTERPRISE}/modules/ext/jsf
	#java-pkg_jar-from commons-beanutils-1.7 commons-beanutils.jar
	#java-pkg_jar-from commons-collections commons-collections.jar
	#java-pkg_jar-from commons-digester commons-digester.jar
	#java-pkg_jar-from commons-logging commons-logging.jar

	#cd ${1}/enterprise${ENTERPRISE}/modules/ext/struts
	#java-pkg_jar-from antlr antlr.jar
	#java-pkg_jar-from commons-beanutils-1.7 commons-beanutils.jar
	#java-pkg_jar-from commons-digester commons-digester.jar
	#java-pkg_jar-from commons-fileupload commons-fileupload.jar
	#java-pkg_jar-from commons-logging commons-logging.jar
	#java-pkg_jar-from commons-validator commons-validator.jar
	#java-pkg_jar-from jakarta-oro-2.0 jakarta-oro.jar
	#java-pkg_jar-from struts-1.2 struts.jar


	if use harness ; then
		einfo "Symlinking harness jars"
		targetdir="harness"
		dosyminstjar ${targetdir} javahelp jhall.jar jsearch-2.0_05.jar
	fi


	#einfo "Symlinking ide jars"

	#cd ${1}/ide${IDE_VERSION}/modules/ext
	#java-pkg_jar-from commons-logging commons-logging.jar commons-logging-1.0.4.jar
	#java-pkg_jar-from flute
	#java-pkg_jar-from jsch jsch.jar jsch-0.1.24.jar
	#java-pkg_jar-from junit junit.jar junit-3.8.2.jar
	#java-pkg_jar-from sac
	#java-pkg_jar-from servletapi-2.2 servlet.jar servlet-2.2.jar
	#java-pkg_jar-from xerces-2 xercesImpl.jar xerces-2.8.0.jar

	#cd ${1}/ide${IDE_VERSION}/modules/ext/jaxrpc16
	#java-pkg_jar-from sun-jaf
	#java-pkg_jar-from fastinfoset fastinfoset.jar FastInfoset.jar
	#java-pkg_jar-from jaxp
	#java-pkg_jar-from jsr101
	#java-pkg_jar-from jax-rpc jaxrpc-impl.jar
	#java-pkg_jar-from jax-rpc jaxrpc-spi.jar
	#java-pkg_jar-from jsr173 jsr173.jar jsr173_api.jar
	#java-pkg_jar-from sun-javamail
	#java-pkg_jar-from relaxng-datatype
	#java-pkg_jar-from jsr67 jsr67.jar saaj-api.jar
	#java-pkg_jar-from saaj saaj.jar saaj-impl.jar
	#java-pkg_jar-from xsdlib

	#cd ${1}/ide${IDE_VERSION}/modules/ext/jaxws21
	#java-pkg_jar-from sun-jaf
	#java-pkg_jar-from fastinfoset fastinfoset.jar FastInfoset.jar
	#java-pkg_jar-from jaxb-2 jaxb-impl.jar
	#java-pkg_jar-from jaxb-tools-2 jaxb-tools.jar jaxb-xjc.jar
	#java-pkg_jar-from jax-ws-2 jax-ws.jar jaxws-rt.jar
	#java-pkg_jar-from jax-ws-2 jax-ws.jar jaxws-tools.jar
	#java-pkg_jar-from jsr173 jsr173.jar jsr173_api.jar
	#java-pkg_jar-from jsr250
	#java-pkg_jar-from saaj saaj.jar saaj-impl.jar
	#java-pkg_jar-from sjsxp

	#cd ${1}/ide${IDE_VERSION}/modules/ext/jaxws21/api
	#java-pkg_jar-from jaxb-2 jaxb-api.jar
	#java-pkg_jar-from jax-ws-api-2 jax-ws-api.jar jaxws-api.jar
	#java-pkg_jar-from jsr181 jsr181.jar jsr181-api.jar
	#java-pkg_jar-from jsr67 jsr67.jar saaj-api.jar


	einfo "Symlinking platform jars"

	targetdir="platform${PLATFORM}/modules/ext"
	dosyminstjar ${targetdir} javahelp jh.jar jh-2.0_05.jar
	dosyminstjar ${targetdir} swing-layout-1 swing-layout.jar swing-layout-1.0.3.jar

	#if use mobility ; then
	#	einfo "Symlinking mobility jars"

	#	cd ${1}/extra/external
	#	java-pkg_jar-from commons-httpclient
	#	java-pkg_jar-from commons-logging commons-logging.jar
	#	java-pkg_jar-from jdom-1.0

	#	cd ${1}/extra/external/proguard
	#	java-pkg_jar-from proguard proguard.jar proguard3.5.jar

	#	cd ${1}/extra/modules/ext
	#	java-pkg_jar-from commons-net commons-net.jar commons-net-1.4.1.jar
	#	java-pkg_jar-from jakarta-oro-2.0 jakarta-oro.jar jakarta-oro-2.0.8.jar
	#fi
}

dosymcompilejar() {
	if [ -z "${JAVA_PKG_NB_BUNDLED}" ] ; then
		local dest="${1}"
		local package="${2}"
		local jar_file="${3}"
		local target_file="${4}"

		# We want to know whether the target jar exists and fail if it doesn't so we know
		# something is wrong
		local target="${S}/${dest}/${target_file}"
		[ ! -e "${target}" ] && die "Target jar does not exist so will not create link: ${target}"
		java-pkg_jar-from --build-only --into "${S}"/${dest} ${package} ${jar_file} ${target_file}
	fi
}

dosyminstjar() {
	if [ -z "${JAVA_PKG_NB_BUNDLED}" ] ; then
		local dest="${1}"
		local package="${2}"
		local jar_file="${3}"
		local target_file=""
		if [ -z "${4}" ]; then
			target_file="${3}"
		else
			target_file="${4}"
		fi

		# We want to know whether the target jar exists and fail if it doesn't so we know
		# something is wrong
		local target="${DESTINATION}/${dest}/${target_file}"
		[ ! -e "${D}/${target}" ] && die "Target jar does not exist so will not create link: ${D}/${target}"
		dosym /usr/share/${package}/lib/${jar_file} ${target}
	fi
}

# Compiles locale support
# Arguments
# 1 - ant flags
# 2 - clusters
# 3 - locale
compile_locale_support() {
	einfo "Compiling support for '${3}' locale"
	ANT_OPTS="-Xmx1g -Djava.awt.headless=true" eant ${1} ${2} -f nbbuild/build.xml -Dlocales=${3} build-nozip-ml
}
