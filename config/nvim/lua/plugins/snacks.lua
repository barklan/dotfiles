local ivy_layout = {
    preset = "ivy_split",
}

local layout_select = {
    preset = "select",
}

local layout_ctrll = {
    -- preview = false,
    preset = "vscode",
}

local layout_lsp_symbols = {
    -- preview = false,
    preset = "right",
}

local tab_map = { "list_down", mode = { "i", "n" } }

local ctrl_l_confirm = function(picker, item)
    -- P(item)
    picker:norm(function()
        if item then
            if item.info then
                if item.info.bufnr then
                    picker:action("edit")

                    return
                end

                vim.notify("snacks item.info impossible situation")

                return
            end

            if item.file then
                local action_key = ChooseFileAction(item.file)
                if action_key == "edit" then
                    -- require("fzf-lua").actions.file_edit(selected, opts)
                    picker:action("edit")
                elseif action_key == "open" then
                    picker:close()
                    vim.schedule(function()
                        vim.cmd([[silent !xdg-open ]] .. item.file)
                    end)
                elseif action_key == "none" then
                    picker:close()
                else
                    picker:close()
                    vim.notify("Unknown action key! FIX THIS BUG.")
                end

                return
            end

            picker:close()
            vim.notify("Don't know what to do with snacks item. FIX IT!")
        end
    end)
end

return {
    {
        "folke/snacks.nvim",
        cond = NotVSCode,
        priority = 1000,
        lazy = false,
        opts = {
            toggle = { enabled = false },
            lazygit = { enabled = false },
            bigfile = { enabled = true },
            scroll = {
                enabled = true,
                animate = {
                    duration = { step = 8, total = 150 },
                    easing = "linear",
                },
                -- faster animation when repeating scroll after delay
                -- animate_repeat = {
                --     delay = 100, -- delay in ms before using the repeat animation
                --     duration = { step = 5, total = 50 },
                --     easing = "linear",
                -- },
            },
            image = { enabled = true },
            picker = {
                enabled = true,
                layout = ivy_layout,
                toggles = {
                    regex = { icon = "regex", value = true },
                },
                win = {
                    input = {
                        keys = {
                            ["<Tab>"] = tab_map,
                            ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
                            ["<C-l>"] = { "cancel", mode = { "i", "n" } },
                            ["<C-k>"] = { "cancel", mode = { "i", "n" } },
                            ["<Esc>"] = { "cancel", mode = { "i", "n" } },
                            ["<leader>`"] = { "cancel", mode = { "n" } },
                            ["<leader><Tab>"] = { "cancel", mode = { "n" } },
                            ["<C-u>"] = { "<c-u>", mode = { "i" }, expr = true, desc = "delete line" },
                            ["<M-r>"] = { "toggle_regex", mode = { "i", "n" }, desc = "toggle regex" },
                            ["<M-q>"] = { "qflist", mode = { "i", "n" }, desc = "send to quickfix" },
                            ["<C-q>"] = { "cancel", mode = { "i", "n" }, desc = "cancel" },
                            -- <C-t> Mapped in normal mode also, because it crashes in normal mode otherwise.
                            ["<C-t>"] = { " -- -t", mode = { "i", "n" }, expr = true, desc = "filter by filetype" },
                        },
                    },
                },
                icons = {
                    files = {
                        enabled = false,
                    },
                },
            },
        },
        -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
        keys = {
            {
                "<leader><leader>",
                function()
                    Snacks.picker.resume()
                end,
            },
            {
                "<leader>a",
                function()
                    Snacks.picker({ layout = layout_select })
                end,
            },
            {
                "<leader>;",
                function()
                    Snacks.picker.commands()
                end,
                desc = "Commands",
            },
            {
                "<leader><tab>",
                function()
                    Snacks.picker.buffers({
                        layout = layout_ctrll,
                    })
                end,
                desc = "Buffers",
            },
            {
                "<leader>`",
                function()
                    Snacks.picker.recent({
                        layout = layout_ctrll,
                        show_empty = true,
                        filter = {
                            cwd = true,
                            paths = {
                                [vim.fn.getcwd() .. "/.git"] = false,
                            },
                        },
                    })
                end,
                desc = "Jumps",
            },
            {
                "<leader>u",
                function()
                    Snacks.picker.undo({
                        on_show = function()
                            vim.cmd.stopinsert()
                        end,
                    })
                end,
                desc = "Search undo history",
            },
            {
                "<C-'>",
                function()
                    Snacks.picker.diagnostics({
                        show_empty = false,
                        on_show = function()
                            vim.cmd.stopinsert()
                        end,
                    })
                end,
                desc = "Workspace diagnostics",
            },
            {
                "<C-f>",
                function()
                    Snacks.picker.grep({
                        hidden = true,
                        ignored = true,
                        regex = false,
                    })
                end,
            },
            {
                "<leader>f",
                function()
                    Snacks.picker.grep_word({
                        on_show = function()
                            vim.cmd.stopinsert()
                        end,
                    })
                end,
                mode = { "n", "x" },
            },
            {
                "<leader>s",
                function()
                    Snacks.picker.search_history()
                end,
            },
            {
                "<C-k>",
                function()
                    local ext = vim.bo.filetype
                    if ext == "neo-tree" then
                        vim.notify("call this from buffer", "info", { timeout = 1000 })
                    elseif ext == "go" or ext == "rust" or ext == "python" or ext == "lua" or ext == "json" or ext == "yaml" then
                        Snacks.picker.lsp_symbols({
                            layout = layout_lsp_symbols,
                            filter = {
                                default = {
                                    "Class",
                                    "Constructor",
                                    "Enum",
                                    -- "Field",
                                    "Function",
                                    "Interface",
                                    "Method",
                                    "Module",
                                    "Namespace",
                                    "Package",
                                    "Property",
                                    "Struct",
                                    "Trait",
                                },
                            },
                        })
                    else
                        Snacks.picker.treesitter({
                            layout = layout_lsp_symbols,
                        })
                    end
                end,
            },
            {
                "<C-t>",
                function()
                    Snacks.picker.lsp_workspace_symbols()
                end,
            },
            {
                "gd",
                function()
                    Snacks.picker.lsp_definitions({
                        on_show = function()
                            vim.cmd.stopinsert()
                        end,
                    })
                end,
                desc = "Goto Definition",
            },
            {
                "gD",
                function()
                    Snacks.picker.lsp_declarations({
                        on_show = function()
                            vim.cmd.stopinsert()
                        end,
                    })
                end,
                desc = "Goto Declaration",
            },
            {
                "gj",
                function()
                    Snacks.picker.lsp_references({
                        on_show = function()
                            vim.cmd.stopinsert()
                        end,
                    })
                end,
                nowait = true,
                desc = "References",
            },
            {
                "gi",
                function()
                    Snacks.picker.lsp_implementations({
                        on_show = function()
                            vim.cmd.stopinsert()
                        end,
                    })
                end,
                desc = "Goto Implementation",
            },
            {
                "<C-l>",
                function()
                    Snacks.picker.smart({
                        filter = {
                            cwd = true,
                            paths = {
                                [vim.fn.getcwd() .. "/.git"] = false,
                            },
                        },
                        layout = layout_ctrll,
                        hidden = true,
                        ignored = true,
                        confirm = ctrl_l_confirm,
                    })
                end,
                desc = "Smart Find Files",
            },

            -- NOTE: doesn't make much sense, since smart already hidden = true and ignored = true
            -- Mapped in nvim_keymaps instead
            -- {
            --     "<C-M-l>",
            --     function()
            --         Snacks.picker.files({
            --             filter = {
            --                 cwd = true,
            --             },
            --             layout = vscode_layout,
            --             confirm = ctrl_l_confirm,
            --             hidden = true,
            --             ignored = true,
            --         })
            --     end,
            -- },
            {
                "<C-p>",
                function()
                    Snacks.picker.files({
                        filter = { cwd = true },
                        dirs = { GetCurrentBufDirAbsolute() },
                        args = { "--exact-depth=1" },
                        layout = layout_ctrll,
                        confirm = ctrl_l_confirm,
                        hidden = true,
                        ignored = true,
                    })
                end,
                desc = "Dir files",
            },
            ------------
            ---- Git
            ------------
            {
                "<C-;>",
                function()
                    Snacks.picker.git_status({
                        win = {
                            input = {
                                keys = {
                                    ["<Tab>"] = tab_map,
                                },
                            },
                        },
                    })
                end,
                desc = "Git Status",
            },
            {
                "<C-g>s",
                function()
                    Snacks.picker.git_stash({
                        confirm = "cancel", -- NOTE: disabled for safety
                    })
                end,
                desc = "Git Stash",
            },
            {
                "<C-g>k",
                function()
                    Snacks.picker.git_branches({
                        on_close = function()
                            vim.defer_fn(function()
                                require("nvim-gitstatus").update_git_status()
                            end, 1000)
                        end,
                    })
                end,
                desc = "Git Branches",
            },
            {
                "<C-g>lf",
                function()
                    Snacks.picker.git_log_file({
                        layout = layout_lsp_symbols,
                    })
                end,
                desc = "Git Log File",
            },
            {
                "<C-g>ll",
                function()
                    Snacks.picker.git_log({
                        layout = layout_lsp_symbols,
                    })
                end,
                desc = "Git Log File",
            },
            {
                "<C-g>i",
                function()
                    Snacks.picker.git_log_line({
                        layout = layout_lsp_symbols,
                    })
                end,
                desc = "Git Log Line",
            },
        },
    },
}
