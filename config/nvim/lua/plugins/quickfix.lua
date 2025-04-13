return {
    {
        "kevinhwang91/nvim-bqf",
        cond = NotVSCode,
        lazy = true,
        ft = "qf",
        dependencies = {
            { "junegunn/fzf" },
            { "nvim-treesitter/nvim-treesitter" },
        },
        opts = {
            auto_enable = true,
            auto_resize_height = false,
            func_map = {
                open = "o",
                openc = "<CR>",
            },
        },
    },
}
