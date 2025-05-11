vim.api.nvim_create_augroup("git_auto", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = "git_auto",
    pattern = "COMMIT_EDITMSG",
    callback = function()
        vim.defer_fn(function()
            vim.cmd("clearjumps") -- NOTE: no way currently to delete specific entry from jumplist
            vim.cmd("echo")
            vim.cmd("normal! `A")

            vim.cmd(":Neotree show source=filesystem position=left") -- source can be "last" or "filesystem"
        end, 0)
    end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    group = "git_auto",
    pattern = "COMMIT_EDITMSG",
    callback = function()
        vim.defer_fn(function()
            require("nvim-gitstatus").update_git_status()
        end, 200)
    end,
})

vim.api.nvim_create_autocmd("TermClose", {
    group = "git_auto",
    pattern = "*",
    callback = function(args)
        require("lualine").hide({ unhide = true })

        vim.defer_fn(function()
            require("nvim-gitstatus").update_git_status()
        end, 1000)

        vim.defer_fn(function()
            require("nvim-gitstatus").update_git_status()
        end, 10000)

        local res = vim.api.nvim_exec2("echo v:event.status", { output = true })
        local exit_code = tonumber(res.output)

        local term_cmd = vim.api.nvim_buf_get_name(args.buf)
        if string.find(term_cmd, "git commit", 1, true) then
            if exit_code == 0 then
                if IsPersonalDevice() then
                    vim.defer_fn(function()
                        vim.cmd([[silent !git pa ]])
                    end, 0)
                end

                vim.api.nvim_buf_delete(args.buf, { force = true })
            else
                vim.defer_fn(function()
                    vim.notify("git commit exited with error, check term buffer", "warn", { title = "neovim terminal" })
                end, 0)
            end
        end
    end,
})

local git_fetch = function()
    require("plenary.job")
        :new({
            command = "git",
            args = { "fetch" },
            cwd = vim.fn.getcwd(),
            on_exit = function(j, return_val)
                if return_val ~= 0 then
                    vim.notify("autofetch failed")
                end
            end,
        })
        :start()
end

vim.defer_fn(function()
    if IsScrollbackPager() or IsCMDLineEditor() or IsGitEditor() then
        return
    end

    local obj = vim.system({ "git", "rev-parse", "--is-inside-work-tree" }):wait()
    if obj.code ~= 0 then
        vim.notify("Not in git repo, disabling autofetch.", "info", { timeout = 1500 })

        return
    end

    vim.schedule(function()
        local timer = vim.uv.new_timer()

        timer:start(
            10000, -- initial delay
            30000, -- interval
            vim.schedule_wrap(function()
                git_fetch()
            end)
        )
    end)
end, 1000)
