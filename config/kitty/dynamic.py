# WARN:
# `kitten @ load-config` leads to memory leaks, so this is used instead on kitty startup

import os
from pathlib import Path


def get_background_value():
    config_path = Path(os.environ["HOME"]) / ".cache" / "theme_style"

    try:
        with open(config_path, "r") as f:
            data = f.read().strip()
            if data == "dark" or data == "light":
                return data
            else:
                return "dark"
    except Exception as e:
        return "dark"


if __name__ == "__main__":
    background = get_background_value()
    if background == "dark":
        print("include kitty_dark.conf")
    elif background == "light":
        print("include kitty_light.conf")
