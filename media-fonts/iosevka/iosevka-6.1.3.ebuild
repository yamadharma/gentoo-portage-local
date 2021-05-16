# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

S="${WORKDIR}"
MY_PV=${PV//_alpha/-alpha.}
MY_PV=${PV//_beta/-beta.}
inherit font

DESCRIPTION="Open source coding font"
HOMEPAGE="http://be5invis.github.io/Iosevka "
BASE_SRC_URI="https://github.com/be5invis/Iosevka/releases/download"
SRC_URI="
	super-ttc? (
		${BASE_SRC_URI}/v${MY_PV}/super-ttc-${PN}-${MY_PV}.zip
		iosevka_shape_curly? (
			${BASE_SRC_URI}/v${MY_PV}/super-ttc-${PN}-curly-${MY_PV}.zip
			iosevka_shape_slab? (
				${BASE_SRC_URI}/v${MY_PV}/super-ttc-${PN}-curly-slab-${MY_PV}.zip
			)
		)
		iosevka_shape_slab? (
			${BASE_SRC_URI}/v${MY_PV}/super-ttc-${PN}-slab-${MY_PV}.zip
		)
		quasi-prop? (
			${BASE_SRC_URI}/v${MY_PV}/super-ttc-${PN}-aile-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/super-ttc-${PN}-etoile-${MY_PV}.zip
		)
	)
	ttc? (
		${BASE_SRC_URI}/v${MY_PV}/ttc-${PN}-${MY_PV}.zip
		iosevka_shape_curly? (
			${BASE_SRC_URI}/v${MY_PV}/ttc-${PN}-curly-${MY_PV}.zip
			iosevka_shape_slab? (
				${BASE_SRC_URI}/v${MY_PV}/ttc-${PN}-curly-slab-${MY_PV}.zip
			)
		)
		iosevka_shape_slab? (
			${BASE_SRC_URI}/v${MY_PV}/ttc-${PN}-slab-${MY_PV}.zip
		)
		quasi-prop? (
			${BASE_SRC_URI}/v${MY_PV}/ttc-${PN}-aile-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/ttc-${PN}-etoile-${MY_PV}.zip
		)
	)
	!ttc? (
		${BASE_SRC_URI}/v${MY_PV}/ttf-${PN}-${MY_PV}.zip
		iosevka_shape_slab? (
			${BASE_SRC_URI}/v${MY_PV}/ttf-${PN}-slab-${MY_PV}.zip
		)
		iosevka_spacing_term? (
			${BASE_SRC_URI}/v${MY_PV}/ttf-${PN}-term-${MY_PV}.zip
			iosevka_shape_slab? (
				${BASE_SRC_URI}/v${MY_PV}/ttf-${PN}-term-slab-${MY_PV}.zip
			)
		)
		iosevka_spacing_term-lig? (
			${BASE_SRC_URI}/v${MY_PV}/ttf-${PN}-term-lig-${MY_PV}.zip
			iosevka_shape_slab? (
				${BASE_SRC_URI}/v${MY_PV}/ttf-${PN}-term-lig-slab-${MY_PV}.zip
			)
		)
		iosevka_spacing_type? (
			${BASE_SRC_URI}/v${MY_PV}/ttf-${PN}-type-${MY_PV}.zip
			iosevka_shape_slab? (
				${BASE_SRC_URI}/v${MY_PV}/ttf-${PN}-type-slab-${MY_PV}.zip
			)
		)
	)
	iosevka_shape_curly? (
		${BASE_SRC_URI}/v${MY_PV}/ttf-${PN}-curly-${MY_PV}.zip
		iosevka_shape_slab? (
			${BASE_SRC_URI}/v${MY_PV}/ttf-${PN}-curly-slab-${MY_PV}.zip
		)
		iosevka_spacing_term? (
			${BASE_SRC_URI}/v${MY_PV}/ttf-${PN}-term-curly-${MY_PV}.zip
			iosevka_shape_slab? (
				${BASE_SRC_URI}/v${MY_PV}/ttf-${PN}-term-curly-slab-${MY_PV}.zip
			)
		)
		iosevka_spacing_term-lig? (
			${BASE_SRC_URI}/v${MY_PV}/ttf-${PN}-term-lig-curly-${MY_PV}.zip
			iosevka_shape_slab? (
				${BASE_SRC_URI}/v${MY_PV}/ttf-${PN}-term-lig-curly-slab-${MY_PV}.zip
			)
		)
		iosevka_spacing_type? (
			${BASE_SRC_URI}/v${MY_PV}/ttf-${PN}-type-curly-${MY_PV}.zip
			iosevka_shape_slab? (
				${BASE_SRC_URI}/v${MY_PV}/ttf-${PN}-type-curly-slab-${MY_PV}.zip
			)
		)
	)
	quasi-prop? (
		${BASE_SRC_URI}/v${MY_PV}/${PN}-aile-${MY_PV}.zip
		${BASE_SRC_URI}/v${MY_PV}/${PN}-etoile-${MY_PV}.zip
	)
	ss? (
		${BASE_SRC_URI}/v${MY_PV}/${PN}-ss01-${MY_PV}.zip
		${BASE_SRC_URI}/v${MY_PV}/${PN}-ss02-${MY_PV}.zip
		${BASE_SRC_URI}/v${MY_PV}/${PN}-ss03-${MY_PV}.zip
		${BASE_SRC_URI}/v${MY_PV}/${PN}-ss04-${MY_PV}.zip
		${BASE_SRC_URI}/v${MY_PV}/${PN}-ss05-${MY_PV}.zip
		${BASE_SRC_URI}/v${MY_PV}/${PN}-ss06-${MY_PV}.zip
		${BASE_SRC_URI}/v${MY_PV}/${PN}-ss07-${MY_PV}.zip
		${BASE_SRC_URI}/v${MY_PV}/${PN}-ss08-${MY_PV}.zip
		${BASE_SRC_URI}/v${MY_PV}/${PN}-ss09-${MY_PV}.zip
		${BASE_SRC_URI}/v${MY_PV}/${PN}-ss10-${MY_PV}.zip
		${BASE_SRC_URI}/v${MY_PV}/${PN}-ss11-${MY_PV}.zip
		${BASE_SRC_URI}/v${MY_PV}/${PN}-ss12-${MY_PV}.zip
		iosevka_spacing_term? (
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-ss01-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-ss02-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-ss03-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-ss04-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-ss05-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-ss06-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-ss07-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-ss08-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-ss09-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-ss10-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-ss11-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-ss12-${MY_PV}.zip
		)
		iosevka_spacing_term-lig? (
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-lig-ss01-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-lig-ss02-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-lig-ss03-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-lig-ss04-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-lig-ss05-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-lig-ss06-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-lig-ss07-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-lig-ss08-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-lig-ss09-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-lig-ss10-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-lig-ss11-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-term-lig-ss12-${MY_PV}.zip
		)
		iosevka_spacing_type? (
			${BASE_SRC_URI}/v${MY_PV}/${PN}-type-ss01-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-type-ss02-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-type-ss03-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-type-ss04-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-type-ss05-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-type-ss06-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-type-ss07-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-type-ss08-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-type-ss09-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-type-ss10-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-type-ss11-${MY_PV}.zip
			${BASE_SRC_URI}/v${MY_PV}/${PN}-type-ss12-${MY_PV}.zip
		)
	)
"

LICENSE="OFL-1.1"
SLOT="0"
# KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="iosevka_shape_curly iosevka_shape_slab iosevka_spacing_term iosevka_spacing_term-lig iosevka_spacing_type quasi-prop ss ttc super-ttc web"
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND=""

FONT_S="${S}/ttf"
FONT_SUFFIX="ttf"

src_install() {
	font_src_install
	use web && (
		insinto /usr/share/webfonts/"${PN}"
		doins -r "${S}"/woff{,2}/*
		# TODO: webfont.css
	)
}
