return
    {
        "rebelot/heirline.nvim" ,
        event = "UIEnter",
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'neovim/nvim-lspconfig',
            'mfussenegger/nvim-dap',
            "rcarriga/nvim-dap-ui",
            "tpope/vim-fugitive",
        },
        config = function(_, _)
            local colours = require("one_monokai.colors")
            local heirline = require("heirline")
            local utils = require("heirline.utils")
            local conditions = require("heirline.conditions")

            local ViMode = {
                init = function(self)
                    self.mode = vim.fn.mode(1)
                end,
                static = {
                    mode_names = {
                        n = "NORMAL",
                        no = "NORMAL",
                        nov = "NORMAL",
                        noV = "NORMAL VISUAL LINE",
                        ["no\22"] = "NORMAL VISUAL BLOCK",
                        niI = "NORMAL INSERT",
                        niR = "NORMAL REPLACE",
                        niV = "NORMAL VISUAL",
                        nt = "NORMAL TERMINAL",
                        v = "VISUAL",
                        vs = "VISUAL SELECT",
                        V = "VISUAL LINE",
                        Vs = "VISUAL LINE SELECT",
                        ["\22"] = "VISUAL BLOCK",
                        ["\22s"] = "VISUAL BLOCK SELECT",
                        s = "SELECT",
                        S = "SELECT LINE",
                        ["\19"] = "SELECT BLOCK",
                        i = "INSERT",
                        ic = "INSERT",
                        ix = "INSERT UNDO",
                        R = "REPLACE",
                        Rc = "REPLACE",
                        Rx = "REPLACE UNDO",
                        Rv = "VISUAL REPLACE",
                        Rvc = "VISUAL REPLACE",
                        Rvx = "VISUAL REPLACE UNDO",
                        c = "COMMAND",
                        cv = "EX MODE",
                        r = "PROMPT",
                        rm = "MORE PROMPT",
                        ["r?"] = "CONFIRM",
                        ["!"] = "SHELL",
                        t = "TERMINAL",
                    },
                    mode_colors = {
                        n = colours.white,
                        i = colours.green,
                        v = colours.purple,
                        V =  colours.purple,
                        ["\22"] =  colours.purple,
                        c =  colours.yellow,
                        s =  colours.yellow,
                        S =  colours.yellow,
                        ["\19"] =  colours.yellow,
                        R =  colours.red,
                        r =  colours.red,
                        ["!"] =  colours.red,
                        t =  colours.yellow,
                    },
                },
                provider = function(self)
                    return " %2("..self.mode_names[self.mode].."%)"
                end,
                hl = function(self)
                    local mode = self.mode:sub(1, 1)
                    return { fg = self.mode_colors[mode], bold = true, }
                end,
                update = {
                    "ModeChanged",
                    pattern = "*:*",
                    callback = vim.schedule_wrap(function()
                        vim.cmd("redrawstatus")
                    end),
                },
            }

            local  FileNameBlock = {
                init = function(self)
                    self.filename = vim.api.nvim_buf_get_name(0)
                end,
            }

            local FileIcon = {
                init = function(self)
                    local filename = self.filename
                    local extension = vim.fn.fnamemodify(filename, ":e")
                    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
                end,
                provider = function(self)
                    return self.icon and (self.icon .. " ")
                end,
                hl = function(self)
                    return { fg = self.icon_color }
                end
            }

            local FileName = {
                provider = function(self)
                    local filename = vim.fn.fnamemodify(self.filename, ":p:~")
                    if filename == "" then return "[No Name]" end

                    if not conditions.width_percent_below(#filename, 0.25) then
                        local comps = vim.split(filename, "[/\\]+")
                        local new_comps = { comps[1], comps[2], "...", comps[#comps - 1], comps[#comps] }
                        filename = table.concat(new_comps, "/")
                    end
                    return filename
                end,
                hl = { fg = colours.gray },
            }

            local FileNameModifier = {
                hl = function()
                    if vim.bo.modified then
                        return { fg = colours.light_gray, bold = true, force = true }
                    end
                end,
            }
            FileNameBlock = utils.insert(FileNameBlock,
                FileIcon,
                utils.insert(FileNameModifier, FileName),
                { provider = '%<' }
            )
            local Align = {
                hl = { bg = colours.none },
                provider = "%=",
            }
            local Space = {
                hl = { bg = colours.none },
                provider = " ",
            }

            local FileType = {
                provider = function()
                    return string.upper(vim.bo.filetype)
                end,
                hl = { fg = colours.white, bold = true },
            }

            local Ruler = {
                provider = "%7(%l/%3L%):%2c %P",
                hl = { bg = colours.none },
            }

            local LSPActive = {
                condition = conditions.lsp_attached,
                update = { 'LspAttach', 'LspDetach' },
                -- Or complicate things a bit and get the servers names
                provider = function()
                    local names = {}
                    for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
                        table.insert(names, server.name)
                    end
                    return "[" .. table.concat(names, " ") .. "]"
                end,
                hl = { fg = "green", bold = true },
            }
            local Diagnostics = {

                condition = conditions.has_diagnostics,

                static = {
                    error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
                    warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
                    info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
                    hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
                },

                init = function(self)
                    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
                    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
                    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
                    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
                end,

                update = { "DiagnosticChanged", "BufEnter" },

                {
                    condition = function(self) return self.errors > 0 end,
                    {
                        provider = function(self) return self.error_icon end,
                        hl = { fg = colours.red, bg = colours.none },
                    },
                    {
                        provider = function(self) return self.errors .. " " end,
                        hl = { bg = colours.none },
                    }
                },
                {
                    condition = function(self) return self.warnings > 0 end,
                    {
                        provider = function(self) return self.warn_icon end,
                        hl = { fg = colours.orange, bg = colours.none},
                    },
                    {
                        provider = function(self) return self.warnings .. " " end,
                        hl = { bg = colours.none },
                    }
                },
                {
                    condition = function(self) return self.info > 0 end,
                    {
                        provider = function(self) return self.info_icon end,
                        hl = { fg = colours.cyan, bg = colours.none },
                    },
                    {
                        provider = function(self) return self.info .. " " end,
                        hl = { bg = colours.none },
                    }
                },
                {
                    condition = function(self) return self.hints > 0 end,
                    {
                        provider = function(self) return self.hint_icon end,
                        hl = { fg = colours.green, bg = colours.none },
                    },
                    {
                        provider = function(self) return self.hints .. " " end,
                        hl = { bg = colours.none },
                    }
                },
            }
            local Git = {
                init = function(self)
                    local status = vim.fn['FugitiveStatusline']()
                    self.branch = status:match("%[Git%((.-)%)%]")
                end,
                hl = { fg = colours.yellow, bg = colours.none },
                {
                    provider = function(self)
                        if self.branch and self.branch ~= "" then
                            return "|  " .. self.branch
                        else
                            return ''
                        end
                    end,
                }
            }
            local DefaultStatusline = {
                ViMode, Space, Space, FileNameBlock, Space,
                Git, Align,
                FileType, Space, Space, Ruler
            }
            local InactiveStatusline = {
                condition = conditions.is_not_active,
                FileNameBlock, Align,
            }
            local SpecialStatusline = {
                condition = function()
                    return conditions.buffer_matches({
                        buftype = { "nofile", "prompt", "help", "quickfix" },
                        filetype = { "^git.*", "fugitive" },
                    })
                end,
                FileType, Space, Align,
            }
            local StatusLine = {
                fallthrough = false,
                SpecialStatusline, InactiveStatusline, DefaultStatusline,
            }

            local WinBar = {
                LSPActive, Space, Diagnostics, Align
            }

            ---   -------- BUFFERLINE ---------

            -- initialize the buflist cache
            local buflist_cache = {}
            local buflist_num_cache = {}
            local TablineBufnr = {
                provider = function(self)
                    return tostring(buflist_num_cache[self.bufnr]) .. ". "
                end,
                hl = { fg = colours.white, bg = colours.none },
            }

            local TablineFileName = {
                provider = function(self)
                    local filename = self.filename
                    if filename:match("neo%-tree") then return " NEOTREE " end
                    filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
                    return filename
                end,
                hl = function(self)
                    return { bold = self.is_active or self.is_visible,
                        fg = colours.light_gray, bg = colours.none,
                    }
                end,
            }

            local TabFileNameModifer = {
                hl = function(self)
                    if vim.api.nvim_get_option_value("modified", { buf = self.bufnr }) then
                        -- use `force` because we need to override the child's hl foreground
                        return { italic = true, force=true, }
                    end
                end,
            }

            local TablineFileFlags = {
                condition = function(self)
                    return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
                        or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
                end,
                provider = function(self)
                    if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
                        return "  "
                    else
                        return ""
                    end
                end,
                hl = { fg = colours.orange, },
            }

            local TablineFileNameBlock = {
                init = function(self)
                    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
                end,
                hl = function(self)
                return { bg = colours.none,
                        underline = self.is_active or self.is_visible,
                        sp = colours.peanut,
                        force = true, }
                end,
                on_click = {
                    callback = function(_, minwid, _, button)
                        if(button == "m") and not vim.api.nvim_get_option_value("modified", { buf = minwid }) then
                            buflist_num_cache[minwid] = nil
                            vim.schedule(function()
                                vim.api.nvim_buf_delete(minwid, { force = false })
                            end)
                        else
                            vim.api.nvim_win_set_buf(0, minwid)
                        end
                    end,
                    minwid = function(self)
                        return self.bufnr
                    end,
                    name = "heirline_tabline_buffer_callback",
                },
                TablineBufnr,
                FileIcon,
                utils.insert(TabFileNameModifer, TablineFileName),
                TablineFileFlags,
            }
            local TablineCloseButton = {
                Space,
                {
                    provider = "󰅖 ",
                    hl = { fg = colours.light_gray, bg = colours.none },
                    on_click = {
                        condition = function(self)
                            return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
                        end,
                        callback = function(_, minwid)
                            if not vim.api.nvim_get_option_value("modified", { buf = minwid }) then
                                buflist_num_cache[minwid] = nil
                                vim.schedule(function()
                                    vim.api.nvim_buf_delete(minwid, { force = true })
                                    vim.cmd.redrawtabline()
                                end)
                            end
                        end,
                        minwid = function(self)
                            return self.bufnr
                        end,
                        name = "heirline_tabline_close_buffer_callback",
                    },
                },
            }
            local TablineBufferBlock = utils.surround({ "|" }, function(self)
                if self.is_active then
                    return colours.peanut
                else
                    return colours.gray
                end
            end, { TablineFileNameBlock, TablineCloseButton })


            local get_bufs = function()
                local neo_tree_buffers = {}
                local buffers = vim.tbl_filter(function(bufnr)
                    if vim.api.nvim_get_option_value("filetype", { buf = bufnr }) == "neo-tree" and vim.api.nvim_buf_get_name(bufnr) ~= "" then
                        table.insert(neo_tree_buffers, bufnr)
                        return false
                    else
                        return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
                    end
                end, vim.api.nvim_list_bufs())

                local sorted_buffers = vim.list_extend(neo_tree_buffers, buffers)
                return sorted_buffers
            end

            local function find_curr_buffer(buffers)
                local curr_bufnr = vim.api.nvim_get_current_buf()
                for i, bufnr in ipairs(buffers) do
                    if bufnr == curr_bufnr then
                        return i
                    end
                end
                return nil
            end

            local function change_buffer(direction)
                local buffers = buflist_cache
                local curr_idx = find_curr_buffer(buffers)

                if not curr_idx then
                    return
                end

                local new_idx = (curr_idx + direction - 1) % #buffers + 1
                local new_bufnr = buffers[new_idx]
                vim.api.nvim_win_set_buf(0, new_bufnr)
            end
            local function close_buffer()
                local curr_idx = vim.api.nvim_get_current_buf()
                if not curr_idx then
                    return
                end

                vim.api.nvim_buf_delete(curr_idx, { force = true })
                vim.cmd.redrawtabline()
            end

            vim.keymap.set("n", "<Tab>", function()
                change_buffer(1)
            end, { noremap = true, silent = true })
            vim.keymap.set("n", "<S-Tab>", function()
                change_buffer(-1)
            end, { noremap = true, silent = true })

            vim.keymap.set("n", "<leader>c", function()
                close_buffer()
            end, { noremap = true, silent = true })

            -- setup an autocmd that updates the buflist_cache every time that buffers are added/removed
            vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
                callback = function()
                    vim.schedule(function()
                        local buffers = get_bufs()
                        for i, v in ipairs(buffers) do
                            buflist_cache[i] = v
                            buflist_num_cache[v] = i
                        end
                        for i = #buffers + 1, #buflist_cache do
                            buflist_cache[i] = nil
                        end
                        vim.o.showtabline = 2
                    end)
                end,
            })

            local BufferLine = { utils.make_buflist(
                TablineBufferBlock,
                { provider = "", hl = { fg = colours.gray, bg = colours.none } },
                { provider = "", hl = { fg = colours.gray, bg = colours.none } },
                function()
                    return buflist_cache
                end,
                false
            ), Align }
            local Tabpage = {
                provider = function(self)
                    return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
                end,
                hl = function(self)
                    if not self.is_active then
                        return "TabLine"
                    else
                        return "TabLineSel"
                    end
                end,
            }

            local TabpageClose = {
                provider = "%999X  %X",
                hl = "TabLine",
            }

            local TabPages = {
                -- only show this component if there's 2 or more tabpages
                condition = function()
                    return #vim.api.nvim_list_tabpages() >= 2
                end,
                { provider = "%=" },
                utils.make_tablist(Tabpage),
                TabpageClose,
            }
            heirline.setup({
                statusline = StatusLine,
                tabline = BufferLine,
                winbar = WinBar
            })
        end
    }
