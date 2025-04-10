return {
    {
        "folke/lazydev.nvim",
        cond = function()
            return NotVSCode() and IsPersonalDevice()
        end,
        lazy = true,
        ft = "lua",
        -- event = "VeryLazy",
        config = function()
            require("lazydev").setup({
                library = {
                    { path = "snacks.nvim", words = { "Snacks" } },
                },
            })
            -- This is if loading plugin "VeryLazy".
            -- vim.defer_fn(function()
            --     AttachLspToExistingBuffers()
            -- end, 0)
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "neovim/nvim-lspconfig",
        },
    },
    {
        -- TODO: possibly move to native neovim stuff for this
        -- https://github.com/ray-x/go.nvim/issues/558
        "neovim/nvim-lspconfig",
        cond = NotVSCode,
        lazy = true,
        ft = { "json", "yaml", "javascript", "typescript", "sh", "python" },
        event = { "CmdlineEnter" },
        dependencies = {
            "b0o/schemastore.nvim",
            "onsails/lspkind.nvim",
            "saghen/blink.cmp",
        },
        config = function()
            local shared = require("config.lsp_shim")

            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
            local servers = {
                "basedpyright",
                "ts_ls",
                "jsonls",
                "yamlls",
                "bashls",
            }

            if IsPersonalDevice() == false then
                servers = {}
            end

            local nvim_lsp = require("lspconfig")

            for _, lsp in ipairs(servers) do
                if lsp == "yamlls" then
                    nvim_lsp[lsp].setup({
                        on_attach = shared.on_attach,
                        capabilities = capabilities,
                        settings = {
                            yaml = {
                                schemaStore = {
                                    url = "https://www.schemastore.org/api/json/catalog.json",
                                    enable = true,
                                },
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
                                schemas = require("schemastore").json.schemas(),
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
