return {
    {
        "idr4n/github-monochrome.nvim",
        cond = NotVSCode,
        lazy = false,
        priority = 1000,
        opts = {
            styles = {
                comments = { italic = true },
                keywords = { bold = false },
                functions = { bold = false },
                statements = { bold = false }, -- e.g., try/except statements, but also if, for, etc.
                conditionals = { bold = false }, -- e.g., if statements
                loops = { bold = false }, -- e.g., for, while statements
                variables = {},
                floats = "normal", -- "dark", "transparent" or "normal"
                sidebars = "normal", -- "dark", "transparent" or "normal"
            },
            on_colors = function(c, s)
                c.number = c.teal
                -- c.string = c.normal
                -- if s == "light" then
                -- c.number = c.blue
                -- end
            end,
            on_highlights = function(hl, c, s)
                local tnd = "#16161E"
                hl.BlinkCmpGhostText = { fg = "#7f7f7f" }
                hl.FloatBorder = { fg = c.magenta }
                -- hl.TreesitterContext = { bg = "#1a1b26" }
                hl.TreesitterContext = { bg = c.none }
                hl.TreesitterContextBottom = { underline = true, sp = "#808080" }
                hl.GitSignsCurrentLineBlame = { fg = c.comment }
                hl.Cursor = { bg = c.magenta, blend = 95 }

                -- hl.NeoTreeNormal = { bg = tnd }
                -- hl.NeoTreeNormalNC = { bg = tnd }
                -- hl.WinSeparator = { fg = "#1a1b26", bg = "#1a1b26" } -- color of Normal background in tokyonight-night
                -- hl.NeoTreeWinSeparator = { fg = "#1a1b26", bg = "#1a1b26" } -- color of Normal background in tokyonight-night
                -- hl.DapUINormal = { bg = "#16161e" } -- color or neo-tree in tokyonight-night
            end,
        },
    },
    {
        "folke/tokyonight.nvim",
        cond = NotVSCode,
        enabled = true,
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                styles = {
                    comments = {
                        italic = true,
                    },
                    keywords = { italic = false },
                },
                -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
                day_brightness = 0.1,
                lualine_bold = true,
                cache = false,
                on_highlights = function(hl, c)
                    -- These are bright ones.
                    -- hl.TSComment = { fg = "#ff9dab" }
                    -- hl.Comment = { fg = "#ff9dab" }

                    -- These are grey.
                    -- hl.TSComment = { fg = "#a6a6a6" }
                    -- hl.Comment = { fg = "#a6a6a6" }

                    hl.CursorLineNr = {link = "LineNr"}

                    hl.Comment = {
                        fg = "#606a99", -- Default is "#565F89"
                        italic = true,
                    }

                    local bg_darker = "#16161E"

                    hl.SnacksPickerDir = { fg = "#7777b6" }
                    hl.SnacksPickerInputTitle = { fg = c.magenta }
                    hl.SnacksPickerBoxTitle = { fg = c.magenta }
                    hl.BlinkCmpGhostText = { fg = "#7f7f7f" }
                    hl.DiagnosticUnnecessary = { fg = c.normal }

                    hl.WinSeparator = { fg = "#1a1b26", bg = "#1a1b26" } -- color of Normal background in tokyonight-night
                    hl.DapUINormal = { bg = bg_darker } -- color or neo-tree in tokyonight-night

                    hl.TreesitterContext = { bg = "#1a1b26" }
                    -- hl.TreesitterContextBottom = { underline = true, sp = "#808080" }
                    hl.TreesitterContextBottom = { underline = true, sp = c.comment }

                    hl.SnacksPickerInputBorder = { fg = c.magenta, bg = bg_darker }
                    hl.SnacksPickerBorder = { fg = c.magenta, bg = bg_darker }
                    -- hl.FloatBorder = { fg = "#bb9af7" }

                    -- EXPERIMENTAL decoloring
                    -- theese are good commented
                    -- hl.Constant = { fg = c.normal }
                    -- hl.String = { fg = c.normal }
                    -- hl.Number = { fg = c.normal }
                    --
                    -- hl.Character = { fg = c.normal }
                    -- hl.Boolean = { fg = c.normal }
                    -- hl.Identifier = { fg = c.normal }
                    -- hl.Function = { fg = c.normal }
                    -- hl.Statement = { fg = c.normal }
                    -- hl.Conditional = { fg = c.normal }
                    -- hl.Repeat = { fg = c.normal }
                    -- hl.Label = { fg = c.normal }
                    -- hl.Operator = { fg = c.normal }
                    -- hl.Keyword = { fg = c.normal }
                    -- hl.Exception = { fg = c.normal }
                    -- hl.PreProc = { fg = c.normal }
                    -- hl.Include = { fg = c.normal }
                    -- hl.Define = { fg = c.normal }
                    -- hl.Macro = { fg = c.normal }
                    -- hl.PreCondit = { fg = c.normal }
                    -- hl.Type = { fg = c.normal }
                    -- hl.StorageClass = { fg = c.normal }
                    -- hl.Structure = { fg = c.normal }
                    -- hl.Typedef = { fg = c.normal }
                    -- hl.SpecialChar = { fg = c.normal }
                    -- hl.Tag = { fg = c.normal }
                    -- hl.Delimiter = { fg = c.normal }
                    -- hl.SpecialComment = { fg = c.normal }
                    -- hl.Debug = { fg = c.normal }
                    -- hl.Method = { fg = c.normal }
                end,
            })
        end,
    },
}
