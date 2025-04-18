return {
    {
        "j-hui/fidget.nvim",
        cond = NotVSCode,
        enabled = false,
        lazy = true,
        event = "VeryLazy",
        opts = {
            progress = {
                ignore_done_already = true,
                suppress_on_insert = false,
                ignore_empty_message = true,
                ignore = {
                    "null-ls",
                },
                display = {
                    done_ttl = 0,
                },
            },
        },
    },
}
