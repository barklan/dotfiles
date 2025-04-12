return {
    {
        "okuuva/auto-save.nvim",
        cond = function()
            if InVSCode() or IsCMDLineEditor() or IsScrollbackPager() then
                return false
            end

            return true
        end,
        lazy = true,
        event = "VeryLazy",
        opts = {
            enabled = true,
            trigger_events = { -- See :h events
                immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" },
                defer_save = { "InsertLeave", "TextChanged" },
                cancel_deferred_save = { "InsertEnter" },
            },
            condition = function(buf)
                local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
                if vim.tbl_contains(DontAutoSaveOrAutoCloseFiletypes, filetype) then
                    return false
                end

                -- Check if it's a special buffer type
                local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
                if buftype ~= "" then
                    return false
                end

                if not vim.api.nvim_get_option_value("modifiable", { buf = buf }) then
                    return false
                end

                return true
            end,
            write_all_buffers = false,
            noautocmd = false,
            debounce_delay = 800,
        },
    },
}
