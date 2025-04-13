# Neovim Cheatsheet

### Useful builtin keymaps

In normal mode:

- `gi` - Drop into insert mode at last inserted position
- `gv` - Select previous selection
- `ZZ` - Save and close
- `ZQ` - Close without saving

In selection mode:

- `o` to jump to different ends of selection

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
:norm I foo
```

Prepend all selected lines with "foo".

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

