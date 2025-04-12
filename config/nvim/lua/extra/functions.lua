local M = {}

M.get_directories = function()
    local directories = {}

    local fdcmd = "fd"
    if not IsPersonalDevice() then
        fdcmd = "fdfind"
    end

    local handle = io.popen(fdcmd .. " . --type directory --strip-cwd-prefix")
    if handle then
        for line in handle:lines() do
            table.insert(directories, line)
        end
        handle:close()
    else
        print("Failed to execute fd command")
    end

    return directories
end

M.rg_all_cwd_lines_important_args = "--hidden --ignore --max-columns=500 --max-filesize=5M"
M.rg_all_cwd_lines_limit = 1000000

M.rg_all_cwd_lines = function()
    local results = {}
    local cmd = "sh -c 'timeout 2 rg --color=never --no-heading --with-filename --line-number --column "
        .. M.rg_all_cwd_lines_important_args
        .. " --max-columns-preview -g !.git -- .'; printf '\n%s' $?"

    local reached_limit = false
    local msg = ""

    local handle = io.popen(cmd)
    if handle then
        for line in handle:lines() do
            if #results < M.rg_all_cwd_lines_limit and line ~= "" then
                table.insert(results, line)
            end

            if #results == M.rg_all_cwd_lines_limit and reached_limit == false then
                msg = msg .. "reached limit | "
                reached_limit = true
            end
        end
        handle:close()

        if not reached_limit then
            local lastline = table.remove(results) -- Remove last line with exit code

            if lastline == "124" then
                msg = msg .. "reached timeout | "
            elseif lastline ~= "0" then
                NotifySend("rg_all_cwd_lines: unknown error " .. lastline)
            end
        end
    else
        NotifySend("rg_all_cwd_lines: failed to start rg")
    end

    return results, msg
end

M.snacks_rg_all_cwd_lines = function()
    local Snacks = require("snacks")

    local cwd = vim.fn.getcwd()
    local lines, msg = M.rg_all_cwd_lines()

    return Snacks.picker({
        title = msg .. "rg " .. M.rg_all_cwd_lines_important_args,
        jump = { match = true },
        format = "file",
        finder = function(_, _)
            local items = {}
            for i, line in ipairs(lines) do
                local file, line_no, _, text = line:match("^(.+):(%d+):(%d+):(.*)$")

                table.insert(items, {
                    idx = i,
                    cwd = cwd,
                    file = file,
                    text = text, -- This is content to be filtered
                    line = text, -- This is for display
                    pos = { tonumber(line_no), 0 },
                    -- pos = { tonumber(line_no), (text:find(ctx.filter.search) or 1) - 1 },
                })
            end
            return items
        end,
    })
end

M.snacks_dirs = function()
    local Snacks = require("snacks")
    local dirs = M.get_directories()

    return Snacks.picker({
        layout = {
            preset = "vscode",
        },
        finder = function()
            local items = {}
            for i, item in ipairs(dirs) do
                table.insert(items, {
                    idx = i,
                    file = item,
                    text = item,
                })
            end
            return items
        end,
        format = function(item, _)
            local file = item.file
            local ret = {}
            local a = Snacks.picker.util.align
            ret[#ret + 1] = { "> " }
            ret[#ret + 1] = { a(file, 20) }

            return ret
        end,
        confirm = function(picker, item)
            picker:close()
            Snacks.picker.pick("files", {
                layout = {
                    preset = "vscode",
                },

                dirs = { item.file },
            })
        end,
    })
end

return M
