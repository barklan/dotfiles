vim.api.nvim_create_augroup("limit_buffers", { clear = true })

local max_buffers = 5

local function is_file_buffer(buf)
    local bufname = vim.api.nvim_buf_get_name(buf)
    if bufname == "" then
        return false
    end

    local bufname_split = Split(bufname, "/")
    local bufname_last = bufname_split[#bufname_split]

    if bufname_last == "COMMIT_EDITMSG" then
        return false
    end

    local filetype = vim.api.nvim_get_option_value("filetype", {buf = buf})
    if vim.tbl_contains(DontAutoSaveOrAutoCloseFiletypes, filetype) then
        return false
    end

    -- Check if it's a special buffer type
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
    if buftype ~= "" then
        return false
    end

    if not vim.api.nvim_get_option_value("modifiable", { buf = buf }) then
        return false
    end

    if vim.api.nvim_get_option_value("buflisted", { buf = buf }) == false then
        return false
    end

    if not vim.fn.filereadable(bufname) == 1 then
        return false
    end

    -- Additional check for actual file existence
    local stat = vim.loop.fs_stat(bufname)
    return stat and stat.type == "file"
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave" }, {
    group = "limit_buffers",
    callback = function(args)
        if is_file_buffer(args.buf) then
            vim.b[args.buf].last_used = os.time()
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufAdd" }, {
    group = "limit_buffers",
    callback = function(args)
        if is_file_buffer(args.buf) then
            vim.b[args.buf].last_used = os.time()
        end

        local buffers = {}
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if is_file_buffer(buf) then
                table.insert(buffers, {
                    buf = buf,
                    last_used = vim.b[buf].last_used or 0,
                })
            end
        end

        table.sort(buffers, function(a, b)
            return a.last_used < b.last_used
        end)

        while #buffers > max_buffers do
            local oldest = table.remove(buffers, 1)
            vim.api.nvim_buf_delete(oldest.buf, { force = true })
        end
    end,
})
