local function set_highlight(group, properties)
    vim.api.nvim_set_hl(0, group, properties)
end
local colours = require("one_monokai.colors")
-- Define custom highlight groups with 'my' prefix
set_highlight('myStatuslineGitAccent', { fg = colours.yellow, bg = colours.none  })
set_highlight('myStatuslineEndAccent', { fg = colours.white, bg = colours.none })
set_highlight('myStatuslineAccent', { fg = colours.white, bg = colours.dark_blue })
set_highlight('myStatuslineInsertAccent', { fg = colours.black, bg = colours.green })
set_highlight('myStatuslineVisualAccent', { fg = colours.black, bg = colours.purple })
set_highlight('myStatuslineReplaceAccent', { fg = colours.black, bg = colours.red })
set_highlight('myStatuslineCmdLineAccent', { fg = colours.black, bg = colours.yellow })
set_highlight('myStatuslineTerminalAccent', { fg = colours.black, bg = colours.cyan })
