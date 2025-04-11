local M = {}

-- vim.cmd([[
-- if strftime("%H") >= 6 && strftime("%H") < 18
--     set background=dark
--     colorscheme tokyonight-night
-- else
--     set background=dark
--     colorscheme tokyonight-night
-- endif
-- ]])

function M.save_colorscheme()
    local state = {
        background = vim.o.background,
        colorscheme = vim.g.colors_name or "default",
    }

    local path = vim.fn.stdpath("data") .. "/colorscheme_state.json"
    local file = io.open(path, "w")
    if file then
        file:write(vim.json.encode(state))
        file:close()
    else
        NotifySend("Error saving colorscheme state")
    end
end

function M.load_colorscheme()
    local path = vim.fn.stdpath("data") .. "/colorscheme_state.json"
    local file = io.open(path, "r")
    if not file then
        NotifySend("No saved colorscheme state found, defaulting to dark:tokyonight-night")

        vim.o.background = "dark"
        local ok, _ = pcall(vim.cmd.colorscheme, "tokyonight-night")
        if ok then
            M.save_colorscheme()
        end

        return
    end

    local content = file:read("*a")
    file:close()

    local ok, state = pcall(vim.json.decode, content)
    if not ok or not state then
        NotifySend("Error parsing colorscheme state")
        return
    end

    vim.o.background = state.background or "dark"
    pcall(vim.cmd.colorscheme, state.colorscheme or "tokyonight-night")
end

return M
