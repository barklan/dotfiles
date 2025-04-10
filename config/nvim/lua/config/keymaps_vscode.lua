local silent = { silent = true }

vim.keymap.set("n", "q", "<Nop>")
vim.keymap.set("n", "/", "<cmd>call VSCodeNotify('actions.find')<cr>", silent)

-- Use VS Code's undo.
vim.keymap.set("n", "u", "<cmd>call VSCodeNotify('undo')<cr>", silent)

vim.keymap.set("n", "<BS>", "<cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<cr>", silent)

-- INFO: keep shortcuts here mainly instead of defining in vscode
vim.keymap.set("n", "gd", "<Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>", silent)
vim.keymap.set("n", "gj", "<Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>", silent)
vim.keymap.set("n", "gi", "<Cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>", silent)

vim.keymap.set("n", "]c", "<Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR>", silent)
vim.keymap.set("n", "[c", "<Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR>", silent)

vim.keymap.set("n", "<leader>1", "<Cmd>call VSCodeNotify('workbench.action.closeOtherEditors')<CR>", silent)
vim.keymap.set("n", ";", "<Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>", silent)

vim.keymap.set("n", "<leader>l", function()
    vim.cmd("noh")
    vim.cmd("echo")
end, { silent = true, desc = "Clean shit" })
