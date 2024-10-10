return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        lazy = false,
        branch="v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            "3rd/image.nvim",
        },
        keys = {
            { "<leader>pv", "<Cmd>Neotree toggle current<CR>", desc = "NeoTree" },
        },
        init = function()
            -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
            -- because `cwd` is not set up properly.
            vim.api.nvim_create_autocmd("BufEnter", {
                group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
                desc = "Start Neo-tree with directory",
                once = true,
                callback = function()
                    if package.loaded["neo-tree"] then
                        return
                    else
                        local stats = vim.uv.fs_stat(vim.fn.argv(0))
                        if stats and stats.type == "directory" then
                            require("neo-tree")
                        end
                    end
                end,
            })
        end,
        config = function()
            vim.fn.sign_define("DiagnosticSignError", {text = " ", texthl = "DiagnosticSignError"})
            vim.fn.sign_define("DiagnosticSignWarn", {text = " ", texthl = "DiagnosticSignWarn"})
            vim.fn.sign_define("DiagnosticSignInfo", {text = " ", texthl = "DiagnosticSignInfo"})
            vim.fn.sign_define("DiagnosticSignHint", {text = "󰌵", texthl = "DiagnosticSignHint"})
            require("neo-tree").setup({
                close_if_last_window = false,
                enable_git_status = true,
                enable_diagnostics = true,
                sources = { "filesystem", "buffers", "git_status" },
                open_files_do_not_replace_types = {"terminal", "Trouble", "trouble", "qf" },
                sort_case_insensitive = false,
                sort_function = nil,
                source_selector = { content_layour = "center", },
                default_component_configs = {
                    container = {
                        enable_character_fade = true,
                    },
                    indent = {
                        indent_size = 2,
                        padding = 1,
                        with_markers = true,
                        indent_marker = "|",
                        last_indent_marker = "└",
                        highlight = "NeoTreeIndentMarker",
                        with_expanders = true,
                        expander_collapsed = "",
                        expander_expanded = "",
                        expander_highlight = "NeoTreeExpander",
                    },
                    icon = {
                        folder_closed = "",
                        folder_open = "",
                        folder_empty = "󰜌",
                        provider = function(icon, node, state)
                            if node.type == "file" or node.type == "terminal" then
                                local success, web_devicons = pcall(require, "nvim-web-devicons")
                                local name = node.type == "terminal" and "terminal" or node.name
                                if success then
                                    local devicon, hl = web_devicons.get_icon(name)
                                    icon.text = devicon or icon.text
                                    icon.highlight = hl or icon.highlight
                                end
                            end
                        end,
                        default = "*",
                        highlight = "NeoTreeFileIcon",
                    },
                    modified = {
                        symbol = "[+]",
                        highlight = "NeoTreeModified",
                    },
                    name = {
                        trailing_slash = false,
                        use_git_status_colors = true,
                        highlight = "NeoTreeFileName",
                    },
                    git_status = {
                        symbols = {
                            -- Change type
                            added     = "",
                            modified  = "",
                            deleted   = "✖",
                            renamed   = "󰁕",
                            -- Status type
                            untracked = "",
                            ignored   = "",
                            unstaged = "󰄱",
                            staged = "󰱒",
                            conflict  = "",
                        },
                    },
                    -- Optional columns
                    file_size = {
                        enabled = true,
                        required_width = 64,
                    },
                    type = {
                        enabled = true,
                        required_width = 122,
                    },
                    last_modified = {
                        enabled = true,
                        required_width = 88,
                    },
                    created = {
                        enabled = true,
                        required_width = 110,
                    },
                    symlink_target = {
                        enabled = false,
                    },
                },
                commands = {},
                window = {
                    position = "current",
                },
                filesystem = {
                    bind_to_cwd = false,
                    follow_current_file = { enabled = true, leave_dirs_open = false },
                    filtered_items = { visible = true, },
                    group_empty_dirs = false,
                    hijack_netrw_behavior = "open_current",
                    open_files_in_last_window = false,
                    --window = { position = "current" },
                },

            })
            -- Autocommand to set 'buflisted' for Neo-tree buffers
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "neo-tree",
        callback = function()
          vim.opt_local.buflisted = true
        end,
      })

      -- Key mapping to reveal Neo-tree
      vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
            --[[require("neo-tree").setup({
                filesystem = {
                    bind_to_cwd = false,
                    follow_current_file = { enabled = true },
                    close_if_last_window = false,
                    enable_git_status = true,
                    open_files_in_last_window = false,
                    sources = { "filesystem", "buffers", "git_status" },
                    open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
                    hijack_netrw_behavior = "open_current",
                    use_libuv_file_watcher = true,
                    window = {
                        position = "current",
                    },
                    filtered_items = {
                        visible = true,
                    },
                },
                source_selector = {
                    content_layout = "center",
                },
                default_component_configs = {
                    indent = {
                        with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                        expander_collapsed = "",
                        expander_expanded = "",
                        expander_highlight = "NeoTreeExpander",
                    },
                    git_status = {
                        symbols = {
                            unstaged = "󰄱",
                            staged = "󰱒",
                        },
                    },
                },
            })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "neo-tree",
                callback = function()
                vim.opt_local.buflisted = true
                end
            })]]--
        end,
    }
}
