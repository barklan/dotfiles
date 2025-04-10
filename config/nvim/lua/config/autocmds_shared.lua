vim.api.nvim_create_augroup("main", { clear = true })

vim.cmd([[
autocmd! InsertEnter * call feedkeys("\<Cmd>noh\<cr>" , 'n')
]])

local highlight_group = vim.api.nvim_create_augroup("highlight_yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    group = highlight_group,
    pattern = "*",
    callback = function()
        vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
})

-- start git messages in insert mode
vim.api.nvim_create_augroup("bufcheck", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "bufcheck",
    pattern = { "gitcommit" },
    command = "startinsert | 1",
})

vim.filetype.add({
    extension = {
        dockerfile = "dockerfile",
        pac = "javascript",
    },
})
