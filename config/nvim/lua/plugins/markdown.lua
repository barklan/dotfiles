return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        cond = NotVSCode,
        lazy = true,
        ft = { "markdown" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            preset = "lazy",
            overrides = {
                buftype = {
                    nofile = {
                        enabled = false,
                    },
                },
            },
            inline_highlight = {
                enabled = false,
            },
            code = {
                enabled = true,
                border = "thick",
                inline_pad = 1,
                language_icon = false,
                language_name = false,
            },
            bullet = {
                enabled = false,
            },
        },
    },
}
