return {
    {
        "ThePrimeagen/refactoring.nvim",
        cond = NotVSCode,
        lazy = true,
        cmd = "Refactor",
        keys = {
            { "<leader>re", ":Refactor extract<cr>", mode = { "x" }, desc = "Extract" },
            { "<leader>rv", ":Refactor extract_var<cr>", mode = { "x" }, desc = "Extract variable" },
            { "<leader>ri", mode = { "n", "x" }, ":Refactor inline_var<cr>", desc = "Inline variable" },
            {
                "<leader>rp",
                mode = { "n", "x" },
                function()
                    require("refactoring").debug.print_var({ below = true })
                end,
                desc = "Print variable",
            },
            { "<leader>rb", mode = { "n" }, ":Refactor extract_block<cr>", desc = "Extract block" },
        },
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-treesitter/nvim-treesitter" },
        },
        config = function()
            require("refactoring").setup({})
        end,
    },
}
