------
--- Go
------

-- https://github.com/ray-x/go.nvim/issues/352
vim.api.nvim_create_user_command("GoLintEx", function()
    vim.opt_local.makeprg = "golangci-lint run --print-issued-lines=false --exclude-use-default=true --out-format=line-number"
    vim.cmd("GoMake")
end, {})
vim.keymap.set("n", "<leader>gl", ":GoLintEx<cr>", { desc = "Lint" })

vim.keymap.set("n", "<leader>gr", ":LspRestart<cr>", { silent = true })
vim.keymap.set("n", "<leader>gf", ":GoFillStruct<cr>", { silent = true })
vim.keymap.set("n", "<leader>gp", ":GoFixPlurals<cr>", { silent = true })
vim.keymap.set("n", "<leader>gp", ":GoFixPlurals<cr>", { silent = true })
vim.keymap.set("n", "<leader>gT", ":GoAddTag<cr>")
vim.keymap.set("n", "<leader>gj", ":GoAlt<cr>")
vim.keymap.set("n", "<leader>ga", ":GoCodeLenAct<cr>")

vim.keymap.set("n", "<leader>gi", function()
    vim.cmd(":GoImports")
    vim.cmd(":LspRestart") -- because goimports fucks up gopls
end, { desc = "GoImports" })

-----------
--- Testing
-----------

vim.keymap.set("n", "<leader>gta", ":GoAddTest<cr>", { desc = "Add test for current function" })
vim.keymap.set("n", "<leader>gtc", function()
    vim.cmd(":GoCoverage -p")
end, { desc = "Test and show coverage" })

vim.keymap.set("n", "<leader>g<cr>", function()
    local cwd = vim.fn.getcwd()
    local go_pkg_path = GetCurrentBufDirRelativeToCwd()
    local kitty_pid = GetKittyPID()

    -- https://sw.kovidgoyal.net/kitty/launch/
    vim.fn.system(
        "kitten @ --to unix:@mykitty-"
            .. tostring(kitty_pid)
            .. " launch --type=window --bias -60 --cwd "
            .. cwd
            .. " fish -ic 'kitten @ action goto_layout tall && echo go test "
            .. go_pkg_path
            .. " && print-line && go test -cover "
            .. go_pkg_path
            .. " && print-line; read -P continue -n1'"
    )
end, { desc = "Test current package" })

-------------
--- Debugging
-------------

vim.keymap.set("n", "<leader>gbs", ":GoBreakSave<cr>", { desc = "Save breakpoints" })
vim.keymap.set("n", "<leader>gbl", ":GoBreakLoad<cr>", { desc = "Load breakpoints" })

vim.keymap.set("n", "<F5>", function()
    local dap = require("dap")

    if dap.session() ~= nil then
        dap.continue()

        return
    end

    local cwd = vim.fn.getcwd()
    local target = vim.fn.input("DEBUG ./cmd/")

    if target == "" then
        vim.notify("Debug target not specified.", "info", { timeout = 1000 })

        vim.defer_fn(function()
            vim.cmd(":echo")
        end, 10)

        return
    end

    if PathExists(cwd .. "/cmd/" .. target) == false then
        vim.notify("Specified debug path (./cmd/" .. target .. ") does not exist.")

        vim.defer_fn(function()
            vim.cmd(":echo")
        end, 10)

        return
    end

    local kitty_pid = GetKittyPID()

    vim.fn.system("kitten @ --to unix:@mykitty-" .. tostring(kitty_pid) .. " action goto_layout fat")

    -- https://sw.kovidgoyal.net/kitty/launch/
    vim.fn.system(
        "kitten @ --to unix:@mykitty-"
            .. tostring(kitty_pid)
            -- .. " launch --type=tab --location=neighbor --tab-title debug --dont-take-focus --cwd "
            .. " launch --type=window --bias -15 --dont-take-focus --cwd "
            .. cwd
            .. " fish -ic 'dlv debug ./cmd/"
            .. target
            .. "/ --headless --listen=:12345 -- -config=config.yaml 2>&1 | tee ./_dlv_log; kitten @ action goto_layout tall'"
    )

    vim.cmd(":GoDebug -e placeholder")
    vim.cmd(":Neotree close")
end, { desc = "Run debug session" })

-- This is Shift+F5
vim.keymap.set("n", "<F17>", function()
    vim.cmd("GoDebug --stop")
    vim.cmd(":Neotree close")
    vim.cmd(":Neotree show")
end, { desc = "Stop debug session" })

vim.keymap.set("n", "<F9>", ":GoBreakToggle<cr>", { desc = "Toggle breakpoint" })

-- This is Shift+F9
vim.keymap.set("n", "<F21>", function()
    require("dap").clear_breakpoints()
end, { desc = "Clear breakpoints" })

vim.keymap.set("n", "<F10>", function()
    require("dap").step_over()
end, { desc = "DAP: step over" })

vim.keymap.set("n", "<F11>", function()
    require("dap").step_into()
end, { desc = "DAP: step into" })

vim.keymap.set("n", "<F12>", function()
    require("dap").step_out()
end, { desc = "DAP: step out" })
