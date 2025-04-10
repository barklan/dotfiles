return {
    {
        "folke/todo-comments.nvim",
        cond = NotVSCode,
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "VeryLazy", -- To highlight immediately
        keys = {
            {
                "<leader>t",
                function()
                    Snacks.picker.todo_comments({
                        keywords = { "TODO", "FIX", "FIXME" },
                        args = {
                            "--hidden",
                            "--type-not=json",
                        },
                        show_empty = true,
                        on_show = function()
                            vim.cmd.stopinsert()
                        end,
                    })
                end,
                desc = "Todo/Fix/Fixme",
            },
        },
        opts = {
            signs = false,
            -- highlight = {
            --     exclude = { "json" },
            -- },
        },
    },
}
