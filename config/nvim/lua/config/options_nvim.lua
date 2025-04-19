-- TODO: not recommended) Suppresses deprecation warnings. Disable once neovim stablizes.
vim.deprecate = function() end

-- vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,terminal"
vim.o.sessionoptions = "buffers,curdir,winsize"

-- vim.o.winborder = "none" -- NEW thing in neovim 0.11

vim.o.showcmd = false -- Shows number of selected lines, etc.
function ToggleShowCmd()
    vim.o.showcmd = not vim.o.showcmd
    local status = vim.o.showcmd and "ON" or "OFF"
    vim.notify("showcmd is now " .. status, vim.log.levels.INFO, { title = "Toggle ShowCmd" })
end

vim.keymap.set("n", "<leader>mc", ToggleShowCmd, { desc = "Toggle showcmd" })

vim.o.confirm = true

-- vim.opt.fixendofline = true
vim.o.autowrite = true
vim.o.autowriteall = true
vim.o.autoread = true
vim.o.hidden = true
vim.o.showtabline = 1
vim.o.wrap = true
vim.o.linebreak = true
vim.o.termguicolors = true
vim.o.mouse = "a"
vim.o.smoothscroll = true -- Not sure what this does
vim.o.mousemoveevent = true
vim.o.number = true
vim.o.relativenumber = false
vim.o.swapfile = false -- fuck swap files
vim.o.scrolloff = 6
vim.o.smartindent = true
vim.o.timeout = true
vim.o.timeoutlen = 700 -- this is for jk escape (if mapped natively) and other repetitions like `xx`
vim.o.signcolumn = "yes"
vim.o.numberwidth = 1
vim.o.writebackup = false -- if a file is being edited by another program, it is not allowed to be edited
vim.o.jumpoptions = "stack" -- go back with <C-o> even if buffer has been closed
vim.o.cmdheight = 1
vim.o.showmode = false -- Dont show mode since we have a statusline
vim.o.mousescroll = "ver:3"

vim.o.grepformat = "%f:%l:%c:%m"
vim.o.grepprg = "rg --vimgrep --smart-case"

vim.o.cursorline = true

-- To enable Cursor highlight
vim.o.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor,t:block-blinkon500-blinkoff500-TermCursor"

vim.o.spell = false
vim.o.spelllang = "en_us,ru"

-- vim.opt.textwidth = 120 -- live the dream
vim.o.undofile = true
vim.o.updatetime = 500 -- interval for writing swap file to disk, also used by gitsigns
vim.o.laststatus = 0
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

require("extra.autotheme").load_colorscheme()
require("extra.decolor").golang()
local bg = vim.o.background
if bg == "light" then
    vim.api.nvim_set_hl(0, "@string", { link = "String", force = true }) -- This is for vscode light theme
    vim.api.nvim_set_hl(0, "@comment", { link = "Comment", force = true }) -- This is for vscode light theme
elseif bg == "dark" then
    vim.api.nvim_set_hl(0, "@string", { link = "String", italic = false, force = true }) -- This is for tokyonight night theme
    vim.api.nvim_set_hl(0, "@keyword", { link = "Statement", italic = false, force = true }) -- This is for tokyonight night theme
end

local function cwd()
    local full_cwd = vim.fn.getcwd()
    local cwd_table = Split(full_cwd, "/")
    return cwd_table[#cwd_table]
end

-- Set window title.
vim.defer_fn(function()
    local title = "NVIM"
    if IsCMDLineEditor() then
        title = "CMDLINE_EDITOR"
    else
        title = cwd() .. [[\ -\ NVIM]]
    end

    vim.cmd([[set title titlestring=]] .. title)
end, 20)
