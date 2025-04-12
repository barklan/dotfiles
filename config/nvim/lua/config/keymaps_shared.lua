local all_map_modes = { "n", "i", "c", "v", "x", "s", "o", "t", "l" }

-- Unmap annoying stuff.
vim.keymap.set("n", "q", "<Nop>") -- Just map macros for neovim if needed
vim.keymap.set("n", "gh", "<Nop>")
vim.keymap.set({ "n" }, "s", "<Nop>")
vim.keymap.set("n", "<C-]>", "<Nop>")
vim.keymap.set(all_map_modes, "<F1>", "<Nop>")
vim.keymap.set(all_map_modes, "<RightMouse>", "<Nop>")
vim.keymap.set(all_map_modes, "<MiddleMouse>", "<Nop>")
vim.keymap.set(all_map_modes, "<2-MiddleMouse>", "<Nop>")
vim.keymap.set(all_map_modes, "<3-MiddleMouse>", "<Nop>")
vim.keymap.set(all_map_modes, "<4-MiddleMouse>", "<Nop>")

vim.keymap.set("n", "<leader>rs", ":%s/\\v", { desc = "Search and replace" })

-- Make < > shifts keep selection.
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Make cursor stay at the end of selection after yanking.
vim.keymap.set("v", "y", "ygv<esc>")

-- Visual block mode to free C-v for pasting.
vim.keymap.set("n", "<leader>v", "<C-v>", { silent = true, desc = "Visual block mode" })

vim.keymap.set({ "n", "v" }, "H", "0^")
vim.keymap.set({ "n", "v" }, "L", "$")
vim.keymap.set({ "n", "v" }, "J", "}")
vim.keymap.set({ "n", "v" }, "K", "{")

-- Look into treesitter objects
vim.keymap.set("n", "<M-CR>", "<Nop>")

