return {
    {
        "ray-x/go.nvim",
        cond = NotVSCode,
        lazy = true,
        ft = { "go", "gomod" },
        event = { "CmdlineEnter" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "neovim/nvim-lspconfig",
            "ray-x/guihua.lua",
            "rcarriga/nvim-dap-ui", -- To load debug plugins.
            "saghen/blink.cmp",
        },
        config = function()
            local shared = require("config.lsp_shim")

            local capabilities = require("blink.cmp").get_lsp_capabilities()

            require("go").setup({
                gopls_cmd = { "gopls", "-remote=auto", "-remote.listen.timeout=20m" },
                -- gopls_cmd = { "gopls" },
                goimports = "gopls",
                max_line_len = 250, -- NOTE: should be in sync with null_ls golines
                gofmt = "golines",
                lsp_gofumpt = true,
                lsp_document_formatting = true,
                tag_options = "",
                verbose_tests = false,
                tag_transform = "camelcase",
                -- tag_transform = "snakecase",
                lsp_cfg = {
                    capabilities = capabilities,
                    on_attach = shared.on_attach,
                    settings = {
                        gopls = {
                            symbolScope = "workspace",
                            diagnosticsTrigger = "Edit",
                        },
                    },
                },
                diagnostic = {
                    hdlr = false, -- hook lsp diag handler and send diag to quickfix
                    underline = true,
                    -- virtual_text = { spacing = 0, prefix = "■" },
                    signs = false,
                    update_in_insert = false,
                },
                lsp_inlay_hints = {
                    enable = false, -- Still fucking buggy
                },
                icons = { breakpoint = "🔴", currentpos = "🟡" },
                dap_debug_keymap = false,
                dap_debug_vt = {
                    virt_text_pos = "inline", -- or "eol"
                },
                dap_debug_gui = {
                    -- expand_lines = true,
                    -- floating = {
                    --     border = "single",
                    --     mappings = {
                    --         close = { "q", "<Esc>" },
                    --     },
                    -- },
                    -- force_buffers = true,
                    -- icons = {
                    --     collapsed = "",
                    --     current_frame = "",
                    --     expanded = "",
                    -- },
                    layouts = {
                        {
                            elements = {
                                {
                                    id = "scopes",
                                    size = 0.6,
                                },
                                {
                                    id = "breakpoints",
                                    size = 0.20,
                                },
                                {
                                    id = "stacks",
                                    size = 0.20,
                                },
                                -- {
                                --     id = "watches",
                                --     size = 0.25,
                                -- },
                            },
                            position = "left",
                            size = 40,
                        },
                    },
                    mappings = {
                        edit = "e",
                        expand = { "<CR>", "<2-LeftMouse>" },
                        open = "o",
                        remove = "d",
                        repl = "r",
                        toggle = "t",
                    },
                    render = {
                        indent = 1,
                        max_value_lines = 100,
                    },
                },
            })
        end,
    },
}
