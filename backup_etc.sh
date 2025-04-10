#!/usr/bin/env bash

set -euo pipefail

etc_dir="${PWD}/etc/"
mkdir -p "${etc_dir}tor"

cp -r /etc/modules-load.d "${etc_dir}"
cp -r /etc/sysctl.d "${etc_dir}"

cp /etc/environment "${etc_dir}environment"
cp /etc/tor/torrc "${etc_dir}tor/torrc"

cp /etc/NetworkManager/dispatcher.d/51-wg0.sh "${etc_dir}NetworkManager/dispatcher.d/51-wg0.sh"
