pack-nvim:
    #!/usr/bin/env bash
    set -euxo pipefail
    tar -C ~/.local/share/nvim -I zstd -cpf lazy.tar.zst lazy

pre-commit-autoupdate:
    pre-commit autoupdate -c ./home/sys/lint.yml
