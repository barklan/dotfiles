local M = {}

local trim_whitespace = function(str)
    return str:match("^%s*(.-)%s*$")
end

function M.load_colorscheme()
    local is_light = false

    local theme_style_env = vim.env.THEME_STYLE
    if theme_style_env then
        local trimmed = trim_whitespace(theme_style_env)
        if trimmed == "dark" then
            is_light = false
        elseif trimmed == "light" then
            is_light = true
        else
            NotifySend("unknown value of THEME_STYLE")
        end
    else
        NotifySend("THEME_STYLE not set")
    end

    if is_light then
        vim.o.background = "light"
        pcall(vim.cmd.colorscheme, "vscode")
    else
        vim.o.background = "dark"
        pcall(vim.cmd.colorscheme, "tokyonight-storm")
        -- pcall(vim.cmd.colorscheme, "kanagawa")
    end
end

return M
