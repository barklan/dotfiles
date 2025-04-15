---------------------
--- RU layout support
---------------------

local silent = { silent = true }

-- NOTE: mapped using better-escape.nvim
-- vim.keymap.set("i", "ло", "<esc>", silent)

-- local function escape(str)
--     -- You need to escape these characters to work correctly
--     local escape_chars = [[;,."|\]]
--     return vim.fn.escape(str, escape_chars)
-- end

-- local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
-- local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
-- local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
-- local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

-- -- used by plugin in rus.lua
-- vim.opt.langmap = vim.fn.join({
--     -- | `to` should be first     | `from` should be second
--     escape(ru_shift)
--     .. ";"
--     .. escape(en_shift),
--     escape(ru) .. ";" .. escape(en),
-- }, ",")

-- Below is simplistic way.
local en = {
    "`",
    "q",
    "w",
    "e",
    "r",
    "t",
    "y",
    "u",
    "i",
    "o",
    "p",
    "[",
    "]",
    "a",
    "s",
    "d",
    "f",
    "g",
    "h",
    "j",
    "k",
    "l",
    ";",
    "'",
    "z",
    "x",
    "c",
    "v",
    "b",
    "n",
    "m",
}
local ru = {
    "ё",
    "й",
    "ц",
    "у",
    "к",
    "е",
    "н",
    "г",
    "ш",
    "щ",
    "з",
    "х",
    "ъ",
    "ф",
    "ы",
    "в",
    "а",
    "п",
    "р",
    "о",
    "л",
    "д",
    "ж",
    "э",
    "я",
    "ч",
    "с",
    "м",
    "и",
    "т",
    "ь",
}

local en_shift = {
    "~",
    "Q",
    "W",
    "E",
    "R",
    "T",
    "Y",
    "U",
    "I",
    "O",
    "P",
    "{",
    "}",
    "A",
    "S",
    "D",
    "F",
    "G",
    "H",
    "J",
    "K",
    "L",
    ":",
    '"',
    "Z",
    "X",
    "C",
    "V",
    "B",
    "N",
    "M",
    "<",
    ">",
}
local ru_shift = {
    "Ë",
    "Й",
    "Ц",
    "У",
    "К",
    "Е",
    "Н",
    "Г",
    "Ш",
    "Щ",
    "З",
    "Х",
    "Ъ",
    "Ф",
    "Ы",
    "В",
    "А",
    "П",
    "Р",
    "О",
    "Л",
    "Д",
    "Ж",
    "Э",
    "Я",
    "Ч",
    "С",
    "М",
    "И",
    "Т",
    "Ь",
    "Б",
    "Ю",
}

assert(#en == #ru)
assert(#en_shift == #ru_shift)

for i = 1, #ru do
    vim.keymap.set({ "n", "v" }, ru[i], en[i], { silent = true })
end

for i = 1, #ru_shift do
    vim.keymap.set({ "n", "v" }, ru_shift[i], en_shift[i], { silent = true })
end

-- Hide from which-key
vim.defer_fn(function()
    for i = 1, #ru do
        require("which-key").add({ ru[i], hidden = true })
    end

    for i = 1, #ru_shift do
        require("which-key").add({ ru_shift[i], hidden = true })
    end
end, 1000)
