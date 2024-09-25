local modes = {
    ["n"] = "NORMAL",
    ["no"] = "NORMAL",
    ["v"] = "VISUAL",
    ["V"] = "VISUAL LINE",
    ["s"] = "SELECT",
    ["S"] = "SELECT LINE",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rv"] = "VISUAL REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "VIM EX",
    ["ce"] = "EX",
    ["r"] = "PROMPT",
    ["rm"] = "MOAR",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL",
}

local function mode()
    local current_mode = vim.api.nvim_get_mode().mode
    return string.format(" %s ", modes[current_mode]):upper()
end

local function update_mode_colors()
    local current_mode = vim.api.nvim_get_mode().mode
    local mode_color = "%#myStatuslineAccent#"
    if current_mode == "n" then
        mode_color = "%#myStatuslineAccent#"
    elseif current_mode == "i" or current_mode == "ic" then
        mode_color = "%#myStatuslineInsertAccent#"
    elseif current_mode == "v" or current_mode == "V" then
        mode_color = "%#myStatuslineVisualAccent#"
    elseif current_mode == "R" then
        mode_color = "%#myStatuslineReplaceAccent#"
    elseif current_mode == "c" then
        mode_color = "%#myStatuslineCmdLineAccent#"
    elseif current_mode == "t" then
        mode_color = "%#myStatuslineTerminalAccent#"
    end
    return mode_color
end

local function filepath()
    local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:h")
    if fpath == "" or fpath == "." then
        return " "
    end

    local comps = vim.split(fpath, "[/\\]+")

    if #comps > 5 then
        local new_comps = {
            comps[1],
            comps[2],
            "...",
            comps[#comps - 1],
            comps[#comps]
        }
        fpath = table.concat(new_comps, "/")
    else
        fpath = table.concat(comps, "/")
    end

    return string.format(" %%<%s/", fpath)
end

local function filename()
    local fname = vim.fn.expand "%:t"
    if fname == "" then
        return " "
    end
    return fname .. " "
end

local function lsp()
    local count = {}
    local levels = {
        errors = "Error",
        warnings = "Warn",
        info = "Info",
        hints = "Hint",
    }

    for k, level in pairs(levels) do
        count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
    end

    local errors = ""
    local warnings = ""
    local hints = ""
    local info = ""

    if count["errors"] ~= 0 then
        errors = " %#DiagnosticsSignError# " .. count["errors"]
    end
    if count["warnings"] ~= 0 then
        warnings = " %#DiagnosticsSignWarning# " .. count["warnings"]
    end
    if count["hints"] ~= 0 then
        hints = " %#DiagnosticsSignHint#" .. count["hints"]
    end
    if count["info"] ~= 0 then
        info = " %#DiagnosticsSignInformation# " .. count["info"]
    end

    return errors .. warnings .. hints .. info .. "%#Normal#"
end

local function filetype()
    return string.format(" %s ", vim.bo.filetype):upper()
end

local function lineinfo()
    if vim.bo.filetype == "alpha" then
        return ""
    end
    return "    Row %l, Col %c     %P "
end

local function getGitBranch()
    local git_branch = vim.fn.system('git rev-parse --abbrev-ref HEAD 2>/dev/null'):gsub("%s+", "")
    if git_branch ~= "" then
        return string.format('|  %s ', git_branch)
    else
        return ''
    end
end

Statusline = {}

Statusline.active = function()
    return table.concat {
        "%#Statusline#",
        update_mode_colors(),
        mode(),
        "%#Normal# ",
        filepath(),
        filename(),
        "%#Normal#",
        lsp(),
        "%#Normal#",
        getGitBranch(),
        "%=%#StatusLineExtra#",
        filetype(),
        lineinfo()
    }
end

function Statusline.inactive()
    return " %F"
end

function Statusline.short()
    return "%#StatusLineNC#  NvimTree"
end

vim.api.nvim_exec([[
    augroup Statusline
    au!
    au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
    au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
    au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline.short()
    augroup END
    ]], false)
