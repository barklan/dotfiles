# WARN:
# `kitten @ load-config` leads to memory leaks, so this is used instead on kitty startup

import json
import os
from pathlib import Path


def get_background_value():
    config_path = (
        Path(os.environ["HOME"])
        / ".local"
        / "share"
        / "nvim"
        / "colorscheme_state.json"
    )

    try:
        with open(config_path, "r") as f:
            data = json.load(f)
            return data.get("background", "dark")  # Default to 'dark' if key missing
    except KeyError:
        return "dark"
    except FileNotFoundError:
        return "dark"
    except json.JSONDecodeError:
        return "dark"
    except Exception as e:
        return "dark"


if __name__ == "__main__":
    background = get_background_value()
    if background == "dark":
        print("include kitty_dark.conf")
    elif background == "light":
        print("include kitty_light.conf")
        print("env THEME_STYLE=light")
