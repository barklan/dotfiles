#!/usr/bin/env bash

set -euo pipefail
shopt -s dotglob

# Rename a `target` path to `target.backup` if the path
# exists and if it's a 'real' path, ie not a symlink.
backup() {
	target=$1
	if [[ -e "${target}" ]]; then
		if [[ ! -L "${target}" ]]; then
			mv "$target" "${target}.backup"
			echo "-----> Moved your old ${target} config path to ${target}.backup"
		fi
	fi
}

symlink() {
	file=$1
	link=$2
	if [ ! -e "${link}" ]; then
		echo "-----> Symlinking your new ${link}"
		ln -s "$file" "$link"
	fi
}

for path in ./config/*; do
	name=${path##*/}
	target="${HOME}/.config/${name}"
	backup "$target"
	symlink "${PWD}/config/${name}" "$target"
done

for path in ./home/*; do
	name=${path##*/}
	target="${HOME}/${name}"
	backup "$target"
	symlink "${PWD}/home/${name}" "$target"
done

echo "all done"
