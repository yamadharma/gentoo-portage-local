# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/colorator/colorator-0.1-r1.ebuild,v 1.3 2015/02/25 18:02:33 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Add linkblog features to your Jekyll site."
HOMEPAGE="https://github.com/octopress/linkblog"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "www-apps/octopress-hooks
	dev-ruby/titlecase"

ruby_add_bdepend "test? ( dev-ruby/bundler
	dev-ruby/clash
	dev-ruby/rake
	dev-ruby/pry-byebug )"
