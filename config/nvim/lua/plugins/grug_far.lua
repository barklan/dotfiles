return {
    {
        "MagicDuck/grug-far.nvim",
        cond = NotVSCode,
        lazy = true,
        cmd = { "GrugFar", "GrugFarWithin" },
        keys = {
            { "<leader>rr", ":GrugFar<cr>", mode = { "n" }, desc = "Global search and replace (GrugFar)" },
            { "<leader>rr", ":GrugFarWithin<cr>", mode = { "x" }, desc = "Global search and replace (GrugFar)" },
        },
        config = function()
            require("grug-far").setup({})
        end,
    },
}
