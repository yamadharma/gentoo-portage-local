# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/jekyll-gist/jekyll-gist-1.1.0.ebuild,v 1.2 2014/11/21 11:01:48 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="README.markdown LICENSE"

inherit ruby-fakegem

DESCRIPTION="Provides the Import command for Jekyll"
HOMEPAGE="http://github.com/jekyll/jekyll-import"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=www-apps/jekyll-2
	dev-ruby/nokogiri
	dev-ruby/fastercsv"

ruby_add_bdepend ">=www-apps/jekyll-2 
	dev-ruby/rake
	dev-ruby/rdoc
	dev-ruby/activesupport
	dev-ruby/launchy
	dev-ruby/htmlentities
	dev-ruby/hpricot
	dev-ruby/pg
	"

