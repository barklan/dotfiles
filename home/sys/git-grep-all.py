#!/usr/bin/env python3

import subprocess
import sys

if __name__ == "__main__":
    args = " ".join(sys.argv[1:])
    args_quoted = "'" + args + "'"
    cmd = f"git log -G{args_quoted} -p --branches --all"
    subprocess.call(cmd, shell=True)
