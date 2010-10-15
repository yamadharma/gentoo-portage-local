# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MODULE_AUTHOR=IBB
inherit perl-module

DESCRIPTION="'Unbless' Perl objects."

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

SRC_TEST="do"

COMMON="dev-lang/perl"
RDEPEND="${COMMON}"
DEPEND="${COMMON}"
