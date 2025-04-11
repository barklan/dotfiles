vim.api.nvim_create_user_command("ExportPlugins", function()
    vim.notify("exporting plugins...", "info", { timeout = 1000 })

    vim.fn.system("tar -C ~/.local/share/nvim -I zstd -cpf lazy.tar.zst lazy")
    NotifySend("plugins exported to lazy.tar.zst!")
end, {})
