return {
    {
        -- NOTE: this plugin auto-fetches
        "abccsss/nvim-gitstatus",
        cond = NotVSCode,
        lazy = true,
        event = "VeryLazy",
        config = true,
    },
    {
        "nvim-lualine/lualine.nvim",
        cond = function()
            if InVSCode() then
                return false
            end

            return true
        end,
        lazy = true,
        event = "VeryLazy",
        config = function()
            local function diff_source()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                    return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed,
                    }
                end
            end

            local function cwd()
                local full_cwd = vim.fn.getcwd()
                local cwd_table = Split(full_cwd, "/")
                return cwd_table[#cwd_table]
            end

            local function oil_buffer_name()
                local dir = require("oil").get_current_dir(vim.b.integer)
                if dir then
                    return vim.fn.fnamemodify(dir, ":~")
                else
                    -- If there is no current directory (e.g. over ssh), just show the buffer name
                    return vim.api.nvim_buf_get_name(0)
                end
            end

            local function oil_buffer_warning()
                -- if vim.bo.filetype == "oil" then
                return "OIL: " .. oil_buffer_name()
                -- end

                -- return ""
            end

            local function is_oil_buffer()
                if vim.bo.filetype == "oil" then
                    return true
                end

                return false
            end

            require("lualine").setup({
                options = {
                    theme = "auto", -- rosepine-dawn?
                    globalstatus = true,
                    icons_enabled = true,
                    component_separators = { left = "", right = " " },
                    section_separators = { left = "", right = " " },
                },
                extensions = {
                    "neo-tree",
                    "quickfix",
                    "lazy",
                },
                sections = {
                    lualine_a = {
                        {
                            cwd,
                        },
                    },
                    lualine_b = {
                        {
                            "b:gitsigns_head",
                            fmt = function(name, _)
                                if name == "" then
                                    return name
                                else
                                    return " " .. name
                                end
                            end,
                            -- padding = {
                            --     right = 1,
                            --     left = 1,
                            -- },
                        },
                        -- {
                        --     "gitstatus",
                        --     sections = {
                        --         { "branch", format = " {}" },
                        --         { "is_dirty", format = "*" },
                        --     },
                        --     sep = "",
                        -- },
                        {
                            "gitstatus",
                            sections = {
                                { "ahead", format = "{}↑" },
                                { "behind", format = "{}↓" },
                                { "conflicted", format = "{}!" },
                                { "staged", format = "{}=" },
                                { "untracked", format = "{}+" },
                                { "modified", format = "{}*" },
                                { "renamed", format = "{}~" },
                                { "deleted", format = "{}-" },
                            },
                            sep = " ",
                            -- padding = {
                            --     right = 1,
                            --     left = 1,
                            -- },
                        },
                        {
                            function()
                                return " " .. require("dap").status()
                            end,
                            icon = { "", color = { fg = "#e7c664" } }, -- nerd icon.
                            cond = function()
                                if not package.loaded.dap then
                                    return false
                                end
                                local session = require("dap").session()
                                return session ~= nil
                            end,
                        },
                    },
                    lualine_c = {
                        {
                            "diff",
                            padding = {
                                left = 1,
                                right = 2,
                            },
                            fmt = function(name, _)
                                if name == "" then
                                    return name
                                else
                                    return "buf: " .. name
                                end
                            end,
                            source = diff_source,
                        },
                        {
                            "diagnostics",
                            symbols = { error = "E", warn = "W", info = "I", hint = "H" },
                        },
                        {
                            oil_buffer_warning,
                            cond = is_oil_buffer,
                            color = "WarningMsg",
                        },
                    },
                    lualine_x = {
                        {
                            require("capslock").status_string,
                        },
                        {
                            "buffers",
                            icons_enabled = false,
                            max_length = vim.o.columns * 8 / 10,
                            show_filename_only = false,
                            show_modified_status = true,
                            buffers_color = {
                                active = "lualine_a_normal", -- Color for active buffer.
                                inactive = "lualine_c_normal", -- This fix is mainly for tokyo-night
                            },
                            symbols = {
                                modified = "^", -- Text to show when the buffer is modified
                                alternate_file = "", -- Text to show to identify the alternate file
                            },
                            filetype_names = {
                                snacks_picker_input = "FZF",
                                oil = "OIL",
                            }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
                        },
                    },
                    lualine_y = {},
                    lualine_z = { "progress" },
                },
            })
        end,
    },
}
