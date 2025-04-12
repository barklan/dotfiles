return {
    {
        "mfussenegger/nvim-dap",
        cond = NotVSCode,
        lazy = true,
        config = function()
            local function delete_files_by_glob(glob_pattern)
                local files = vim.fn.glob(glob_pattern, true, true) -- Get list of files
                for _, file in ipairs(files) do
                    os.remove(file)
                end
            end

            local dap = require("dap")

            local exit_dap_ui = function()
                vim.cmd("GoDebug --stop")

                vim.defer_fn(function()
                    require("notify").dismiss({ silent = true, pending = false })
                    delete_files_by_glob("./__debug_bin*")
                end, 10)

                vim.cmd(":Neotree close")
                vim.cmd(":Neotree show")
            end

            -- For normal termination
            dap.listeners.after["event_terminated"]["my-hook"] = function()
                exit_dap_ui()
            end

            -- For when debug session exits
            dap.listeners.after["event_exited"]["my-hook"] = function()
                exit_dap_ui()
            end
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        cond = NotVSCode,
        lazy = true,
        event = "VeryLazy",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",

            -- TODO: some bug with nil call
            -- "theHamsta/nvim-dap-virtual-text",
        },
        config = function()
            require("dapui").setup()
            -- require("dap.ext.vscode").load_launchjs("./.vacode/launch_nvim.json", {
            --     go = { "go", "delve" }, -- Filetypes to associate
            --     python = { "python" },  -- Add other languages as needed
            -- })
        end,
    },
}
