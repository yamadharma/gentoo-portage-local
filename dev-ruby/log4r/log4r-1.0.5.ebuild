# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/log4r/log4r-1.0.5.ebuild,v 1.5 2006/09/29 06:40:46 wormo Exp $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="Log4r is a comprehensive and flexible logging library written in
Ruby for use in Ruby programs."
HOMEPAGE="http://log4r.sourceforge.net/"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc x86"
DEPENDS="=dev-lang/ruby-1.8*"
