return {
    {
        "folke/lazydev.nvim",
        cond = function()
            return NotVSCode() and IsPersonalDevice()
        end,
        lazy = true,
        ft = { "lua" },
        config = function()
            require("lazydev").setup({
                library = {
                    { path = "snacks.nvim", words = { "Snacks" } },
                },
            })
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "neovim/nvim-lspconfig",
        },
    },
    {
        "neovim/nvim-lspconfig",
        cond = NotVSCode,
        lazy = true,
        ft = {
            "json",
            "yaml",
            "javascript",
            "typescript",
            "sh",
            "python",
            "just",
        },
        event = { "CmdlineEnter" },
        dependencies = {
            "saghen/blink.cmp",
        },
        config = function()
            if not IsPersonalDevice() then
                return
            end

            local shared = require("config.lsp_shim")

            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
            local servers = {
                "basedpyright",
                "ts_ls",
                "jsonls",
                "yamlls",
                "bashls",
                "just",
            }

            local nvim_lsp = require("lspconfig")

            for _, lsp in ipairs(servers) do
                if lsp == "yamlls" then
                    nvim_lsp[lsp].setup({
                        on_attach = shared.on_attach,
                        capabilities = capabilities,
                        settings = {
                            yaml = {
                                format = {
                                    enable = true,
                                },
                            },
                        },
                    })
                elseif lsp == "jsonls" then
                    nvim_lsp[lsp].setup({
                        on_attach = shared.on_attach,
                        capabilities = capabilities,
                        settings = {
                            json = {
                                validate = { enable = true },
                            },
                        },
                    })
                else
                    nvim_lsp[lsp].setup({
                        on_attach = shared.on_attach,
                        capabilities = capabilities,
                    })
                end
            end

            nvim_lsp.lua_ls.setup({
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        runtime = {
                            version = "LuaJIT",
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })
        end,
    },
}
