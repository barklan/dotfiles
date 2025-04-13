FIX: Make theming more simple

- [x] Clean up all kitten @ load-config references in neovim
- [x] Clean up all kitten @ load-config references in fish
- [x] Don't run auto-theming in fish on neovim exit
- [ ] Make auto-theme (save/load) in neovim read `~/.cache/dev_theme` containing either `dark` or `light`. Hardcode themes based on that
- [ ] Make fish do the same as above
- [ ] Add `themetoggle` function to `config.fish` that toggles `dark`/`light`, writing to `~/.cache/.dev_theme`
