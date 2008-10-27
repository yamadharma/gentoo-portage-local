# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/openoffice-bin/openoffice-bin-2.4.0.ebuild,v 1.1 2008/03/27 08:14:06 suka Exp $

inherit eutils fdo-mime multilib

IUSE="gnome java kde"

DESCRIPTION="Сборка OpenOffice от компании Инфра-ресурс"

SRC_URI="x86?	( http://download.i-rs.ru/pub/openoffice/${PV}/ru/OOo_${PV}_LinuxIntel_ru_infra.tar.gz )
	amd64?	( http://download.i-rs.ru/pub/openoffice/${PV}/ru/OOo_${PV}_LinuxX86-64_ru_infra.tar.gz )"

HOMEPAGE="http://www.i-rs.ru/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="!app-office/openoffice
	!app-office/openoffice-infra
    x11-libs/libXaw
    sys-libs/glibc
    >=dev-lang/perl-5.0
    app-arch/zip
    app-arch/unzip
    >=media-libs/freetype-2.1.10-r2
    java? ( >=virtual/jre-1.5 )"

DEPEND="${RDEPEND}
    sys-apps/findutils"
								

PROVIDE="virtual/ooo"
RESTRICT="strip"

src_unpack() {
	unpack ${A}
}

src_install () {

	#Multilib install dir magic for AMD64
	has_multilib_profile && ABI=x86
	INSTDIR="/opt/openoffice"
	INSTDIRP="\/opt\/openoffice\/openoffice.org3\/program"

	einfo "Установка OpenOffice.org в сборочный корень..."
	dodir ${INSTDIR}

	if [[ "${ARCH}" == "amd64" ]]; then
		gentoo_env_set_src="X86-64"
	else
		gentoo_env_set_src="Intel"
	fi

	mv "${WORKDIR}"/OOo_${PV}_Linux${gentoo_env_set_src}_ru_infra/* "${D}${INSTDIR}"

	#Menu entries, icons and mime-types
	cd "${D}${INSTDIR}/openoffice.org3/share/xdg/"

	for desk in base calc draw impress math printeradmin writer; do
		sed -i -e s/"Exec=openoffice.org3"/"Exec=ooffice"/	${desk}.desktop || die
		sed -i -e s/"Icon=openofficeorg3-"/"Icon=ooo_"/  ${desk}.desktop || die
		domenu ${desk}.desktop
		doicon "${FILESDIR}/ooo_${desk}.svg"
	done

	# Component symlinks
	for app in base calc draw impress math writer; do
		dosym ${INSTDIR}/openoffice.org3/program/s${app} /usr/bin/oo${app}
	done

	dosym ${INSTDIR}/openoffice.org3/program/spadmin	/usr/bin/ooffice-printeradmin
	dosym ${INSTDIR}/openoffice.org3/program/soffice	/usr/bin/soffice

	# Install wrapper script
	newbin "${FILESDIR}/wrapper.in" ooffice
	sed -i -e s/"\/usr\/LIBDIR\/openoffice\/program"/"${INSTDIRP}"/g "${D}/usr/bin/ooffice" || die


	# Change user install dir
	sed -i -e s/".openoffice.org\/3"/.ooo-3.0/g "${D}${INSTDIR}/openoffice.org3/program/bootstraprc" || die

	# Non-java weirdness see bug #99366
	use !java && rm -f "${D}${INSTDIR}/openoffice.org3/program/javaldx"

	# prevent revdep-rebuild from attempting to rebuild all the time
	insinto /etc/revdep-rebuild && doins "${FILESDIR}/50-openoffice-bin"

}

pkg_postinst() {

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	eselect oodict update --libdir $(get_libdir)

	[[ -x /sbin/chpax ]] && [[ -e /usr/$(get_libdir)/openoffice/program/soffice.bin ]] && chpax -zm /usr/$(get_libdir)/openoffice/program/soffice.bin

	elog " Чтобы запустить OpenOffice.org ${PV} Pro, выполните:"
	elog
	elog " $ ooffice"
	elog
	elog " Также, для конкретных компонентов, вы можете использовать следующее:"
	elog
	elog " oobase, oocalc, oodraw, ooimpress, oomath, или oowriter"
}
