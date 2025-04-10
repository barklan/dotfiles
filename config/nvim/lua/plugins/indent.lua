return {
    {
        "saghen/blink.nvim",
        cond = NotVSCode,
        -- all modules handle lazy loading internally
        lazy = false,
        opts = {
            indent = {
                enabled = true,
                -- start with indent guides visible
                visible = true,
                static = {
                    enabled = false,
                    char = "▎",
                    priority = 1,
                    -- specify multiple highlights here for rainbow-style indent guides
                    -- highlights = { 'BlinkIndentRed', 'BlinkIndentOrange', 'BlinkIndentYellow', 'BlinkIndentGreen', 'BlinkIndentViolet', 'BlinkIndentCyan' },
                    highlights = { "BlinkIndent" },
                },
                scope = {
                    enabled = true,
                    -- char = "▎",
                    -- priority = 1024,
                    highlights = { "BlinkIndent" },
                    underline = {
                        -- enable to show underlines on the line above the current scope
                        enabled = false,
                        highlights = {
                            "BlinkIndentRedUnderline",
                            "BlinkIndentYellowUnderline",
                            "BlinkIndentBlueUnderline",
                            "BlinkIndentOrangeUnderline",
                            "BlinkIndentGreenUnderline",
                            "BlinkIndentVioletUnderline",
                            "BlinkIndentCyanUnderline",
                        },
                    },
                },
            },
        },
    },
}
