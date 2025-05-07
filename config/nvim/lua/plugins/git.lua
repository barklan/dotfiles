return {
    {
        "willothy/flatten.nvim",
        cond = NotVSCode,
        -- Ensure that it runs first to minimize delay when opening file from terminal
        lazy = false,
        priority = 1001,
        opts = {
            window = {
                open = "current",
            },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        cond = NotVSCode,
        lazy = true,
        event = "VeryLazy",
        opts = {
            current_line_blame_opts = {
                delay = 100,
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                map("n", "<M-c>", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "next_hunk" })

                map("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "prev_hunk" })

                map({ "n", "v" }, "<C-g>ha", ":Gitsigns stage_hunk<CR>", { desc = "stage/unstage hunk" })
                map({ "n", "v" }, "<C-g>hr", ":Gitsigns reset_hunk<CR>", { desc = "reset hunk" })
                map("n", "<C-g>hu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
                map("n", "<C-g>hR", gs.reset_buffer, { desc = "reset buffer" })
                map("n", "<C-g>hp", gs.preview_hunk, { desc = "preview hunk" })
                map("n", "<C-g>hi", gs.preview_hunk_inline, { desc = "preview hunk inline" })
                map("n", "<C-g><C-g>", gs.preview_hunk_inline, { desc = "preview hunk inline" })
                map("n", "<C-g>hb", function()
                    gs.blame_line({ full = true })
                end, { desc = "blame line" })
                map("n", "<C-g>tb", gs.toggle_current_line_blame, { desc = "toggle current line blame" })
                map("n", "<C-g>td", gs.toggle_deleted, { desc = "toggle deleted" })
                map("n", "<C-g>tw", gs.toggle_word_diff, { desc = "toggle word diff" })

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end,
        },
    },
}
