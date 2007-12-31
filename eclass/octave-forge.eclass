# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header 

# Version: 0.05 (2007-10-20)
# Authors: Markus Dittrich <markusle@gentoo.org>

HOMEPAGE="http://octave.sourceforge.net"
SLOT="0"
LICENSE="GPL-2"

EXPORT_FUNCTIONS src_compile src_install pkg_postinst pkg_prerm

# unless requested otherwise we're happy with 
# octave-2.9.15 and newer
NEED_OCTAVE=${NEED_OCTAVE:-2.9.15}

DEPEND="${DEPEND}
	>=sci-mathematics/octave-${NEED_OCTAVE}
	sys-apps/mktemp"
RDEPEND="${RDEPEND}
	>=sci-mathematics/octave-${NEED_OCTAVE}"


#################################################################
# define global paths needed for the install
#################################################################
OCT_PKG=${P#octave-forge-}
OCT_PKG_NAME=${PN#octave-forge-}
S="${WORKDIR}/${OCT_PKG}"
OCT_INSTALL_ROOT=/usr/share/octave
OCT_INSTALL_PKG="${OCT_INSTALL_ROOT}/packages/${OCT_PKG}"
OCT_BINARY=$(type -p octave)
OCT_DATABASE="${OCT_INSTALL_ROOT}/octave_packages"
OCT_DESC="${OCT_INSTALL_PKG}/packinfo/DESCRIPTION"
OCT_DESC_SRC="${S}/DESCRIPTION"


################################################################
# generate the architecture dependend install directory name
################################################################
octave_getarch() {
	local host_type="$(octave-config -p CANONICAL_HOST_TYPE)";
	eval $1="${host_type}-$(octave-config -p API_VERSION)";
}


#################################################################
# determine if autoload is requested
#################################################################
check_autoload() {
	local answer="$(fgrep -i 'autoload' "${OCT_DESC_SRC}"  | cut -d' ' -f2)"
	if [[  "${answer}" == "yes" \
		|| "${answer}" == "true" \
		|| "${answer}" == "0" \
		|| "${answer}" == "1" ]]; then
			eval $1="${answer}"
	fi
}

#################################################################
# extract package description from the DESCRIPTION file for
# updating the database
#################################################################
get_description()
{
	local count=0
	local tracker=0
	local line
	while read line
	do
		if [[ "${line}" == *:* ]]; then
			keys[${count}]=$(echo "${line}" | cut -f1 -d: | sed -e "s: $::g" | gawk '{ print tolower($1)}')
			values[${count}]=$(echo "${line}" | cut -f2 -d: | sed -e "s:^ ::g")
			if [[ ${keys[count]} == "depends" ]]; then
				tracker=${count}
			fi

			(( count++ ))
	  	fi
	done < "${OCT_DESC}" 	

	# further separate depend string 
	local depend_value=${values[tracker]}
	depend_value=${depend_value/\(/}
	depend_value=${depend_value/\)/}
	pkg_name=$(echo ${depend_value} | cut -d' ' -f1)
	operator=$(echo ${depend_value} | cut -d' ' -f2)
	version=$(echo ${depend_value} | cut -d' ' -f3)
}


################################################################
# metaprogram to generate octave code to add package
# to global database
################################################################
add_pkg_to_database()
{
	# read properties from DESCRIPTION file
	declare -a keys
	declare -a values
	get_description 

	# securely generate tmp file
	OCT_TMP=$(mktemp generate-database.XXXXXXXXXX) \
		|| die "Failed to generate temporary file."

	if [ -e "${OCT_DATABASE}" ]; then
		echo "global_packages = load (\"${OCT_DATABASE}\").global_packages;" >> "${OCT_TMP}"
	else
		echo "global_packages = {};" >> "${OCT_TMP}"
	fi
	
	echo "new_package = struct();" >> "${OCT_TMP}"

	# add archprefix; needed for >=octave-2.9.15
	local libexec_dir="$(octave-config -p LIBEXECDIR)/octave/packages"

	echo "new_package.archprefix = \"${libexec_dir}\";" \
		>> "${OCT_TMP}"
	
	for ((count=0; count < ${#keys[*]}; count++)); do
		# the depend string needs a separate struct
		if [[ ${keys[count]} == "depends" ]]; then
			echo "temp = struct(\"operator\",\"${operator}\",\"package\",\"${pkg_name}\",\"version\",\"${version}\");" >> "${OCT_TMP}"
			echo "foo = {temp};" >> "${OCT_TMP}"
			echo "new_package.depends = foo;" >> "${OCT_TMP}"
		else
			echo "new_package.${keys[count]} = \"${values[count]}\";" >> "${OCT_TMP}"
		fi
	done

	cat >> "${OCT_TMP}" <<EOF
new_package.dir = "${OCT_INSTALL_PKG}";
global_packages = { global_packages{:}, new_package};
save("${OCT_DATABASE}","global_packages");
EOF

	# let octave do the final setup of the database file
	echo
	ebegin "Adding package to global octave database."
	"${OCT_BINARY}" -q "${OCT_TMP}" >& /dev/null
	eend $?
	echo;

	# remove the superfluous generation file
	rm -f "${OCT_TMP}" \
		|| die "Failed to remove temporary octave database code."
}


#################################################################
# metaprogram to generate octave code to remove package
# to global database
#################################################################
delete_pkg_from_database()
{
	# read properties from DESCRIPTION file
	declare -a keys
	declare -a values
	get_description 

	local remove_name
	for ((count=0; count < ${#keys[*]}; count++)); do
		if [[ ${keys[count]} == "name" ]]; then
			remove_name=${values[count]}
		fi
	done

	# securely generate tmp file
	OCT_TMP=$(mktemp /tmp/generate-database.XXXXXXXXXX) || \
		die "Failed to generate temporary file."

	# generate octave code to remove relevant entry from 
	# global file
	cat >> "${OCT_TMP}" <<EOF
old_packages = load ("${OCT_DATABASE}").global_packages; 
global_packages = {};
for i=1:length(old_packages);
if ( !strcmp(old_packages{i}.name,"${remove_name}"));
global_packages = {global_packages{:}, old_packages{i}}; endif; endfor;
save ("${OCT_DATABASE}","global_packages");
EOF

	
	# let octave do the final setup of the database file
	echo
	ebegin "Removing from database"
	"${OCT_BINARY}" -q "${OCT_TMP}"  >& /dev/null
	eend $?

	# if the database file is empty we get rid of it completely
	# otherwise octave will be confused
	fgrep 'author' "${OCT_DATABASE}"  >& /dev/null
	if [[ $? == 1 ]]; then
		ebegin "Purging empty database"
		rm -f "${OCT_DATABASE}" 
		eend $?
	fi
	echo

	# remove the superfluous generation file
	rm -f "${OCT_TMP}" \
		|| die "Failed to remove temporary octave database code."
} 


octave-forge_src_compile() {
	cd "${S}"

	# check for configure/makefile since not all octave-forge 
	# packages have one
	if [[ -e src/configure ]]; then
		pushd . && cd src/ 
		econf || die "configure failed in src"
		popd
	fi
	
	if [[ -e src/Makefile ]]; then
		pushd . && cd src/
		emake -j1 || die "make failed in src"
		popd
	fi

	# we need to check if there are any examples 
	# to build as well
	if [[ -e examples/configure ]]; then
		pushd . && cd examples/
		econf || die "configure failed in examples"
		popd
	fi

	if [[ -e examples/Makefile ]]; then
		pushd . && cd examples/
		emake -j1 || die "make failed in examples"
		popd
	fi
}


octave-forge_src_install() {
	cd "${S}"

	# get arch string
	local octave_arch=""
	octave_getarch octave_arch

	# copy *.m, *.mex, *.oct files in src to their
	# appropriate destinations
	m_files=$(find ./src -type f -name "*.m" -print0 2> /dev/null)
	oct_files=$(find ./src -type f -name "*.oct" -print0 2> /dev/null)
	mex_files=$(find ./src -type f -name "*.mex" -print0 2> /dev/null)
	insinto "${OCT_INSTALL_PKG}"
	if [[ -n "${m_files}" ]]; then
		doins src/*.m \
			|| die "failed to install m files"
	fi

	# install mex/oct files if present
	if [[ -n "${oct_files}" || -n "${mex_files}" ]]; then
		insinto "${OCT_INSTALL_PKG}/${octave_arch}"
		if [[ -n "${oct_files}" ]]; then
			doins src/*.oct \
				|| die "failed to install oct files"
		fi
		if [[ -n "${mex_files}" ]]; then
			doins src/*.mex \
				|| die "failed to install mex files"
		fi
	fi
	
	# include PKG_ADD and PKG_DEL
	# TODO: need to scan included *.m *.cc files for
	# additional PKG_ADD/PKG_DEL commands for appending
	if [[ -e "${S}/PKG_ADD" ]]; then
		doins "${S}/PKG_ADD" \
			|| die "failed to install PKG_ADD"
	fi
	if [[ -e "${S}/PKG_DEL" ]]; then
		doins "${S}/PKG_DEL" \
			|| die "failed to install PKG_ADD"
	fi

	# copy files in inst if they exits
	if [[ -d "${S}"/inst ]]; then
		insinto "${OCT_INSTALL_PKG}"
		doins inst/* \
			|| die "failed to install inst/"
	fi

	# check for on_uninstall.m and install if present
	local uninstall_file=$(find ${S} -name 'on_uninstall.m')
	if [[ -n "${uninstall_file}" ]]; then
		doins "${uninstall_file}" \
			|| die "failed to install on_uninstall.m"
	fi

	# copy files in packinfo
	insinto "${OCT_INSTALL_PKG}"/packinfo
	doins COPYING DESCRIPTION \
		|| die "failed to install packinfo files"

	if [[ -e "Changelog" ]]; then
		doins Changelog \
			|| die "failed to install Changelog"
	fi

	local want_autoload=""
	check_autoload want_autoload
	if [[ -n "${want_autoload}" ]]; then
		touch ${T}/.autoload && doins ${T}/.autoload \
			|| die "failed to install autoload"
	fi

	# check for index file
	# TODO: need to generate index file in case it is missing
	local index_file=$(find ${S} -name 'INDEX')
	if [ -n "${index_file}" ]; then
		doins "${index_file}" \
			|| die "failed to install INDEX"
	else
		echo 'generating index file'
		#generate_index_file()
	fi

	# check for doc directory and install if present
	if [[ -d "${S}"/doc ]]; then
		insinto "${OCT_INSTALL_PKG}"/doc
		doins doc/* \
			|| die "failed to install docs"
	fi

	# check for bin directory and install contents if present
	if [[ -d "${S}"/bin ]]; then
		insinto "${OCT_INSTALL_PKG}"/bin
		doins bin/* \
			|| die "failed to install bin"
	fi

	# check for examples to be installed
	if [[ -d "${S}"/examples ]]; then
		insinto "${OCT_INSTALL_PKG}"/examples
		doins examples/*.m examples/*.oct examples/README \
			|| die "failed to install example files"
	fi
}

octave-forge_pkg_postinst() {
	add_pkg_to_database
}

octave-forge_pkg_prerm() {
	delete_pkg_from_database
}
