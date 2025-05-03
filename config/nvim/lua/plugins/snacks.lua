local layout_default = {
    preset = "ivy_split",
}

local layout_select = {
    preview = false,
    preset = "select",
}

local layout_ctrll = {
    preview = false,
    preset = "vscode",
}

local layout_ctrll_preview = {
    preview = "main",
    preset = "vscode",
}

local layout_right = {
    preset = "right",
}

local tab_map = { "list_down", mode = { "i", "n" } }

local ctrl_l_confirm = function(picker, item)
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
            },
            image = { enabled = true },
            picker = {
                enabled = true,
                layout = layout_default,
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
                    Snacks.picker.commands({ layout = layout_select })
                end,
                desc = "Commands",
            },
            {
                "<leader><tab>",
                function()
                    Snacks.picker.buffers({
                        layout = layout_ctrll,
                        on_show = function()
                            vim.cmd.stopinsert()
                        end,
                    })
                end,
                desc = "Buffers",
            },
            {
                "<M-s>",
                function()
                    -- systemctl --user status cliphist-watch.service
                    -- systemd-run --unit=cliphist-watch --collect --user wl-paste --watch cliphist store
                    Snacks.picker.cliphist({ layout = layout_select })
                end,
                mode = { "n", "i" },
                desc = "Clipboard history",
            },
            {
                "<leader>/",
                function()
                    Snacks.picker.lines({ layout = layout_default })
                end,
                desc = "Lines",
            },
            {
                "<leader>u",
                function()
                    Snacks.picker.undo({
                        layout = layout_default,
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
                        layout = layout_default,
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
                        layout = layout_default,
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
                        layout = layout_default,
                        on_show = function()
                            vim.cmd.stopinsert()
                        end,
                    })
                end,
                mode = { "n", "x" },
            },
            -- KEYMAP IS TAKEN
            -- {
            --     "<leader>s",
            --     function()
            --         Snacks.picker.search_history({ layout = layout_select })
            --     end,
            -- },
            {
                "<C-k>",
                function()
                    local ext = vim.bo.filetype
                    if ext == "neo-tree" then
                        vim.notify("call this from buffer", "info", { timeout = 1000 })
                    elseif ext == "go" or ext == "rust" or ext == "python" or ext == "lua" or ext == "json" or ext == "yaml" then
                        Snacks.picker.lsp_symbols({
                            layout = layout_right,
                            -- layout = layout_ctrll_preview,
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
                            layout = layout_ctrll_preview,
                        })
                    end
                end,
            },
            {
                "<C-t>",
                function()
                    Snacks.picker.lsp_workspace_symbols({ layout = layout_ctrll })
                end,
            },
            {
                "gd",
                function()
                    Snacks.picker.lsp_definitions({
                        layout = layout_default,
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
                        layout = layout_default,
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
                        layout = layout_default,
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
                        layout = layout_default,
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
            {
                "<leader>`",
                function()
                    Snacks.picker.files({
                        filter = { cwd = true },
                        layout = layout_ctrll,
                        -- show_empty = true,
                        hidden = true,
                        ignored = true,
                        confirm = ctrl_l_confirm,
                        args = { "--no-ignore", "--unrestricted" },
                        dirs = {
                            vim.fn.getcwd(),
                            vim.fn.getcwd() .. "/.git",
                        },
                    })
                end,
                desc = "ALL files",
            },
            ------------
            ---- Git
            ------------
            {
                "<C-;>",
                function()
                    Snacks.picker.git_status({
                        layout = layout_ctrll,
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
                        layout = layout_right,
                        confirm = "cancel", -- NOTE: disabled for safety
                    })
                end,
                desc = "Git Stash",
            },
            {
                "<C-g>k",
                function()
                    Snacks.picker.git_branches({
                        layout = layout_right,
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
                        layout = layout_right,
                    })
                end,
                desc = "Git Log File",
            },
            {
                "<C-g>ll",
                function()
                    Snacks.picker.git_log({
                        layout = layout_right,
                    })
                end,
                desc = "Git Log File",
            },
            {
                "<C-g>i",
                function()
                    Snacks.picker.git_log_line({
                        layout = layout_right,
                    })
                end,
                desc = "Git Log Line",
            },
        },
    },
}
