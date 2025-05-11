local M = {}

-- Use `:Inspect` command.
-- For some reason only specific groups work:
-- @type.definition.go - this works
-- @type.definition    - this does not
M.golang = function()
    ---- GO STUFF
    -------------

    -- vim.api.nvim_set_hl(0, "@keyword.type.go", { link = "@none", force = true }) -- anonymous struct also go here

    -- vim.api.nvim_set_hl(0, "@string.go", { fg = "#86c5da", italic = false, force = true }) -- Set in theme.lua instead
    vim.api.nvim_set_hl(0, "@character.printf", { link = "@string.go", force = true })

    vim.api.nvim_set_hl(0, "@number.go", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@boolean.go", { link = "@none", force = true })

    -- NOTE: USEFULL 1st level
    --
    -- vim.api.nvim_set_hl(0, "@type.definition.go", { link = "@none", force = true })
    -- vim.api.nvim_set_hl(0, "@function.go", { link = "@none", force = true })
    -- vim.api.nvim_set_hl(0, "@function.method.go", { link = "@none", force = true })

    -- NOTE: USEFULL 2nd level (functions)
    --
    -- vim.api.nvim_set_hl(0, "@function.method.call.go", { link = "@none", force = true })
    -- vim.api.nvim_set_hl(0, "@function.call.go", { link = "@none", force = true })

    -- NOTE: USEFULL 3rd level (types)
    --
    -- vim.api.nvim_set_hl(0, "@type.go", { link = "@none", force = true })
    -- vim.api.nvim_set_hl(0, "@type.builtin.go", { link = "@none", force = true })
    -- vim.api.nvim_set_hl(0, "@constant.builtin.go", { link = "@none", force = true })

    -- NOTE: the rest
    --
    vim.api.nvim_set_hl(0, "@module.go", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@variable.member.go", { link = "@none", force = true })

    vim.api.nvim_set_hl(0, "@property.go", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@constant.go", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@variable.go", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@variable.builtin", { link = "@none", force = true })

    -- To disable special highlighting for `map`, `chan`, etc..
    vim.api.nvim_set_hl(0, "@lsp.type.keyword.go", { link = "@none", force = true })

    -- vim.api.nvim_set_hl(0, "@function.builtin.go", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@punctuation.delimiter.go", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@operator.go", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@variable.parameter.go", { link = "@none", force = true })

    ---- GO STUFF END
    -----------------

    vim.api.nvim_set_hl(0, "@constructor", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@variable.parameter", { link = "@none", force = true })

    vim.api.nvim_set_hl(0, "@variable.member", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@operator", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@punctuation.delimiter", { link = "@none", force = true })
end

return M
