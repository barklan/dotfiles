return {
    {
        "stevearc/oil.nvim",
        cond = function ()
            return NotVSCode() and IsOilEditor()
        end,
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
        opts = {
            default_file_explorer = false,
            delete_to_trash = true,
            watch_for_changes = true,
            view_options = {
                show_hidden = true,
            },
        },
    },
}
