-- TODO: not recommended) Suppresses deprecation warnings. Disable once neovim stablizes.
vim.deprecate = function() end

-- vim.o.winborder = "none" -- NEW thing in neovim 0.11

vim.opt.showcmd = false -- Shows number of selected lines, etc.
function ToggleShowCmd()
    vim.opt.showcmd = not vim.opt.showcmd:get()
    local status = vim.opt.showcmd:get() and "ON" or "OFF"
    vim.notify("showcmd is now " .. status, vim.log.levels.INFO, { title = "Toggle ShowCmd" })
end

vim.keymap.set("n", "<leader>mc", ToggleShowCmd, { desc = "Toggle showcmd" })

vim.opt.confirm = true

-- vim.opt.fixendofline = true
vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.showtabline = 1
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.smoothscroll = true -- Not sure what this does
vim.opt.mousemoveevent = true
vim.opt.number = true -- Option is set as local on autocmd
vim.opt.relativenumber = false
vim.opt.swapfile = false -- fuck swap files
vim.opt.scrolloff = 6
vim.opt.smartindent = true
vim.o.timeout = true
vim.o.timeoutlen = 700 -- this is for jk escape (if mapped natively) and other repetitions like `xx`
vim.opt.signcolumn = "yes"
vim.o.numberwidth = 1
vim.o.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

vim.opt.jumpoptions = "stack" -- go back with <C-o> even if buffer has been closed

-- vim.opt.winborder = "single"
vim.opt.cmdheight = 1
vim.opt.showmode = false -- Dont show mode since we have a statusline
vim.opt.scroll = 15
vim.opt.mousescroll = "ver:5"

vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep --smart-case"

vim.opt.cursorline = true

-- To enable Cursor highlight
vim.opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor,t:block-blinkon500-blinkoff500-TermCursor"

vim.opt.spell = false
vim.opt.spelllang = "en_us,ru"

-- vim.opt.textwidth = 120 -- live the dream

vim.opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
vim.opt.updatetime = 500

vim.opt.laststatus = 0

vim.o.lazyredraw = false
vim.o.ttyfast = true

vim.diagnostic.config({
    underline = false,

    virtual_text = true,

    virtual_lines = false,

    signs = false,
    update_in_insert = false,
})

-- Don't display `~` at the end of buffer.
vim.opt.fillchars = { eob = " " }

if IsCMDLineEditor() == true or IsScrollbackPager() == true then
    vim.cmd([[
        set background=dark
        colorscheme tokyonight-night
    ]])
else
    --     vim.cmd([[
    --         " set background=light
    --         set background=dark
    --         colorscheme tokyonight-night
    --         " colorscheme github-monochrome-tokyonight
    --     ]])
    require("extra.autotheme").load_colorscheme()
end

local enable_dark_theme = function()
    vim.o.background = "dark"
    vim.cmd("colorscheme tokyonight-night")
end
vim.keymap.set("n", "<Leader><f4>", enable_dark_theme, { desc = "Dark theme" })

local enable_light_theme = function()
    vim.o.background = "light"
    vim.cmd("colorscheme vscode")
end
vim.keymap.set("n", "<Leader><f5>", enable_light_theme, { desc = "Light theme" })

local function cwd()
    local full_cwd = vim.fn.getcwd()
    local cwd_table = Split(full_cwd, "/")
    return cwd_table[#cwd_table]
end

-- Set window title.
vim.defer_fn(function()
    local title = cwd() .. [[\ -\ NVIM]]
    vim.cmd([[set title titlestring=]] .. title)
end, 20)

-- https://github.com/kovidgoyal/kitty/issues/108
vim.cmd([[
" vim hardcodes background color erase even if the terminfo file does
" not contain bce (not to mention that libvte based terminals
" incorrectly contain bce in their terminfo files). This causes
" incorrect background rendering when using a color theme with a
" background color.
let &t_ut=''
]])

-- vim.cmd([[
-- if has('gui_running') || has('nvim')
--     hi Normal 		guifg=#f6f3e8 guibg=#1a1b26
-- else
--     " Set the terminal default background and foreground colors, thereby
--     " improving performance by not needing to set these colors on empty cells.
--     hi Normal guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
--     let &t_ti = &t_ti . "\033]10;#f6f3e8\007\033]11;#242424\007"
--     let &t_te = &t_te . "\033]110\007\033]111\007"
-- endif
-- ]])

-- TODO: move somewhere else
vim.cmd("cabbrev g !git")
