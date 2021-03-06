# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-fs/samba/samba-2.2.7a.ebuild,v 1.1 2002/12/16 18:19:18 woodchip Exp $

IUSE="pam acl cups ldap ssl tcpd oav"


DESCRIPTION="SAMBA is a suite of SMB and CIFS client/server programs for UNIX"
HOMEPAGE="http://www.samba.org"

S=${WORKDIR}/${P}
SRC_URI="http://us3.samba.org/samba/ftp/cifs-cvs/${P}.tar.gz
http://us3.samba.org/samba/ftp/cifs-cvs/mount.cifs
http://us3.samba.org/samba/ftp/cifs-cvs/mount.cifs.8"

DEPEND=">=sys-libs/glibc-2.1.2
	pam? >=sys-libs/pam-0.72
	acl? sys-apps/acl
	cups? net-print/cups
	ldap? =net-nds/openldap-2*
	ssl? >=dev-libs/openssl-0.9.6
	tcpd? >=sys-apps/tcp-wrappers-7.6
	oav? >=dev-libs/popt-1.6.3
	virtual/krb5
	>=dev-libs/libxml2-2*"
	
KEYWORDS="x86 ~ppc ~sparc alpha"
LICENSE="GPL-2"
SLOT="0"

#src_unpack() {
#	local i
#	unpack ${A} || die
#	cd ${S} || die

#	patch -p0 <${FILESDIR}/samba-2.2.2-smbmount.diff || die
#	patch -p1 <${FILESDIR}/samba-2.2.5-gp-reloc-fix.patch || die
#	cd ${S}/source/client
#	patch -p0 <${FILESDIR}/samba-2.2.6-smbumount_lazy.patch || die

#	if use portldap; then
#		cd ${S}/source
#		patch -p0 <$FILESDIR/nonroot-bind.diff || die
#	fi

#	if use ldap; then
#		cd ${S}
#		patch -p0 <${FILESDIR}/samba-2.2.6-libresolv.patch || die
#	fi

	# fix kerberos include file collision..
#	cd ${S}/source/include
#	mv profile.h smbprofile.h
#	sed -e "s:profile\.h:smbprofile.h:" includes.h > includes.h.new
#	mv includes.h.new includes.h

	# for clean docs packaging sake, make a copy..
#	cp -a ${S}/examples ${S}/examples.bin
#	if use oav; then
#		# prep source for selected vscan plugin modules..
#		for i in ${VSCAN_MODS}
#		do
#			cp -a ${WORKDIR}/${PN}-vscan-${VSCAN_VER}/$i \
#				${S}/examples.bin/VFS
#		done
#	fi
#
#	cd ${S}/source
#	autoconf || die
#}

src_compile() {
	local i myconf
#	myconf="`use_enable ldap cups`"
	use acl && myconf="${myconf} --with-acl-support" ||  myconf="${myconf} --without-acl-support"
	use ssl && myconf="${myconf} --with-ssl" || myconf="${myconf} --without-ssl"
	use pam && myconf="${myconf} --with-pam --with-pam_smbpass" || \
		myconf="${myconf} --without-pam --without-pam_smbpass"
  use cups && myconf="${myconf} --enable-cups" || myconf="${myconf} --disable-cups"
#  myconf="${myconf} `use_enable cups`"
#  myconf="${myconf} `use_enable ldap cups`"
  use ldap && myconf="${myconf} --with-ldap" || myconf="${myconf} --without-ldap"

	cd ${S}/source
	./configure \
		--prefix=/usr \
		--bindir=/usr/sbin \
		--libdir=/etc/samba \
		--sbindir=/usr/sbin \
		--sysconfdir=/etc/samba \
		--localstatedir=/var/log \
		--with-configdir=/etc/samba \
		--with-mandir=/usr/share/man \
		--with-piddir=/var/run/samba \
		--with-swatdir=/usr/share/samba/swat \
		--with-lockdir=/var/cache/samba \
		--with-privatedir=/etc/samba/private \
		--with-codepagedir=/var/lib/samba/codepages \
		--with-libiconv \
		--with-sendfile-support \
		--without-sambabook \
		--with-automount \
		--without-spinlocks \
		--with-libsmbclient \
		--with-smbwrapper \
		--with-netatalk \
		--with-smbmount \
		--with-profile \
		--with-quotas \
		--with-syslog \
		--with-msdfs \
		--with-utmp \
		--with-vfs \
		--with-ads \
		--with-fhs \
		--with-krb5 \
		--host=${CHOST} ${myconf} || die "bad ./configure"
		#--with-winbind-ldap-hack

  # compile samba..
  emake proto
  emake all nsswitch/libnss_wins.so modules
  emake debug2html
  emake bin/smbspool
#	make all smbfilter smbwrapper smbcacls \
#		nsswitch nsswitch/libnss_wins.so debug2html
#	assert "samba compile problem"
  if use pam; then
    make pam_smbpass || die "pam_smbpass compile problem"
  fi

	# compile the bundled vfs modules..
#	cd ${S}/examples.bin/VFS
#	./configure \
#		--prefix=/usr \
#		--mandir=/usr/share/man || die "bad ./configure"
#	make || die "VFS modules compile problem"

	# compile mkntpasswd in examples/LDAP/ for smbldaptools..
#	if use ldap; then
#		cd ${S}/examples.bin/LDAP/smbldap-tools/mkntpwd
#		VISUAL="" make || die "mkntpwd compile problem"
#	fi

	# compile the selected antivirus vfs plugins..
#	if use oav; then
#		for i in ${VSCAN_MODS}
#		do
#			cd ${S}/examples.bin/VFS/$i && make
#			assert "problem building $i vscan module"
#		done
#	fi
}

src_install() {
	local i

	# we may as well do this all manually since it was starting
	# to get out of control and samba _does_ have some rather
	# silly installation quirks ;)  much of this was adapted
	# from mandrake's .spec file..
	#
	# // woodchip - 5 May 2002


	# install standard binary files..
	for i in nmblookup smbclient smbpasswd smbstatus testparm testprns \
		make_smbcodepage make_unicodemap make_printerdef rpcclient \
		smbspool smbcacls smbclient smbmount smbumount smbsh wbinfo
	do
		exeinto /usr/bin
		doexe source/bin/${i}
	done
	# make users lives easier..
	fperms 4755 /usr/bin/smbumount


	# libraries..
	exeinto /usr/lib
	doexe source/bin/smbwrapper.so
	doexe source/bin/libsmbclient.so
	insinto /usr/lib
	doins source/bin/libsmbclient.a
	exeinto /lib/security
	use pam && doexe source/bin/pam_smbpass.so
	doexe source/nsswitch/pam_winbind.so


	# vfs modules..
	exeinto /usr/lib/samba/vfs
	doexe examples.bin/VFS/audit.so
	doexe examples.bin/VFS/block/block.so
	doexe examples.bin/VFS/recycle/recycle.so
	use oav && doexe examples.bin/VFS/*/vscan-*.so


	# some utility scripts..
	for i in mksmbpasswd.sh smbtar convert_smbpasswd
	do
		exeinto /usr/bin
		doexe source/script/${i}
	done
	# and this handy one..
	doexe packaging/Mandrake/findsmb


	# secure binary files..
	for i in smbd nmbd swat smbfilter debug2html smbmnt smbcontrol winbindd
	do
		exeinto /usr/sbin
		doexe source/bin/${i}
	done
	# make users lives easier..
	fperms 4755 /usr/sbin/smbmnt


	# man pages..
	doman docs/manpages/*


	# codepage source files
	for i in 437 737 775 850 852 857 861 862 866 932 936 949 950 1125 1251
	do
		insinto /var/lib/samba/codepages/src
		doins source/codepages/codepage_def.${i}
	done
	for i in 437 737 775 850 852 857 861 862 866 932 936 949 950 1125 1251 \
		ISO8859-1 ISO8859-2 ISO8859-5 ISO8859-7 \
		ISO8859-9 ISO8859-13 ISO8859-15 KOI8-R KOI8-U
	do
		insinto /var/lib/samba/codepages/src
		doins source/codepages/CP${i}.TXT
	done


	# build codepage load files..
	for i in 437 737 775 850 852 857 861 862 866 932 936 949 950 1125 1251
	do
		${D}/usr/bin/make_smbcodepage c ${i} \
			${D}/var/lib/samba/codepages/src/codepage_def.${i} \
			${D}/var/lib/samba/codepages/codepage.${i}
	done


	# build unicode load files..
	for i in 437 737 775 850 852 857 861 862 866 932 936 949 950 1125 1251 \
		ISO8859-1 ISO8859-2 ISO8859-5 ISO8859-7 \
		ISO8859-9 ISO8859-13 ISO8859-15 KOI8-R KOI8-U
	do
		${D}/usr/bin/make_unicodemap ${i} \
			${D}/var/lib/samba/codepages/src/CP${i}.TXT \
			${D}/var/lib/samba/codepages/unicode_map.${i}
	done
	rm -rf ${D}/var/lib/samba/codepages/src


	# install the nsswitch library extension files..
	for i in wins winbind
	do
		exeinto /lib
		doexe source/nsswitch/libnss_${i}.so
	done
	# make link for wins and winbind resolvers..
	( cd ${D}/lib ; ln -s libnss_wins.so libnss_wins.so.2 )
	( cd ${D}/lib ; ln -s libnss_winbind.so libnss_winbind.so.2 )


	# install SWAT helper files..
	for i in swat/help/*.html docs/htmldocs/*.html
	do
		insinto /usr/share/swat/help
		doins ${i}
	done
	for i in swat/images/*.gif
	do
		insinto /usr/share/swat/images
		doins ${i}
	done
	for i in swat/include/*.html
	do
		insinto /usr/share/swat/include
		doins ${i}
	done


	# install the O'Reilly "Using Samba" book..
	for i in docs/htmldocs/using_samba/*.html
	do
		insinto /usr/share/swat/using_samba
		doins ${i}
	done
	for i in docs/htmldocs/using_samba/gifs/*.gif
	do
		insinto /usr/share/swat/using_samba/gifs
		doins ${i}
	done
	for i in docs/htmldocs/using_samba/figs/*.gif
	do
		insinto /usr/share/swat/using_samba/figs
		doins ${i}
	done


	# install the utilities from LDAP/smbldap-tools
	if use ldap; then
		exeinto /usr/share/samba/smbldap-tools
		doexe examples/LDAP/smbldap-tools/*.pl
		doexe examples/LDAP/smbldap-tools/smbldap_tools.pm
		doexe examples/LDAP/{import,export}_smbpasswd.pl
		chmod 0700 ${D}/usr/share/samba/smbldap-tools/{import,export}_smbpasswd.pl
		exeinto /usr/sbin
		doexe examples.bin/LDAP/smbldap-tools/mkntpwd/mkntpwd
		#dodir /usr/lib/perl5/site_perl/5.6.1
		eval `perl '-V:installarchlib'`
		dodir ${installarchlib}
		dosym /etc/samba/smbldap_conf.pm ${installarchlib}
		dosym /usr/share/samba/smbldap-tools/smbldap_tools.pm ${installarchlib}
	fi


	# we don't want two copies of the book or manpages
	rm -rf docs/htmldocs/using_samba docs/manpages
	# attempt to install all the docs as easily as possible :/
	dodoc COPYING Manifest README Roadmap WHATSNEW.txt
	docinto full_docs
	cp -a docs/* ${D}/usr/share/doc/${PF}/full_docs
	docinto examples
	cp -a examples/* ${D}/usr/share/doc/${PF}/examples
	prepalldocs
	# keep this next line *after* prepalldocs!
	dosym /usr/share/swat/using_samba /usr/share/doc/${PF}/using_samba
	# and we should unzip the html docs..
	gunzip ${D}/usr/share/doc/${PF}/full_docs/faq/*
	gunzip ${D}/usr/share/doc/${PF}/full_docs/htmldocs/*
	if use oav; then
		docinto vscan-modules
		cd ${WORKDIR}/${PN}-vscan-${VSCAN_VER}
		dodoc AUTHORS COPYING ChangeLog FAQ INSTALL NEWS README TODO
		for i in ${VSCAN_MODS}
		do
			docinto vscan-modules/$i
			dodoc $i/INSTALL
		done
	fi
	cd ${S} # hyaah; thems a lotta docs!


	# link /usr/bin/smbmount to /sbin/mount.smbfs which allows it
	# to work transparently with the standard 'mount' command..
	dodir /sbin
	dosym /usr/bin/smbmount /sbin/mount.smbfs


	# make the smb backend symlink for cups printing support..
	if use cups; then
		dodir /usr/lib/cups/backend
		dosym /usr/bin/smbspool /usr/lib/cups/backend/smb
	fi


	# make a symlink on /usr/lib/smbwrapper.so in /usr/sbin
	# to fix smbsh problem.  #6936
	dosym /usr/lib/smbwrapper.so /usr/sbin/smbwrapper.so


	# now the config files..
	insinto /etc
	doins ${FILESDIR}/nsswitch.conf-winbind
	doins ${FILESDIR}/nsswitch.conf-wins

	insinto /etc/samba
	doins ${FILESDIR}/smbusers
	doins ${FILESDIR}/smb.conf.example
	doins ${FILESDIR}/lmhosts
	doins ${FILESDIR}/recycle.conf
	if use ldap; then
		doins ${FILESDIR}/smbldap_conf.pm
		doins ${FILESDIR}/samba-slapd-include.conf
	fi

	insinto /etc/pam.d
	newins ${FILESDIR}/samba.pam samba
	doins ${FILESDIR}/system-auth-winbind

	exeinto /etc/init.d
	newexe ${FILESDIR}/samba-init samba
	newexe ${FILESDIR}/winbind-init winbind

	insinto /etc/xinetd.d
	newins ${FILESDIR}/swat.xinetd swat
}

pkg_postinst() {
	# touch /etc/samba/smb.conf so that people installing samba just
	# to mount smb shares don't get annoying warnings all the time..
	if [ ! -e ${ROOT}/etc/samba/smb.conf ] ; then
		touch ${ROOT}/etc/samba/smb.conf
	fi


	# empty dirs..
	install -m0700 -o root -g root -d ${ROOT}/etc/samba/private
	install -m1777 -o root -g root -d ${ROOT}/var/spool/samba
	install -m0755 -o root -g root -d ${ROOT}/var/log/samba
	install -m0755 -o root -g root -d ${ROOT}/var/run/samba
	install -m0755 -o root -g root -d ${ROOT}/var/cache/samba
	install -m0755 -o root -g root -d ${ROOT}/var/lib/samba/{netlogon,profiles}
	install -m0755 -o root -g root -d \
		${ROOT}/var/lib/samba/printers/{W32X86,WIN40,W32ALPHA,W32MIPS,W32PPC}
}
