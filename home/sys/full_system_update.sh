#!/usr/bin/env bash

set -euo pipefail

echo -e "Updating system packages"
yay

echo -e "Updating fisher"
fish -c "fisher update" &

echo -e "Updating global npm packages"
npm update -g &

echo -e "Updating pipx packages"
http_proxy='' https_proxy='' pipx upgrade-all &

echo -e "Updating rustup toolchain"
rustup update &

echo "Waiting for jobs to complete"
wait

cargo install-update -a &
gore update &

echo "Waiting for jobs to complete"
wait

echo "------"
echo "All done. Restart system now!"

notify-send -u critical "Update finished, reboot!"
