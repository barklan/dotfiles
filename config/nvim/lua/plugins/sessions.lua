return {
    {
        "folke/persistence.nvim",
        -- event = "BufReadPre", -- this will only start session saving when an actual file was opened
        lazy = false,
        cond = ShouldEnableSessions,
        opts = {},
    },
    -- {
    --     "rmagatti/auto-session",
    --     cond = function()
    --         if InVSCode() then
    --             return false
    --         end
    --
    --         if IsGitEditor() then
    --             return false
    --         end
    --
    --         if IsCMDLineEditor() then
    --             return false
    --         end
    --
    --         if IsScrollbackPager() then
    --             return false
    --         end
    --
    --         return true
    --     end,
    --     lazy = false,
    --     priority = 900, -- Load after theme.
    --     init = function()
    --         -- vim.o.sessionoptions = "buffers,curdir,tabpages"
    --         vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    --     end,
    --     opts = {
    --         log_level = "error",
    --         suppressed_dirs = { "~/dev" },
    --         auto_save = true,
    --         auto_restore = true,
    --         session_lens = {
    --             load_on_setup = false,
    --         },
    --         pre_save_cmds = {
    --             "Neotree close",
    --         },
    --         post_restore_cmds = {
    --             function()
    --                 vim.g.neotree_opened = true
    --             end,
    --             "Neotree filesystem show",
    --             function()
    --                 vim.defer_fn(function()
    --                     DeleteBuffersWithoutFile()
    --                 end, 100)
    --             end,
    --         },
    --     },
    -- },
}
