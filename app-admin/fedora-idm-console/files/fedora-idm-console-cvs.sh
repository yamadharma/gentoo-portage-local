#!/bin/bash

DATE=`date +%Y%m%d`
CVSTAG=HEAD
VERSION=1.1.0
PKGNAME=fedora-idm-console
export CVSROOT=:pserver:anonymous@cvs.fedora.redhat.com:/cvs/dirsec

cvs -d "$CVSROOT" -z3 export -r$CVSTAG -d $PKGNAME-$VERSION-pre$DATE fedora-idm-console

tar -cjf $PKGNAME-$VERSION-pre$DATE.tar.bz2 $PKGNAME-$VERSION-pre$DATE

rm -rf $PKGNAME-$VERSION-pre$DATE
