return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        -- branch = "main",
        branch = "v3.x",
        cond = ShouldEnableNeotree,
        lazy = false, -- neo-tree will lazily load itself
        -- cmd = "Neotree",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "mrbjarksen/neo-tree-diagnostics.nvim",
        },
        config = function()
            local function edit_or_open(state)
                local node = state.tree:get_node()
                if require("neo-tree.utils").is_expandable(node) then
                    state.commands["toggle_node"](state)
                else
                    local file = node:get_id()
                    local action_key = ChooseFileAction(file)
                    if action_key == "edit" then
                        state.commands["open"](state)
                    elseif action_key == "open" then
                        vim.cmd([[silent !xdg-open ]] .. file .. [[" &]])
                    elseif action_key ~= "none" then
                        vim.notify("Unknown action key! FIX THIS BUG.")
                    end
                end
            end

            require("neo-tree").setup({
                popup_border_style = "rounded",
                auto_clean_after_session_restore = true, -- TODO: does this even exist?
                sources = {
                    "filesystem",
                    -- "buffers",
                    "git_status",
                    "diagnostics",
                },
                close_if_last_window = true,
                enable_git_status = true,
                enable_diagnostics = true,
                window = {
                    width = 35,
                    mappings = {
                        ["l"] = "open",
                        ["h"] = "close_node",
                        ["t"] = "none",
                        ["<BS>"] = "none",
                        ["<C-f>"] = "none",
                        ["ZZ"] = function()
                            vim.cmd(":wqall")
                        end,
                        ["<tab>"] = "next_source",
                    },
                },
                default_component_configs = {
                    file_size = {
                        enabled = false,
                    },
                    diagnostics = {
                        symbols = {
                            -- hint = "󰌵 ",
                            -- info = "  ",
                            hint = "",
                            info = "",
                            warn = "",
                            -- warn = "  ",
                            -- error = "  ",
                            error = "E ",
                        },
                        highlights = {
                            -- hint = "DiagnosticSignHint",
                            -- info = "DiagnosticSignInfo",
                            -- warn = "DiagnosticSignWarn",

                            hint = "Normal",
                            info = "Normal",
                            warn = "Normal",
                            error = "DiagnosticSignError",
                        },
                    },
                    icon = {
                        folder_empty = "e",
                        folder_empty_open = ">",
                        -- default = "˗",
                        default = " ",
                        folder_closed = ">",
                        folder_open = "v",
                    },
                    modified = {
                        symbol = "",
                    },
                    name = {
                        trailing_slash = false,
                    },
                    git_status = {
                        symbols = {
                            -- untracked = " ",
                            untracked = "UNTRACKED ",
                            added = "NEW ",
                            modified = "",
                            -- unstaged = "＊ ",
                            unstaged = "",
                            deleted = "DEL ",
                            renamed = "RENAME ",
                            conflict = "CONFLICT! ",
                            ignored = "",
                            staged = "STAGED ",
                        },
                    },
                },
                filesystem = {
                    hijack_netrw_behavior = "open_default",
                    use_libuv_file_watcher = true,
                    bind_to_cwd = true,
                    follow_current_file = {
                        enabled = true,
                        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
                    },
                    window = {
                        mappings = {
                            ["O"] = "open_in_file_manager",
                            -- ["O"] = "system_open",
                            ["l"] = "edit_or_open",
                            ["<CR>"] = "edit_or_open_and_close_neotree",
                            ["<2-leftmouse>"] = "edit_or_open",
                            ["i"] = "run_command",
                        },
                    },
                    commands = {
                        open_in_file_manager = function(state)
                            local node = state.tree:get_node()
                            local file = node:get_id()
                            local file_slice = Split(file, "/")
                            table.remove(file_slice, #file_slice)
                            local file_dir = table.concat(file_slice, "/")
                            vim.cmd([[silent !xdg-open ]] .. file_dir .. [[ &>/dev/null 0<&- & disown;]])
                        end,
                        edit_or_open = edit_or_open,
                        edit_or_open_and_close_neotree = function(state)
                            edit_or_open(state)
                            vim.cmd(":Neotree close")
                        end,
                        system_open = function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.api.nvim_command("silent !xdg-open " .. path)
                        end,
                        run_command = function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.api.nvim_input(": " .. path .. "<Home>")
                        end,
                        delete = function(state)
                            local inputs = require("neo-tree.ui.inputs")
                            local node = state.tree:get_node()
                            local path = node.path
                            local msg = "trash " .. path
                            inputs.confirm(msg, function(confirmed)
                                if not confirmed then
                                    return
                                end
                                -- if require("neo-tree.utils").is_expandable(node) == false then
                                -- vim.notify(path)
                                -- end
                                vim.fn.system({ "gtrash", "put", vim.fn.fnameescape(path) })

                                require("neo-tree.sources.manager").refresh(state.name)

                                vim.defer_fn(function()
                                    DeleteBuffersWithoutFile()
                                end, 50)
                            end)
                        end,

                        -- over write default 'delete_visual' command to 'trash' x n.
                        delete_visual = function(state, selected_nodes)
                            local inputs = require("neo-tree.ui.inputs")

                            local msg = "trash " .. #selected_nodes .. " files ?"
                            inputs.confirm(msg, function(confirmed)
                                if not confirmed then
                                    return
                                end
                                for _, node in ipairs(selected_nodes) do
                                    vim.fn.system({ "gtrash", "put", vim.fn.fnameescape(node.path) })
                                end

                                require("neo-tree.sources.manager").refresh(state.name)

                                vim.defer_fn(function()
                                    DeleteBuffersWithoutFile()
                                end, 50)
                            end)
                        end,
                    },
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_gitignored = false,
                        hide_hidden = false,
                        visible = true,
                        -- NOTE: This should be synced with global gitignore
                        -- to avoid accidental commits of these files.
                        hide_by_name = {
                            ".git",
                        },
                    },
                },
            })
        end,
    },
}
