local silent = { silent = true }

if IsPersonalDevice() then
    vim.keymap.set("n", "<leader>z", ":Lazy<cr>", { silent = true, desc = "Lazy Dashboard" })
end

vim.keymap.set("n", "<leader>c", ":Cheat<cr>", { silent = true, desc = "Open cheatsheet" })

vim.keymap.set("n", "<leader>h", function()
    if vim.bo.filetype == "markdown" then
        vim.cmd([[:vimgrep /^##\+ / %]])
        vim.cmd("copen")
    else
        vim.notify("Not a markdown file.", "info", { timeout = 1000 })
    end
end, { silent = true, desc = "Markdown headings to qf" })

vim.keymap.set("n", "<C-i>", "<C-i>", { noremap = true }) -- So that <Tab> mappings wont overwrite this.

-- Handled by better-escape.nvim
-- vim.keymap.set("i", "kj", "<esc>", silent)

vim.keymap.set("i", "<C-;>", "<C-v>", silent) -- To insert something without expanding (to bypass abbreviations for example).

local close_current_buffer = function()
    if vim.bo.filetype == "qf" then
        vim.cmd("cclose")
    elseif vim.bo.filetype == "help" then
        vim.cmd("bdelete")
    elseif vim.bo.filetype == "Trouble" then
        vim.cmd(":q")
    elseif vim.bo.filetype == "oil" then
        vim.cmd(":u0")
        vim.schedule(function()
            vim.cmd("echo")
        end)
        require("mini.bufremove").delete(0)
    elseif vim.bo.readonly == true then
        require("mini.bufremove").delete(0)
    else
        local buf_ft = vim.bo.filetype
        if buf_ft == "gitcommit" then -- This condition needed to trigger autocmd.
            vim.cmd(":write")
        else
            vim.cmd(":update")
        end

        require("mini.bufremove").delete(0)
    end
end

vim.keymap.set({ "n" }, "<C-h>", ":WhichKey<cr>")

------------------------
--- VSCode-like mappings
------------------------

vim.keymap.set("i", "<C-CR>", "<C-o>o", silent)
vim.keymap.set("i", "<C-BS>", "<C-W>", silent)
vim.keymap.set("c", "<C-BS>", "<C-W>", silent)

vim.keymap.set("n", "<C-q>", "<cmd>qall<cr>", { silent = true, desc = "Quit Neovim" })

-- Move lines like in vscode!
vim.keymap.set("n", "<C-M-n>", ":m .+1<CR>==")
vim.keymap.set("n", "<C-M-p>", ":m .-2<CR>==")
vim.keymap.set("v", "<C-M-n>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-M-p>", ":m '<-2<CR>gv=gv")

-------------------------------
-- Buffer and window management
-------------------------------

vim.keymap.set("n", "<A-k>", ":bnext<cr>", { silent = true })
vim.keymap.set("n", "<A-j>", ":bprevious<cr>", { silent = true })

-- Delete all buffers except the current one.
vim.keymap.set("n", "<leader>1", function()
    DeleteOtherBuffers()
end, { desc = "Close other buffers" })

if IsGitEditor() or IsCMDLineEditor() or IsScrollbackPager() then
    vim.keymap.set("n", "<BS>", "<cmd>wqall<cr>", { silent = true, desc = "Quit Neovim" })
else
    vim.keymap.set("n", "<BS>", close_current_buffer, { silent = true, desc = "Close buffer" })
end

vim.keymap.set("n", "<M-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<M-l>", "<C-w>l", { silent = true })

local function is_split_open()
    local win_count = 0

    for _, win_id in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win_id)
        local buf_bt = vim.bo[buf].buftype
        local buf_ft = vim.bo[buf].filetype

        -- Count windows with regular files, ignoring 'neo-tree' and special buffers
        if buf_bt == "" and buf_ft ~= "neo-tree" then
            win_count = win_count + 1
        end
    end

    return win_count > 1
end

vim.keymap.set("n", "<C-\\>", function()
    if is_split_open() then
        vim.cmd("wincmd q")
    else
        vim.cmd("wincmd v")
    end
end, { silent = true })

--------------
-- Diagnostics (also look in lsp_shim.lua)
--------------

vim.keymap.set("n", ";", function()
    vim.cmd("silent! LspFormat")
    vim.cmd("silent update")
end, { silent = true, desc = "Format document" })

local function toggle_hover()
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(winid)
        local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
        if ft == "lspinfo" or ft == "markdown" then
            vim.api.nvim_win_close(winid, true)
            return
        end
    end

    vim.lsp.buf.hover({ border = "single", focusable = false })
end

vim.keymap.set("n", "<Tab>", function()
    toggle_hover()

    -- Temporary multiline diagnostics for current line.
    vim.diagnostic.config({ virtual_lines = { current_line = true }, virtual_text = false })
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = vim.api.nvim_create_augroup("line-diagnostics", { clear = true }),
        callback = function()
            vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
            return true
        end,
    })
end, { desc = "Toggle LSP Hover" })

local function toggle_lsp_lines()
    local current_config = vim.diagnostic.config()
    local new_state_virtual_lines = not current_config.virtual_lines
    local new_state_virtual_text = not current_config.virtual_text

    vim.diagnostic.config({ virtual_lines = new_state_virtual_lines, virtual_text = new_state_virtual_text })
end
vim.keymap.set("n", "<Leader>dm", toggle_lsp_lines, { desc = "Toggle multiline diagnostics" })

local diagnostics_active = true
vim.keymap.set("n", "<leader>dt", function()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then
        vim.diagnostic.show()
    else
        vim.diagnostic.hide()
    end
end, { desc = "Toggle diagnostics" })

-----
--Git
-----

vim.keymap.set("n", "<C-g>o", "<cmd>silent !git-open<cr>")

vim.keymap.set("n", "<C-g>a", function()
    local file = vim.fn.expand("%") -- Get current file name
    if file ~= "" then
        vim.cmd(":update")
        local output = vim.fn.system("git add " .. vim.fn.shellescape(file))
        vim.notify("File staged", "info", { timeout = 2000 })
    else
        print("No file to stage.")
    end

    pcall(function()
        require("neo-tree.sources.git_status").refresh()
    end)
end, { silent = true, desc = "Stage current file" })

vim.keymap.set("n", "<C-g>j", function()
    vim.cmd(":update")
    vim.cmd(":Neotree show source=git_status position=left") -- source can be "last"

    vim.schedule(SmartCommit)
end, { silent = true, desc = "Smart commit" })

-- Git base
vim.keymap.set("n", "<C-g>bh", function()
    vim.cmd("Gitsigns change_base HEAD")
    vim.cmd("Neotree show git_base=HEAD")
end, { desc = "Change base to HEAD" })

vim.keymap.set("n", "<C-g>bd", function()
    vim.cmd("Gitsigns change_base develop")
    vim.cmd("Neotree show git_base=develop")
end, { desc = "Change base to develop" })

vim.keymap.set("n", "<C-g>bm", function()
    vim.cmd("Gitsigns change_base main")
    vim.cmd("Neotree show git_base=main")
end, { desc = "Change base to main" })

-----------------
-- Misc
-----------------

vim.keymap.set("n", "<C-M-l>", function()
    require("extra.functions").snacks_dirs()
end)

vim.keymap.set("n", "<C-M-f>", function()
    require("extra.functions").snacks_rg_all_cwd_lines()
end)

vim.keymap.set("n", "<leader>o", ":Oil<cr>", { desc = "Open Oil buffer" })

local function toggle_quickfix()
    for _, win in ipairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            vim.cmd("cclose")
            return
        end
    end
    vim.cmd("copen")
end

vim.keymap.set("n", "<leader>q", toggle_quickfix, { silent = true, desc = "Open quickfix" })

vim.keymap.set("n", "<C-e>", function()
    if require("dap").session() ~= nil then
        if vim.bo.filetype == "dapui_scopes" then
            vim.cmd("q")
        else
            require("dapui").float_element("scopes", { enter = true })
        end
        return
    end

    if vim.bo.filetype == "neo-tree" then
        vim.cmd("wincmd l")
    else
        vim.cmd(":Neotree source=filesystem position=left action=focus reveal=true") -- source can be "last"
    end
end, { silent = true, desc = "Focus explorer" })

if IsCMDLineEditor() == true then
    vim.keymap.set("n", "<M-e>", "<cmd>wqall<cr>", { silent = true, desc = "Quit Neovim" })
else
    vim.keymap.set("n", "<M-e>", ":Neotree git_status toggle float focus reveal=true<cr>", { silent = true, desc = "git status float" })
end

vim.keymap.set("n", "<C-M-e>", ":Neotree source=diagnostics toggle float focus reveal=true<cr>", { silent = true, desc = "diasgnostic float" })

-- Clear stuff
-- TODO: also delete file buffers that don't have cwd prefix
vim.keymap.set("n", "<leader>l", function()
    require("notify").dismiss({ silent = true, pending = false })
    vim.cmd("noh")
    vim.cmd("cclose")
    CloseNamelessBuffers()
    vim.cmd("wall")
    -- vim.cmd("on") -- close other windows
    vim.cmd("echo")
end, { desc = "Clean shit" })

vim.keymap.set("n", "R", "<Nop>")
