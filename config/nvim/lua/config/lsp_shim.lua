local M = {}

M.setup = function()
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    M.augroup = augroup
end

M.on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- Format on save
    if client:supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = M.augroup, buffer = bufnr })
        vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", function()
            vim.lsp.buf.format({
                bufnr = bufnr,
            })
        end, {})
    end

    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true)
    end

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- INFO: Defined using Snacks
    -- buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    -- buf_set_keymap("n", "gi", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    -- buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "<M-d>", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

    buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<leader>do", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    buf_set_keymap("n", "<leader>di", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    -- buf_set_keymap("n", "<leader>df", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
end

return M
