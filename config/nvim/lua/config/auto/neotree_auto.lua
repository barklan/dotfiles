vim.api.nvim_create_augroup("neotree_auto", { clear = true })

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
