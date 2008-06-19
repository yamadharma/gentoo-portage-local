# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header

#
# Version: 0.11 (2008-06-06)
# Authors: Markus Dittrich <markusle@gentoo.org>
#
# The octave-forge eclass installs and manages the split
# octave-forge packages. In a nutshell, it does two things:
# 1) Compile (if necessary) and install individual octave-forge
#    packages
# 2) Add/Remove the octave-forge package and its description
#    from the database file in
#       /usr/share/octave/octave_packages
#    such that octave knows what octave-forge packages are
#    installed and what functionality they provide.
#
# The individual octave-forge packages should only need to inherit
# this eclass and possible have some additional dependencies and/or
# custom patches.
#

HOMEPAGE="http://octave.sourceforge.net"
SLOT="0"
LICENSE="GPL-2"

inherit eutils


EXPORT_FUNCTIONS src_unpack src_compile src_install pkg_postinst pkg_prerm

# unless requested otherwise we're happy with octave-3.0.0
NEED_OCTAVE=${NEED_OCTAVE:-3.0.0}

DEPEND="${DEPEND}
	>=sci-mathematics/octave-${NEED_OCTAVE}
	|| ( >=sys-apps/coreutils-6.10-r1 sys-apps/mktemp )"
RDEPEND="${RDEPEND}
	>=sci-mathematics/octave-${NEED_OCTAVE}"


#################################################################
# define global paths needed for the install
#################################################################
OCT_PKG=${P#octave-forge-}
OCT_PKG_TARBALL="${OCT_PKG}.tar.gz"
OCT_INSTALL_ROOT="/usr/share/octave"
OCT_INSTALL_PKG="${OCT_INSTALL_ROOT}/packages/${OCT_PKG}"
OCT_INSTALL_PATH="${OCT_INSTALL_ROOT}/packages"
OCT_BINARY=$(type -p octave)
OCT_DATABASE="${OCT_INSTALL_ROOT}/octave_packages"
OCT_DESC="${OCT_INSTALL_PKG}/packinfo/DESCRIPTION"
S="${WORKDIR}/${OCT_PKG}"


#################################################################
# extract package description from the DESCRIPTION file into
# a bash array so we can use it later to update the octave 
# database
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
# this function uses the DESCRIPTION file parsed into a bash
# array to update the octave package database via creating
# a temporary octave file and calling octave on it
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

	# path to parent of directory holding mex/oct files
	local libexec_dir="${OCT_INSTALL_PKG}"
	echo "new_package.archprefix = \"${libexec_dir}\";" \
		>> "${OCT_TMP}"

	for ((count=0; count < ${#keys[*]}; count++)); do
		# the depend string needs a separate struct
		if [[ ${keys[count]} == "depends" ]]; then
			echo "temp = struct(\"operator\",\"${operator}\",\"package\",\"${pkg_name}\",\"version\",\"${version}\");" >> "${OCT_TMP}"
			echo "foo = {temp};" >> "${OCT_TMP}"
			echo "new_package.depends = foo;" >> "${OCT_TMP}"
		elif [[ ${keys[count]} == "name" ]]; then
			echo "new_package.${keys[count]} = lower(\"${values[count]}\");" >> "${OCT_TMP}"
		else
			echo "new_package.${keys[count]} = \"${values[count]}\";" >> "${OCT_TMP}"
		fi
	done

	cat >> "${OCT_TMP}" <<-EOF
		new_package.dir = "${OCT_INSTALL_PKG}";
		global_packages = { global_packages{:}, new_package};
		save("${OCT_DATABASE}","global_packages");
	EOF

	# let octave do the final setup of the database file
	echo
	ebegin "Adding package to global octave database."
	"${OCT_BINARY}" -q "${OCT_TMP}" >& /dev/null
	eend $?
	echo

	# remove the temporary octave file
	rm -f "${OCT_TMP}" \
		|| die "Failed to remove temporary octave database code."
}


#################################################################
# this function removes an octave-forge package from the
# global octave package database
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
	cat >> "${OCT_TMP}" <<-EOF
		old_packages = load ("${OCT_DATABASE}").global_packages;
		global_packages = {};
		purge_name = lower("${remove_name}");
		for i=1:length(old_packages);
		if ( !strcmp(old_packages{i}.name,purge_name));
		global_packages = {global_packages{:}, old_packages{i}}; endif; endfor;
		save ("${OCT_DATABASE}","global_packages");
	EOF

	# let octave do the final setup of the database file
	echo
	ebegin "Removing from database"
	"${OCT_BINARY}" -q "${OCT_TMP}"  >& /dev/null
	eend $?
	echo

	# if the database file is empty we get rid of it completely
	# otherwise octave will be confused. To check if it is empty, 
	# we simply test if there are any author fields remaining.
	fgrep 'author' "${OCT_DATABASE}"  >& /dev/null
	if [[ $? == 1 ]]; then
		ebegin "Purging empty database"
		rm -f "${OCT_DATABASE}"
		eend $?
	fi
	echo

	# remove the temporary octave file
	rm -f "${OCT_TMP}" \
		|| die "Failed to remove temporary octave database code."
}


#################################################################
# since we use octave's package installed for compiling we need
# to provide the raw gzipped octave-forge source tarballs. 
# Hence, if there are no patches to apply, we simply copy the
# tarball to ${WORKDIR}. If there are patches we unpack
# the tarball in ${WORKDIR}, apply the patches, and repack it.
#################################################################
octave-forge_src_unpack() {
	cd "${WORKDIR}"

	if [[ -n "${PATCHES}" ]]; then
		unpack "${A}"
		pushd "${S}" >& /dev/null
		for patch in "${PATCHES}"; do
			epatch "${FILESDIR}/${patch}"
		done
		popd >& /dev/null
		tar czf "${OCT_PKG_TARBALL}" "${OCT_PKG}" \
			&& rm -fr "${OCT_PKG}" \
			|| die "Failed to recompress the source"
	else
		cp "${DISTDIR}/${OCT_PKG_TARBALL}" ./
	fi
}


####################################################################
# use octave's pkg add command to do the compilation 
####################################################################
octave-forge_src_compile() {
	cd "${WORKDIR}"

	# securely generate tmp file
	OCT_TMP=$(mktemp /tmp/octave-install.XXXXXXXXXX) || \
		die "Failed to generate temporary file."

	# generate octave code to remove relevant entry from
	# global file
	cat >> "${OCT_TMP}" <<-EOF
		pkg prefix "${WORKDIR}" "${WORKDIR}" 
		pkg install -verbose -local ${OCT_PKG_TARBALL}
	EOF

	# let octave do the final setup of the database file
	einfo "Compiling ${P}. Please be patient ...." 
	"${OCT_BINARY}" -q "${OCT_TMP}" || die "Failed to compile package"

	# remove the temporary octave file
	rm -f "${OCT_TMP}" \
		|| die "Failed to remove temporary octave database code."
}


####################################################################
# install the compiled files
####################################################################
octave-forge_src_install() {
	cd "${WORKDIR}"
	insinto ${OCT_INSTALL_PATH}
	doins -r ${OCT_PKG} || die "Failed to install files."

	# make .oct, .mex, *.so files executable
	# we don't die after the finds since chmod will complain
	# if there aren't any files to act on
	target="${D}"${OCT_INSTALL_PATH}/${OCT_PKG}
	find ${target} -type f -name "*.oct" -print0 \
		| xargs -0 chmod 0755 >& /dev/null
	find ${target} -type f -name "*.mex" -print0 \
		| xargs -0 chmod 0755 >& /dev/null
	find ${target} -type f -name "*.so" -print0 \
		| xargs -0 chmod 0755 >& /dev/null
}
	


##################################################################
# after installation, add package to global octave database
##################################################################
octave-forge_pkg_postinst() {
	add_pkg_to_database
}


##################################################################
# after unmerging, remove package from global octave database
##################################################################
octave-forge_pkg_prerm() {
	delete_pkg_from_database
}
