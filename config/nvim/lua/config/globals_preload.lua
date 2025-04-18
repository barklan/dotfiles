DontAutoSaveOrAutoCloseFiletypes = { "gitcommit", "oil" }

IsPersonalDevice = function()
    local user = os.getenv("USER")
    return user == "barklan"
end

Split = function(s, delimiter)
    local result = {}
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

InVSCode = function()
    return vim.g.vscode ~= nil
end

NotVSCode = function()
    return vim.g.vscode == nil
end

IsGitEditor = function()
    local num_args = vim.fn.argc()
    if num_args < 1 then
        return false
    end

    local first_arg = vim.fn.argv()[1]
    local f = ""
    local split = Split(first_arg, "/")
    f = split[#split]

    if f == "COMMIT_EDITMSG" or f == "TAG_EDITMSG" or f == "git-rebase-todo" then
        return true
    end

    return false
end

IsCMDLineEditor = function()
    local num_args = vim.fn.argc()
    if num_args < 1 then
        return false
    end

    local first_arg = vim.fn.argv()[1]
    if string.find(first_arg, "/tmp/tmp") then
        return true
    end

    return false
end

IsScrollbackPager = function()
    if os.getenv("NVIM_SCROLLBACK") == "true" then
        return true
    end

    return false
end

IsOilEditor = function()
    if IsCMDLineEditor() or IsScrollbackPager() or IsGitEditor() then
        return false
    end

    return true
end

ShouldEnableNeotree = function()
    if InVSCode() or IsScrollbackPager() or IsCMDLineEditor() then
        return false
    end

    return true
end

ShouldEnableSessions = function()
    local cwd = vim.fn.getcwd()
    local dev_dir = os.getenv("HOME") .. "/dev"

    if cwd == dev_dir then
        return false
    end

    if not vim.startswith(cwd, dev_dir) then
        return false
    end

    if InVSCode() or IsScrollbackPager() or IsCMDLineEditor() or IsGitEditor() then
        return false
    end

    return true
end

function TimeIt(msg, fn, ...)
    local start = vim.loop.hrtime()
    local result = fn(...)
    local elapsed = (vim.loop.hrtime() - start) / 1e6
    local elapsed_str = string.format("took %.2f ms", elapsed)
    NotifySend(msg .. ": " .. elapsed_str)
    return result
end
