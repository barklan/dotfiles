P = function(v)
    print(vim.inspect(v))
    return v
end

Contains = function(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

GetFileExt = function(filename)
    local ext, _ = string.gsub(filename, ".*%.", "")
    return ext
end

GetKittyPID = function()
    local kitty_pid = vim.fn.system("pgrep -o kitty"):gsub("%s+", "")

    if kitty_pid == "" or not tonumber(kitty_pid) then
        vim.notify("No running Kitty instance found", vim.log.levels.WARN)
        return
    end

    return kitty_pid
end

PathExists = function(path)
    local uv = vim.loop or vim.uv
    local stat = uv.fs_stat(path)
    return stat ~= nil
end

GetCurrentBufDirAbsolute = function()
    local buf_path = vim.api.nvim_buf_get_name(0)
    if buf_path == "" then
        return vim.fn.getcwd()
    end

    return vim.fn.fnamemodify(buf_path, ":p:h")
end

GetCurrentBufDirRelativeToCwd = function()
    -- Get absolute path of current buffer
    local buf_path = vim.api.nvim_buf_get_name(0)
    if buf_path == "" then
        return "."
    end -- Return current dir for unnamed buffers

    -- Convert to absolute directory path
    local abs_dir = vim.fn.fnamemodify(buf_path, ":p:h")
    local cwd = vim.fn.getcwd()

    -- If the directory is the CWD itself
    if abs_dir == cwd then
        return "."
    end

    -- If the directory is under CWD
    if abs_dir:sub(1, #cwd) == cwd then
        local relative = abs_dir:sub(#cwd + 2) -- +2 to skip the trailing slash
        return "./" .. relative
    end

    -- If outside CWD, return absolute path
    return abs_dir
end

-- Returns either 'edit', 'open', 'none'
ChooseFileAction = function(file)
    local common_text = require("config.common_types").list_text
    local common_nontext = require("config.common_types").list_nontext
    local common_block = require("config.common_types").list_block
    local ext = GetFileExt(file)

    if Contains(common_text, ext) == true then
        return "edit"
    elseif Contains(common_nontext, ext) == true then
        return "open"
    elseif Contains(common_block, ext) == true then
        vim.notify("Extension " .. ext .. " is blocked for open.", "warn", { title = "File action chooser." })
        return "none"
    end

    local handle = io.popen("file -b --mime-type " .. file .. " | sed 's|/.*||'")
    if handle == nil then
        vim.notify("Could not check file mimetype.", "warn", { title = "File action chooser." })
        return "none"
    end
    local output = handle:read("*a")
    local mimetype = string.gsub(output, "%s+", "")
    handle:close()
    if mimetype == "text" or mimetype == "inode" then
        -- vim.notify("Don't forget to add '" .. ext .. "' to common text types.", "info", { title = "File action chooser." })
        return "edit"
    elseif mimetype == "image" then
        return "open"
    else
        vim.notify("not opening mimetype: " .. mimetype, "warn", { title = "File picker" })
        return "none"
    end
end

SmartCommit = function()
    vim.cmd("normal! mA")

    local previous_tries = vim.g.smart_commit_prep_try or 0
    vim.g.smart_commit_prep_try = previous_tries + 1

    require("plenary.job")
        :new({
            command = "git",
            args = { "smart-prep" },
            cwd = vim.fn.getcwd(),
            on_exit = function(j, return_val)
                if return_val == 111 then
                elseif return_val ~= 0 then
                    local stdout = table.concat(j:result(), "\n")
                    local stderr = table.concat(j:stderr_result(), "\n")

                    if vim.g.smart_commit_prep_try <= 2 then

                        -- NOTE: this happens too often, don't even notify
                        -- vim.schedule(function()
                        --     vim.notify("git smart-prep failed, retrying in 500ms", "info", { title = "git" })
                        -- end)

                        vim.defer_fn(SmartCommit, 500)
                    else
                        vim.g.smart_commit_prep_try = 0

                        vim.schedule(function()
                            vim.notify("git smart-prep failed:\n" .. (stderr ~= "" and stderr or stdout), "error", { title = "git" })
                        end)
                    end
                else
                    vim.g.smart_commit_prep_try = 0
                    vim.schedule(function()
                        require("lualine").hide()
                        -- NOTE: :terminal uses "flatten" plugin magic.
                        vim.cmd(":terminal git commit -q --status")
                    end)
                end
            end,
        })
        :start()
end

GitFetchMainBranch = function()
    require("plenary.job")
        :new({
            command = "git",
            args = { "fetch-main-safe" },
            cwd = vim.fn.getcwd(),
            on_exit = function(j, return_val)
                if return_val ~= 0 then
                    vim.defer_fn(function()
                        NotifySend("Failed fetching default branch!")
                    end, 0)
                end
            end,
        })
        :start()
end

function FileExists(name)
    local stat = vim.loop.fs_stat(name)
    return stat and stat.type == "file"
end

function DeleteBuffersWithoutFile()
    local bufnrs = vim.tbl_filter(function(bufnr)
        if 1 ~= vim.fn.buflisted(bufnr) then
            return false
        end

        local bufname = vim.api.nvim_buf_get_name(bufnr)

        return true
    end, vim.api.nvim_list_bufs())

    if not next(bufnrs) then
        return
    end

    local buffers = {}
    local default_selection_idx = 1
    for _, bufnr in ipairs(bufnrs) do
        local flag = bufnr == vim.fn.bufnr("") and "%" or (bufnr == vim.fn.bufnr("#") and "#" or " ")

        local element = {
            bufnr = bufnr,
            flag = flag,
            info = vim.fn.getbufinfo(bufnr)[1],
        }

        local idx = ((buffers[1] ~= nil and buffers[1].flag == "%") and 2 or 1)
        table.insert(buffers, idx, element)
    end

    -- P(buffers)

    for k, v in pairs(buffers) do
        if not FileExists(v.info.name) then
            require("mini.bufremove").delete(v.bufnr)
        end
    end
end

function CloseNamelessBuffers()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            local name = vim.api.nvim_buf_get_name(buf)
            local modified = vim.api.nvim_get_option_value("modified", { buf = buf })
            local listed = vim.api.nvim_get_option_value("buflisted", { buf = buf })

            -- Check for unnamed, unmodified, listed buffers
            if name == "" and not modified and listed then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end
    end
end

function DeleteOtherBuffers()
    local current = vim.api.nvim_get_current_buf()

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current and vim.api.nvim_buf_is_valid(buf) then
            local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
            local name = vim.api.nvim_buf_get_name(buf)

            local is_neo_tree = filetype == "neo-tree" or name:match("neo%-tree")

            if not is_neo_tree then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end
    end
end
