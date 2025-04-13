#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# System & Basic
sudo pacman -Syu --needed \
	hunspell hunspell-en_us hunspell-ru hunspell-de telegram-desktop \
	tor torsocks zip unzip unrar wl-clipboard gnome-keyring \
	cryfs gocryptfs \
	xdg-desktop-portal \
	xdg-desktop-portal-kde ffmpegthumbs p7zip keepassxc \
	bluez bluez-utils bluedevil mat2 plasma-systemmonitor \
	rclone electrum kdeplasma-addons plasma-browser-integration \
	firefox-developer-edition thunderbird \
    brotli \
	kcharselect yakuake fish fisher kgpg musl sqlite \
	xdg-desktop-portal-gtk wireguard-tools \
	aspell aspell-ru aspell-de usbguard sbctl efibootmgr libreoffice-fresh \
    spotify-launcher fastfetch neochat \
    tesseract-data-eng tesseract-data-rus tesseract \
    qalculate-qt python-gevent shadowsocks-rust python-pysocks \
    fprintd kitty linux-zen cliphist

yay -Syu --needed \
    qbittorrent-enhanced

# Fonts
sudo pacman -Syu --needed \
    ttf-roboto ttf-jetbrains-mono noto-fonts noto-fonts-emoji ttf-fira-code ttc-iosevka \
    ttf-nerd-fonts-symbols inter-font ttf-croscore ttf-opensans ttf-fira-sans ttf-anonymous-pro \
    otf-commit-mono-nerd

# Intel
sudo pacman -Syu --needed \
	vulkan-intel intel-media-sdk intel-media-driver intel-gpu-tools vpl-gpu-rt

sudo pacman -Syu --needed \
	systembus-notify earlyoom

# Dev
sudo pacman -Syu --needed \
	neovim \
	go rustup sccache cargo-outdated \
	protobuf pyenv nodejs npm typescript lua luajit luarocks llvm lld clang \
	docker docker-compose docker-buildx \
	alacritty bubblewrap git-lfs \
	graphviz python-pygments hugo \
	python-pipx python-pynvim gdb zellij bpf kompare \
    osv-scanner gitleaks

# Cli
sudo pacman -Syu --needed \
	fzf ripgrep ripgrep-all \
	fd bat plocate glow git-delta strace \
	tcpdump perf nmap glab github-cli \
	xh sd choose bottom pgcli kubectl just \
	watchexec eza dust duf gping peco grex tealdeer bandwhich \
	hyperfine hexyl chafa sad wireless_tools age zstd \
    mtr jaq lf sshfs ldns moreutils whois ngrep

yay -Syu --needed \
	pandoc-bin

# Media
sudo pacman -Syu --needed \
	inkscape krita blender \
	mpv mpv-mpris opencv mediainfo noise-suppression-for-voice \
	yt-dlp kdenlive libjxl qt5-imageformats qt6-imageformats kimageformats \
    libbluray libaacs

# LSP and linters
sudo pacman -Syu --needed \
	bash-language-server pyright \
	yaml-language-server typescript-language-server \
	lua-language-server stylua shfmt shellharden \
	python-lsp-server buf

rustup default stable
rustup component add rust-analyzer

# Multilib
# sudo pacman -Syu --needed wine wine-mono xf86-video-intel

yay -Syu --needed \
	visual-studio-code-bin postman-bin shellcheck-bin \
	hadolint-bin \
	upscayl-bin \
	nekoray sing-geosite sing-geoip

npm install -g \
	neovim @fsouza/prettierd markdownlint-cli \
	standard-version pnpm \
	vscode-langservers-extracted

pipx install black
pipx install codespell
pipx install flake8
pipx inject flake8 flake8-eradicate flake8-pytest-style
pipx install pydocstyle
pipx install mypy
pipx install curlylint
pipx install pdm
pipx install yamllint
pipx install ansible-lint
pipx install isort
pipx install pre-commit
pipx install basedpyright
pipx install pdfCropMargins
pipx install litecli
pipx install sqruff

cargo install cargo-update
cargo install killport
cargo install kalker
cargo install dotenv-linter

# This is `gore dump -l`
go install golang.org/x/perf/cmd/benchstat@latest
go install golang.org/x/tools/cmd/callgraph@latest
go install github.com/google/capslock/cmd/capslock@latest
go install github.com/tylertreat/comcast@latest
go install golang.org/x/tools/cmd/deadcode@latest
go install github.com/kevwan/depu@latest
go install github.com/barklan/dhsteal@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install golang.org/x/tools/go/analysis/passes/fieldalignment/cmd/fieldalignment@latest
go install github.com/davidrjenni/reftools/cmd/fillstruct@latest
go install github.com/davidrjenni/reftools/cmd/fillswitch@latest
go install mvdan.cc/garble@latest
go install github.com/onsi/ginkgo/v2/ginkgo@latest
go install github.com/yolo-pkgs/gitx@latest
go install github.com/abice/go-enum@latest
go install github.com/oligot/go-mod-upgrade@latest
go install github.com/ramya-rao-a/go-outline@latest
go install github.com/kisielk/godepgraph@latest
go install golang.org/x/tools/cmd/godoc@latest
go install mvdan.cc/gofumpt@latest
go install github.com/rogpeppe/gohack@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/segmentio/golines@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/abenz1267/gomvp@latest
go install golang.org/x/tools/cmd/gonew@latest
go install github.com/yolo-pkgs/goo@latest
go install github.com/haya14busa/goplay/cmd/goplay@latest
go install golang.org/x/tools/gopls@latest
go install github.com/yolo-pkgs/gore@latest
go install golang.org/x/tools/cmd/gorename@latest
go install github.com/cweill/gotests/gotests@latest
go install gotest.tools/gotestsum@latest
go install golang.org/x/vuln/cmd/govulncheck@latest
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
go install github.com/umlx5h/gtrash@latest
go install golang.org/x/tools/cmd/guru@latest
go install github.com/davecheney/httpstat@latest
go install github.com/koron/iferr@latest
go install github.com/josharian/impl@latest
go install github.com/tmc/json-to-struct@latest
go install github.com/golang-migrate/migrate/v4/cmd/migrate@latest
go install go.uber.org/mock/mockgen@latest
go install go.uber.org/nilaway/cmd/nilaway@latest
go install golang.org/x/pkgsite/cmd/pkgsite@latest
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
go install github.com/kyoh86/richgo@latest
go install github.com/stern/stern@latest
go install github.com/swaggo/swag/cmd/swag@latest
go install github.com/yolo-pkgs/test-dev-pkg@latest
go install github.com/open-telemetry/opentelemetry-collector-contrib/tracegen@latest
go install github.com/google/wire/cmd/wire@latest
go install github.com/bombsimon/wsl/v4/cmd/wsl@latest
