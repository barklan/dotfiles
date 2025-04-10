return {
    {
        "ThePrimeagen/refactoring.nvim",
        cond = NotVSCode,
        lazy = true,
        keys = {
            { "<leader>re", mode = { "x" }, desc = "Extract variable" },
            { "<leader>rv", mode = { "n", "x" }, desc = "Print variable" },
            { "<leader>rb", mode = { "n" }, desc = "Extract block" },
            { "<leader>ri", mode = { "n" }, desc = "Inline variable" },
        },
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-treesitter/nvim-treesitter" },
        },
        config = function()
            require("refactoring").setup({})

            local nse = { noremap = true, silent = true, expr = false }

            vim.keymap.set("x", "<leader>re", function()
                require("refactoring").refactor("Extract Variable")
            end, { desc = "Extract variable" })

            vim.keymap.set({ "x", "n" }, "<leader>rv", function()
                require("refactoring").debug.print_var()
            end, { desc = "Print variable" })

            vim.api.nvim_set_keymap(
                "n",
                "<leader>rb",
                [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
                { noremap = true, silent = true, expr = false, desc = "Extract block" }
            )

            vim.api.nvim_set_keymap(
                "n",
                "<leader>ri",
                [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
                { noremap = true, silent = true, expr = false, desc = "Inline variable" }
            )
        end,
    },
}
