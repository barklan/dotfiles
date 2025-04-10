vim.api.nvim_create_augroup("git_auto", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = "git_auto",
    pattern = "COMMIT_EDITMSG",
    callback = function()
        vim.defer_fn(function()
            vim.cmd("clearjumps") -- NOTE: no way currently to delete specific entry from jumplist
            vim.cmd("echo")
            vim.cmd("normal! `A")

            -- vim.cmd(":Neotree close")
            -- vim.cmd(":Neotree show")
            vim.cmd(":Neotree source=filesystem position=left reveal=true") -- source can be "last" or "filesystem"
        end, 0)
    end,
})

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    group = "git_auto",
    pattern = "COMMIT_EDITMSG",
    callback = function()
        vim.schedule(function()
            vim.cmd(":Neotree source=git_status position=left reveal=true") -- source can be "last"
        end)

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
                        vim.cmd([[silent !systemd-run --same-dir --collect --user gitx rapid-push & ]])
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
