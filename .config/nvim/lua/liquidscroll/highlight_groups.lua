local colours = {
    fg = "#abb2bf",
    bg = "#282c34",
    gray = "#676e7b",
    pink = "#e06c75",
    green = "#98c379",
    cyan = "#56b6c2",
    aqua = "#61afef",
    yellow = "#e5c07b",
    purple = "#c678dd",
    peanut = "#f6d5a4",
    orange = "#d19a66",
    dark_pink = "#ff008c",
    dark_cyan = "#2b8db3",
    red = "#f75f5f",
    dark_red = "#d03770",
    white = "#d7d7ff",
    light_gray = "#9ca3b2",
    dark_gray = "#4b5261",
    vulcan = "#383a3e",
    dark_green = "#2d2e27",
    dark_blue = "#26292f",
    black = "#1e2024",
    none = "NONE",
}

local function set_highlight(group, properties)
    vim.api.nvim_set_hl(0, group, properties)
end

-- Define your custom highlight groups with 'my' prefix

set_highlight('myStatuslineAccent',        { fg = colours.white,      bg = colours.dark_blue })
set_highlight('myStatuslineInsertAccent',  { fg = colours.black,      bg = colours.green })
set_highlight('myStatuslineVisualAccent',  { fg = colours.black,      bg = colours.purple })
set_highlight('myStatuslineReplaceAccent', { fg = colours.black,      bg = colours.red })
set_highlight('myStatuslineCmdLineAccent', { fg = colours.black,      bg = colours.yellow })
set_highlight('myStatuslineTerminalAccent',{ fg = colours.black,      bg = colours.cyan })
