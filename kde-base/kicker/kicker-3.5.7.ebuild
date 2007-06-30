# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kicker/kicker-3.5.7.ebuild,v 1.1 2007/05/22 23:56:41 carlo Exp $

KMNAME=kdebase

PATCH_VER="642174"

MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils flag-o-matic

SRC_URI="${SRC_URI}
	mirror://gentoo/kdebase-3.5-patchset-03.tar.bz2"

DESCRIPTION="Kicker is the KDE application starter panel and is also capable of some useful applets and extensions."
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="kdehiddenvisibility kickoff pertty xcomposite"

RDEPEND="
$(deprange $PV $MAXKDEVER kde-base/libkonq)
$(deprange $PV $MAXKDEVER kde-base/kdebase-data)
	x11-libs/libXau
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXtst
	xcomposite? ( x11-libs/libXcomposite )"

DEPEND="${RDEPEND}
	kickoff? ( sys-libs/liblazy >=app-misc/beagle-0.2.11 )"

KMCOPYLIB="libkonq libkonq"
KMEXTRACTONLY="libkonq
	kdm/kfrontend/themer/"
KMCOMPILEONLY="kdmlib/"

PATCHES=""

if use pertty;
then
	PATCHES="${PATCHES}
			 $FILESDIR/$KMNAME-3.5.6-$PN-execute_feedback.patch"

	#
	# Revert to old search + Kbutton patches if not using kickoff
	# - cannot have both on at the same time (yet)
	#
	if ! use kickoff;
	then
	PATCHES="${PATCHES}
		 	 $FILESDIR/$KMNAME-3.5.5-$PN-kmenu-button-reload.patch
		 	 $FILESDIR/$KMNAME-3.5.5-$PN-kmenu-search-box-suse.patch"
	fi
fi

src_unpack() {
	kde-meta_src_unpack

	#
	# If we are using kickoff, then epatch here and extract icons
	#
	if use kickoff;
	then
		# Add Kickoff support
		epatch "${FILESDIR}/$KMNAME-$PV-$PN-kickoff-suse-$PATCH_VER.diff"

		# Adjustments for Gentoo
		epatch "${FILESDIR}/kickoff-gentoo-xeffects-integration-$PATCH_VER.patch"
	
		# copy icons over
		tar xjf ${FILESDIR}/kickoff-icons.tar.bz2 -C ${WORKDIR}/${PN}-${PV}/${PN}/data
	fi
}

pkg_setup() {
	kde_pkg_setup
	if use kickoff && use kdehiddenvisibility ; then
		echo ""
		ewarn "You have enabled use flags 'kdehiddenvisibility' and 'kickoff'"
		ewarn "at the same time. While this may work for some, it likely will"
		ewarn "not. If you really want kickoff to work properly, please stop"
		ewarn "this emerge and disable 'kdehiddenvisibility' before you try"
		ewarn "again."
		echo ""
	fi

	if use pertty && ! built_with_use --missing false =kde-base/kdelibs-3.5* pertty; then
		eerror "The pertty USE flag in this package enables special extensions"
		eerror "and requires that kdelibs be patched to support these extensions."
		eerror "Since it appears your version of kdelibs was not compiled with these"
		eerror "extensions, you must either emerge kicker without pertty or"
		eerror "re-emerge kdelibs with pertty enabled and then emerge kicker again."
		die "Missing pertty USE flag on kde-base/kdelibs"
	fi
}

src_compile() {
	#
	# There is something broken in the build. So, first we setup myconf and run
	# configure.
	#
	export UNSERMAKE="no"

	kde-meta_src_compile myconf configure

	myconf="$myconf $(use_with xcomposite composite)"

	if use kickoff;
	then
		#
		# Now we run emake... until it fails
		#
		emake

		#
		# Fix the makefile and run emake... until it fails
		#
		sed -i '/SUBDIRS/ s/ui core/core ui/' kicker/kicker/Makefile.am
		emake

		#
		# Fix the makefile and run emake... until it fails
		#
		sed -i '/SUBDIRS/ s/core ui/interfaces core ui/' kicker/kicker/Makefile.am
		emake

		#
		#
		# Fix the makefile and run emake... until it fails
		#
		sed -i '/SUBDIRS/ s/interfaces core ui/ui interfaces core ui/' kicker/kicker/Makefile.am
		emake

		# Ok, that should get us to the point where we can finally run a full build
		# It's not perfect, but it does get the thing compiled. Anyone with a better
		# fix, let me know and I'll integrate it.
		#
	fi

	kde-meta_src_compile make
}

pkg_postinst() {
	kde_pkg_postinst
	echo
	ewarn "Do NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs to roderick.greening@gmail.com"
	einfo "Or, you may post them to http://forums.gentoo-xeffects.org"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
