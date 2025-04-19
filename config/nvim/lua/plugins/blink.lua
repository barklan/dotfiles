return {
    {
        "windwp/nvim-autopairs",
        lazy = true,
        cond = NotVSCode,
        event = "InsertEnter",
        config = function()
            vim.keymap.set("s", '"', '""<Left>', { noremap = true }) -- So it will work in snippet selection mode.

            local autopairs = require("nvim-autopairs")
            autopairs.setup({
                enable_check_bracket_line = false, -- Disable line checks for selections
                disable_in_replace_mode = false,
                disable_in_macro = false,
                enable_abbr = false,
                check_ts = false,
                ignored_next_char = "[%w%.]",
                map_cr = true,
            })
        end,
    },
    {
        "saghen/blink.cmp",
        lazy = true,
        cond = NotVSCode,
        event = "InsertEnter",
        dependencies = {
            "mikavilpas/blink-ripgrep.nvim",
            "windwp/nvim-autopairs",
            "abecodes/tabout.nvim",
            "onsails/lspkind.nvim",
        },
        build = "cargo build --release", -- This requires rust nightly!
        config = function()
            require("blink-cmp").setup({
                signature = {
                    enabled = true,
                    window = {
                        border = "rounded",
                        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
                    },
                },
                keymap = {
                    preset = "super-tab",
                    -- preset = "none",
                    ["<C-M-e>"] = { "select_prev", "fallback" },
                    ["<C-e>"] = { "select_next", "fallback" },
                    ["<M-r>"] = { "snippet_forward" },
                    ["<M-e>"] = { "snippet_backward" },
                    ["<M-l>"] = { "hide" },
                },

                appearance = {
                    nerd_font_variant = "mono",
                },
                completion = {
                    trigger = {
                        show_in_snippet = true,
                    },
                    accept = {
                        auto_brackets = {
                            enabled = true,
                        },
                    },
                    ghost_text = {
                        enabled = true,
                    },
                    documentation = {
                        auto_show = true,
                        auto_show_delay_ms = 200,
                    },
                    menu = {
                        draw = {
                            components = {
                                kind_icon = {
                                    text = function(ctx)
                                        local lspkind = require("lspkind")
                                        local icon = ctx.kind_icon
                                        icon = lspkind.symbolic(ctx.kind, {
                                            mode = "symbol",
                                        })

                                        return icon .. ctx.icon_gap .. " "
                                    end,
                                },
                            },
                        },
                    },
                },
                sources = {
                    default = {
                        "snippets",
                        "lsp",
                        "buffer",
                        "path",
                        "ripgrep",
                    },
                    providers = {
                        snippets = {
                            score_offset = 4,
                            opts = {
                                friendly_snippets = false,
                            },
                        },
                        lsp = {
                            score_offset = 3,
                        },
                        path = {
                            opts = {
                                show_hidden_files_by_default = true,
                            },
                        },
                        ripgrep = {
                            async = true,
                            score_offset = -1,
                            module = "blink-ripgrep",
                            name = "Ripgrep",
                            opts = {
                                prefix_min_len = 3,
                                context_size = 2,
                                max_filesize = "1M",
                                project_root_marker = ".git",
                                project_root_fallback = true,
                                search_casing = "--ignore-case",
                                additional_rg_options = { "--threads=6" },
                                fallback_to_regex_highlighting = false,
                                ignore_paths = {},
                                additional_paths = {},
                                future_features = {
                                    -- Workaround for
                                    -- https://github.com/mikavilpas/blink-ripgrep.nvim/issues/185. This
                                    -- is a temporary fix and will be removed in the future.
                                    issue185_workaround = true, -- TODO: disable once the bug is fixed
                                    -- toggles = {
                                    --     on_off = "<leader>tg",
                                    -- },

                                    backend = {
                                        -- The backend to use for searching. Defaults to "ripgrep".
                                        -- Available options:
                                        -- - "ripgrep", always use ripgrep
                                        -- - "gitgrep", always use git grep
                                        -- - "gitgrep-or-ripgrep", use git grep if possible, otherwise
                                        --   ripgrep
                                        use = "gitgrep-or-ripgrep",
                                    },
                                },
                                debug = false,
                            },
                            transform_items = function(_, items)
                                for _, item in ipairs(items) do
                                    -- example: append a description to easily distinguish rg results
                                    item.labelDetails = {
                                        description = "(rg)",
                                    }
                                end
                                return items
                            end,
                        },
                    },
                },
                fuzzy = {
                    implementation = "rust",
                    -- Add this section if you want exact matches to be prioritized
                    -- sorts = {
                    --     "exact",
                    --     "score",
                    --     "sort_text",
                    -- },
                },
                snippets = {
                    preset = "default",
                },
                cmdline = {
                    enabled = true,
                    keymap = {
                        preset = "inherit",
                    },
                    completion = {
                        menu = {
                            auto_show = true,
                        },
                    },
                },
            })
        end,
    },
}
