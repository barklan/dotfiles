local M = {}

-- Use `:Inspect` command.
-- For some reason only specific groups work:
-- @type.definition.go - this works
-- @type.definition    - this does not
M.golang = function()
    -- NOTE: USEFULL 1st level
    -- vim.api.nvim_set_hl(0, "@type.definition.go", { link = "@none", force = true })
    -- vim.api.nvim_set_hl(0, "@function.go", { link = "@none", force = true })
    -- vim.api.nvim_set_hl(0, "@function.method.go", { link = "@none", force = true })

    -- NOTE: USEFULL 2nd level
    -- vim.api.nvim_set_hl(0, "@function.method.call.go", { link = "@none", force = true })
    -- vim.api.nvim_set_hl(0, "@function.call.go", { link = "@none", force = true })

    -- NOTE: USEFULL 3rd level (somewhat in order)
    vim.api.nvim_set_hl(0, "@type.go", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@type.builtin.go", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@module.go", { link = "@none", force = true })

    -- vim.api.nvim_set_hl(0, "@variable.member.go", { link = "@none", force = true })

    vim.api.nvim_set_hl(0, "@property.go", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@variable.go", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@function.builtin.go", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@punctuation.delimiter.go", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@constant.builtin.go", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@operator.go", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@variable.parameter.go", { link = "@none", force = true })
    vim.api.nvim_set_hl(0, "@boolean.go", { link = "@none", force = true })
end

return M
