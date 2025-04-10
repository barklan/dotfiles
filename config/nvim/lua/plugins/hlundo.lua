return {
    {
        "tzachar/highlight-undo.nvim",
        cond = NotVSCode,
        enabled = true,
        event = "VeryLazy",
        opts = {
            duration = 300,
            pattern = { "*" },
        },
    },
}
