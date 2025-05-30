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
                stages = "static",
            })

            -- List of messages to ignore
            local ignore_messages = {
                "No information available",
            }

            local ignore_prefixes = {
                "just lint-nvim",
                "golangci-lint run",
                "Client gopls quit with exit code 2 and signal 0.",
                "nvim-dap-virtual-text not found",
                "INFO: plugin nvim-dap-virtual-text module nvim-dap-virtual-text  not loaded",
                "Yanked to register",
                "no test file found for",
            }

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
            delay = 600,
            preset = "helix",
            icons = {
                mappings = false,
            },
        },
    },
    {
        "lewis6991/satellite.nvim",
        cond = NotVSCode,
        enabled = true,
        lazy = true,
        event = "VeryLazy",
        config = function()
            require("satellite").setup({
                current_only = true,
                winblend = 0,
                zindex = 40,
                excluded_filetypes = { "neo-tree" },
                width = 4,
                handlers = {
                    cursor = {
                        enable = false,
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
                        show_builtins = false,
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
