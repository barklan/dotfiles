local all_map_modes = { "n", "i", "c", "v", "x", "s", "o", "t", "l" }
local toggle_term_title = "TOGGLE_TERM"

---------------
-- Commands
---------------

vim.keymap.set("n", "<leader>e", function()
    local file = vim.api.nvim_buf_get_name(0)
    local cwd = vim.fn.getcwd()
    local kitty_pid = GetKittyPID()

    vim.fn.system("kitten @ action goto_layout tall")
    vim.fn.system(
        "kitten @ --to unix:@mykitty-"
        .. tostring(kitty_pid)
        .. " launch --type=window --bias -60 --cwd "
        .. cwd
        .. " fish -ic 'run "
        .. file
        .. "; read -P continue -n1'"
    )
end, { silent = true, desc = "Execute file" })

vim.keymap.set("n", "<leader>j", function()
    local cwd = vim.fn.getcwd()
    local kitty_pid = GetKittyPID()

    vim.fn.system("kitten @ action goto_layout tall")
    vim.fn.system(
        "kitten @ --to unix:@mykitty-"
        .. tostring(kitty_pid)
        .. " launch --type=window --bias -60 --cwd "
        .. cwd
        .. " fish -ic 'just; read -P continue -n1'"
    )
end, { silent = true, desc = "just test" })

-------------------
--- Toggle terminal
-------------------

-- "fg", "bg", "err"
local get_zellij_status = function()
    local output = vim.fn.system("pgrep zellij | wc -l"):gsub("%s+", "")

    if output == "" or not tonumber(output) then
        vim.notify("error getting zellij process count")

        return "err"
    end

    local process_count = tonumber(output)
    if process_count == 0 or process_count == 1 then
        return "bg"
    elseif process_count == 2 then
        return "fg"
    end

    vim.notify("error getting zellij process count: unknown process_count")
    return "err"
end

local function pass() end

-- zellij has two processes when active in foreground
local toggle_terminal = function()
    local cwd = vim.fn.getcwd()
    -- local kitty_pid = GetKittyPID() -- NOTE: Uses kitty "current pid" stuff right now

    local zj_status = get_zellij_status()
    if zj_status == "fg" then
        -- kitty @ send-key --match 'title:^Zellij' ctrl+j
        -- vim.fn.system("kitten @ action goto_layout fat")
        -- "kitten @ --to unix:@mykitty-" .. tostring(kitty_pid)
        vim.fn.system("kitten @ send-key --match 'title:^" .. toggle_term_title .. "$' ctrl+j")

        return
    elseif zj_status == "bg" then
        pass()
    elseif zj_status == "err" then
        vim.notify("erorr getting zellij status")
        return
    else
        vim.notify("unknown zellij status")
        return
    end

    -- vim.fn.system("kitten @ --to unix:@mykitty-" .. tostring(kitty_pid) .. " action goto_layout fat")
    vim.fn.system("kitten @ action goto_layout fat")
    vim.fn.system("kitten @ launch --title " ..
    toggle_term_title .. " --type=window --bias -40 --cwd " .. cwd .. " fish -ic zj")
end

vim.keymap.set(all_map_modes, "<C-j>", toggle_terminal,
    { noremap = true, silent = true, desc = "Toggle (almost) terminal" })

--------------------
--- Paragraph runner
--------------------

-- FIX: this does not escape chars

local function trim_whitespace(str)
    return str:match("^%s*(.-)%s*$")
end

local get_current_paragraph = function()
    -- Save cursor position
    local original_pos = vim.api.nvim_win_get_cursor(0)
    local buf = 0 -- current buffer

    -- Find paragraph boundaries
    vim.cmd("normal! {")
    local start_lnum = vim.api.nvim_win_get_cursor(0)[1]
    vim.cmd("normal! }")
    local end_lnum = vim.api.nvim_win_get_cursor(0)[1]

    -- Restore cursor position
    vim.api.nvim_win_set_cursor(0, original_pos)

    -- Handle single-line paragraphs
    if start_lnum == end_lnum then
        return vim.api.nvim_buf_get_lines(buf, start_lnum - 1, start_lnum, false)[1]
    end

    -- Get all lines in paragraph
    local lines = vim.api.nvim_buf_get_lines(buf, start_lnum - 1, end_lnum, false)
    local output = table.concat(lines, "\n")

    return trim_whitespace(output)
end

local get_current_line = function()
    return vim.api.nvim_get_current_line()
end

local function get_first_line()
    local lines = vim.api.nvim_buf_get_lines(0, 0, 1, false)
    return lines[1] or "" -- Returns empty string if buffer is empty
end

local run_paragraph = function()
    local first_line = get_first_line()
    local whitelist = { "sql", "cql" }

    if vim.tbl_contains(whitelist, vim.bo.filetype) then
        pass()
    elseif not first_line:find("interactive", 1, true) then
        vim.notify("ft not in whitelist: \n" .. table.concat(whitelist, ",") .. "\n\nand interactive directive not set")

        return
    end

    local paragraph = get_current_paragraph()
    local zj_status = get_zellij_status()
    if zj_status == "fg" then
        pass()
    elseif zj_status == "bg" then
        vim.notify("TOGGLE_TERM not in foreground")
        return
    elseif zj_status == "err" then
        vim.notify("erorr getting zellij status")
        return
    else
        vim.notify("unknown zellij status")
        return
    end

    local cmd = [[kitten @ send-text --match 'title:^]] .. toggle_term_title .. [[$' ]] .. paragraph
    vim.fn.system(cmd)
    vim.fn.system("kitten @ send-key --match 'title:^" .. toggle_term_title .. "$' enter")
end

vim.keymap.set("n", "<leader>p", run_paragraph, { desc = "Run paragraph in TOGGLE_TERM" })
