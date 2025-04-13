return {
    {
        "tzachar/highlight-undo.nvim",
        cond = NotVSCode,
        enabled = false, -- TODO: creates artifacts
        event = "VeryLazy",
        opts = {
            duration = 300,
            pattern = { "*" },
        },
    },
}
