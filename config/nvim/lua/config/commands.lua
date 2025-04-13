vim.api.nvim_create_user_command("ExportPlugins", function()
    vim.notify("exporting plugins...", "info", { timeout = 1000 })

    vim.fn.system("tar -C ~/.local/share/nvim -I zstd -cpf lazy.tar.zst lazy")
    NotifySend("plugins exported to lazy.tar.zst!")
end, {})

vim.api.nvim_create_user_command("Cheat", function()
    vim.cmd("view " .. vim.fn.stdpath("config") .. "/cheatsheet.md")
    vim.bo.modifiable = false
end, {})

local group = vim.api.nvim_create_augroup("personal_leave_cheatsheet", { clear = true })
vim.api.nvim_create_autocmd({"BufLeave", "QuitPre"}, {
    group = group,
    pattern = vim.fn.stdpath("config") .. "/cheatsheet.md",
    callback = function(args)
        require("mini.bufremove").delete(args.buf)
    end,
})
