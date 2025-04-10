return {
    {
        "rcarriga/nvim-notify",
        cond = NotVSCode,
        lazy = true,
        event = "VeryLazy",
        config = function()
            require("notify").setup({
                fps = 60,
                render = "simple",
                -- stages = "fade",
                stages = "static",
            })

            -- List of messages to ignore
            local ignore_messages = {
                "Client gopls quit with exit code 2 and signal 0. Check log for errors: /home/barklan/.local/state/nvim/lsp.log",
                "No information available"
            }

            local ignore_prefixes = {
                "golangci-lint run",
            }

            -- vim.notify = require("notify")
            vim.notify = function(msg, ...)
                for _, ignored in ipairs(ignore_messages) do
                    if msg:match(ignored) then
                        return
                    end
                end

                for _, ignore_prefix in ipairs(ignore_prefixes) do
                    if vim.startswith(msg, ignore_prefix) then
                        return
                    end
                end

                if vim.startswith(msg, "test finished:") then
                    vim.defer_fn(function()
                        os.remove("./cover.cov")
                    end, 300)
                end

                require("notify")(msg, ...)
            end
        end,
    },
    {
        "folke/which-key.nvim",
        cond = NotVSCode,
        lazy = true,
        event = "VeryLazy",
        opts = {
            delay = 500,
            preset = "modern",
            icons = {
                mappings = false,
            }
        },
    },
    {
        "lewis6991/satellite.nvim", -- This is scroll bar.
        cond = NotVSCode,
        lazy = true,
        event = "VeryLazy",
        config = function()
            require("satellite").setup({
                current_only = false,
                winblend = 0,
                zindex = 40,
                excluded_filetypes = { "neo-tree" },
                width = 10,
                handlers = {
                    cursor = {
                        enable = false,
                        -- Supports any number of symbols
                        symbols = { "⎺", "⎻", "⎼", "⎽" },
                    },
                    search = {
                        enable = true,
                    },
                    diagnostic = {
                        enable = true,
                        signs = { "-", "=", "≡" },
                        min_severity = vim.diagnostic.severity.HINT,
                    },
                    gitsigns = {
                        enable = true,
                        signs = { -- can only be a single character (multibyte is okay)
                            add = "│",
                            change = "│",
                            delete = "-",
                        },
                    },
                    marks = {
                        enable = false,
                        show_builtins = false, -- shows the builtin marks like [ ] < >
                        key = "m",
                    },
                    quickfix = {
                        signs = { "-", "=", "≡" },
                    },
                },
            })
        end,
    },
    {
        -- NOTE: provides <A-i> text object (and A-n, A-p keymaps)
        "RRethy/vim-illuminate",
        cond = NotVSCode,
        lazy = true,
        event = "VeryLazy",
        config = function()
            require("illuminate").configure({
                -- under_cursor = false,
                -- delay = 100,
            })
        end,
    },
}
