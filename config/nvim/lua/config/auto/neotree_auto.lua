vim.api.nvim_create_augroup("neotree_auto", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", { -- Changed from BufReadPre
    desc = "Open neo-tree on enter",
    group = "neotree_auto",
    once = true,
    callback = function()
        if IsGitEditor() then
            vim.g.neotree_opened = true
            vim.cmd(":Neotree show source=git_status position=left") -- source can be "last"
        end
        -- NOTE: mb find a way to replace existing buffer to load even faster (also look in auto-session)

        local num_args = vim.fn.argc()
        if num_args == 0 then
            vim.schedule(function()
                if not vim.g.neotree_opened then
                    -- Neotree position=current
                    -- NOTE: mb find a way to replace existing buffer to load even faster (also look in auto-session)
                    vim.g.neotree_opened = true
                    vim.cmd("Neotree show")
                end
            end)
        end
    end,
})

local refresh_neotree_git_status = function()
    pcall(function()
        require("neo-tree.sources.git_status").refresh()
    end)
end

vim.schedule(function()
    local timer = vim.uv.new_timer()

    timer:start(
        5000, -- initial delay
        6000, -- interval
        vim.schedule_wrap(function()
            refresh_neotree_git_status()
        end)
    )
end)
