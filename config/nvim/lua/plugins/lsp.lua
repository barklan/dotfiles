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
            "go",
            "c",
        },
        event = { "CmdlineEnter" },
        dependencies = {
            "saghen/blink.cmp",
        },
        config = function()
            local shared = require("config.lsp_shim")

            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
            local servers = { "gopls", "just", "basedpyright", "clangd", "ts_ls", "jsonls", "yamlls", "bashls" }

            if not IsPersonalDevice() then
                servers = { "gopls", "just", "basedpyright", "clangd" }
            end

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
                elseif lsp == "clangd" then
                    -- .clangd file:
                    -- ---
                    -- CompileFlags:
                    --   Add:
                    --     - -I/home/barklan/dev/krb5-1.21.3/src/include

                    nvim_lsp[lsp].setup({
                        cmd = { "clangd", "--enable-config" },
                    })
                elseif lsp == "basedpyright" then
                    nvim_lsp[lsp].setup({
                        on_attach = shared.on_attach,
                        capabilities = capabilities,
                        settings = {
                            basedpyright = {
                                reportMissingImports = "off",
                                analysis = {
                                    -- ["off", "basic", "standard", "strict", "recommended", "all"]
                                    typeCheckingMode = "basic",
                                    -- diagnosticMode = "openFilesOnly",
                                    -- inlayHints = {
                                    --     callArgumentNames = true,
                                    -- },
                                },
                            },
                        },
                    })
                elseif lsp == "gopls" then
                    nvim_lsp[lsp].setup({
                        -- cmd = { "gopls", "-remote=auto", "-remote.listen.timeout=10m" },
                        cmd = { "gopls" },
                        on_attach = shared.on_attach,
                        capabilities = capabilities,
                        settings = {
                            gopls = {
                                gofumpt = true,
                                hints = {
                                    assignVariableTypes = true,
                                    compositeLiteralFields = true,
                                    compositeLiteralTypes = true,
                                    constantValues = true,
                                    functionTypeParameters = true,
                                    parameterNames = true,
                                    rangeVariableTypes = true,
                                },
                                analyses = {
                                    unusedparams = true,
                                    shadow = true,
                                },
                                semanticTokens = true,
                                symbolScope = "workspace",
                                usePlaceholders = false,
                                staticcheck = true,
                                directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
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

            if not IsPersonalDevice() then
                return
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
