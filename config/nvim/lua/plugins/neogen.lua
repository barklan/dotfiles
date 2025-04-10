return {
    {
        "danymat/neogen",
        cond = NotVSCode,
        lazy = true,
        cmd = "Neogen",
        keys = {
            { "<leader>rn", ":Neogen<cr>", mode = { "n" }, desc = "Neogen" },
        },
        opts = {
            snippet_engine = "nvim",
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
}
