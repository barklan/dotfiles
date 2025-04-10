return {
    {
        dir = vim.fn.stdpath("config") .. "/lplug/acceleratedjk",
        lazy = false, -- Don't want to have any delays here.
        keys = {
            { "j", silent = true },
            { "k", silent = true },
        },
        opts = {
            acceleration_limit = 35,
            acceleration_table = { 1, 3, 5, 7, 9 },
        },
    },
    {
        "haya14busa/vim-asterisk",
        lazy = true,
        keys = {
            { "*", [[<Plug>(asterisk-z*)]], mode = { "n", "x" } },
            { "#", [[<Plug>(asterisk-z#)]], mode = { "n", "x" } },
            { "g*", [[<Plug>(asterisk-gz*)]], mode = { "n", "x" } },
            { "g#", [[<Plug>(asterisk-gz#)]], mode = { "n", "x" } },
        },
    },
    {
        "tummetott/unimpaired.nvim",
        lazy = true,
        event = "VeryLazy",
        opts = {},
    },
    {
        "echasnovski/mini.ai",
        version = false,
        lazy = false,
        -- event = "VeryLazy",
        config = function()
            require("mini.ai").setup({
                custom_textobjects = {
                    o = false, -- To not overwrite unimpaired.nvim

                    -- Line without whitespace
                    k = function()
                        local line = vim.api.nvim_get_current_line() -- Get current line (1-based)
                        local row = vim.api.nvim_win_get_cursor(0)[1] -- Current line number

                        -- Find first non-whitespace character
                        local from = line:find("[^%s]") -- %s matches any whitespace
                        if not from then
                            return nil
                        end -- Line is empty/whitespace-only

                        -- Find last non-whitespace character
                        local to = line:reverse():find("[^%s]")
                        to = #line - to + 1 -- Convert from reversed position

                        local from_pos = { line = row, col = from }
                        local to_pos = { line = row, col = to }
                        return { from = from_pos, to = to_pos }
                    end,

                    -- snake_case, camelCase, PascalCase, etc; all capitalizations
                    -- https://github.com/echasnovski/mini.nvim/discussions/1434
                    -- ['\r'] also can be mapped as <cr>
                    -- `s` for "key that just under w on a keyboard"
                    s = {
                        -- Lua 5.1 character classes and the undocumented frontier pattern:
                        -- https://www.lua.org/manual/5.1/manual.html#5.4.1
                        -- http://lua-users.org/wiki/FrontierPattern
                        -- note: when I say "letter" I technically mean "letter or digit"
                        {
                            -- Matches a single uppercase letter followed by 1+ lowercase letters.
                            -- This covers:
                            -- - PascalCaseWords (or the latter part of camelCaseWords)
                            "%u[%l%d]+%f[^%l%d]", -- An uppercase letter, 1+ lowercase letters, to end of lowercase letters

                            -- Matches lowercase letters up until not lowercase letter.
                            -- This covers:
                            -- - start of camelCaseWords (just the `camel`)
                            -- - snake_case_words in lowercase
                            -- - regular lowercase words
                            "%f[^%s%p][%l%d]+%f[^%l%d]", -- after whitespace/punctuation, 1+ lowercase letters, to end of lowercase letters
                            "^[%l%d]+%f[^%l%d]", -- after beginning of line, 1+ lowercase letters, to end of lowercase letters

                            -- Matches uppercase or lowercase letters up until not letters.
                            -- This covers:
                            -- - SNAKE_CASE_WORDS in uppercase
                            -- - Snake_Case_Words in titlecase
                            -- - regular UPPERCASE words
                            -- (it must be both uppercase and lowercase otherwise it will
                            -- match just the first letter of PascalCaseWords)
                            "%f[^%s%p][%a%d]+%f[^%a%d]", -- after whitespace/punctuation, 1+ letters, to end of letters
                            "^[%a%d]+%f[^%a%d]", -- after beginning of line, 1+ letters, to end of letters
                        },
                        "^().*()$",
                    },
                },
            })
        end,
    },
    {
        "gbprod/cutlass.nvim",
        lazy = false,
        keys = { "c", "C", "d", "D", "x", "X" },
        opts = {
            cut_key = "x",
            override_del = nil,
            exclude = { "ns", "nS" },
        },
    },
    {
        "Wansmer/treesj",
        lazy = true,
        keys = { "<space>m" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("treesj").setup({
                use_default_keymaps = true,
                max_join_length = 160,
            })
            vim.keymap.set("n", "<leader>m", require("treesj").toggle, { desc = "treesj toggle" })
        end,
    },
    {
        -- Used only as a dependency for flit
        "ggandor/leap.nvim",
        lazy = true,
        config = function()
            require("leap").setup({
                case_insensitive = true,
            })
        end,
    },
    {
        "ggandor/flit.nvim",
        lazy = true,
        keys = {
            { "f", mode = { "n", "v", "o" } },
            { "F", mode = { "n", "v", "o" } },
            { "t", mode = { "n", "v", "o" } },
            { "T", mode = { "n", "v", "o" } },
        },
        config = true,
        dependencies = {
            "ggandor/leap.nvim",
        },
    },
    {
        "gbprod/substitute.nvim",
        lazy = true,
        keys = {
            { ",", "<cmd>lua require('substitute').operator()<cr>", mode = { "n" } },
            { ",", "<cmd>lua require('substitute').visual()<cr>", mode = { "x" } },
        },
        opts = {},
    },
    {
        "monaqa/dial.nvim",
        lazy = true,
        cond = NotVSCode,
        keys = {
            { "<C-a>", mode = { "n" } },
            { "<C-a>", mode = { "v" } },
            { "<C-x>", mode = { "n" } },
            { "<C-x>", mode = { "v" } },
        },
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group({
                -- default augends used when no group name is specified
                default = {
                    augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
                    augend.hexcolor.new({
                        case = "lower",
                    }),
                    augend.constant.alias.bool, -- boolean value (true <-> false)
                    augend.date.alias["%Y-%m-%d"],
                    augend.constant.new({
                        elements = { "and", "or" },
                        word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
                        cyclic = true,
                    }),
                    augend.constant.new({
                        elements = { "&&", "||" },
                        word = false,
                        cyclic = true,
                    }),
                    augend.constant.new({
                        elements = { "==", "!=" },
                        word = false,
                        cyclic = true,
                    }),
                    augend.constant.new({
                        elements = { "True", "False" },
                        word = false,
                        cyclic = true,
                    }),
                },
            })
            vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
            vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
            vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
            vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
        end,
    },
    {
        "barklan/readline.nvim",
        cond = NotVSCode,
        lazy = false,
        config = function()
            local readline = require("readline")
            vim.keymap.set("!", "<M-f>", readline.forward_word)
            vim.keymap.set("!", "<M-b>", readline.backward_word)
            vim.keymap.set("!", "<C-a>", readline.beginning_of_line)
            -- vim.keymap.set("!", "<C-M-e>", readline.end_of_line)
            vim.keymap.set("!", "<M-d>", readline.kill_word)
            -- vim.keymap.set("!", "<C-k>", readline.kill_line)
            vim.keymap.set("!", "<C-u>", readline.backward_kill_line)
            vim.keymap.set("!", "<C-f>", "<Right>")
            vim.keymap.set("!", "<C-b>", "<Left>")
        end,
    },
    {
        "barklan/capslock.nvim",
        cond = NotVSCode,
        lazy = true,
        keys = {
            { "<C-l>", "<Plug>CapsLockToggle", mode = { "i" } },
            -- { "<C-g>c", "<Plug>CapsLockToggle", mode = { "n" } },
        },
        config = true,
    },
}
