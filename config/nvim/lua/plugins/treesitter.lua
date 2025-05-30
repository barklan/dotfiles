return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "master", -- TODO: switch to "main" once stabilizes
        build = ":TSUpdate",
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                -- branch = "main",
            },
            { "RRethy/nvim-treesitter-endwise" },
            { "theHamsta/nvim-treesitter-pairs" },
        },
        config = function()
            local treesitter = require("nvim-treesitter.configs")

            treesitter.setup({
                ensure_installed = "all",
                sync_install = false,
                auto_install = true,
                ignore_install = {
                    "hoon",
                    "ocaml",
                    "org",
                    "ocaml_interface",
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<CR>",
                        node_incremental = "<CR>",
                        scope_incremental = false,
                        node_decremental = "<M-CR>",
                    },
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                endwise = {
                    enable = true,
                },
                pairs = {
                    enable = true,
                    disable = {},
                    highlight_pair_events = { "CursorMoved" },
                    highlight_self = false,
                    goto_right_end = true,
                    fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')",
                    keymaps = {
                        goto_partner = "<M-'>",
                        delete_balanced = "<leader>r'",
                    },
                    delete_balanced = {
                        only_on_first_char = false,
                        fallback_cmd_normal = nil,
                        longest_partner = false,
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ix"] = "@parameter.inner",
                            ["ax"] = "@parameter.outer",
                            ["aC"] = "@class.outer",
                            ["iC"] = "@class.inner",
                            ["ac"] = "@conditional.outer",
                            ["ic"] = "@conditional.inner",
                            -- ["ae"] = "@block.outer",
                            -- ["ie"] = "@block.inner",
                            ["al"] = "@loop.outer",
                            ["il"] = "@loop.inner",
                            ["ad"] = "@comment.outer",
                            ["am"] = "@call.outer",
                            ["im"] = "@call.inner",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>ra"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>rA"] = "@parameter.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["<M-]>"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["<M-[>"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                    },
                },
            })

            if vim.g.vscode ~= nil then
                vim.cmd("TSDisable highlight")
            end
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        -- branch = "master",
        cond = NotVSCode,
        lazy = true,
        event = "VeryLazy",
        opts = {
            mode = "cursor",
            max_lines = 2,
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "numToStr/Comment.nvim",
        cond = NotVSCode,
        lazy = true,
        keys = {
            { "<c-/>",     mode = { "n", "x" }, desc = "Comment code" },
            { "<leader>k", mode = { "n" },      desc = "Comment at the eol" },
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            local commentstring_avail, commentstring = pcall(require,
                "ts_context_commentstring.integrations.comment_nvim")
            local opts = {}
            if commentstring_avail then
                opts.pre_hook = commentstring.create_pre_hook()
            end

            require("Comment").setup(opts)

            local api = require("Comment.api")
            vim.keymap.set("n", "<C-/>", api.toggle.linewise.current, { desc = "Toggle line comment." })

            local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
            vim.keymap.set("x", "<C-/>", function()
                vim.api.nvim_feedkeys(esc, "nx", false)
                api.toggle.linewise(vim.fn.visualmode())
            end)
            vim.keymap.set("n", "<leader>k", api.insert.linewise.eol, { desc = "Add comment at the end of line." })
        end,
    },
}
