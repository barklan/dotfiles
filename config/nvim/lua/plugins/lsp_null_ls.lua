return {
    {
        -- Sources here: https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
        "nvimtools/none-ls.nvim",
        name = "null_ls",
        cond = NotVSCode,
        lazy = true,
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local shared = require("config.lsp_shim")
            local null_ls = require("null-ls")

            local sources_personal = {
                null_ls.builtins.diagnostics.hadolint,
                null_ls.builtins.diagnostics.sqruff,
                null_ls.builtins.diagnostics.dotenv_linter,
                null_ls.builtins.diagnostics.fish,

                null_ls.builtins.diagnostics.yamllint.with({
                    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
                    args = { "-c", os.getenv("HOME") .. "/sys/yamllint.yml", "--format", "parsable", "-" },
                }),
                null_ls.builtins.diagnostics.markdownlint.with({
                    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
                    extra_args = { "--disable=MD012", "--disable=MD013", "--disable=MD033", "--disable=MD041", "--disable=MD034" },
                }),
                null_ls.builtins.formatting.markdownlint.with({
                    extra_args = { "--disable=MD034" },
                }),
                -- null_ls.builtins.diagnostics.golangci_lint.with({
                --     method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
                --     extra_args = { "--no-config", "--concurrency=4", "--max-same-issues=0", "--fast" },
                --     timeout = 6000,
                -- }),

                null_ls.builtins.formatting.golines.with({
                    extra_args = { "--max-len=150", "--base-formatter=gofumpt" },
                }),
                null_ls.builtins.diagnostics.buf.with({
                    args = { "lint" },
                    extra_args = { "--config=/home/barklan/sys/buf.yml" },
                }),
                null_ls.builtins.formatting.sqruff,
                null_ls.builtins.formatting.shfmt,
                null_ls.builtins.formatting.just,
                -- NOTE: This fucks up some variables where you actually what them unquoted.
                -- null_ls.builtins.formatting.shellharden,
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort.with({
                    extra_args = { "--profile=black" },
                }),
                null_ls.builtins.formatting.prettierd.with({
                    disabled_filetypes = { "json" },
                }),
                null_ls.builtins.formatting.fish_indent,
                null_ls.builtins.formatting.buf,
                null_ls.builtins.formatting.stylua,
            }

            local sources_work = {
                null_ls.builtins.diagnostics.sqruff,
                null_ls.builtins.diagnostics.fish,
                null_ls.builtins.formatting.golines.with({
                    extra_args = { "--max-len=250", "--base-formatter=gofumpt" },
                }),
                null_ls.builtins.formatting.sqruff,
                null_ls.builtins.formatting.fish_indent,
            }

            if IsPersonalDevice() then
                null_ls.setup({
                    sources = sources_personal,
                    on_attach = shared.on_attach,
                    debounce = 2000,
                    default_timeout = 6000,
                })
            else
                null_ls.setup({
                    sources = sources_work,
                    on_attach = shared.on_attach,
                    debounce = 2000,
                    default_timeout = 6000,
                })
            end
        end,
    },
}
