# Cheatsheet

## Neovim

## Forgotten builtin keymaps

In normal mode:

- `gi` - Drop into insert mode at last inserted position
- `gv` - Select previous selection

In selection mode:

- `o` to jump to different ends of selection

## Commands

### :g

```txt
:g/one\|two/     : list lines containing "one" or "two"
:g/^\s*$/d       : delete all blank lines
:g/green/d       : delete all lines containing "green"
:v/green/d       : delete all lines not containing "green"
:g/one/,/two/d   : not line based
:v/./.,/./-1join : compress empty lines
```

Command `:g/^/` matches every line.

### :norm

Select lines and

```txt
:norm I foo      : Prepend all selected lines with "foo".
:%norm! @a       : Execute the macro stored in register a on all lines.
```

### :sort

Sorts selected lines.

### Global search and replace

1. Populate quickfix with fzf picker
2. In quickfix:

```txt
:cfdo %s/<something>/<other>/c
```

Note that `:cfdo` will do command on every **file** present in quickfix, while `:cdo` will do it on every **entry**.

### External commands

Select lines and

```txt
:!jaq .             # format them with jaq
:%!jaq              # or entire buffer
```

## Fish shell specific

```fish
set -l temp "samira"    # set variable
echo $temp
```

### Control flow

#### IF

```fish
if test 5 -gt 2
    echo "Yes, 5 is greater than 2"
end
```

#### and/or

```fish
set -q XDG_CONFIG_HOME; and set -l configdir $XDG_CONFIG_HOME
or set -l configdir ~/.config
```

#### Loops

`break` and `continue` are available.

```fish
for i in (seq 1 5)
    echo $i
end
```

```fish
for f in *{1,2,3}000.png
    file $f
end
```

```fish
while read -l line
    echo line: $line
end < file.txt
```

#### Error handling

There are 3 options as of now. See [issue](https://github.com/fish-shell/fish-shell/issues/510) for more info.

```fish
git sast; or return
echo "hi"
```

```fish
git sast; and echo "hi"
```

```fish
git sast
if test $status != 0
    echo "exit status not 0"
    return
end

echo hi
```

### Builtins

```fish
basename main.py .py                        # main
count *.py                                  # 1
path basename ./foo.mp4                     # foo.mp4
path dirname /usr/bin/                      # /usr
path extension ./foo.mp4                    # .mp4
path normalize /usr/bin//../../etc/fish     # /etc/fish
path resolve main.py                        # /home/barklan/main.py
math 1+1                                    # 2
```

### `test`

https://fishshell.com/docs/current/cmds/test.html

```fish
if test -f main.py
    bat main.py
end
```

Operators on numbers: `-eq; -ne; -gt; -ge; -lt; -le`

#### Operators to combine expressions

- `COND1 -a COND2` - Returns true if both COND1 and COND2 are true.
- `COND1 -o COND2` - Returns true if either COND1 or COND2 are true.

```fish
set -l temp samira
which python

if test $status = 0 -a $temp = samira
    echo "hi there"
else
    echo fucker
```

### `string`

```fish
string length 'hello, world'                            # 12
string lower 'TEST'                                     # test
string match -r 'cat|dog|fish' 'nice dog'               # dog
string match -r '(\d\d?):(\d\d):(\d\d)' 2:34:56         # 2:34:56 \n 2 \n 34 \n 56
echo foo | string repeat -n 2                           # foofoo
string replace is was 'blue is my favorite'             # blue was my favorite
string replace -a ' ' _ 'spaces to underscores'         # spaces_to_underscores
string replace -r '(\w+)\s+(\w+)' '$2 $1' 'left right'  # right left
string split . example.com                              # example \n com
string sub -s 2 -l 2 abcde                              # bc
string trim ' abc  '                                    # abc
```

## Tools

### System info

```fish
lscpu
lspci                           # PCI devices
lsscsi                          # SCI devices
free -h                         # RAM
sudo dmidecode -t memory        # More RAM
sudo dmidecode -t bios          # Bios info
uname -a                        # Kernel info
zramctl                         # Zram info
```

### Session info

```fish
id          # Find user ID and group ID
w
who -b      # Boot time
uptime
groups
users
last
```

### Filesystem

```fish
lsblk               # Disk info
sudo fdisk -l       # Filesystem info
lsusb               # USB devices
df -h               # Filesystem stats

mktemp              # Create temp file
mktemp -d           # Create temp directory
dust                # Show file tree sorted by size
```

### Diagnostic

```fish
sudo strace -Yyy -p 185021                   # Attach and view
sudo strace -o out.txt -Yyy ping -c 1 google.com  # Launch and dump
sudo strace -e open -o out.txt cmd               # Track specific syscall
sudp strace -f -e trace=network -- go run main.go # Follow forks and trace network

ps aux | peco                               # Interactive filtering
sudo lsof                                   # See open files
sudo lsfd                                   # Modern replacement for lsof
```

### Network

```bash
ifconfig -a                             # Network interfaces, deprecated in favour of ip command
ip link show                            # Network interfaces
ip route list                           # IP routes
iwconfig                                # More info about wireless interfaces

gping google.com                        # Better ping
drill google.com                        # DNS
resolvectl status                       # To check the DNS currently in use by systemd-resolved
mtr google.com                          # Better traceroute alternative
nmap google.com                         # See open ports, https://wiki.archlinux.org/title/Nmap
nmap -A -sT scanme.nmap.org             # Open ports and TCP connect
sudo netstat -tulpn                     # See open ports locally
sudo tcpdump -i wlan0 | peco            # Interactive filtering
tcpdump -A port 8080 -i any
httpstat google.com
sudo bandwhich                          # Interactive traffic

ngrep port 53                           # Grep for network packages

sudo dhclient                           # Obtain a fresh IP from the DHCP server
arp -a                                  # Show arp cache
hostname                                # Show hostname
hostname -i                             # System IP
```

### Core

```fish
cat
tac
echo 'Linuxize' | tr '[:lower:]' '[:upper:]'            # LINUXIZE
echo "my phone is 123-456-7890" | tr -cd '[:digit:]'    # Remove all non-numeric chars
echo $PATH | tr  ':' '\n'
cut -c 4-10 file.txt                                    # Show 4-10 chars from each line
paste -d ' ' -s file.txt                                # Join lines of file with separator ' '
expand file.txt                                         # convert tabs to spaces
wc -l                                                   # number of lines
wc -w                                                   # number of words
uniq -u                                                 # Get unique values
sort -u                                                 # Delete duplicates
sort -g                                                 # General numeric sort
printf "var1: %s\tvar2: %s\n" "$VAR1" "$VAR2"
```

### `sd` and `choose`

```fish
sd '(\w+)' '$1$1' file.txt                  # Replace in place.
sd -F 'before' 'after' file.txt             # Replace in place, -F to disable regex.
choose 5                                    # Print the 5th item from a line (zero indexed)
choose -1                                   # Print the last item from a line
```

### `rg`

```fish
cat ddl.sql | \
rg 'grant ' | \
rg -o 'to (\w+);' -r '$1' | \
sort | \
uniq | \
parallel -j 1 echo "create user {}\;"
```

### moreutils

```fish
rg --passthru 'blue' -r 'red' ip.txt > tmp.txt && mv tmp.txt ip.txt

rg --passthru 'blue' -r 'red' ip.txt | sponge ip.txt    # soak up all stdin and write to file
```

### `xargs` and `parallel`

https://www.gnu.org/software/parallel/parallel_examples.html

```fish
ls |xargs -n1 wc -l
parallel -u ::: 'cmd1' 'cmd2'                      # Launch several commands
parallel --tag --bar ::: 'cmd1' 'cmd2'             # Launch several commands, separate output
seq 32 | parallel -j 32 -u -n0 'cmd'               # Launch several instances of one command
parallel 'flac -d -c {} | opusenc --bitrate 96 - {.}.opus' ::: *.flac
```

You can make a script be interpreted by parallel:

```bash {linenos=inline}
#!/usr/bin/env -S parallel --shebang --ungroup --jobs 8
echo task 1 start; sleep 3; echo task 1 done
echo task 2 start; sleep 3; echo task 2 done
echo task 3 start; sleep 3; echo task 3 done
echo task 4 start; sleep 3; echo task 4 done
```

### Compress & Encrypt

```fish
tar -cpvf data.tar /path/to/directory                           # Tar.
zstd data.tar                                                   # Compress
age -o data.tar.zst.age -r a1ql3z7hjy data.tar.zst              # Encrypt. -r <SSH public key>

tar -cpv directory | zstd | age -o data.tar.zst.age -R key.pub  # Oneliner

tar -cpv directory | zstd --ultra -22 -o directory.tar.zst      # Max compression

# Faster way and ask for password
tar -I zstd -cpf - ./dir1 ./dir2 | age -o data.tar.zst.age -p

age -d -i ~/.ssh/private data.tar.zst.age > data.tar.zst        # Decrypt.
unzstd data.tar.zst                                             # Decompress
tar -xvf data.tar                                               # Untar
```

Instructions for the unintiated on MacOS:

```fish
brew install zstd
brew install age
age -d -i ~/.ssh/private data.tar.zst.age | zstd -d | tar -xvf -
```

### Misc

```fish
uuidgen             # Generate UUID
uuidparse <uuid>    # Parse UUID
base64              # Encode
base64 -d           # Decode
zbarimg img.png     # Scan QR code

timedatectl                 # Get system time info
timedatectl list-timezones  # List available timezones
sudo timedatectl set-timezone Europe/Moscow     # Set timezone

split -b 10G myimage.jpg myimage_part   # Split file
cat myimage_part* > newimage.jpg        # Join file
```

### GRPC

```fish
protoc --go_out=. --go_opt=paths=source_relative \
--go-grpc_out=. --go-grpc_opt=paths=source_relative \
proto/v1/service.proto
```

### Frontend stuff

```fish
chromium --disable-web-security --user-data-dir="/tmp/chrome_dev_test"        # Launch without CORS check
chromium --proxy-server="socks5://127.0.0.1:9050"                             # Chrome with TOR proxy
```

### Working with JSON

```fish
python -m json.tool <temp.json              # Prettify json
jaq <temp.json                              # Prettify json

jaq '.[].api_details.amount?' <temp.json
```

### Docker

```fish
docker run --rm -it archlinux
docker network create --attachable traefik-public
docker system prune -a
```

Most pointless docker command ever:

```fish
docker run -ti
    --privileged
    --net=host --pid=host --ipc=host
    --volume /:/host
    busybox
    chroot /host
```

### k8s

```fish
tsh login --proxy=access.example.com:443 --auth=local --user=temp  # Connect to teleport proxy server
tsh kube login development                                         # Connect to teleport cluster

kubectl logs -n temp service/temp-app-service                      # Logs from service
kubectl logs -n temp app-5b5b666964-4wrsw                          # Logs from specific pod
stern -n temp deployment/app                                       # Tail logs from temp namespace from specific deployment
kubectl describe pod -n temp temp-app-79f54976dc-zcbbr             # Describe pod
watch kubectl top pod app-7c4f4cf56d-r65q9 -n temp --containers    # Cpu & mem
kubectl port-forward service/app-service -n temp 5000:5000         # Port forward
kubectl  get pods -n temp                                          # List pods of namespace
kubectl -n temp edit configmap app-configmap                       # Edit configmap
```

## Git

### Stash

To abort stash pop with conflicts
(will discard any staged changes; stash contents won't be lost and can be re-applied later):

```fish
git reset --merge
```

To save a stash without modifying working tree:

```fish
git stash store "$(git stash create)"
```

### Rebase

```fish
git rebase -i @~5                           # Rebase 5 commits starting from HEAD
git rebase -v --autostash -i origin/main    # Rebase with stash beforehand

git rebase -X theirs -i origin/main         # If conflict, choose our changes
git rebase -X ours -i origin/main           # If conflict, choose origin/main changes
```

### Simple history delete

```fish
git checkout --orphan latest_branch
git add -A
git commit -am "init"
git branch -D main
git branch -m main
git push -f origin main
```

#### Splitting commits

To split most recent commit:

```fish
git reset @~
```

To split 3 commits back:

```fish
git rebase -i @~3
```

When you get the rebase edit screen, find the commit you want to break apart.
At the beginning of that line, replace pick with edit (e for short).
Then do `git reset @~`, do the work and `git rebase --continue`.

### Git misc

```fish
git cherry-pick -n <commit-hash>            # cherry-pick without committing

git update-index --assume-unchanged file.txt        # Don't track changes in file
git update-index --no-assume-unchanged file.txt     # Track changes in file

git lfs install
git lfs track "*.zst"
```

## Fish Keybindings

Default:

- `Ctrl+r` - command history (use `ctrl+r` and `ctrl+s` to go forward/backward page)
- `Alt+h` - Show man page
- `Alt+e` - Edit cmdline buffer
- `Alt+l` - List the contents of the current directory
- `Alt+s` - prepends `sudo` to the current commandline. If the commandline is empty, prepend `sudo` to the last commandline
- `Ctrl+x` - copies the current buffer to the system’s clipboard. `Ctrl+v` to paste.
- `Ctrl+c` - cancels the entire line
- `Alt+Enter` - inserts a newline at the cursor position
- `Ctrl+p`, `Ctrl+n` - cycle through history
- `Alt+.` - recall individual arguments, starting from the last argument in the last executed line

Emacs mode:

- `Ctrl+a`, `Ctrl+e`, `Alt+f`, `Alt+b`, `Ctrl+f`, `Ctrl+b` - navigation
- `Ctrl+h`, `Ctrl+d`, `Ctrl+w` (`Alt+Backspace`), `Alt+d`, `Ctrl+u`, `Ctrl+k` - deletion
- `Alt+u` - uppercase the current (or following) word
- `Alt+t` - transposes the last two words
- `Ctrl+z` - undo the most recent edit of the line
- `Alt+/` - reverts the most recent undo

## Databases

```fish
sqlite3 -header -csv my_db.db "select * from my_table;" > out.csv
```

## More misc

```fish
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
docker exec -it ollama ollama run codellama

# OCR pdf
docker run --rm -v "$(pwd):/data" -w /data -i ocr:local --force-ocr -l "$1" "/data/$2" "/data/ocr_$2"

ssh -NL 5432:127.0.0.1:5432 <host>       # ssh using remote port forwarding to remote postgres

# Download youtube video in best quality
yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' -S vcodec:av1 $argv[1]

# Extract audio from file
ffmpeg -i <file> -vn -acodec copy output-audio.aac

# Compress video with qsv
ffmpeg -hwaccel vaapi -hwaccel_output_format vaapi -i $argv[1] -vaapi_device /dev/dri/renderD128 -vf 'hwmap=derive_device=qsv,format=qsv,scale_qsv=w=2560:h=1600' -c:v hevc_qsv -c:a copy -global_quality 25 -preset slow -loglevel warning -stats $argv[2]

# Compress video with vaapi
ffmpeg -hwaccel vaapi -hwaccel_output_format vaapi -threads 16 -i $argv[1] -vaapi_device /dev/dri/renderD128 -c:v hevc_vaapi -c:a copy -vf format='nv12|vaapi,hwupload' -qp 40 -preset ultrafast -loglevel warning -stats $filename
```

Fish function to convert all images in folder to avif:

```fish
for f in *.png *.jpg
    set -f base (string split -r -m 1 -f 1 . $f)
    avifenc -j all --ignore-exif --ignore-xmp -- $f "$base".avif
end
```

## Just

TODO: needs update

```txt
set shell := ["bash", "-uc"]
set dotenv-load
set unstable

# https://just.systems/man/en/chapter_30.html
home_dir := env_var('HOME')

python_dir := if os_family() == "windows" { "./.venv/Scripts" } else { "./.venv/bin" }
python := python_dir + if os_family() == "windows" { "/python.exe" } else { "/python3" }
system_python := if os_family() == "windows" { "py.exe -3.9" } else { "python3.9" }

# These recipes will be run when invoking `just` with no arguments.
default: lint build test

# Set up development environment
bootstrap:
    if test ! -e .venv; then {{ system_python }} -m venv .venv; fi
    {{ python }} -m pip install --upgrade pip wheel pip-tools
    {{ python_dir }}/pip-sync

# Recipe with two arguments
build target tests=default:
    @echo 'Building {{target}}…'
    cd {{target}} && make

# Recipe with dependant recipe with defined argument
push target: (build target)
    @echo 'Pushing {{target}}…'

# Recipe with variadic argument (0 or more)
script *ARGS:
    {{ python }} script.py {{ ARGS }}

# Recipe with variadic argument (1 or more)
backup +FILES:
    scp {{FILES}} me@server.com:

# Recipe with argument that will be exported as environment variable
foo $bar:
    echo $bar

# Multiline recipe that uses bash
foo:
    #!/usr/bin/env bash
    set -euxo pipefail
    echo "Hello from Bash!"

# This is a private recipe.
[private]
a:
  echo 'A!'

# Order of execution: a -> b -> c -> d
b: a && c d
  echo 'B!'

c:
  echo 'C!'

d:
  echo 'D!'

```
