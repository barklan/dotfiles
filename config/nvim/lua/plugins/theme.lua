return {
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

                    hl.illuminatedWord = { bg = "#313751" }
                    hl.illuminatedCurWord = { bg = "#313751" }
                    hl.IlluminatedWordRead = { bg = "#313751" }
                    hl.IlluminatedWordText = { bg = "#313751" }
                    hl.IlluminatedWordWrite = { bg = "#313751" }
                end,
            })
        end,
    },
}
