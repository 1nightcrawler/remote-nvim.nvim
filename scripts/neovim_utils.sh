#!/usr/bin/env bash

# Compare neovim versions
# Returns 0 if version1 < version2, 1 if version1 >= version2
function compare_versions {
	local version1=${1#v}
	local version2=${2#v}

	# Special cases for 'stable' and 'nightly': They are not lesser than any specific version
	if [[ $version1 == "stable" ]] || [[ $version1 == "nightly" ]]; then
		# If version1 is 'stable' or 'nightly', it is not lesser than any specific version
		return 1
	fi

	# Split version numbers into arrays
	IFS='.' read -r -a ver1 <<<"$version1"
	IFS='.' read -r -a ver2 <<<"$version2"

	# Compare each part of the version numbers
	for ((i = 0; i < ${#ver1[@]}; i++)); do
		if [[ -z ${ver2[i]} ]]; then
			# If version2 has fewer parts and the current part of version1 is greater than zero
			if ((ver1[i] > 0)); then
				return 1
			fi
		elif ((ver1[i] > ver2[i])); then
			return 1
		elif ((ver1[i] < ver2[i])); then
			return 0
		fi
	done

	# If version2 has more parts and they are greater than zero
	for ((i = ${#ver1[@]}; i < ${#ver2[@]}; i++)); do
		if ((ver2[i] > 0)); then
			return 0
		fi
	done

	return 1
}
