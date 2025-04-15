# dotfiles

## Backup

1. Run `sudo total-backup`.
2. Backup firefox files:
   - bookmarks
   - logins
   - uBlock backup
   - Violentmonkey

## Installing

- Enable full-disk encryption, don't add swap

## Configure system

- Restore `.ssh` and `.gnupg`. Restore files that belong to `/etc`.
- Reload again (for tcp bbr kernel module to load).
- Apply `sudo sysctl --system`.
- [Increase commit interval](https://wiki.archlinux.org/title/Ext4#Increasing_commit_interval) for ext4.
- [Enable fast commit](https://wiki.archlinux.org/title/Ext4#Enabling_fast_commit_in_existing_filesystems) for main ext4 partition.
- Walk through all KDE settings:
  - 200ms for key hold delay
  - Make Caps Lock an extra Ctrl

## Packages

Install packages:

```bash
bash packages.sh
```

From fish shell:

```fish
fisher install barklan/extra-fzf.fish
fisher install PatrickF1/fzf.fish
fisher install jorgebucaran/autopair.fish
fisher install wfxr/forgit
fisher install barklan/enter-docker-fzf
```

Configure applications:

```bash
sudo systemctl enable docker.service
#sudo systemctl enable containerd.service  # Probably not needed
sudo groupadd docker
sudo usermod -aG docker $USER

sudo systemctl enable --now bluetooth
sudo systemctl enable --now paccache.timer
sudo systemctl enable --now fstrim.timer
sudo systemctl enable --now earlyoom
```

Install dotfiles:

```bash
bash install.sh
```

Make sure this file is executable: `~/.config/plasma-workspace/env/envs.sh`

Pyenv:

```bash
# Visit pyenv github page and follow instructions for your shell.
pyenv install --list
pyenv install <version>
# pyenv global <version>
```

## VS Code

Notable extensions:

- Error lens
- Git Graph
- Go
- Material icon theme
- TODO tree
- Tokyo night
- VSCode neovim
- Dev Containers
- rust-analyzer

## Fonts

KDE: Inter display / CommitMono
Firefox: Inter / CommitMono

## Keyboard all the way

- `Ctrl + J` for activate task manager entry 1
- `Meta + M` to maximize window
- `Alt + V` to Klipper at mouse position
- `Meta + P` to Play/Pause
- `Meta + [` to Play Prev
- `Meta + ]` to Play Next
- `Meta + S` to open Spectacle
- `Prt Sc` to take full screenshot
- `Meta + R` to record screen

## KDE Plasma

Remove title bar and borders on maximized windows:

https://discuss.kde.org/t/hide-titlebars-of-maximised-windows/1162

Might be outdated:

```bash
kwriteconfig5 --file ~/.config/kwinrc --group Windows --key BorderlessMaximizedWindows true
qdbus org.kde.KWin /KWin reconfigure
```

## Wireguard

Place wireguard config as `wg0.conf` in `/etc/wireguard` - network manager will do the rest.
Make sure that network manager dispatcher script is executable.

Set `DNS = 1.1.1.1` in `wg0.conf` and in your WIFI settings.

Add:

```bash
nmcli connection import type wireguard file wg0.conf
nmcli connection modify wg0 autoconnect no
```

Make `51-wg0...` in NetworkManager executable and copy it to `/etc/NetworkManager/dispatcher.d`

Delete:

```bash
nmcli connection delete wg0
```

## Shadowsocks

Create config:

```bash
sudo nvim /etc/shadowsocks-rust/xefi.json
```

```json
{
  "local_port": 1080,
  "servers": [
    {
      "address": "...",
      "port": 9000,
      "method": "chacha20-ietf-poly1305",
      "password": "...",
      "fast_open": true,
      "tcp_weight": 0.7,
      "udp_weight": 0.7
    },
    {
      "address": "...",
      "port": 9000,
      "method": "chacha20-ietf-poly1305",
      "password": "...",
      "fast_open": true,
      "tcp_weight": 1.0,
      "udp_weight": 1.0
    },
    {
      "address": "...",
      "port": 9000,
      "method": "chacha20-ietf-poly1305",
      "password": "...",
      "fast_open": true,
      "tcp_weight": 0.5,
      "udp_weight": 0.5
    },
    {
      "address": "...",
      "port": 9000,
      "method": "chacha20-ietf-poly1305",
      "password": "...",
      "fast_open": true,
      "tcp_weight": 0.5,
      "udp_weight": 0.5
    }
  ],
  "runtime": {
    "mode": "multi_thread",
    "worker_count": 16
  },
  "no_delay": true
}
```

Enable service:

```bash
sudo systemctl enable --now shadowsocks-rust@xefi.service
```

## Disable swap

To prevent auto activation of swap, look for the swap systemd units using `systemctl --type swap`. For each `*.swap` unit found mask it using `systemctl mask <unit_name>`.

## systemd-resolved

```bash
sudo pacman -Syu systemd-resolvconf
sudo systemctl enable --now systemd-resolved.service
```

And configure:

<https://wiki.archlinux.org/title/Systemd-resolved>

## systemd-resolved cloudflare

```bash
sudo nvim /etc/systemd/resolved.conf
```

```txt
[Resolve]
DNS=1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com
DNSOverTLS=yes
DNSSEC=yes
```

## AMD64-v3/v4 repos

<https://somegit.dev/ALHP/ALHP.GO>

If you have troubles with gpg keys, you can download the key manually from here:

<https://somegit.dev/ALHP/alhp-keyring/src/branch/master/alhp.gpg>

and import it:

```bash
gpg --import ./alhp.gpg
```

or this

```bash
sudo bash -c 'rm -r /etc/pacman.d/gnupg/ && pacman-key --init && pacman-key --populate'
```

if nothing helps add to repos this:

```txt
SigLevel = Optional TrustAll
```

## Disabling KDE wallet

In `~/.config/kwalletrc` add

```txt
Enabled=false
```

## systemd-boot

```bash
sudo nvim /efi/loader/loader.conf
```

use this:

```txt
default *-zen*
timeout 1
```

## Kernel parameters

```bash
sudo nvim /etc/kernel/cmdline
```

Add `quiet splash loglevel=3 audit=0 zswap.enabled=0` parameters and run

```bash
sudo reinstall-kernels
```

## zram

<https://wiki.archlinux.org/title/Zram>

```txt
[zram0]
zram-size = 8192
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
```

## Early KMS for Intel graphics

```bash
sudo nvim /etc/dracut.conf.d/myflags.conf
```

```txt
force_drivers+=" i915 "
```

```bash
sudo dracut-rebuild

# NOTE: this might not work with luks for some reason. Just use `sudo pacman -Syu linux-zen`
sudo reinstall-kernels
```

## usbguard

from root:

```bash
sudo bash -c 'usbguard generate-policy > /etc/usbguard/rules.conf'
```

```bash
sudo systemctl enable --now usbguard.service
```

## firewalld

Change default zone to "drop". To stop firewall-applet from autostart:

```bash
sudo nvim /etc/xdg/autostart/firewall-applet.desktop
```

Comment out the exec line and then:

```bash
sudo chattr +i /etc/xdg/autostart/name-of-desktop.desktop
```

Change +i to -i to reverse.

## pam-duress

Follow instructions at:

[https://github.com/nuvious/pam-duress]

## Auth configuration

```bash
sudo nvim /etc/security/faillock.conf
```

## Add git hook to dotfiles repo

```bash
ln -s ~/sys/hooks/pre-commit .git/hooks/pre-commit
```

## Kitty goodies

To see available fonts (to update fonts run `fc-cache -fv ~/.local/share/fonts`):

```bash
kitten choose-fonts
```

To hide window decorations (for gnome especially):

```txt
hide_window_decorations yes
```

## Management of dotfiles themselves

```bash
pre-commit autoupdate -c ./home/sys/lint.yml
```

## Fonts shit

Enable stem darkening:

```bash
# Set in /etc/environment
FREETYPE_PROPERTIES="cff:no-stem-darkening=0 cff:darkening-parameters=500,350,1000,25,1667,0,2000,0 autofitter:no-stem-darkening=0 autofitter:darkening-parameters=500,350,1000,25,1667,0,2000,0"
```

more in docs https://freetype.org/freetype2/docs/reference/ft2-properties.html#no-stem-darkening
