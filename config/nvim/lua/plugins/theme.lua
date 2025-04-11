return {
    {
        "idr4n/github-monochrome.nvim",
        cond = NotVSCode,
        enabled = true,
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
        priority = 1001,
        config = function()
            require("tokyonight").setup({
                styles = {
                    comments = { italic = true },
                    keywords = { italic = false },
                },
                -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
                day_brightness = 0.3,
                lualine_bold = true,
                on_highlights = function(hl, c)
                    hl.CursorLineNr = { link = "LineNr" }

                    -- hl.SnacksPickerDir = { fg = "#7777b6" }
                    hl.SnacksPickerInputTitle = { fg = c.magenta }
                    hl.SnacksPickerBoxTitle = { fg = c.magenta }
                    hl.BlinkCmpGhostText = { fg = "#7f7f7f" }
                    hl.DiagnosticUnnecessary = { fg = c.fg }

                    hl.WinSeparator = { fg = c.bg, bg = c.bg } -- color of Normal background in tokyonight-night
                    hl.DapUINormal = { bg = c.bg_dark } -- color or neo-tree in tokyonight-night

                    hl.TreesitterContext = { bg = c.bg }
                    hl.TreesitterContextBottom = { underline = true, sp = c.comment }

                    hl.SnacksPickerInputBorder = { fg = c.magenta, bg = c.bg_dark }
                    hl.SnacksPickerBorder = { fg = c.magenta, bg = c.bg_dark }
                    hl.Comment = {
                        fg = "#606a99", -- Default is "#565F89"
                        italic = true,
                    }
                end,
            })
        end,
    },
}
