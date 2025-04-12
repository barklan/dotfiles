return {
    {
        "Mofiqul/vscode.nvim",
        cond = NotVSCode,
        enabled = true,
        lazy = false,
        priority = 1000,
        config = function()
            -- local c = require("vscode.colors").get_colors()
            require("vscode").setup({
                group_overrides = {
                    LineNr = { link = "Whitespace" },
                    Comment = { fg = "#8f8f8f", italic = true },
                    String = { fg = "#2c778e" },

                    Cursor = {
                        bg = "#909090",
                        fg = "#6F6F6F",
                    },
                    CursorLine = { bg = "#f2f2f2" },
                    CursorLineNr = { link = "CursorLine" },

                    SnacksPickerCol = { link = "Whitespace" },
                    NeoTreeDimText = { link = "Whitespace" },
                    NeoTreeDirectoryIcon = { link = "NeoTreeDirectoryName" },
                    NeoTreeDotfile = { fg = "#959595" },
                    GitGutterChange = { fg = "#a77817" },
                },
            })
        end,
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
                day_brightness = 0.25,
                lualine_bold = true,
                on_highlights = function(hl, c)
                    hl.CursorLineNr = { link = "CursorLine" }
                    hl.String = { fg = "#86c5da" }

                    hl.SnacksPickerDir = { link = "Comment" }
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

                    -- Only for night theme
                    hl.illuminatedWord = { bg = "#313751" }
                    hl.illuminatedCurWord = { bg = "#313751" }
                    hl.IlluminatedWordRead = { bg = "#313751" }
                    hl.IlluminatedWordText = { bg = "#313751" }
                    hl.IlluminatedWordWrite = { bg = "#313751" }

                    -- Only for night theme
                    hl.Whitespace = { fg = "#282c41" }

                    -- Only for night theme
                    hl.String = { fg = "#86c5da" }
                end,
            })
        end,
    },
}
