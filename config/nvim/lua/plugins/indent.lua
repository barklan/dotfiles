return {
    {
        "saghen/blink.nvim",
        cond = NotVSCode,
        -- all modules handle lazy loading internally
        lazy = false,
        opts = {
            indent = {
                enabled = true,
                visible = true,
                static = {
                    enabled = false,
                    char = "▎",
                    priority = 1,
                    highlights = { "BlinkIndent" },
                },
                scope = {
                    enabled = true,
                    -- char = "▎",
                    -- priority = 1024,
                    highlights = { "BlinkIndent" },
                    underline = {
                        enabled = false,
                    },
                },
            },
        },
    },
}
