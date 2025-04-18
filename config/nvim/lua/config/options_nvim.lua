-- TODO: not recommended) Suppresses deprecation warnings. Disable once neovim stablizes.
vim.deprecate = function() end

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal,options"
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
vim.opt.mousescroll = "ver:3"

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
