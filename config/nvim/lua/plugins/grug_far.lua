return {
    {
        "MagicDuck/grug-far.nvim",
        cond = NotVSCode,
        lazy = true,
        cmd = { "GrugFar", "GrugFarWithin" },
        keys = {
            { "<leader>rg", ":GrugFar<cr>", mode = { "n" }, desc = "Global search and replace (GrugFar)" },
            { "<leader>rg", ":GrugFarWithin<cr>", mode = { "x" }, desc = "Global search and replace (GrugFar)" },
        },
        config = function()
            require("grug-far").setup({})
        end,
    },
}
