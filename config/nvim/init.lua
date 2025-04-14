vim.loader.enable()

vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

require("config.globals_preload")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
    install = {
        -- install missing plugins on startup.
        missing = false,
    },
    concurrency = 10,
    git = {
        cooldown = 60,
    },
    checker = {
        enabled = false,
    },
    change_detection = {
        enabled = false,
        notify = false,
    },
    performance = {
        cache = {
            enabled = true,
        },
        reset_packpath = true,
        rtp = {
            reset = true,
            disabled_plugins = {
                "gzip",
                -- "netrwPlugin", # Need it enabled for spellcheck.
                "rplugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

NotifySend = vim.schedule_wrap(function(msg)
    require("plenary.job")
        :new({
            command = "notify-send",
            args = { "-a", "nvim", msg },
            cwd = vim.fn.getcwd(),
        })
        :start()
end)

if IsOilEditor() and NotVSCode() then
    require("oil").setup()
end

require("config.globals")

require("config.options_shared")
if InVSCode() then
    require("config.options_vscode")
else
    require("config.options_nvim")
end

require("config.keymaps_shared")
if InVSCode() then
    require("config.keymaps_vscode")
else
    require("config.keymaps_nvim")
    require("config.keymaps_nvim_go")
    require("config.keymaps_nvim_ru")
    require("config.keymaps_nvim_kitty")
end

require("config.autocmds_shared")
if not InVSCode() then
    require("config.autocmds_nvim")
    require("config.lsp_shim").setup()

    -- NOTE: This is for terminal emulators only.
    vim.keymap.set("i", "<C-H>", "<C-W>", { silent = true })

    require("config.commands")
end
