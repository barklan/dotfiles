vim.api.nvim_create_augroup("nvim_auto_core", { clear = true })

local function augroup(name)
    return vim.api.nvim_create_augroup("personal_" .. name, { clear = true })
end

if ShouldEnableNeotree() then
    require("config.auto.neotree_auto")
end

require("config.auto.limit_buffers")
require("config.auto.git_auto")

-- Abbreviations for Go.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.cmd("abclear <buffer>")

        vim.cmd("inoreabbrev <buffer> ;e err")
        vim.cmd("inoreabbrev <buffer> ;s string")
        vim.cmd("inoreabbrev <buffer> ;i int64")
        vim.cmd("inoreabbrev <buffer> ;a :=")
        vim.cmd("inoreabbrev <buffer> ;c ctx")
    end,
})

local auto_kitty_font = function()
    local bg = vim.o.background
    if bg == "light" then
        vim.api.nvim_set_hl(0, "@string", { link = "String", force = true }) -- This is for vscode light theme
        vim.api.nvim_set_hl(0, "@comment", { link = "Comment", force = true }) -- This is for vscode light theme
        vim.fn.system("kitten @ load-config ~/.config/kitty/light.conf")
    elseif bg == "dark" then
        vim.api.nvim_set_hl(0, "@string", { link = "String", italic = false, force = true }) -- This is for tokyonight night theme
        vim.fn.system("kitten @ load-config ~/.config/kitty/kitty.conf")
    end
end

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = augroup("save_colorscheme"),
    pattern = { "*" },
    callback = function()
        require("extra.autotheme").save_colorscheme()
        require("extra.decolor").golang()

        vim.defer_fn(function()
            auto_kitty_font()
        end, 0)
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup("colorscheme_kitty_on_enter"),
    once = true,
    callback = function()
        require("extra.decolor").golang()
        vim.defer_fn(function()
            auto_kitty_font()
        end, 0)
    end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    group = augroup("autospell"),
    pattern = { "gitcommit" },
    callback = function()
        vim.opt_local.spell = true
    end,
})

vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    group = "nvim_auto_core",
    pattern = { "*:no*" },
    callback = function()
        vim.opt.relativenumber = true
    end,
})

vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    group = "nvim_auto_core",
    pattern = { "no*:*" },
    callback = function()
        vim.opt.relativenumber = false
    end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "WinLeave", "BufEnter" }, {
    group = augroup("checktime"),
    pattern = "*",
    callback = function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
        end
    end,
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    group = "nvim_auto_core",
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Full-width quickfix window
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.cmd("wincmd J") -- Move quickfix to bottom (full-width)
        vim.wo.winfixheight = true -- Lock height (optional)
    end,
})
