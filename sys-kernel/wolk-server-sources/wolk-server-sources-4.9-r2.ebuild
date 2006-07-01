# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="build"

# OKV=original kernel version, KV=patched kernel version.  They can be the same.

ETYPE="sources"

inherit kernel || die

OKV=2.4.20
EXTRAVERSION=-wolk${PV}s
KV=${OKV}${EXTRAVERSION}
S=${WORKDIR}/linux-${KV}
DESCRIPTION="Working Overloaded Linux Kernel"
SRC_URI="mirror://sourceforge/wolk/linux-2.4.20-wolk4.6-fullkernel.tar.bz2
	mirror://sourceforge/wolk/linux-2.4.20-wolk4.6s-to-4.7s.patch.bz2
	mirror://sourceforge/wolk/linux-2.4.20-wolk4.7s-to-4.8s.patch.bz2
	mirror://sourceforge/wolk/linux-2.4.20-wolk4.8s-to-4.9s.patch.bz2
	mirror://sourceforge/wolk/linux-2.4.20-wolk4.9s-to-4.9s-NEWIDE.patch.bz2"
KEYWORDS="~x86"
SLOT="${KV}"
HOMEPAGE="http://wolk.sourceforge.net http://www.kernel.org"

src_unpack () 
{
    unpack linux-2.4.20-wolk4.6-fullkernel.tar.bz2
#   mv linux-${OKV} linux-${KV} || die
    mv linux-2.4.20-wolk4.6-fullkernel linux-${KV} || die
    cd ${S}
    #
    epatch ${DISTDIR}/linux-2.4.20-wolk4.6s-to-4.7s.patch.bz2           
    epatch ${DISTDIR}/linux-2.4.20-wolk4.7s-to-4.8s.patch.bz2           
    epatch ${DISTDIR}/linux-2.4.20-wolk4.8s-to-4.9s.patch.bz2           
    epatch ${DISTDIR}/linux-2.4.20-wolk4.9s-to-4.9s-NEWIDE.patch.bz2
    
    echo "KV=${KV}" >/tmp/KV
}

src_install () 
{
    dodir /usr/src
    echo ">>> Copying sources..."
    mv ${WORKDIR}/linux* ${D}/usr/src
}

pkg_postinst () 
{
    einfo
    einfo   "If you use Nvidia modules, you will need to use the supplied"
    einfo   "rmap patch in /usr/src/linux-2.4.20-wolk4.0s-pre10/userspace-patches"
    einfo   "against your nvidia kernel driver source"
    einfo   "cd NVIDIA_kernel-1.0-XXXX " 
    einfo	"patch -p1 </usr/src/linux-2.4.20-wolk4.0s-pre10/userspace-patches/"
    einfo   "NVIDIA_kernel-1.0-4191-2.4-rmap15b.patch"                
    einfo   "This patch works fine with NVIDIA_kernel-1.0-3123 also"
    einfo
}

# Local Variables:
# mode: sh
# End:

